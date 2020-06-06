
local PLUGIN = PLUGIN

PLUGIN.name = "Passive Dispatch"
PLUGIN.author = "Dev (shh its actually wowm0ds)"
PLUGIN.description = "Adds in passive dispatch announcements."
PLUGIN.list = {
    {"npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav", "Citizen reminder: Inaction is conspiracy. Report counter-behaviour to a Civil Protection team immediately."},
    {"npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav", "Citizen notice: Failure to cooperate will result in permanent off-world relocation."}
  }
-- Adds the config option for the delay between broadcasts.
ix.config.Add("dispatchBroadcastInterval", 60, "The time inbetween automatic Dispatch broadcasts in minutes.", nil, {
	data = {min = 1, max = 120},
	category = "Passive Dispatch"
})

if (SERVER) then
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
end