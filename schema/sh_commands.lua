
local communityCommands = {
	["Content"] = {desc = "Open the servers content pack.", url = "https://steamcommunity.com/sharedfiles/filedetails/?id=1593990171"},
	["Discord"] = {desc = "Get the community discord invite link.", url = "https://discord.gg/CZpYthQ"},
}

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "dispatch", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Dispatch", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		if (inventory:HasItem("request_device") or client:IsCombine() or client:Team() == FACTION_CAB) then
			if (!client:IsRestricted()) then
				Schema:AddCombineDisplayMessage("@cRequest", Color(0, 0, 255, 255), nil, client:Name())
				Schema:AddWaypoint(client:GetPos(), client:Name() ..": Civil Request", Color(0, 0, 255, 255), 300, client)

				local requestLocation = string.upper(client:GetArea())
				local sounds = {"npc/overwatch/radiovoice/on1.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/alarms62.wav", "npc/overwatch/radiovoice/inprogress.wav", "npc/overwatch/radiovoice/allunitsat.wav"}
				-- Says the name of the location the request was made.
				if string.find(requestLocation,"POLITI-CONTROL SECTION") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/controlsection.wav"
				elseif string.find(requestLocation,"404 ZONE") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/404zone.wav"
				elseif string.find(requestLocation,"CANAL BLOCK") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/canalblock.wav"
				elseif string.find(requestLocation,"CONDEMNED ZONE") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/condemnedzone.wav"
				elseif string.find(requestLocation,"RESTRICTED BLOCK") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/deservicedarea.wav"
				elseif string.find(requestLocation,"DISTRIBUTION BLOCK") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/distributionblock.wav"
				elseif string.find(requestLocation,"HIGH PRIORITY REGION") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/highpriorityregion.wav"
				elseif string.find(requestLocation,"INDUSTRIAL ZONE") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/industrialzone.wav"
				elseif string.find(requestLocation,"INFESTED ZONE") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/infestedzone.wav"
				elseif string.find(requestLocation,"OUTLAND ZONE") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/outlandzone.wav"
				elseif string.find(requestLocation,"PRODUCTION BLOCK") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/productionblock.wav"
				elseif string.find(requestLocation,"REPURPOSED AREA") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/repurposedarea.wav"
				elseif string.find(requestLocation,"RESIDENTIAL BLOCK") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/residentialblock.wav"
				elseif string.find(requestLocation,"STORM SYSTEM") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/stormsystem.wav"
				elseif string.find(requestLocation,"TERMINAL RESTRICTION ZONE") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/terminalrestrictionzone.wav"
				elseif string.find(requestLocation,"TRANSIT BLOCK") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/transitblock.wav"
				elseif string.find(requestLocation,"WASTE RIVER") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/wasteriver.wav"
				elseif string.find(requestLocation,"WORKFORCE INTAKE HUB") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/workforceintake.wav"
				end
				-- Says the number of the location the request was made.
				if string.find(requestLocation,"1") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/one.wav"
				elseif string.find(requestLocation,"2") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/two.wav"
				elseif string.find(requestLocation,"3") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/three.wav"
				elseif string.find(requestLocation,"4") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/four.wav"
				elseif string.find(requestLocation,"5") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/five.wav"
				elseif string.find(requestLocation,"6") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/six.wav"
				elseif string.find(requestLocation,"7") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/seven.wav"
				elseif string.find(requestLocation,"8") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/eight.wav"
				elseif string.find(requestLocation,"9") then
					sounds[#sounds+1] = "npc/overwatch/radiovoice/nine.wav"
				end

				sounds[#sounds + 1] = "npc/overwatch/radiovoice/respond.wav"
				sounds[#sounds + 1] = "npc/overwatch/radiovoice/off4.wav"
				
				for k, v in ipairs(player.GetAll()) do
					if (v:IsCombine()) then
						ix.util.EmitQueuedSounds(v, sounds, 0, nil, v == client and 100 or 80)
					end
				end

				ix.chat.Send(client, "request", message)
				ix.chat.Send(client, "request_eavesdrop", message)
			else
				return "@notNow"
			end
		else
			return "@needRequestDevice"
		end
	end

	ix.command.Add("Request", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.character
	COMMAND.privilege = "Manage Character Flags"
	COMMAND.superAdminOnly = true
	COMMAND.description = "@cmdCharViewFlags"

	function COMMAND:OnRun(client, target)
		if (target:GetFlags() != "") then
			client:NotifyLocalized("charFlags", client:GetName(), target:GetFlags())
		else
		    client:NotifyLocalized("charNoFlags", target:GetName())
		end
	end

	ix.command.Add("CharViewFlags", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "broadcast", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Broadcast", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:IsRestricted()) then
			if (!client:IsRestricted()) then
				Schema:SearchPlayer(client, target)
			else
				return "@notNow"
			end
		end
	end

	ix.command.Add("CharSearch", COMMAND)
end

do
	for cmd, cmdTbl in pairs(communityCommands) do
		ix.command.Add(cmd, {
			description = cmdTbl.desc,
			OnRun = function(self, client)
				client:SendLua("gui.OpenURL(\""..cmdTbl.url.."\")")
			end
		})
	end
end
