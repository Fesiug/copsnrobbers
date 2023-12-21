
GM.Name = "Cops 'n Robbers"
GM.Author = "Fesiug"
GM.Email = "publicfesiug@outlook.com"
GM.Website = "https://github.com/Fesiug/copsnrobbers"
GM.TeamBased = true

AddCSLuaFile("cl_hud.lua")
if CLIENT then
	include ("cl_hud.lua")
end

AddCSLuaFile("player_class_cnr.lua")
	include ("player_class_cnr.lua")

function GM:Initialize()
	-- Do stuff
end

function GM:OnDamagedByExplosion( ply, dmginfo )
	-- ply:SetDSP( 35, false )
end
function GM:PlayerCanJoinTeam( ply, teamid )
	local TimeBetweenSwitches = 0.5
	if ( ply.LastTeamSwitch && RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 0.5
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return false
	end

	if ( ply:Team() == teamid ) then
		ply:ChatPrint( "You're already on that team" )
		return false
	end

	return true
end

-- Write this so at the end of a round you can shittalk
local sv_alltalk = GetConVar( "sv_alltalk" )
function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	local alltalk = sv_alltalk:GetInt()
	if ( alltalk >= 1 ) then return true, alltalk == 2 end

	return pListener:Team() == pTalker:Team(), false
end

function GM:PlayerShouldTaunt( ply, actid )
	return false
end
function GM:AllowPlayerPickup( ply, object )
	return false
end
function GM:PlayerDeathSound()
	return true
end

function GM:CreateTeams()

	TEAM_SIDEA = 1
	team.SetUp( TEAM_SIDEA, "Side A", Color( 200, 200, 255 ) )
	team.SetSpawnPoint( TEAM_SIDEA, "info_player_counterterrorist" )

	TEAM_SIDEB = 2
	team.SetUp( TEAM_SIDEB, "Side B", Color( 255, 200, 200 ) )
	team.SetSpawnPoint( TEAM_SIDEB, "info_player_terrorist" )

	team.SetSpawnPoint( TEAM_SPECTATOR, "worldspawn" )

end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	-- More damage if we're shot in the head
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 )
	end
end

function GM:PlayerSpawn( p, transition )
	player_manager.SetPlayerClass( p, "player_cnr" )

	if ( self.TeamBased and ( p:Team() == TEAM_SPECTATOR or p:Team() == TEAM_UNASSIGNED ) ) then
		self:PlayerSpawnAsSpectator( p )
		return
	end
	p:UnSpectate()

	p:SetSlowWalkSpeed( 190 )
	p:SetWalkSpeed( 320 )
	p:SetRunSpeed( 320 )

	if ( !transition ) then
		GAMEMODE:PlayerLoadout( p )
	end

	GAMEMODE:PlayerSetModel( p )

	p:SetupHands()
end

function GM:PlayerLoadout( p )
	if p:Team() == TEAM_SIDEA then
		p:Give("cnr_m4a1")
		p:Give("cnr_usp")
	elseif p:Team() == TEAM_SIDEB then
		p:Give("cnr_ak47")
		p:Give("cnr_glock")
	end

	return true
end

function GM:PlayerSetModel( p )
	if p:Team() == TEAM_SIDEA then
		p:SetModel( "models/player/combine_soldier.mdl" )
	elseif p:Team() == TEAM_SIDEB then
		p:SetModel( "models/player/group03/male_07.mdl" )
	end
end

concommand.Add( "cnr_cheat_weapons", function( p )
	p:Give( "cnr_ak47" )
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

-- Include module loader here
