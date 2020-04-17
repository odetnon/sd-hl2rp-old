
local playerMeta = FindMetaTable("Player")

function playerMeta:IsCombine()
	if (!IsValid(self)) then
		return
	end
	
	local team = self:Team()

	return team == FACTION_CP or team == FACTION_OTA or team == FACTION_DISP
end

function playerMeta:IsDispatch()
	if (!IsValid(self)) then
		return
	end
	
	local team = self:Team()

	return team == FACTION_DISP
end
