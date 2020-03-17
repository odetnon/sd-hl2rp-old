
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

	if (ix.radio.PlayerHasChannel(client, channel, !data.actualChannel)) then
		return true
	end
end

function PLUGIN:CanEavesdropRadioTrasmit(client, data, transmitPos)
	if (client:GetPos():DistToSqr(transmitPos) <= data.range^2) then
		return true
	end
end

local function AddItemChannel(client, freq)
	ix.radio.AddChannelToPlayer(client, freq:find("^%d%d%d.%d$") and "FREQ "..freq or freq, true)

	local transmitChannel = client:GetLocalVar("transmitChannel")

	if (!transmitChannel or !ix.radio.PlayerHasChannel(client, transmitChannel)) then
		ix.radio.ResetPlayerTransmitChannel(client, true)
	end
end

local function RemoveItemChannel(client, freq)
	ix.radio.RemoveChannelFromPlayer(client, freq:find("^%d%d%d.%d$") and "FREQ "..freq or freq, true)
end

function PLUGIN:OnResetPlayerChannels(client)
	local items = client:GetItems()

	if (items) then
		for _, item in pairs(items) do
			if (item:GetData("frequency", "000.0") != "000.0") then
				AddItemChannel(client, item:GetData("frequency"))
			end
		end
	end
end

function PLUGIN:InventoryItemAdded(oldInv, inventory, item)
	if (!inventory.owner or (oldInv and oldInv.owner == inventory.owner)) then return end

	local client = inventory:GetOwner()

	if (item:GetData("frequency", "000.0") != "000.0") then
		AddItemChannel(client, item:GetData("frequency"))
	end
end

function PLUGIN:InventoryItemRemoved(inventory, item)
	if (!inventory.owner) then return end

	local client = inventory:GetOwner()

	if (item:GetData("frequency", "000.0") != "000.0") then
		RemoveItemChannel(client, item:GetData("frequency"))
	end
end

net.Receive("ixItemFrequency", function(length, client)
	local itemID = net.ReadUInt(16)
	local freq = net.ReadString()

	local item = client:GetCharacter():GetInventory():GetItemByID(itemID)

	if (item and freq:find("^%d%d%d.%d$")) then
		if (tonumber(freq) >= 100.0) then
			item:SetData("frequency", freq)

			ix.radio.ResetPlayerChannels(client)
		else
			return false
		end
	else
		return false
	end
end)
