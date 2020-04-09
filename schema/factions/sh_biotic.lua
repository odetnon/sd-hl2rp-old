
FACTION.name = "Enslaved Biotic"
FACTION.description = ""
FACTION.color = Color(100, 150, 0)
FACTION.bAllowDatafile = true
FACTION.models = {
	"models/hlvr/characters/vortigaunt/vortigaunt_uncombined_hlvr.mdl"
}

function FACTION:GetDefaultName(client)
	return "CMB:BIOTIC."..string.format(math.random(1, 99999), "%05d"), true
end

FACTION_BIOTIC = FACTION.index
