include("shared.lua")

net.Receive("CNR_Logic_Ingame", function()
	Entity(0):EmitSound( "cnr/events/start.ogg", 0, 100, 0.5, CHAN_STATIC )
end)
net.Receive("CNR_Logic_Postgame", function()
	Entity(0):EmitSound( "cnr/events/win.ogg", 0, 100, 0.5, CHAN_STATIC )
end)
net.Receive("CNR_Logic_Pregame", function()
	Entity(0):EmitSound( "cnr/events/pregame.ogg", 0, 100, 0.5, CHAN_STATIC )
end)