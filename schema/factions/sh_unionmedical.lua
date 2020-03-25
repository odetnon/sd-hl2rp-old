
FACTION.name = "Union Medical"
FACTION.description = "A Union Medical employee, specialised in the area of medicine and healthcare."
FACTION.color = Color(150, 125, 100, 255)
FACTION.models = {}
FACTION.bAllowDatafile = true
FACTION.listenChannels = {["union"] = 1, ["um"] = 1}

for i = 1, 4 do
	table.insert(FACTION.models, "models/player/zelpa/clockwork/female_0"..i..".mdl")
end

for i = 6, 7 do
	table.insert(FACTION.models, "models/player/zelpa/clockwork/female_0"..i..".mdl")
end

for i = 1, 10 do
	table.insert(FACTION.models, "models/player/zelpa/clockwork/male_0"..i..".mdl")
end

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )

	character:SetData("cid", id)

	inventory:Add("suitcase", 1)
	inventory:Add("cid", 1, {
		["citizen_name"] = character:GetName(),
		["cid"] = id,
		["issue_date"] = TimeString,
	})
end

FACTION_CWU = FACTION.index
