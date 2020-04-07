
FACTION.name = "Union Medical"
FACTION.description = "A Union Medical employee, specialised in the area of medicine and healthcare."
FACTION.color = Color(150, 125, 100, 255)
FACTION.models = {}
FACTION.bAllowDatafile = true

for i = 1, 4 do
	table.insert(FACTION.models, "models/humans/medic/female_0"..i..".mdl")
end

for i = 6, 7 do
	table.insert(FACTION.models, "models/humans/medic/female_0"..i..".mdl")
end

for i = 1, 9 do
	table.insert(FACTION.models, "models/humans/medic/male_0"..i..".mdl")
end

function FACTION:OnCharacterCreated(client, character)
	local cid = string.format(math.random(1, 99999), "%05d")
	local inventory = character:GetInventory()

	character:SetData("cid", cid)

	inventory:Add("cid", 1, {
		name = character:GetName(),
		cid = tostring(cid)
	})
end

FACTION_UM = FACTION.index
