
local playerMeta = FindMetaTable("Player")

function playerMeta:AddHealBoost(amount)
	if (amount <= 0) then return end

	if (!self.healBoosts) then
		self.healBoosts = {}
	end

	local curBoost = 0

	for k, v in pairs(self.healBoosts) do
		curBoost = curBoost + v
	end

	if (curBoost + amount > ix.config.Get("maxHealBoost", 100)) then return end

	local healRepetitions = ix.config.Get("healRepetitions", 4)
	local healDelay = ix.config.Get("healDelay", 4)

	local index = (#self.healBoosts + 1)

	self.healBoosts[index] = amount

	local timerIdentifier = (self:UniqueID().."healBoost"..index)

	timer.Create(timerIdentifier, healDelay, healRepetitions, function()
		if (!self:Alive()) then
			self.healBoosts[index] = nil

			timer.Destroy(timerIdentifier)
			return
		end

		self:SetHealth(math.min(self:Health() + (amount / healRepetitions), self:GetMaxHealth()))

		if (timer.RepsLeft(timerIdentifier) == 0) then
			self.healBoosts[index] = nil
		end
	end)
end
