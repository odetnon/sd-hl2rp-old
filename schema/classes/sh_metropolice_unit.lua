CLASS.name = "Metropolice Unit"
CLASS.faction = FACTION_MPF

function CLASS:OnCanBe(client)
	local name = client:Name()
	local bStatus = false

	for k, v in ipairs({ "i5", "i4", "i3"}) do
		if (Schema:IsCombineRank(name, v)) then
			bStatus = true

			break
		end
	end

	return bStatus
end

CLASS_MPU = CLASS.index