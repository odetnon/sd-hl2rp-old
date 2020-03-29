CLASS.name = "Elite Metropolice"
CLASS.faction = FACTION_MPF
CLASS.isDefault = false

function CLASS:OnCanBe(client)
	local name = client:Name()
	local bStatus = false

	for k, v in ipairs({ "RL", "HC"}) do
		if (Schema:IsCombineRank(name, v)) then
			bStatus = true

			break
		end
	end

	return bStatus
end

CLASS_EMP = CLASS.index