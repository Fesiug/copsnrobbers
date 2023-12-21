
function SWEP:GetViewModelPosition( pos, ang )
	local p = self:GetOwner()

	local speed = math.Clamp( p:GetVelocity():Length2D()/320, 0, 1 )

	local newpos, newang = Vector( pos ), Angle( ang )

	newpos:Add( ang:Right() * self.ActivePos.x )
	newpos:Add( ang:Forward() * self.ActivePos.y )
	newpos:Add( ang:Up() *  self.ActivePos.z )

	newpos:Add( ang:Right() * 2 * math.sin( CurTime() * math.pi * 2 ) * speed )
	newpos:Add( ang:Up() * -0.5 * math.abs( math.sin( CurTime() * math.pi * 2 ) ) * speed )

	return newpos, newang
end