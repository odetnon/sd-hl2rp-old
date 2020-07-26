
local PLUGIN = PLUGIN

PLUGIN.name = "Dispatch Plus"
PLUGIN.author = "Sundown HL2RP"
PLUGIN.description = "Adds in automated dispatch announcements."
-- List for the random announcements that can play.
PLUGIN.list = {
    {"npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav", "Citizen reminder: Inaction is conspiracy. Report counter-behaviour to a Civil Protection team immediately."},
    {"npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav", "Citizen notice: Failure to cooperate will result in permanent off-world relocation."}
  }
  
-- Adds the config option for the delay between broadcasts.
ix.config.Add("dispatchBroadcastInterval", 30, "The time between automatic Dispatch broadcasts in minutes.", nil, {
	data = {min = 1, max = 120},
	category = "Dispatch Plus"
})
-- Adds the config option to enable/disable curfew.
ix.config.Add("enableCurfew", true, "Whether curfew is enabled or disabled.", nil, {
    category = "Dispatch Plus"
})
-- Adds the config option for the time curfew starts.
ix.config.Add("curfewStartTime", 23, "The hour of day that curfew starts.", nil, {
	data = {min = 1, max = 24},
	category = "Dispatch Plus"
})
-- Adds the config option for the time curfew ends.
ix.config.Add("curfewEndTime", 6, "The hour of day that curfew ends.", nil, {
	data = {min = 1, max = 24},
	category = "Dispatch Plus"
})

if (SERVER) then
    -- Passive announcements
    function PLUGIN:Think()
        if ((self.delay or 0) < CurTime()) then
            self.delay = CurTime() + (ix.config.Get("dispatchBroadcastInterval", 1) * 60)
            -- Plays/chooses a random broadcast.
            local randomSelection = self.list[math.random(#self.list)]
            net.Start("PlaySound")
                net.WriteString(randomSelection[1])
            net.Broadcast()
            -- Sends the chat message.
            net.Start("ixChatMessage")
                net.WriteEntity(NULL)
                net.WriteString("dispatch")
                net.WriteString(randomSelection[2])
                net.WriteBool(false)
                net.WriteTable({})
            net.Broadcast()
        end
    end
    -- Curfew handler
    function PLUGIN:Think()
        if (ix.config.Get("enableCurfew")) then
            if ((self.curfDelay or 0) < CurTime()) then
                if (StormFox.GetTime(true)) == (ix.config.Get("curfewStartTime", 1) * 60) then
                    -- Tells the plugin curfew is in effect (used for things like turning off ration dispensers or locking doors - don't change)
                    ix.isCurfew = true
                    -- Plays the announcement alert.
                    net.Start("PlaySound")
                        net.WriteString("ambient/alarms/scanner_alert_pass1.wav")
                    net.Broadcast()
                    -- Sends the chat message.
                    net.Start("ixChatMessage")
                        net.WriteEntity(NULL)
                        net.WriteString("dispatch")
                        net.WriteString("Citizen notice: Mandatory curfew is now in effect. Return to your designated housing block immediately.")
                        net.WriteBool(false)
                        net.WriteTable({})
                    net.Broadcast()
                    self.curfDelay = CurTime() + 60
                elseif (StormFox.GetTime(true)) == (ix.config.Get("curfewEndTime", 1) * 60) then
                    -- Tells the plugin curfew is no longer in effect (don't change)
                    ix.isCurfew = false
                    -- Plays the announcement alert.
                    net.Start("PlaySound")
                        net.WriteString("ambient/alarms/scanner_alert_pass1.wav")
                    net.Broadcast()
                    -- Sends the chat message.
                    net.Start("ixChatMessage")
                        net.WriteEntity(NULL)
                        net.WriteString("dispatch")
                        net.WriteString("Citizen notice: Mandatory curfew is now lifted. You may leave your designated housing block.")
                        net.WriteBool(false)
                        net.WriteTable({})
                    net.Broadcast()
                    self.curfDelay = CurTime() + 60
                end
            end
        end
    end
end