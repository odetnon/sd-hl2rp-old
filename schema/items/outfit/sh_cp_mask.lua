
ITEM.name = "Civil Protection Mask"
ITEM.description = "A mask with a fitted respirator and voice modulator"
ITEM.model = "models/dpfilms/metropolice/props/generic_gasmask.mdl"

ITEM.replacements = "models/dpfilms/metropolice/hdpolice.mdl"

function ITEM:CanEquipOutfit()
	return (self:GetOwner():GetModel():find("models/kake/metropolice") == true)
end
