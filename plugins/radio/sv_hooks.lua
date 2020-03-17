
local PLUGIN = PLUGIN

function PLUGIN:CanAutoFormatMessage(client, chatType, message)
	if (chatType == "radio_transmit" or chatType == "radio_eavesdrop") then
		return true
	end
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	ix.radio.ResetPlayerChannels(client)
end

function PLUGIN:CanHearRadioTrasmit(client, data)
	local channel = data.channelID

	if (ix.radio.PlayerHasChannel(client, channel)) then
		return true
	end
end

function PLUGIN:CanEavesdropRadioTrasmit(client, data, transmitPos)
	if (client:GetPos():DistToSqr(transmitPos) <= data.range^2) then
		return true
	end
end
