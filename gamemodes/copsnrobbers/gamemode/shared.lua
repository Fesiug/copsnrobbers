
GM.Name = "Cops 'n Robbers"
GM.Author = "Fesiug"
GM.Email = "publicfesiug@outlook.com"
GM.Website = "https://github.com/Fesiug/copsnrobbers"
GM.TeamBased = true

AddCSLuaFile("player_class_cnr.lua")
	include ("player_class_cnr.lua")

AddCSLuaFile("logic.lua")
	include ("logic.lua")

AddCSLuaFile("playerbs.lua")
	include ("playerbs.lua")

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_selectteam.lua")
if CLIENT then
	include ("cl_hud.lua")
	include ("cl_selectteam.lua")
end

function GM:Initialize()
	-- Do stuff
end

concommand.Add( "cnr_cheat_weapons", function( p )
	p:Give( "cnr_ak47" )
	p:Give( "cnr_deagle" )
	p:Give( "cnr_glock" )
	p:Give( "cnr_m4a1" )
	p:Give( "cnr_m4s90" )
	p:Give( "cnr_m249" )
	p:Give( "cnr_mac10" )
	p:Give( "cnr_mossberg" )
	p:Give( "cnr_mp5" )
	p:Give( "cnr_p220" )
	p:Give( "cnr_usp" )
end)

if SERVER then
	function GM:ShowTeam( ply )
		ply:SendLua( "GAMEMODE:ShowTeam()" )
	end
end

-- Include module loader here