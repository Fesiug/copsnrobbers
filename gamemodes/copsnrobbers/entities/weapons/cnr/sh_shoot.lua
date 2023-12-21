
function SWEP:Spread()
	local spread = math.Clamp( math.TimeFraction( self.SpreadBurstStart, self.SpreadBurstEnd, self:GetBurstCount() ), 0, 1 )
	spread = Lerp( spread, self.SpreadStart, self.SpreadEnd )
	return spread
end

function SWEP:PrimaryAttack( mine )
	if self:GetDelay() > CurTime() then
		return false
	end
	if self:Clip1() == 0 then
		self:EmitSound( "weapons/clipempty_rifle.wav", 90, 100, 1, CHAN_STATIC )
		self:SetDelay( CurTime() + self.Delay )
		return false
	end

	if self:GetBurstCount() >= self.MaxBurst then
		return false
	end
	
	self:SetDelay( CurTime() + self.Delay )
	self:SetBurstCount( self:GetBurstCount() + 1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:SetClip1( self:Clip1() - 1 )

	self:EmitSound( self.Sound_Shoot, 90, 100, 1, CHAN_WEAPON )
	
	local spread = math.rad( self:Spread() )
	self:FireBullets( {
		Attacker = self:GetOwner(),
		Tracer = 1,
		Damage = 25,
		Force = 1,
		Num = 1,
		Dir = self:GetOwner():EyeAngles():Forward(),
		Spread = Vector( spread, spread, 0 ),
		Src = self:GetOwner():EyePos(),
		Callback = function( attacker, tr, dmginfo )
		end
	})

	return true
end

function SWEP:SecondaryAttack()
	return true
end