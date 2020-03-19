
ITEM.name = "Medical Base"
ITEM.description = "A healing item"
ITEM.model = "models/warz/items/bandage.mdl"

ITEM.stopBleed = false
ITEM.useSound = nil
ITEM.slowHealth = 0
ITEM.instantHealth = 0

ITEM.functions.Heal = {
	icon = "icon16/heart.png",
	OnRun = function(item)
		local client = item.player

		if (item.stopBleed) then
			client.bleeding = false
		end

		if (item.slowHealth > 0) then
			client:AddHealBoost(item.slowHealth)
		end

		if (item.instantHealth > 0) then
			client:SetHealth(math.min(client:Health() + item.instantHealth, client:GetMaxHealth()))
		end

		if (item.useSound) then
			client:EmitSound(item.useSound)
		end
	end
}

ITEM.functions.Apply = {
	icon = "icon16/pill_go.png",
	OnCanRun = function(item)
		if (IsValid(item.entity)) then
			return false
		end

		local entity = item.player:GetEyeTraceNoCursor().Entity

		if (entity:IsPlayer()) then
			return true
		end

		return false
	end,
	OnRun = function(item)
		local client = item.player
		local entity = client:GetEyeTraceNoCursor().Entity

		if (IsValid(entity) and entity:Alive()) then
			if (item.stopBleed) then
				entity.bleeding = false
			end

			if (item.slowHealth > 0) then
				entity:AddHealBoost(item.slowHealth)
			end

			if (item.instantHealth > 0) then
				entity:SetHealth(math.min(entity:Health() + item.instantHealth, entity:GetMaxHealth()))
			end

			if (item.useSound) then
				entity:EmitSound(item.useSound)
			end
		end
	end
}
