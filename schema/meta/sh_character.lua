
local characterMeta = ix.meta.character

function characterMeta:IsCombine()
	local faction = self:GetFaction()
	return faction == FACTION_CP or faction == FACTION_OTA or faction == FACTION_DISP
end

function characterMeta:IsDispatch()
	local faction = self:GetFaction()
	return faction == FACTION_DISP
end
