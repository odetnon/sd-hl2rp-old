
local PLUGIN = PLUGIN

function PLUGIN:CharacterPreSave(character)
	character:SetData("hunger", math.Round(character:GetData("hunger", 0), 7))
	character:SetData("thirst", math.Round(character:GetData("thirst", 0), 7))
end

function PLUGIN:PlayerDeath(client)
	client:GetChar():SetData("hunger", 0)
	client:GetChar():SetData("thirst", 0)
end

-- Called at an interval while a player is connected.
function PLUGIN:PlayerTick(client)
	local curTime = CurTime()

	if !IsValid(client) then
		return
	end

	if !client:Alive() then
		return
	end

	if !client:GetChar() then
		return
	end

	local playerFaction = ix.faction.Get(client:Team())

	if playerFaction then
		if playerFaction.noNeeds then
			return
		end
	end

	if (!client.nextNeeds or client.nextNeeds < curTime) then
		local tickTime = ix.config.Get("needsTickTime")
		client.nextNeeds = curTime + tickTime
		local scale = 1

		local hunger = math.Clamp(client:GetChar():GetData("hunger", 0) + 60 * scale * tickTime /
			(3600 * ix.config.Get("hungerHours")), 0, 100)
		local thirst = math.Clamp(client:GetChar():GetData("thirst", 0) + 60 * scale * tickTime /
			(3600 * ix.config.Get("thirstHours")), 0, 100)
		-- Lose 60 hunger every 6 hours, 60 thirst every 4 hours
		client:GetChar():SetData("hunger", hunger)
		client:GetChar():SetData("thirst", thirst)

		if (ix.config.Get("killOnMaxNeeds") == true) then
			if (hunger == 100) then
				client:Notify("You have starved to death!")
				client:Kill()
			elseif (thirst == 100) then
				client:Notify("You have died from dehydration!")
				client:Kill()
			end
		end
	end
end
