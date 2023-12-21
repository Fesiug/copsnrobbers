
SWEP.Base						= "weapon_base"

SWEP.PrintName					= "CNR weapon base"
SWEP.Slot						= 5

SWEP.ViewModel					= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.ViewModelFOV				= 90
SWEP.UseHands					= true
SWEP.WorldModel					= "models/weapons/w_rif_ak47.mdl"

SWEP.Sound_Shoot				= "weapons/m4a1/m4a1_unsil-1.wav"

SWEP.Delay						= ( 60 / 900 )
SWEP.MaxBurst					= math.huge
SWEP.ActivePos					= Vector( 2, -2, -2 )

SWEP.SpreadStart				= 1
SWEP.SpreadEnd					= 10
SWEP.SpreadBurstStart			= 3
SWEP.SpreadBurstEnd				= 10

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true

AddCSLuaFile("sh_think.lua")
	include ("sh_think.lua")

AddCSLuaFile("sh_shoot.lua")
	include ("sh_shoot.lua")

AddCSLuaFile("sh_reload.lua")
	include ("sh_reload.lua")

AddCSLuaFile("cl_vm.lua")
if CLIENT then
	include ("cl_vm.lua")
end

function SWEP:Initialize()
	self:SetClip1( self.Primary.ClipSize )
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Delay" )
	self:NetworkVar( "Int", 0, "BurstCount" )
end

SWEP.m_WeaponDeploySpeed = 10
SWEP.BobScale = 0
SWEP.SwayScale = 0
function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_IDLE )
	return true
end
function SWEP:Holster()
	return true
end