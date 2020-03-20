
local characterMeta = ix.meta.character

function characterMeta:IsCombine()
	return IsValid(self) and (self:GetFaction() == FACTION_CP or self:GetFaction() == FACTION_OTA or self:GetFaction() == FACTION_DISP)
end
