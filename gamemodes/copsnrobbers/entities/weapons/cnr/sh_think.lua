
SWEP.RecoilTable = {}

function SWEP:Think()
	local p = self:GetOwner()

	if CLIENT and IsFirstTimePredicted() then
		for i, data in pairs( self.RecoilTable ) do
			local ft = FrameTime()
			local fp = ft * data.speed
			data.dist = math.Approach( data.dist, 0, fp )

			local m_p, m_y = math.cos(math.rad(data.up)), math.sin(math.rad(data.up))

			local p_p, p_y = m_p * fp, m_y * fp

			p:SetEyeAngles( p:EyeAngles() - Angle( p_p, p_y, 0 ) )
			if data.dist == 0 then
				self.RecoilTable[i] = nil
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
		self:SetClip1( self.Primary.ClipSize )
		self:SetRefillTime( -1 )
	end
end