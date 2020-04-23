
local PLUGIN = PLUGIN

util.AddNetworkString("UpdateLastSeen")
util.AddNetworkString("UpdateCivilStatus")
util.AddNetworkString("AddDatafileEntry")
util.AddNetworkString("SetBOL")
util.AddNetworkString("RequestPoints")
util.AddNetworkString("RemoveDatafileLine")
util.AddNetworkString("RefreshDatafile")
util.AddNetworkString("SendPoints")
util.AddNetworkString("CreateFullDatafile")
util.AddNetworkString("CreateRestrictedDatafile")
util.AddNetworkString("CreateManagementPanel")
util.AddNetworkString("UpdateLastSeen")
util.AddNetworkString("UpdateLastSeen")

-- Update the player their datafile.
function PLUGIN:UpdateDatafile(client, GenericData, datafile)
	/* Datafile structure:
		table to JSON encoded with CW function:
		_GenericData = {
			bol = {false, ""},
			restricted = {false, ""},
			civilStatus = "",
			lastSeen = "",
			points = 0,
			sc = 0,
		}
		_Datafile = {
			entries[k] = {
				category = "", -- med, union, civil
				hidden = boolean,
				text = "",
				date = "",
				points = "",
				poster = {charName, steamID, color},
			},
		}
	*/

	if (IsValid(client)) then
		local schemaFolder = Schema.folder
		local datafileTable = ix.config.Get("mysqlDatafileTable", "datafile")
		local character = client:GetCharacter()

		-- Update all the values of a player.
		local updateObj = mysql:Update(datafileTable)
			updateObj:Where("_CharacterID", character:GetID())
			updateObj:Where("_SteamID", client:SteamID())
			updateObj:Where("_Schema", schemaFolder)
			updateObj:Update("_CharacterName", character:GetName())
			updateObj:Update("_GenericData", util.TableToJSON(GenericData))
			updateObj:Update("_Datafile", util.TableToJSON(datafile))
		updateObj:Execute()

		self:LoadDatafile(client)
	end
end

-- Add a new entry. bCommand is used to prevent logging when /AddEntry is used.
function PLUGIN:AddEntry(category, text, points, client, poster, bCommand)
	if (!self.Categories[category]) then return false end
	if ((self:ReturnPermission(poster) <= DATAFILE_PERMISSION_MINOR and category == "civil") or self:ReturnPermission(poster) == DATAFILE_PERMISSION_NONE) then return end

	local GenericData = self:ReturnGenericData(client)
	local datafile = self:ReturnDatafile(client)

	-- If the player isCombine, add SC instead.
	if (client:IsCombine()) then
		GenericData.sc = GenericData.sc + points
	else
		GenericData.points = GenericData.points + points
	end

	-- Add a new entry with all the following values.
	datafile[#datafile + 1] = {
		category = category,
		hidden = false,
		text = text,
		date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
		points = points,
		poster = {
			poster:GetCharacter():GetName(),
			poster:SteamID(),
			team.GetColor(poster:Team()),
		},
	}

	-- Update the player their file with the new entry and possible points addition.
	self:UpdateDatafile(client, GenericData, datafile)

	ServerLog(poster:Name() .. " has added an entry to " .. client:Name() .. "'s datafile with category: " .. category.."\n")
end

-- Set a player their Civil Status.
function PLUGIN:SetCivilStatus(client, poster, civilStatus)
	if (!table.HasValue(PLUGIN.CivilStatus, civilStatus)) then return end
	if (self:ReturnPermission(poster) < DATAFILE_PERMISSION_MINOR) then return end

	local GenericData = self:ReturnGenericData(client)
	local datafile = self:ReturnDatafile(client)
	GenericData.civilStatus = civilStatus

	self:AddEntry("union", poster:GetCharacter():GetName() .. " has changed " .. client:GetCharacter():GetName() .. "'s Civil Status to: " .. civilStatus, 0, client, poster)
	self:UpdateDatafile(client, GenericData, datafile)

	ServerLog(poster:Name() .. " has changed " .. client:Name() .. "'s Civil Status to: " .. civilStatus.."\n")
end

-- Clear a character's datafile.
function PLUGIN:ClearDatafile(client)
	if (client:IsCombine()) then
		self:UpdateDatafile(client, PLUGIN.Default.GenericData, PLUGIN.Default.CombineData)
	else
		self:UpdateDatafile(client, PLUGIN.Default.GenericData, PLUGIN.Default.CivilianData)
	end
end

-- Update the time a player has last been seen.
function PLUGIN:UpdateLastSeen(client)
	local GenericData = self:ReturnGenericData(client)
	local datafile = self:ReturnDatafile(client)
	GenericData.lastSeen = os.date("%H:%M:%S - %d/%m/%Y", os.time())

	self:UpdateDatafile(client, GenericData, datafile)
end

-- Enable or disable a BOL on the player.
function PLUGIN:SetBOL(bBOL, text, client, poster)
	if (self:ReturnPermission(poster) <= DATAFILE_PERMISSION_MINOR) then return end

	local GenericData = self:ReturnGenericData(client)
	local datafile = self:ReturnDatafile(client)

	if (bBOL) then
		-- add the BOL with the text
		GenericData.bol[1] = true
		GenericData.bol[2] = text

		self:AddEntry("union", poster:GetCharacter():GetName() .. " has put a bol on " .. client:GetCharacter():GetName(), 0, client, poster)

	else
		-- remove the BOL, get rid of the text
		GenericData.bol[1] = false
		GenericData.bol[2] = ""

		self:AddEntry("union", poster:GetCharacter():GetName() .. " has removed a bol on " .. client:GetCharacter():GetName(), 0, client, poster)
	end

	self:UpdateDatafile(client, GenericData, datafile)
end

-- Make the file of a player restricted or not.
function PLUGIN:SetRestricted(bRestricted, text, client, poster)
	local GenericData = self:ReturnGenericData(client)
	local datafile = self:ReturnDatafile(client)

	if (bRestricted) then
		-- make the file restricted with the text
		GenericData.restricted[1] = true
		GenericData.restricted[2] = text

		self:AddEntry("civil", poster:GetCharacter():GetName() .. " has made " .. client:GetCharacter():GetName() .. "'s file restricted.", 0, client, poster)
	else
		-- make the file unrestricted, set text to ""
		GenericData.restricted[1] = false
		GenericData.restricted[2] = ""

		self:AddEntry("civil", poster:GetCharacter():GetName() .. " has removed the restriction on " .. client:GetCharacter():GetName() .. "'s file.", 0, client, poster)
	end

	self:UpdateDatafile(client, GenericData, datafile)
end

-- Remove an entry by checking for the key & validating it is the entry.
function PLUGIN:RemoveEntry(client, target, key, date, category, text)
	local GenericData = self:ReturnGenericData(target)
	local datafile = self:ReturnDatafile(target)

	if (datafile[key].date == date and datafile[key].category == category and datafile[key].text == text) then
		table.remove(datafile, key)

		self:UpdateDatafile(target, GenericData, datafile)

		ServerLog(client:Name() .. " has removed an entry of " .. target:Name() .. "'s datafile with category: " .. category.."\n")
	end
end

-- Return the amount of points someone has.
function PLUGIN:ReturnPoints(client)
	local GenericData = self:ReturnGenericData(client)

	if (client:IsCombine()) then
		return GenericData.sc
	else
		return GenericData.points
	end
end

function PLUGIN:ReturnCivilStatus(client)
	local GenericData = self:ReturnGenericData(client)

	return GenericData.civilStatus
end

function PLUGIN:ReturnCivilStatus(client)
	local GenericData = self:ReturnGenericData(client)

	return GenericData.civilStatus
end

-- Return _GenericData in normal table format.
function PLUGIN:ReturnGenericData(client)
	return client.ixDatafile.GenericData
end

-- Return _Datafile in normal table format.
function PLUGIN:ReturnDatafile(client)
	return client.ixDatafile.Datafile
end

-- Return the BOL of a player.
function PLUGIN:ReturnBOL(client)
	local GenericData = self:ReturnGenericData(client)
	local bHasBOL = GenericData.bol[1]
	local BOLText = GenericData.bol[2]

	if (bHasBOL) then
		return true, BOLText
	else
		return false, ""
	end
end

-- Return the permission of a player. The higher, the more privileges.
function PLUGIN:ReturnPermission(client)
	local faction = ix.faction.Get(client:Team()).name
	local permission = DATAFILE_PERMISSION_NONE

	if (self.Permissions[faction]) then
		permission = self.Permissions[faction]
	end

	return permission
end

-- Returns if the player their file is restricted or not, and the text if it is.
function PLUGIN:IsRestricted(client)
	local GenericData = self:ReturnGenericData(client)
	local bIsRestricted = GenericData.restricted[1]
	local restrictedText = GenericData.restricted[2]

	return bIsRestricted, restrictedText
end

-- If the player is apart of any of the factions allowing a datafile, return false.
function PLUGIN:IsRestrictedFaction(client)
	local factionTable = ix.faction.Get(client:Team())

	if (factionTable.bAllowDatafile) then
		return false
	end

	return true
end
