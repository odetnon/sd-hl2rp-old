
FACTION.name = "Civil Protection"
FACTION.description = ""
FACTION.color = Color(50, 150, 250)
FACTION.models = {"models/cultist/hl_a/metropolice/metrocop.mdl"}
FACTION.isGloballyRecognized = false
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}
FACTION.channels = {
	["combine"] = true,
	["tac"] = true
}
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("stunstick", 1)
	inventory:Add("usp_match", 1)
	inventory:Add("9mm_ammo", 1)
end

function FACTION:GetDefaultName(client)
	return "c17:00.TAGLINE-0", true
end

FACTION_CP = FACTION.index
