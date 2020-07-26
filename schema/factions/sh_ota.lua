
FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = ""
FACTION.color = Color(200, 0, 0)
FACTION.models = {"models/characters/combine_soldier/jqblk/combine_s.mdl"}
FACTION.factionRecognized = {
	["civilpro"] = true,
	["ota"] = true
}
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}
FACTION.bAllowDatafile = true
FACTION.channels = {
	["union"] = true,
	["um"] = true,
	["terminal"] = true,
	["division"] = true,
	["cwui"] = true,
	["overwatch"] = true,
	["combine"] = true,
	["tac"] = true
}
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true
FACTION.noGas = true
FACTION.noNeeds = true
FACTION.painSounds = {"npc/combine_soldier/pain1.wav","npc/combine_soldier/pain2.wav","npc/combine_soldier/pain3.wav"}

function FACTION:GetPlayerPainSound(client)
	local randomSelection = self.painSounds[math.random(#self.painSounds)]
	return randomSelection[1], true
end

function FACTION:GetDefaultName(client)
	return "OTA:OWS.ECHO."..string.format("%05d", math.random(1, 99999)), true
end

function FACTION:OnCharacterCreated(client, character)
	local max = ix.config.Get("maxAttributes", 100)

	for k, v in pairs(ix.attributes.list) do
		character:SetAttrib(k, v.maxValue or max)
	end
end

FACTION_OTA = FACTION.index
