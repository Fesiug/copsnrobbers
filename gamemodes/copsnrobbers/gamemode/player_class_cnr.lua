
AddCSLuaFile()

local PLAYER = {}

PLAYER.DisplayName			= "CNR Player Class"

PLAYER.SlowWalkSpeed		= 200
PLAYER.WalkSpeed			= 250
PLAYER.RunSpeed				= 280
PLAYER.CrouchedWalkSpeed	= 0.3
PLAYER.DuckSpeed			= 0.3
PLAYER.UnDuckSpeed			= 0.3
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight		= true
PLAYER.MaxHealth			= 100
PLAYER.MaxArmor				= 100
PLAYER.StartHealth			= 100
PLAYER.StartArmor			= 0
PLAYER.DropWeaponOnDie		= false
PLAYER.TeammateNoCollide	= true
PLAYER.AvoidPlayers			= true
PLAYER.UseVMHands			= true

function PLAYER:SetupDataTables()
end

player_manager.RegisterClass( "player_cnr", PLAYER, "player_default" )
