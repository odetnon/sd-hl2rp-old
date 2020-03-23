
local PLUGIN = PLUGIN

ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if !character then return 0 end

	local hunger = character:GetData("hunger", 0)

	if (!PLUGIN.hunger) then
		PLUGIN.hunger = hunger
	else
		PLUGIN.hunger = math.Approach(PLUGIN.hunger, hunger, 1)
	end

	local text, color = PLUGIN:GetHungerText(PLUGIN.hunger)

	return PLUGIN.hunger/100, text
end, Color(155, 155, 0), nil, "hunger")

ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if !character then return 0 end

	local thirst = character:GetData("thirst", 0)

	if (!PLUGIN.thirst) then
		PLUGIN.thirst = thirst
	else
		PLUGIN.thirst = math.Approach(PLUGIN.thirst, thirst, 1)
	end

	local text, color = PLUGIN:GetThirstText(PLUGIN.thirst)

	return PLUGIN.thirst/100, text
end, Color(155, 155, 0), nil, "thirst")

function PLUGIN:CreateCharacterInfo(panel)
	if (panel) then
		panel.hunger = panel:Add("ixListRow")
		panel.hunger:SetList(panel.list)
		panel.hunger:Dock(TOP)
		panel.hunger:SizeToContents()

		panel.thirst = panel:Add("ixListRow")
		panel.thirst:SetList(panel.list)
		panel.thirst:Dock(TOP)
		panel.thirst:SizeToContents()
	end
end

function PLUGIN:UpdateCharacterInfo(panel)
	if (panel.hunger) then
		panel.hunger:SetLabelText("Hunger")

		local hunger = LocalPlayer():GetChar():GetData("hunger", 0)

		if (!self.hunger) then
			self.hunger = hunger
		else
			self.hunger = math.Approach(self.hunger, hunger, 1)
		end

		local text = self:GetHungerText(self.hunger)

		panel.hunger:SetText(text.." ["..math.Round(self.hunger).."%]")
	end

	if (panel.thirst) then
		panel.thirst:SetLabelText("Thirst")

		local thirst = LocalPlayer():GetChar():GetData("thirst", 0)

		if (!self.thirst) then
			self.thirst = thirst
		else
			self.thirst = math.Approach(self.thirst, thirst, 1)
		end

		local text = self:GetThirstText(self.thirst)

		panel.thirst:SetText(text.." ["..math.Round(self.thirst).."%]")
	end
end
