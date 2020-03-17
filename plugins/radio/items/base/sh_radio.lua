
ITEM.name = "Radio Base"
ITEM.description = "A basic radio with a changable frequency."

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local freq = tooltip:AddRowAfter("name", "frequency")
		freq:SetText("Frequency: "..self:GetData("frequency", "000.0"))
		freq:SetBackgroundColor(derma.GetColor("Success", tooltip))
		freq:SizeToContents()
	end
end

ITEM.functions.Frequency = {
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetData("frequency", "000.0"):find("^%d%d%d.%d$")
	end,
	OnRun = function(item)
		net.Start("ixItemFrequency")
			net.WriteString(item:GetData("frequency", "000.0"))
			net.WriteUInt(item.id, 16)
		net.Send(item.player)

		return false
	end
}
