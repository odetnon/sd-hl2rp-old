
ITEM.name = "Citizen Identification Card"
ITEM.description = "A small card with combine branding"
ITEM.model = "models/sky/cid.mdl"

function ITEM:PopulateTooltip(tooltip)
	local cid = tooltip:AddRowAfter("name", "cid")
	cid:SetText("[ CARD HOLDER: "..self:GetData("name", "ERROR"):upper().." ] - [ ID #"..self:GetData("cid", "00000").." ]")
	cid:SetBackgroundColor(Color(0, 150, 250))
	cid:SizeToContents()
end
