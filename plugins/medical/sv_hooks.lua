
local PLUGIN = PLUGIN

function PLUGIN:PlayerTick(client)
	if (client.bleeding) then
		if (!client.bleedTick or client.bleedTick <= CurTime()) then
			client.bleedTick = CurTime() + ix.config.Get("bleedTick", 15)

			client:SetHealth(math.max(client:Health() - ix.config.Get("bleedDamage", 2), 0))
			client:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav")
		end
	end
end

function PLUGIN:EntityTakeDamage(entity, dmgInfo)
	if (!entity:IsPlayer()) then return end

	if (dmgInfo:IsBulletDamage()) then
		entity.bleeding = true
	end

	for k, v in pairs(entity.healBoosts or {}) do
		local timerIdentifier = (entity:UniqueID().."healBoost"..k)

		if (timer.Exists(timerIdentifier)) then
			timer.Destroy(timerIdentifier)
		end
	end

	entity.healBoosts = {}
end

function PLUGIN:PlayerDeath(client)
	client.bleeding = false

	for k, v in pairs(client.healBoosts or {}) do
		local timerIdentifier = (client:UniqueID().."healBoost"..k)

		if (timer.Exists(timerIdentifier)) then
			timer.Destroy(timerIdentifier)
		end
	end

	client.healBoosts = {}
end
