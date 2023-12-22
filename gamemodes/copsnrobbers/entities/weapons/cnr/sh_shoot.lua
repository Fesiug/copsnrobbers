
function SWEP:Spread()
	local spread = self:GetBubbleSpread()
	spread = Lerp( spread, self.SpreadStart, self.SpreadEnd )
	return spread
end

function SWEP:PrimaryAttack( mine )
	if self:GetDelay() > CurTime() then
		return false
	end
	if self:GetDelayReload() > CurTime() then
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

	self:EmitSound( self.Sound_Fire[ math.random( 1, #self.Sound_Fire ) ], 90, 100, 1, CHAN_STATIC )
	self:EmitSound( self.Sound_Mech[ math.random( 1, #self.Sound_Mech ) ], 90, 100, 0.125, 255+2 )
	
	local dir = self:GetOwner():EyeAngles()
	local newdir = Vector()
	local spread = math.rad( self:Spread() )
	do
		local radius = util.SharedRandom("CNR_WepRand1_" .. 1, 0, 1 )
		local theta = util.SharedRandom("CNR_WepRand2_" .. 1, 0, math.rad(360) )
		local x = radius * math.sin(theta)
		local y = radius * math.cos(theta)

		newdir:Set( dir:Forward() + (dir:Right() * spread * x) + (dir:Up() * spread * y) )
	end

	self:FireBullets( {
		Attacker = self:GetOwner(),
		Tracer = 1,
		Damage = self.DamageClose,
		Force = 1,
		Num = 1,
		Dir = newdir,
		Spread = vector_origin,
		Src = self:GetOwner():EyePos(),
		Callback = function( attacker, tr, dmginfo )
		end
	})

	do
		if ( !game.SinglePlayer() and CLIENT and IsFirstTimePredicted() ) then
			local recoil = {}

			recoil.up = util.SharedRandom( "CNR_WepRecoil", -1, 1 ) * self.RecoilUp

			recoil.speed = math.max( 1, self.RecoilSpeed ) -- how much to move in a second

			recoil.dist = Lerp( self:GetBubbleRecoil(), self.RecoilDistStart, self.RecoilDistEnd ) -- total distance to travel

			--recoil.up2 = recoil.up + 180
			--recoil.speed2 = recoil.speed * 0.25
			--recoil.dist2 = recoil.dist

			table.insert( self.RecoilTable, recoil )
		end
	end

	return true
end

function SWEP:SecondaryAttack()
	return true
end