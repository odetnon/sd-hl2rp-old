
ITEM.name = "CWU-I Radio"
ITEM.description = "A small handheld radio."
ITEM.model = "models/props_junk/PopCan01a.mdl"

function ITEM:OnInstanced(index, x, y, item)
	item:SetData("frequency", "CWU-I")
end
