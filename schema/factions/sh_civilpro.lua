
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
	return "c17:00.TAGLINE-0", true
end

FACTION_CP = FACTION.index
