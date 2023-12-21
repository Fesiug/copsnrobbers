
function SWEP:Reload()
	if self:GetDelay() > CurTime() then
		return false
	end
	if self:GetDelayReload() > CurTime() then
		return false
	end
	if self:Clip1() >= self.Primary.ClipSize then
		return false
	end
	self:SendWeaponAnim( ACT_VM_RELOAD )
	self:GetOwner():GetViewModel():SetPlaybackRate( 2.5 )
	self:SetDelayReload( CurTime() + self:SequenceDuration()/2.5 )
	self:SetRefillTime( CurTime() + self:SequenceDuration()/2.5 )
	--self:SetClip1( self.Primary.ClipSize )
	return true
end