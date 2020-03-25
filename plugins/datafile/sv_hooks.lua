
local PLUGIN = PLUGIN

-- Create the table for the datafile.
hook.Add("DatabaseConnected", "datafile.DatabaseConnected", function()
	local query = mysql:Create("datafile")
		query:Create("_Key", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("_CharacterID", "VARCHAR(50) NOT NULL")
		query:Create("_CharacterName", "VARCHAR(150) NOT NULL")
		query:Create("_SteamID", "VARCHAR(60) NOT NULL")
		query:Create("_Schema", "TEXT NOT NULL")
		query:Create("_GenericData", "TEXT NOT NULL")
		query:Create("_Datafile", "TEXT NOT NULL")
		query:PrimaryKey("_Key")
	query:Execute()
end)

-- Check if the player has a datafile or not. If not, create one.
function PLUGIN:PostPlayerLoadout(player)
	local bHasDatafile = self:HasDatafile(player)

	-- Nil because the bHasDatafile is not in every player their character data.
	if ((!bHasDatafile || bHasDatafile == nil) && !self:IsRestrictedFaction(player)) then
		self:CreateDatafile(player)
	end

	-- load the datafile again with the new changes.
	self:LoadDatafile(player)
end

-- Function to load the datafile on the player's character. Used after updating something in the MySQL.
function PLUGIN:LoadDatafile(player)
	if (IsValid(player)) then
		local schemaFolder = Schema.folder
		local character = player:GetCharacter()

		local queryObj = mysql:Select("datafile")
			queryObj:Where("_CharacterID", character:GetID())
			queryObj:Where("_SteamID", player:SteamID())
			queryObj:Where("_Schema", schemaFolder)
			queryObj:Callback(function(result, status, lastID)
				if (!IsValid(player)) then return end

				if (result) then
					player.ixDatafile = {
						GenericData = util.JSONToTable(result[1]._GenericData),
						Datafile = util.JSONToTable(result[1]._Datafile)
					}
				end
			end)
		queryObj:Execute()
	end
end

-- Create a datafile for the player.
function PLUGIN:CreateDatafile(player)
	if (IsValid(player)) then
		local schemaFolder = Schema.folder
		local character = player:GetCharacter()
		local steamID = player:SteamID()

		local defaultDatafile = self.Default.CivilianData

		if (player:IsCombine()) then
			defaultDatafile = self.Default.CombineData
		end

		-- Set all the values.
		local insertObj = mysql:Insert("datafile")
			insertObj:Insert("_CharacterID", character:GetID())
			insertObj:Insert("_CharacterName", character:GetName())
			insertObj:Insert("_SteamID", steamID)
			insertObj:Insert("_Schema", schemaFolder)
			insertObj:Insert("_GenericData", util.TableToJSON(PLUGIN.Default.GenericData))
			insertObj:Insert("_Datafile", util.TableToJSON(defaultDatafile))
			insertObj:Callback(function(result, status, lastID)
				PLUGIN:SetHasDatafile(player, true)
			end)
		insertObj:Execute()
	end
end

-- Sets whether as character has a datafile.
function PLUGIN:SetHasDatafile(player, bhasDatafile)
	player:GetChar():SetData("HasDatafile", bhasDatafile)
end

-- Returns true if the player has a datafile.
function PLUGIN:HasDatafile(player)
	return player:GetChar():GetData("HasDatafile", false)
end

-- Datafile handler. Decides what to do when a player types /Datafile John Doe.
function PLUGIN:HandleDatafile(player, target)
	local playerValue = self:ReturnPermission(player)
	local targetValue = self:ReturnPermission(target)
	local bTargetIsRestricted, restrictedText = self:IsRestricted(player)

	if (playerValue >= targetValue) then
		if (playerValue == DATAFILE_PERMISSION_NONE) then
			player:Notify("You are not authorized to access this datafile.")

			return false
		end

		local GenericData = self:ReturnGenericData(target)
		local datafile = self:ReturnDatafile(target)

		if (playerValue == DATAFILE_PERMISSION_MINOR) then
			if (bTargetIsRestricted) then
				player:Notify("This datafile has been restricted access denied. REASON: " .. restrictedText)

				return false
			end

			for k, v in pairs(datafile) do
				if (v.category == "civil") then
					table.remove(datafile, k)
				end
			end

			net.Start("CreateRestrictedDatafile")
				net.WriteTable({target, GenericData, datafile})
			net.Send(player)
		else
			net.Start("CreateFullDatafile")
				net.WriteTable({target, GenericData, datafile})
			net.Send(player)
		end

	elseif (playerValue < targetValue) then
		player:Notify("You are not authorized to access this datafile.")

		return false
	end
end

-- Datastream

-- Update the last seen.
net.Receive("UpdateLastSeen", function(len, player)
	local data = net.ReadTable()
	local target = data[1]

	PLUGIN:UpdateLastSeen(target)
end)

-- Update the civil status.
net.Receive("UpdateCivilStatus", function(len, player)
	local data = net.ReadTable()
	local target = data[1]
	local civilStatus = data[2]

	PLUGIN:SetCivilStatus(target, player, civilStatus)
end)

-- Add a new entry.
net.Receive("AddDatafileEntry", function(len, player)
	local data = net.ReadTable()
	local target = data[1]
	local category = data[2]
	local text = data[3]
	local points = data[4]

	PLUGIN:AddEntry(category, text, points, target, player, false)
end)

-- Add/remove a BOL.
net.Receive("SetBOL", function(len, player)
	local data = net.ReadTable()
	local target = data[1]
	local bHasBOL = PLUGIN:ReturnBOL(player)

	if (bHasBOL) then
		PLUGIN:SetBOL(false, "", target, player)
	else
		PLUGIN:SetBOL(true, "", target, player)
	end
end)

-- Send the points of the player back to the user.
net.Receive("RequestPoints", function(len, player)
	local data = net.ReadTable()
	local target = data[1]

	if (PLUGIN:ReturnPermission(player) == DATAFILE_PERMISSION_MINOR and (PLUGIN:ReturnPermission(target) == DATAFILE_PERMISSION_NONE or PLUGIN:ReturnPermission(target) == DATAFILE_PERMISSION_MINOR)) then
		net.Start("SendPoints")
			net.WriteTable({PLUGIN:ReturnPoints(target)})
		net.Send(player)
	end
end)

-- Remove a line from someone their datafile.
net.Receive("RemoveDatafileLine", function(len, player)
	local data = net.ReadTable()
	local target = data[1]
	local key = data[2]
	local date = data[3]
	local category = data[4]
	local text = data[5]

	PLUGIN:RemoveEntry(player, target, key, date, category, text)
end)

-- Refresh the active datafile panel of a player.
net.Receive("RefreshDatafile", function(len, player)
	local data = net.ReadTable()
	local target = data[1]

	PLUGIN:HandleDatafile(player, target)
end)
