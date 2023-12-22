
SWEP.RecoilTable = {}

function SWEP:Think()
	local p = self:GetOwner()

	if CLIENT and IsFirstTimePredicted() then
		for i, data in pairs( self.RecoilTable ) do
			local ft = FrameTime()
			local diff = data.dist - math.Approach( data.dist, 0, ft * data.speed )
			data.dist = math.Approach( data.dist, 0, ft * data.speed )
			local m_p, m_y = math.cos(math.rad(data.up)), math.sin(math.rad(data.up))

			local p_p, p_y = m_p * diff, m_y * diff

			p:SetEyeAngles( p:EyeAngles() - Angle( p_p, p_y, 0 ) )

			if data.up2 then
				if data.dist == 0 then
					local diff = data.dist2 - math.Approach( data.dist2, 0, ft * data.speed2 )
					data.dist2 = math.Approach( data.dist2, 0, ft * data.speed2 )
					local m_p, m_y = math.cos(math.rad(data.up2)), math.sin(math.rad(data.up2))
		
					local p_p, p_y = m_p * diff, m_y * diff
		
					p:SetEyeAngles( p:EyeAngles() - Angle( p_p, p_y, 0 ) )
				end
				if data.dist2 == 0 then
					self.RecoilTable[i] = nil
				end
			else
				if data.dist == 0 then
					self.RecoilTable[i] = nil
				end
			end
		end
	end

	if !p:KeyDown( IN_ATTACK ) then
		self:SetBurstCount( 0 )
	end
	
	local up = self:GetDelay() > CurTime()-engine.TickInterval()
	self:SetBubbleSpread( math.Approach( self:GetBubbleSpread(), up and 1 or 0, FrameTime()/(up and self.BubbleSpreadUp or self.BubbleSpreadDown) ) )
	self:SetBubbleRecoil( math.Approach( self:GetBubbleRecoil(), up and 1 or 0, FrameTime()/(up and self.BubbleRecoilUp or self.BubbleRecoilDown) ) )

	if self:GetRefillTime() != -1 and CurTime() >= self:GetRefillTime() then
		self:SetClip1( self.ShotgunReloading and (self:Clip1() + 1) or self.Primary.ClipSize )
		self:SetRefillTime( -1 )
	end

	if self:GetShotgunReloading() == 1 then
		if p:KeyDown( IN_ATTACK ) or (self:GetDelayReload() <= CurTime() and self:Clip1() == self.Primary.ClipSize) then
			self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			self:GetOwner():GetViewModel():SetPlaybackRate( 2.5 )
			self:SetRefillTime( -1 )
			self:SetShotgunReloading( 0 )
		else
			if self:GetDelayReload() <= CurTime() then
				self:SendWeaponAnim( ACT_VM_RELOAD )
				self:GetOwner():GetViewModel():SetPlaybackRate( 2.5 )
				self:SetDelayReload( CurTime() + 0.2 )
				self:SetRefillTime( CurTime() + 0.1 )
			end
		end
	end
end