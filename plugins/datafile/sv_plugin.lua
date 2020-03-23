
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
function PLUGIN:UpdateDatafile(player, GenericData, datafile)
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

	if (IsValid(player)) then
		local schemaFolder = Schema.folder
		local character = player:GetCharacter()

		-- Update all the values of a player.
		local updateObj = mysql:Update("datafile")
			updateObj:Where("_CharacterID", character:GetID())
			updateObj:Where("_SteamID", player:SteamID())
			updateObj:Where("_Schema", schemaFolder)
			updateObj:Update("_CharacterName", character:GetName())
			updateObj:Update("_GenericData", util.TableToJSON(GenericData))
			updateObj:Update("_Datafile", util.TableToJSON(datafile))
		updateObj:Execute()

		self:LoadDatafile(player)
	end
end

-- Add a new entry. bCommand is used to prevent logging when /AddEntry is used.
function PLUGIN:AddEntry(category, text, points, player, poster, bCommand)
	if (!self.Categories[category]) then return false end
	if ((self:ReturnPermission(poster) <= DATAFILE_PERMISSION_MINOR and category == "civil") or self:ReturnPermission(poster) == DATAFILE_PERMISSION_NONE) then return end

	local GenericData = self:ReturnGenericData(player)
	local datafile = self:ReturnDatafile(player)

	-- If the player isCombine, add SC instead.
	if (player:IsCombine()) then
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
	self:UpdateDatafile(player, GenericData, datafile)

	ServerLog(poster:Name() .. " has added an entry to " .. player:Name() .. "'s datafile with category: " .. category.."\n")
end

-- Set a player their Civil Status.
function PLUGIN:SetCivilStatus(player, poster, civilStatus)
	if (!table.HasValue(PLUGIN.CivilStatus, civilStatus)) then return end
	if (self:ReturnPermission(poster) < DATAFILE_PERMISSION_MINOR) then return end

	local GenericData = self:ReturnGenericData(player)
	local datafile = self:ReturnDatafile(player)
	GenericData.civilStatus = civilStatus

	self:AddEntry("union", poster:GetCharacter():GetName() .. " has changed " .. player:GetCharacter():GetName() .. "'s Civil Status to: " .. civilStatus, 0, player, poster)
	self:UpdateDatafile(player, GenericData, datafile)

	ServerLog(poster:Name() .. " has changed " .. player:Name() .. "'s Civil Status to: " .. civilStatus.."\n")
end

-- Clear a character's datafile.
function PLUGIN:ClearDatafile(player)
	if (player:IsCombine()) then
		self:UpdateDatafile(player, PLUGIN.Default.GenericData, PLUGIN.Default.CombineData)
	else
		self:UpdateDatafile(player, PLUGIN.Default.GenericData, PLUGIN.Default.CivilianData)
	end
end

-- Update the time a player has last been seen.
function PLUGIN:UpdateLastSeen(player)
	local GenericData = self:ReturnGenericData(player)
	local datafile = self:ReturnDatafile(player)
	GenericData.lastSeen = os.date("%H:%M:%S - %d/%m/%Y", os.time())

	self:UpdateDatafile(player, GenericData, datafile)
end

-- Enable or disable a BOL on the player.
function PLUGIN:SetBOL(bBOL, text, player, poster)
	if (self:ReturnPermission(poster) <= DATAFILE_PERMISSION_MINOR) then return end

	local GenericData = self:ReturnGenericData(player)
	local datafile = self:ReturnDatafile(player)

	if (bBOL) then
		-- add the BOL with the text
		GenericData.bol[1] = true
		GenericData.bol[2] = text

		self:AddEntry("union", poster:GetCharacter():GetName() .. " has put a bol on " .. player:GetCharacter():GetName(), 0, player, poster)

	else
		-- remove the BOL, get rid of the text
		GenericData.bol[1] = false
		GenericData.bol[2] = ""

		self:AddEntry("union", poster:GetCharacter():GetName() .. " has removed a bol on " .. player:GetCharacter():GetName(), 0, player, poster)
	end

	self:UpdateDatafile(player, GenericData, datafile)
end

-- Make the file of a player restricted or not.
function PLUGIN:SetRestricted(bRestricted, text, player, poster)
	local GenericData = self:ReturnGenericData(player)
	local datafile = self:ReturnDatafile(player)

	if (bRestricted) then
		-- make the file restricted with the text
		GenericData.restricted[1] = true
		GenericData.restricted[2] = text

		self:AddEntry("civil", poster:GetCharacter():GetName() .. " has made " .. player:GetCharacter():GetName() .. "'s file restricted.", 0, player, poster)
	else
		-- make the file unrestricted, set text to ""
		GenericData.restricted[1] = false
		GenericData.restricted[2] = ""

		self:AddEntry("civil", poster:GetCharacter():GetName() .. " has removed the restriction on " .. player:GetCharacter():GetName() .. "'s file.", 0, player, poster)
	end

	self:UpdateDatafile(player, GenericData, datafile)
end

-- Remove an entry by checking for the key & validating it is the entry.
function PLUGIN:RemoveEntry(player, target, key, date, category, text)
	local GenericData = self:ReturnGenericData(target)
	local datafile = self:ReturnDatafile(target)

	if (datafile[key].date == date and datafile[key].category == category and datafile[key].text == text) then
		table.remove(datafile, key)

		self:UpdateDatafile(target, GenericData, datafile)

		ServerLog(player:Name() .. " has removed an entry of " .. target:Name() .. "'s datafile with category: " .. category.."\n")
	end
end

-- Return the amount of points someone has.
function PLUGIN:ReturnPoints(player)
	local GenericData = self:ReturnGenericData(player)

	if (player:IsCombine()) then
		return GenericData.sc
	else
		return GenericData.points
	end
end

function PLUGIN:ReturnCivilStatus(player)
	local GenericData = self:ReturnGenericData(player)

	return GenericData.civilStatus
end

-- Return _GenericData in normal table format.
function PLUGIN:ReturnGenericData(player)
	return player.ixDatafile.GenericData
end

-- Return _Datafile in normal table format.
function PLUGIN:ReturnDatafile(player)
	return player.ixDatafile.Datafile
end

-- Return the BOL of a player.
function PLUGIN:ReturnBOL(player)
	local GenericData = self:ReturnGenericData(player)
	local bHasBOL = GenericData.bol[1]
	local BOLText = GenericData.bol[2]

	if (bHasBOL) then
		return true, BOLText
	else
		return false, ""
	end
end

-- Return the permission of a player. The higher, the more privileges.
function PLUGIN:ReturnPermission(player)
	local faction = ix.faction.Get(player:Team()).name
	local permission = DATAFILE_PERMISSION_NONE

	if (self.Permissions[faction]) then
		permission = self.Permissions[faction]
	end

	return permission
end

-- Returns if the player their file is restricted or not, and the text if it is.
function PLUGIN:IsRestricted(player)
	local GenericData = self:ReturnGenericData(player)
	local bIsRestricted = GenericData.restricted[1]
	local restrictedText = GenericData.restricted[2]

	return bIsRestricted, restrictedText
end

-- If the player is apart of any of the factions allowing a datafile, return false.
function PLUGIN:IsRestrictedFaction(player)
	local factionTable = ix.faction.Get(player:Team())

	if (factionTable.bAllowDatafile) then
		return false
	end

	return true
end
