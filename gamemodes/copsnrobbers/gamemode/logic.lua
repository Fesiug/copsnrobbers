
CONVARS = {}

CONVARS["friendlyfire"]			= CreateConVar( "cnr_friendlyfire", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Whether shooting friendlies hurts them", 0, 1 )
CONVARS["time_round"]			= CreateConVar( "cnr_time_round", 3*60, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Length of a round in seconds" )
CONVARS["time_haste"]			= CreateConVar( "cnr_time_haste", 1*60, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Time before the round ends to enable haste mode in seconds" )
CONVARS["time_pregame"]			= CreateConVar( "cnr_time_pregame", 5, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Time before the round starts in seconds" )
CONVARS["time_postgame"]		= CreateConVar( "cnr_time_postgame", 5, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Time before the round restarts in seconds" )
CONVARS["rounds_swap"]			= CreateConVar( "cnr_rounds_swap", 2, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Rounds before teams swap" )
CONVARS["rounds_max"]			= CreateConVar( "cnr_rounds_max", 6, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum rounds before match finishes", 1 )

STATE_UNINITIALIZED				= 0
STATE_WAITINGFORPLAYERS			= 1
STATE_PREGAME					= 2
STATE_INGAME					= 3
STATE_POSTGAME					= 4

if SERVER then
	gamelogic = NULL
	hook.Add( "Think", "CNR_GameLogic", function()
		if !gamelogic:IsValid() then
			for i, ent in ents.Iterator() do
				if ( ent:GetClass() == "cnr_logic" ) then gamelogic = ent print("Located CNR game logic entity") break end
			end
			if !gamelogic:IsValid() then
				gamelogic = ents.Create( "cnr_logic" )
				assert( gamelogic:IsValid(), "Failed to create CNR game logic entity." )
				gamelogic:Spawn()
				print("Created CNR game logic entity")
			end
		end
	
		local state = gamelogic:GetState()
		if state == STATE_UNINITIALIZED then
			-- Initialize
			state = STATE_WAITINGFORPLAYERS
		end
	
		local willingplayers = #player.GetAll()
		if state == STATE_WAITINGFORPLAYERS then
			if willingplayers >= 2 then
				-- Begin pregame
				state = STATE_PREGAME
				gamelogic:SetPregameStartedAt( RealTime() )
			end
		end
	
		if state == STATE_PREGAME then
			if willingplayers < 2 then
				-- Cancel pregame
				state = STATE_WAITINGFORPLAYERS
				gamelogic:SetPregameStartedAt( 0 )
			elseif (gamelogic:GetPregameStartedAt() + CONVARS["time_pregame"]:GetInt()) <= RealTime() then
				-- Begin round
				state = STATE_INGAME
				gamelogic:SetRoundStartedAt( RealTime() )
			end
		end
	
		if state == STATE_INGAME then
			gamelogic:SetMoney( gamelogic:GetMoney() + 1000 )
			if (gamelogic:GetRoundStartedAt() + CONVARS["time_round"]:GetInt()) <= RealTime() then
				state = STATE_POSTGAME
				gamelogic:SetRoundFinishedAt( RealTime() )
			end
		end
	
		if state == STATE_POSTGAME then
			if (gamelogic:GetRoundFinishedAt() + CONVARS["time_postgame"]:GetInt()) <= RealTime() then
				state = STATE_PREGAME
				gamelogic:SetPregameStartedAt( RealTime() )

				-- Begin preparations for a new round
				gamelogic:SetMoney( 0 )
				gamelogic:SetRound( gamelogic:GetRound() + 1 )

				-- Swap teams
				if CONVARS["rounds_swap"]:GetBool() and gamelogic:GetRound() > (gamelogic:GetSwappedAtRound()-1)+CONVARS["rounds_swap"]:GetInt() then
					gamelogic:SetTeamSwap( !gamelogic:GetTeamSwap() )
					gamelogic:SetSwappedAtRound( gamelogic:GetRound() )
				end

				LOGIC:SetSpawnpoints()

				for i, v in player.Iterator() do
					v:Spawn()
				end
			end
		end
	
		gamelogic:SetState( state )
	end )
end

LOGIC = {}

function LOGIC:GetLogic()
	for i, ent in ents.Iterator() do
		if ( ent:GetClass() == "cnr_logic" ) then return ent end
	end
	if SERVER then
		gamelogic = ents.Create( "cnr_logic" )
		assert( gamelogic:IsValid(), "Failed to create CNR game logic entity." )
		gamelogic:Spawn()
		print("Created CNR game logic entity")
	end
end

function LOGIC:GetTimeLeft()
	local gamelogic = LOGIC:GetLogic()

	if gamelogic:GetState() == STATE_PREGAME then
		local time = CONVARS["time_pregame"]:GetInt()
		return ( gamelogic:GetPregameStartedAt() + time ) - RealTime(), time
	elseif gamelogic:GetState() == STATE_INGAME then
		local time = CONVARS["time_round"]:GetInt()
		return ( gamelogic:GetRoundStartedAt() + time ) - RealTime(), time
	elseif gamelogic:GetState() == STATE_POSTGAME then
		local time = CONVARS["time_postgame"]:GetInt()
		return ( gamelogic:GetRoundFinishedAt() + time ) - RealTime(), time
	else
		return 0, 0
	end
end

function LOGIC:Switcheroo( teamid )
	local gamelogic = LOGIC:GetLogic()
	local flipped = gamelogic:GetTeamSwap()

	if teamid == TEAM_SIDEA then
		return (flipped and TEAM_SIDEB or TEAM_SIDEA)
	else
		return (flipped and TEAM_SIDEA or TEAM_SIDEB)
	end
end

function LOGIC:SetSpawnpoints()
	local gamelogic = LOGIC:GetLogic()
	local flipped = gamelogic:GetTeamSwap()
	team.SetSpawnPoint( flipped and TEAM_SIDEB or TEAM_SIDEA, "info_player_counterterrorist" )
	team.SetSpawnPoint( flipped and TEAM_SIDEA or TEAM_SIDEB, "info_player_terrorist" )
end