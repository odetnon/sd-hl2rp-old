ITEM.name = "Consumable"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.thirst = 0
ITEM.hunger = 0
ITEM.damage = 0
ITEM.health = 0
ITEM.stamina = 0
ITEM.category = "Consumables"

ITEM.drinkSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"}
ITEM.eatSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"}

ITEM.functions.Use = {
	name = "Consume",
	icon = "icon16/cup.png",
	OnRun = function(item)
		local client = item.player

		if (item.thirst != 0) then
			client:GetCharacter():SetData("thirst", math.Clamp(client:GetCharacter():GetData("thirst", 0) - item.thirst, 0, 100))
		end

		if (item.hunger != 0) then
			client:GetCharacter():SetData("hunger", math.Clamp(client:GetCharacter():GetData("hunger", 0) - item.hunger, 0, 100))
		end

		if (item.health != 0) then
			client:SetHealth(math.Clamp(client:Health() + item.health, 0, client:GetMaxHealth()))
		end

		if (item.stamina != 0) then
			client:RestoreStamina(item.stamina)
		end

		if (item.damage != 0) then
			client:SetHealth(client:Health() - item.damage)

			if client:Health() <= 0 then
				client:Kill()
			end
		end

		if (item.junk and type(item.junk) == "string") then
			local junk = client:GetCharacter():GetInv():Add(item.junk)

			if (junk) then
				client:GetCharacter():GetInv():sync(client)
			else
				ErrorNoHalt("[Error] Consumable "..item.name.." attempted to give unexisting junk item "..item.junk..".")
			end
		end

		if (item.hunger > 0) then
			if type(item.eatSound) == "table" then
				item.player:EmitSound(item.eatSound[math.random(1, #item.eatSound)])
			else
				item.player:EmitSound(item.drinkeatSoundSound, 75, 90, 0.35)
			end
		elseif (item.thirst > 0) then
			if type(item.drinkSound) == "table" then
				item.player:EmitSound(item.drinkSound[math.random(1, #item.drinkSound)])
			else
				item.player:EmitSound(item.drinkSound, 75, 90, 0.35)
			end
		end
	end
}