
FACTION.name = "Civil Protection"
FACTION.description = ""
FACTION.color = Color(50, 100, 150)
FACTION.models = {"models/cultist/hl_a/metropolice/metrocop.mdl"}
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}
FACTION.bAllowDatafile = true
FACTION.factionRecognized = {
	["civilpro"] = true
}
FACTION.channels = {
	["combine"] = true,
	["tac"] = true
}
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.noGas = true

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("stunstick", 1)
end

function FACTION:GetDefaultName(client)
	return "CP:00.TAGLINE-0", true
end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter()

	if (!Schema:IsCombineRank(oldValue, "RCT") and Schema:IsCombineRank(value, "RCT")) then
		character:JoinClass(CLASS_MPR)

	elseif (!Schema:IsCombineRank(oldValue, "RL") and Schema:IsCombineRank(value, "RL")) then
		character:JoinClass(CLASS_EMP)
	elseif (!Schema:IsCombineRank(oldValue, "HC") and Schema:IsCombineRank(value, "HC")) then
		character:JoinClass(CLASS_EMP)
	elseif (!Schema:IsCombineRank(oldValue, "50") and Schema:IsCombineRank(value, "50")) then
		character:JoinClass(CLASS_EMP)
	elseif (!Schema:IsCombineRank(oldValue, "75") and Schema:IsCombineRank(value, "75")) then
		character:JoinClass(CLASS_EMP)
	end

	if (!Schema:IsCombineRank(oldValue, "GHOST") and Schema:IsCombineRank(value, "GHOST")) then
		character:SetModel("models/eliteghostcp.mdl")
	end
end

FACTION_CP = FACTION.index
