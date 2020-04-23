
local PLUGIN = PLUGIN

-- Create the table for the datafile.
function PLUGIN:LoadData()
	local query = mysql:Create(ix.config.Get("mysqlDatafileTable", "datafile"))
		query:Create("_Key", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("_CharacterID", "VARCHAR(50) NOT NULL")
		query:Create("_CharacterName", "VARCHAR(150) NOT NULL")
		query:Create("_SteamID", "VARCHAR(60) NOT NULL")
		query:Create("_Schema", "TEXT NOT NULL")
		query:Create("_GenericData", "TEXT NOT NULL")
		query:Create("_Datafile", "TEXT NOT NULL")
		query:PrimaryKey("_Key")
	query:Execute()
end

-- Check if the player has a datafile or not. If not, create one.
function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	local bHasDatafile = self:HasDatafile(client)

	-- Nil because the bHasDatafile is not in every player their character data.
	if ((!bHasDatafile || bHasDatafile == nil) && !self:IsRestrictedFaction(client)) then
		self:CreateDatafile(client)
	end

	-- load the datafile again with the new changes.
	self:LoadDatafile(client)
end

-- Function to load the datafile on the player's character. Used after updating something in the MySQL.
function PLUGIN:LoadDatafile(client)
	if (IsValid(client)) then
		local schemaFolder = Schema.folder
		local character = client:GetCharacter()

		local queryObj = mysql:Select(ix.config.Get("mysqlDatafileTable", "datafile"))
			queryObj:Where("_CharacterID", character:GetID())
			queryObj:Where("_SteamID", client:SteamID())
			queryObj:Where("_Schema", schemaFolder)
			queryObj:Callback(function(result, status, lastID)
				if (!IsValid(client)) then return end

				if (result) then
					client.ixDatafile = {
						GenericData = util.JSONToTable(result[1]._GenericData),
						Datafile = util.JSONToTable(result[1]._Datafile)
					}
				end
			end)
		queryObj:Execute()
	end
end

-- Create a datafile for the player.
function PLUGIN:CreateDatafile(client)
	if (IsValid(client)) then
		local schemaFolder = Schema.folder
		local character = client:GetCharacter()
		local steamID = client:SteamID()

		local defaultDatafile = self.Default.CivilianData

		if (client:IsCombine()) then
			defaultDatafile = self.Default.CombineData
		end

		-- Set all the values.
		local insertObj = mysql:Insert(ix.config.Get("mysqlDatafileTable", "datafile"))
			insertObj:Insert("_CharacterID", character:GetID())
			insertObj:Insert("_CharacterName", character:GetName())
			insertObj:Insert("_SteamID", steamID)
			insertObj:Insert("_Schema", schemaFolder)
			insertObj:Insert("_GenericData", util.TableToJSON(PLUGIN.Default.GenericData))
			insertObj:Insert("_Datafile", util.TableToJSON(defaultDatafile))
			insertObj:Callback(function(result, status, lastID)
				PLUGIN:SetHasDatafile(client, true)
			end)
		insertObj:Execute()
	end
end

-- Sets whether as character has a datafile.
function PLUGIN:SetHasDatafile(client, bhasDatafile)
	client:GetCharacter():SetData("HasDatafile", bhasDatafile)
end

-- Returns true if the player has a datafile.
function PLUGIN:HasDatafile(client)
	return client:GetCharacter():GetData("HasDatafile", false)
end

-- Datafile handler. Decides what to do when a player types /Datafile John Doe.
function PLUGIN:HandleDatafile(client, target)
	local playerValue = self:ReturnPermission(client)
	local targetValue = self:ReturnPermission(target)
	local bTargetIsRestricted, restrictedText = self:IsRestricted(client)

	if (playerValue >= targetValue) then
		if (playerValue == DATAFILE_PERMISSION_NONE) then
			client:Notify("You are not authorized to access this datafile.")

			return false
		end

		local GenericData = self:ReturnGenericData(target)
		local datafile = self:ReturnDatafile(target)

		if (playerValue == DATAFILE_PERMISSION_MINOR) then
			if (bTargetIsRestricted) then
				client:Notify("This datafile has been restricted access denied. REASON: " .. restrictedText)

				return false
			end

			for k, v in pairs(datafile) do
				if (v.category == "civil") then
					table.remove(datafile, k)
				end
			end

			net.Start("CreateRestrictedDatafile")
				net.WriteEntity(target)
				net.WriteTable(GenericData)
				net.WriteTable(datafile)
			net.Send(client)
		else
			net.Start("CreateFullDatafile")
				net.WriteEntity(target)
				net.WriteTable(GenericData)
				net.WriteTable(datafile)
			net.Send(client)
		end

	elseif (playerValue < targetValue) then
		client:Notify("You are not authorized to access this datafile.")

		return false
	end
end

-- net

-- Update the last seen.
net.Receive("UpdateLastSeen", function(len, client)
	local target = net.ReadEntity()

	PLUGIN:UpdateLastSeen(target)
end)

-- Update the civil status.
net.Receive("UpdateCivilStatus", function(len, client)
	local target = net.ReadEntity()
	local civilStatus = net.ReadString()

	PLUGIN:SetCivilStatus(target, client, civilStatus)
end)

-- Add a new entry.
net.Receive("AddDatafileEntry", function(len, client)
	local target = net.ReadEntity()
	local category = net.ReadString()
	local text = net.ReadString()
	local points = net.ReadString()

	PLUGIN:AddEntry(category, text, points, target, client, false)
end)

-- Add/remove a BOL.
net.Receive("SetBOL", function(len, client)
	local target = net.ReadEntity()
	local bHasBOL = PLUGIN:ReturnBOL(target)

	if (bHasBOL) then
		PLUGIN:SetBOL(false, "", target, client)
	else
		PLUGIN:SetBOL(true, "", target, client)
	end
end)

-- Send the points of the player back to the user.
net.Receive("RequestPoints", function(len, client)
	local target = net.ReadEntity()

	if (PLUGIN:ReturnPermission(client) == DATAFILE_PERMISSION_MINOR and (PLUGIN:ReturnPermission(target) == DATAFILE_PERMISSION_NONE or PLUGIN:ReturnPermission(target) == DATAFILE_PERMISSION_MINOR)) then
		net.Start("SendPoints")
			net.WriteString(PLUGIN:ReturnPoints(target))
		net.Send(client)
	end
end)

-- Remove a line from someone their datafile.
net.Receive("RemoveDatafileLine", function(len, client)
	local target = net.ReadEntity()
	local key = net.ReadUInt(8)
	local date = net.ReadString()
	local category = net.ReadString()
	local text = net.ReadString()

	PLUGIN:RemoveEntry(client, target, key, date, category, text)
end)

-- Refresh the active datafile panel of a player.
net.Receive("RefreshDatafile", function(len, client)
	local target = net.ReadEntity()

	PLUGIN:HandleDatafile(client, target)
end)
