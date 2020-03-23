
FACTION.name = "Civil Worker's Union"
FACTION.description = ""
FACTION.color = Color(50, 50, 150)
FACTION.models = {
	"models/models/army/female_01.mdl",
	"models/models/army/female_02.mdl",
	"models/models/army/female_03.mdl",
	"models/models/army/female_04.mdl",
	"models/models/army/female_06.mdl",
	"models/models/army/female_07.mdl",
	"models/wichacks/artnovest.mdl",
	"models/wichacks/erdimnovest.mdl",
	"models/wichacks/ericnovest.mdl",
	"models/wichacks/joenovest.mdl",
	"models/wichacks/mikenovest.mdl",
	"models/wichacks/sandronovest.mdl",
	"models/wichacks/tednovest.mdl",
	"models/wichacks/vancenovest.mdl",
	"models/wichacks/vannovest.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local cid = string.format(math.random(1, 99999), "%05d")
	local inventory = character:GetInventory()

	character:SetData("cid", cid)

	inventory:Add("cid", 1, {
		name = character:GetName(),
		cid = tostring(cid)
	})
end

FACTION_CWU = FACTION.index
