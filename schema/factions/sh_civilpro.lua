
FACTION.name = "Civil Protection"
FACTION.description = ""
FACTION.color = Color(50, 100, 150)
FACTION.models = {"models/ma/hla/terranovapolice.mdl", 0, "022"}
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
	return "CP:i5.TAGLINE-0", true
end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter()

	if (!Schema:IsCombineRank(oldValue, "i5") and Schema:IsCombineRank(value, "i5")) then
		character:JoinClass(CLASS_MPR)

	elseif (!Schema:IsCombineRank(oldValue, "i4") and Schema:IsCombineRank(value, "i4")) then
		character:JoinClass(CLASS_MPR)
	elseif (!Schema:IsCombineRank(oldValue, "RL") and Schema:IsCombineRank(value, "RL")) then
		character:JoinClass(CLASS_EMP)
	elseif (!Schema:IsCombineRank(oldValue, "i1") and Schema:IsCombineRank(value, "i1")) then
		character:JoinClass(CLASS_EMP)
	elseif (!Schema:IsCombineRank(oldValue, "i2") and Schema:IsCombineRank(value, "i2")) then
		character:JoinClass(CLASS_EMP)
	end
end

FACTION_CP = FACTION.index
