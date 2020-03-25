
local PLUGIN = PLUGIN

PLUGIN.name = "Gas Zones"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds in toxic gas zones."

ix.lang.AddTable("english", {
	gas = "Gas",
})

ix.config.Add("gasDelay", 5, "How long between gas damage.", nil, {
	data = {min = 1, max = 128},
	category = "Gas Zones"
})

ix.config.Add("gasDamage", 15, "How much damage gas does.", nil, {
	data = {min = 0, max = 100},
	category = "Gas Zones"
})

ix.config.Add("fastGasReheal", true, "If fast rehealing gas damage is enabled.", nil, {
	category = "Gas Zones"
})

function PLUGIN:SetupAreaProperties()
	ix.area.AddType("gas")
end

if (SERVER) then
	local painSounds = {
		male = {
			"vo/npc/male01/pain01.wav",
			"vo/npc/male01/pain04.wav",
			"vo/npc/male01/pain06.wav"
		},
		female = {
			"vo/npc/male01/pain02.wav",
			"vo/npc/male01/pain05.wav",
			"vo/npc/male01/pain07.wav"
		}
	}

	function PLUGIN:PlayerTick(client)
		if (!client:Alive() or IsValid(client)) then return end
		
		local faction = ix.faction.Get(client:Team())
		
		if (faction and faction.noGas) then
			return
		end

		local area = ix.area.stored[client:GetArea()]

		if ((!client.gasTick or client.gasTick <= CurTime()) and client.ixInArea) then
			client.gasTick = CurTime() + ix.config.Get("gasDelay", 5)

			if (area["type"] == "gas") then
				local items = client:GetItems()

				for k, v in pairs(items or {}) do
					if (v.isRespirator and v:GetData("equip", false) == true) then
						return
					end
				end

				client:SetHealth(client:Health() - ix.config.Get("gasDamage", 15))

				if (client:Health() <= 0) then
					client:Kill()
					client.gasDamage = 0

					return
				end

				if (client:IsFemale()) then
					client:EmitSound(painSounds["female"][math.random(1, #painSounds["female"])])
				else
				    client:EmitSound(painSounds["male"][math.random(1, #painSounds["male"])])
				end

				if (ix.config.Get("fastGasReheal", true) == true) then
					client.gasDamage = client.gasDamage and client.gasDamage + ix.config.Get("gasDamage", 15) or ix.config.Get("gasDamage", 15)
				end
			end
		end

		if (ix.config.Get("fastGasReheal", true) != true) then return end

		if ((client.gasDamage and client.gasDamage > 0) and (!client.gasRehealTick or client.gasRehealTick <= CurTime())) then
			client.gasRehealTick = CurTime() + 0.25

			if (area and area["type"] == "gas" and client.ixInArea) then
				return
			end

			client:SetHealth(math.min(client:Health() + 1, client:GetMaxHealth()))
			client.gasDamage = math.max(client.gasDamage - 2, 0)
		end
	end

	function PLUGIN:OnPlayerAreaChanged(client, oldID, newID)
		local area = ix.area.stored[newID]

		if (area and area["type"] == "gas") then
			local items = client:GetItems()

			for k, v in pairs(items or {}) do
				if (v.isRespirator and v:GetData("equip", false) == true) then
					return
				end
			end

			client:Notify("You've entered a gas zone, your lungs begin to refuse the air you breathe.")
		end
	end
end
