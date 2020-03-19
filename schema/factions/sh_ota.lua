
FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = ""
FACTION.color = Color(200, 0, 0)
FACTION.models = {
	"models/bloocobalt/combine/combine_s.mdl",
	"models/bloocobalt/combine/combine_e.mdl"
}
FACTION.channels = {
	["cwui"] = true,
	["overwatch"] = true,
	["combine"] = true,
	["tac"] = true
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("pulse_rifle", 1)
	inventory:Add("ar2_ammo", 1)
end

FACTION_OTA = FACTION.index
