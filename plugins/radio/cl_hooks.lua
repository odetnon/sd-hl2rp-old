
local PLUGIN = PLUGIN

function PLUGIN:HUDPaint()
	if (!IsValid(ix.gui.chat)) then return end

	local channelString = "none"
	local transmitString = "none"

	local channels = LocalPlayer():GetLocalVar("channels")
	local transmitChannel = LocalPlayer():GetLocalVar("transmitChannel")

	if (channels and table.Count(channels) > 0) then
		channelString = {}

		for k, v in pairs(channels) do
			local channel = ix.radio.Get(k)

			if (channel) then
				channelString[k] = channel.name
			end
		end

		channelString = table.concat(channelString, ", ")
	end

	if (transmitChannel) then
		local channel = ix.radio.Get(transmitChannel)

		if (channel) then
			transmitString = channel.name
		end
	end

	local textColor = ColorAlpha(color_white, ix.gui.chat:GetAlpha())
	local x, y = chat.GetChatBoxPos()

	draw.SimpleText("Radio Channels: "..channelString, "BudgetLabel", x, y - 36, textColor)
	draw.SimpleText("Transmit Channel: "..transmitString, "BudgetLabel", x, y - 18, textColor)
end
