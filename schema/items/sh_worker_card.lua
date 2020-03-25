
ITEM.name = "Worker Card"
ITEM.description = "A metal card with combine insignia"
ITEM.model = "models/gibs/metal_gib4.md"

function ITEM:PopulateTooltip(tooltip)
	local cid = tooltip:AddRowAfter("name", "cid")
	cid:SetText("[ ID #"..self:GetData("cid", "00000").." ]")
	cid:SetBackgroundColor(Color(0, 150, 250))
	cid:SizeToContents()
end
