
FACTION.name = "Conscript Biotic"
FACTION.description = ""
FACTION.color = Color(0, 120, 0)
FACTION.models = {"models/vortigaunt_slave.mdl"}
FACTION.weapons = {"swep_vortigaunt_sweep"}
FACTION.isDefault = true
FACTION.isGloballyRecognized = false

function FACTION:GetDefaultName(client)
	return "CMB:BIOTIC."..string.format(math.random(1, 99999), "%05d"), true
end

FACTION_BIOTIC = FACTION.index
