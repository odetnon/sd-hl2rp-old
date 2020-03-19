
FACTION.name = "Civil Protection"
FACTION.description = ""
FACTION.color = Color(50, 150, 250)
FACTION.models = {
	"models/kake/metropolice_female01.mdl",
	"models/kake/metropolice_female02.mdl",
	"models/kake/metropolice_female03.mdl",
	"models/kake/metropolice_female04.mdl",
	"models/kake/metropolice_female06.mdl",
	"models/kake/metropolice_female06_naomi.mdl",
	"models/kake/metropolice_male01.mdl",
	"models/kake/metropolice_male02.mdl",
	"models/kake/metropolice_male03.mdl",
	"models/kake/metropolice_male04.mdl",
	"models/kake/metropolice_male05.mdl",
	"models/kake/metropolice_male06.mdl",
	"models/kake/metropolice_male07.mdl",
	"models/kake/metropolice_male09.mdl",
	"models/kake/metropolice_male09_hair.mdl"
}
FACTION.channels = {
	["combine"] = true,
	["tac"] = true
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("stunstick", 1)
	inventory:Add("usp_match", 1)
	inventory:Add("9mm_ammo", 1)
	inventory:Add("cp_mask", 1)
end

function FACTION:GetDefaultName(client)
	return "c17:00.TAGLINE-0", true
end

FACTION_CP = FACTION.index
