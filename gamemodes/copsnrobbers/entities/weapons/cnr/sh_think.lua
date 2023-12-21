
SWEP.RecoilTable = {}

function SWEP:Think()
	local p = self:GetOwner()

	if CLIENT and IsFirstTimePredicted() then
		for i, v in pairs( self.RecoilTable ) do

		end
	end

	if !p:KeyDown( IN_ATTACK ) then
		self:SetBurstCount( 0 )
	end
end