


function GM:OnDamagedByExplosion( ply, dmginfo )
	-- ply:SetDSP( 35, false )
end
function GM:PlayerCanJoinTeam( ply, teamid )
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
function GM:PlayerDeathThink( pl )
	if ( pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end
	pl:Spawn()
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
		dmginfo:ScaleDamage( 3 )
	end
end

function GM:PlayerInitialSpawn( pl, transition )
	if pl:IsBot() then
		pl:SetTeam( team.BestAutoJoinTeam() )
	else
		pl:SetTeam( TEAM_UNASSIGNED )
		pl:ConCommand( "gm_showteam" )
	end
end
function GM:PlayerSpawnAsSpectator( pl )
	pl:StripWeapons()
	if ( pl:Team() == TEAM_UNASSIGNED ) then
		pl:Spectate( OBS_MODE_FIXED )
		return
	end
	pl:SetTeam( TEAM_SPECTATOR )
	pl:Spectate( OBS_MODE_ROAMING )
end
function GM:PlayerSelectSpawn( pl, transition )
	local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
	if ( IsValid( ent ) ) then return ent end
end
function GM:PlayerSelectTeamSpawn( TeamID, pl )
	local gamelogic = LOGIC:GetLogic()
	local SpawnPoints = team.GetSpawnPoints( LOGIC:Switcheroo( TeamID ) )
	if ( !SpawnPoints || table.IsEmpty( SpawnPoints ) ) then return end
	local ChosenSpawnPoint = nil
	for i = 0, 6 do
		ChosenSpawnPoint = table.Random( SpawnPoints )
		if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == 6 ) ) then
			return ChosenSpawnPoint
		end
	end
	return ChosenSpawnPoint
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

local PT = FindMetaTable("Player")

function PT:IsCop()
	return self:Team() == LOGIC:Switcheroo( TEAM_SIDEA )
end

function GM:PlayerLoadout( p )
	p:StripWeapons()

	if p:IsCop() then
		p:Give("cnr_m4a1")
		p:Give("cnr_usp")
	else
		p:Give("cnr_ak47")
		p:Give("cnr_glock")
	end

	return true
end

function GM:PlayerSetModel( p )
	if p:IsCop() then
		p:SetModel( "models/player/combine_soldier.mdl" )
	else
		p:SetModel( "models/player/group03/male_07.mdl" )
	end
end


hook.Add( "StartCommand", "CNR_StartCommand", function( ply, cmd )
	if ( ply:IsBot() or !ply:Alive() ) then return end

	local gamelogic = LOGIC:GetLogic()
	if IsValid( gamelogic ) and gamelogic:GetState() == STATE_PREGAME then
		cmd:ClearMovement()
		cmd:ClearButtons()
	end
end)

hook.Add( "Move", "CNR_Move", function( ply, mv )
	local gamelogic = LOGIC:GetLogic()
	if IsValid( gamelogic ) and gamelogic:GetState() == STATE_PREGAME then
		mv:SetMaxClientSpeed( 0 )
		mv:SetMaxSpeed( 0 )
	end
end)

if SERVER then
	util.AddNetworkString( "CNR_Kill" )

	function GM:DoPlayerDeath( ply, attacker, dmginfo )
		ply:CreateRagdoll()
		ply:AddDeaths( 1 )
		if ( attacker:IsValid() && attacker:IsPlayer() ) then
			if ( attacker == ply ) then
				attacker:AddFrags( -1 )
			else
				attacker:AddFrags( 1 )
			end
		end
		net.Start( "CNR_Kill" )
			net.WriteEntity( ply )
			net.WriteEntity( attacker )
			net.WriteEntity( dmginfo:GetInflictor() )
		net.Broadcast()
	end
else
	local c_attacker = Color( 255, 100, 100 )
	local c_victim = Color( 100, 100, 255 )
	net.Receive( "CNR_Kill", function()
		local victim		= net.ReadEntity()
		local attacker		= net.ReadEntity()
		local inflictor		= net.ReadEntity()

		local name_victim = "???"
		local name_attacker = "???"
		local name_inflictor = "???"
		if IsValid(victim) then
			name_victim = victim:Nick()
		end
		if IsValid(attacker) then
			name_attacker = attacker:Nick()
		end
		if IsValid(inflictor) then
			if inflictor.GetPrintName then
				name_inflictor = inflictor:GetPrintName()
			else
				name_inflictor = inflictor:GetClass()
			end
		end

		chat.AddText( c_attacker, name_attacker, color_white, " [", name_inflictor, "] ", c_victim, name_victim, color_white )
	end)
end