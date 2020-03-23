
local characterMeta = ix.meta.character

function characterMeta:IsCombine()
	return (self:GetFaction() == FACTION_CP or self:GetFaction() == FACTION_OTA or self:GetFaction() == FACTION_DISP)
end

function characterMeta:IsDispatch()
	return (self:GetFaction() == FACTION_DISP)
end
