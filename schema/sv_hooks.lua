
function Schema:LoadData()
	self:LoadRationDispensers()
	self:LoadVendingMachines()
	self:LoadCombineLocks()
	self:LoadForceFields()
end

function Schema:SaveData()
	self:SaveRationDispensers()
	self:SaveVendingMachines()
	self:SaveCombineLocks()
	self:SaveForceFields()
end

function Schema:PlayerLoadout(client)
	client:SetNetVar("restricted")
end

function Schema:PlayerSwitchFlashlight(client, enabled)
	if (client:GetCharacter():GetInventory():HasItem("flashlight") or client:IsCombine()) then
		return true
	end
end

function Schema:PlayerUse(client, entity)
	if (entity:IsDoor() and IsValid(entity.ixLock) and client:KeyDown(IN_SPEED)) then
		entity.ixLock:Toggle(client)

		return false
	end
end

function Schema:PlayerUseDoor(client, door)
	if (client:IsCombine()) then
		if (!door:HasSpawnFlags(256) and !door:HasSpawnFlags(1024)) then
			door:Fire("open")
		end
	end
end

function Schema:PlayerLoadedCharacter(client, character, oldCharacter)
	local faction = character:GetFaction()

	if (faction == FACTION_CITIZEN) then
		self:AddCombineDisplayMessage("@cCitizenLoaded", Color(255, 100, 255, 255))
	elseif (client:IsCombine()) then
		client:AddCombineDisplayMessage("@cCombineLoaded")
	end
end

function Schema:CharacterVarChanged(character, key, oldValue, value)
	local client = character:GetPlayer()

	if (key == "name") then
		local factionTable = ix.faction.Get(client:Team())

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, oldValue, value)
		end
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team())

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot])
		return true
	end

	client:EmitSound(soundName)
	return true
end

function Schema:PlayerSpawn(client)
	client:SetCanZoom(client:IsCombine())
end

function Schema:PlayerDeath(client, inflicter, attacker)
	if (client:IsCombine()) then
		local location = client:GetArea() or "unknown location"

		self:AddCombineDisplayMessage("@cLostBiosignal")
		self:AddCombineDisplayMessage("@cLostBiosignalLocation", Color(255, 0, 0, 255), nil, client:GetName(), location)
		self:AddWaypoint(client:GetPos(), client:Name() .."Biosignal Lost", Color(255, 0, 0, 255), 300, client)

		local sounds = {"npc/overwatch/radiovoice/on1.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav"}
		local chance = math.random(1, 7)
		local tagline = string.upper(client:GetName()) -- Stops capitalisation being an issue (not that i'll ever make taglines lowercase)
		-- This makes dispatch say the tagline of which unit died.
		if string.find(tagline,"DEFENDER") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/defender.wav"
		elseif string.find(tagline,"HERO") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/hero.wav"
		elseif string.find(tagline,"JURY") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/jury.wav"
		elseif string.find(tagline,"KING") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/king.wav"
		elseif string.find(tagline,"QUICK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/quick.wav"
		elseif string.find(tagline,"ROLLER") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/roller.wav"
		elseif string.find(tagline,"STICK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/stick.wav"
		elseif string.find(tagline,"UNION") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/union.wav"
		elseif string.find(tagline,"VICE") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/vice.wav"
		elseif string.find(tagline,"VICTOR") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/victor.wav"
		elseif string.find(tagline,"XRAY") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/xray.wav"
		elseif string.find(tagline,"YELLOW") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/yellow.wav"
		end
		-- This makes dispatch say the number of which unit died (it works I guess? not the most robust method maybe?).
		if string.find(tagline,"-1") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/one.wav"
		elseif string.find(tagline,"-2") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/two.wav"
		elseif string.find(tagline,"-3") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/three.wav"
		elseif string.find(tagline,"-4") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/four.wav"
		elseif string.find(tagline,"-5") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/five.wav"
		elseif string.find(tagline,"-6") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/six.wav"
		elseif string.find(tagline,"-7") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/seven.wav"
		elseif string.find(tagline,"-8") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/eight.wav"
		elseif string.find(tagline,"-9") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/nine.wav"
		end
		-- Says the name of the location the biosignal was lost.
		if string.find(dispatchLocation,"POLITI-CONTROL SECTION") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/controlsection.wav"
		elseif string.find(dispatchLocation,"404 ZONE") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/404zone.wav"
		elseif string.find(dispatchLocation,"CANAL BLOCK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/canalblock.wav"
		elseif string.find(dispatchLocation,"CONDEMNED ZONE") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/condemnedzone.wav"
		elseif string.find(dispatchLocation,"RESTRICTED BLOCK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/deservicedarea.wav"
		elseif string.find(dispatchLocation,"DISTRIBUTION BLOCK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/distributionblock.wav"
		elseif string.find(dispatchLocation,"EXTERNAL JURISDICTION") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/externaljurisdiction.wav"
		elseif string.find(dispatchLocation,"HIGH PRIORITY REGION") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/highpriorityregion.wav"
		elseif string.find(dispatchLocation,"INDUSTRIAL ZONE") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/industrialzone.wav"
		elseif string.find(dispatchLocation,"INFESTED ZONE") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/infestedzone.wav"
		elseif string.find(dispatchLocation,"OUTLAND ZONE") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/outlandzone.wav"
		elseif string.find(dispatchLocation,"PRODUCTION BLOCK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/productionblock.wav"
		elseif string.find(dispatchLocation,"REPURPOSED AREA") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/repurposedarea.wav"
		elseif string.find(dispatchLocation,"RESIDENTIAL BLOCK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/residentialblock.wav"
		elseif string.find(dispatchLocation,"STORM SYSTEM") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/stormsystem.wav"
		elseif string.find(dispatchLocation,"TERMINAL RESTRICTION ZONE") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/terminalrestrictionzone.wav"
		elseif string.find(dispatchLocation,"TRANSIT BLOCK") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/transitblock.wav"
		elseif string.find(dispatchLocation,"WASTE RIVER") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/wasteriver.wav"
		elseif string.find(dispatchLocation,"WORKFORCE INTAKE HUB") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/workforceintake.wav"
		end
		-- Says the number of the location the biosignal was lost.
		if string.find(dispatchLocation,"1") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/one.wav"
		elseif string.find(dispatchLocation,"2") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/two.wav"
		elseif string.find(dispatchLocation,"3") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/three.wav"
		elseif string.find(dispatchLocation,"4") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/four.wav"
		elseif string.find(dispatchLocation,"5") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/five.wav"
		elseif string.find(dispatchLocation,"6") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/six.wav"
		elseif string.find(dispatchLocation,"7") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/seven.wav"
		elseif string.find(dispatchLocation,"8") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/eight.wav"
		elseif string.find(dispatchLocation,"9") then
			sounds[#sounds+1] = "npc/overwatch/radiovoice/nine.wav"
		end
		-- Ends off the biosignal loss with one of these, or if the chance is above 3 then none of them.
		if (chance == 1) then
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/remainingunitscontain.wav"
		elseif (chance == 2) then
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/reinforcementteamscode3.wav"
		elseif (chance == 3) then
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/allteamsrespondcode3.wav"
		end

		sounds[#sounds + 1] = "npc/overwatch/radiovoice/off4.wav"

		for k, v in ipairs(player.GetAll()) do
			if (v:IsCombine()) then
				ix.util.EmitQueuedSounds(v, sounds, 0, nil, v == client and 100 or 80)
			end
		end
	end
end

function Schema:PlayerHurt(client, attacker, health, damage)
	if (health <= 0) then
		return
	end

	if (client:IsCombine() and (client.ixTraumaCooldown or 0) < CurTime()) then
		local text = "External"
		local unitName = client:GetName()

		if (damage > 50) then
			text = "Severe"
		end

		self:AddCombineDisplayMessage("@cTrauma", Color(255, 255, 0, 255), nil, text, unitName)

		if (health < 25) then
			client:AddCombineDisplayMessage("@cDroppingVitals", Color(255, 255, 0, 255))
		end

		client.ixTraumaCooldown = CurTime() + 15
	end
end

function Schema:CanPlayerJoinClass(client, class, info)
	if (client:IsRestricted()) then
		client:Notify("You cannot change classes when you are restrained!")

		return false
	end
end

function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if (chatType == "ic" or chatType == "w" or chatType == "y" or chatType == "radio_eavesdrop" or chatType == "dispatch") then
		local class = self.voices.GetClass(speaker)

		for k, v in ipairs(class) do
			local info = self.voices.Get(v, rawText)

			if (info) then
				local volume = 80

				if (chatType == "w") then
					volume = 60
				elseif (chatType == "y") then
					volume = 150
				end

				if (info.sound) then
					if (info.global) then
						netstream.Start(nil, "PlaySound", info.sound)
						net.Start("PlaySound")
							net.WriteString(info.sound)
						net.Broadcast()
					else
						speaker.bTypingBeep = nil
						ix.util.EmitQueuedSounds(speaker, {info.sound, "NPC_MetroPolice.Radio.Off"}, nil, nil, volume)
					end
				end

				if (speaker:IsCombine()) then
					return string.format("<:: %s ::>", info.text)
				else
					return info.text
				end
			end
		end

		if (speaker:IsCombine()) then
			return string.format("<:: %s ::>", text)
		end
	end
end

function Schema:PlayerSpawnObject(client)
	if (client:IsRestricted()) then
		return false
	end
end

function Schema:PlayerStaminaLost(client)
	client:AddCombineDisplayMessage("@cStaminaLost", Color(255, 255, 0, 255))
end

function Schema:PlayerStaminaGained(client)
	client:AddCombineDisplayMessage("@cStaminaGained", Color(0, 255, 0, 255))
end

function Schema:PlayerSpray(client)
	return true
end

net.Receive("PlayerChatTextChanged", function(length, client)
	local key = net.ReadString()

	if (client:IsCombine() and !client.bTypingBeep
	and (key == "y" or key == "w" or key == "r" or key == "t")) then
		client:EmitSound("NPC_MetroPolice.Radio.On")
		client.bTypingBeep = true
	end
end)

net.Receive("PlayerFinishChat", function(length, client)
	if (client:IsCombine() and client.bTypingBeep) then
		client:EmitSound("NPC_MetroPolice.Radio.Off")
		client.bTypingBeep = nil
	end
end)
