
FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = ""
FACTION.color = Color(200, 0, 0)
FACTION.models = {
	"models/bloocobalt/combine/combine_s.mdl",
	"models/bloocobalt/combine/combine_e.mdl"
}
FACTION.isGloballyRecognized = false
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}
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

function FACTION:GetDefaultName(client)
	return "S17:OTA.ECHO."..string.format("%05d", math.random(1, 99999)), true
end

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("pulse_rifle", 1)
	inventory:Add("ar2_ammo", 1)
end

FACTION_OTA = FACTION.index
