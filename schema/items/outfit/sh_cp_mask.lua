
ITEM.name = "Civil Protection Mask"
ITEM.description = "A mask with a fitted respirator and voice modulator"
ITEM.model = "models/dpfilms/metropolice/props/generic_gasmask.mdl"

ITEM.replacements = "models/dpfilms/metropolice/hdpolice.mdl"

function ITEM:CanEquipOutfit()
	local clientModel = self:GetOwner():GetModel()

	if (clientModel:find("/metropolice_")) then
		return true
	end

	return false
end
