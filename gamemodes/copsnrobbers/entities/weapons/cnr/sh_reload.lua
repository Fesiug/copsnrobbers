
function SWEP:Reload()
	if self:GetDelay() > CurTime() then
		return false
	end
	if self:GetDelayReload() > CurTime() then
		return false
	end
	if self:GetShotgunReloading() == 1 then
		return false
	end
	if self:Clip1() >= self.Primary.ClipSize then
		return false
	end

	if self.ShotgunReloading then
		self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
		self:GetOwner():GetViewModel():SetPlaybackRate( 2.5 )
		self:SetDelayReload( CurTime() + 0.1 )
		self:SetShotgunReloading( 1 )
	else
		self:SendWeaponAnim( ACT_VM_RELOAD )
		self:GetOwner():GetViewModel():SetPlaybackRate( 2.5 )
		self:SetDelayReload( CurTime() + self:SequenceDuration()/2.5 )
		self:SetRefillTime( CurTime() + self:SequenceDuration()/2.5 )
	end
	return true
end