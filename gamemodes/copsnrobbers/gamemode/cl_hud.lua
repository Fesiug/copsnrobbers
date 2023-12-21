
local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

surface.CreateFont( "CNR_HUD_1", {
	font = "Bahnschrift Light",
	size = ScreenScaleH(24),
	weight = 0,
})
surface.CreateFont( "CNR_HUD_2", {
	font = "Bahnschrift Bold",
	size = ScreenScaleH(48),
	weight = 0,
})

surface.CreateFont( "CNR_HUD_3", {
	font = "Bahnschrift Light",
	size = ScreenScaleH(14),
	weight = 0,
})
surface.CreateFont( "CNR_HUD_4", {
	font = "Bahnschrift Bold",
	size = ScreenScaleH(28),
	weight = 0,
})

hook.Add("HUDPaint", "CNR_HUD", function()
	local p, sw, sh = LocalPlayer(), ScrW(), ScrH()
	local c = sw/2
	local s = ScreenScaleH
	local c1 = sw*0.125
	local c2 = sw*(1-0.125)
	local b = s(8)

	local w = p:GetActiveWeapon()
	w = IsValid(w) and w or false

	do
		local b_w, b_h = s(64+8), s(64)
		local b_x, b_y = c1, sh - b_h - s(16)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( "HP", "CNR_HUD_1", c1 + b, sh - s(64+12), color_black )
		draw.SimpleText( p:Health(), "CNR_HUD_2", c1 + b, sh - s(64), color_black )
	end

	if w then
		local b_w, b_h = s(64+8), s(64)
		local b_x, b_y = c2 - b_w, sh - b_h - s(16)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( "AMMO", "CNR_HUD_1", c2 - b, sh - s(64+12), color_black, TEXT_ALIGN_RIGHT )
		draw.SimpleText( w:Clip1(), "CNR_HUD_2", c2 - b, sh - s(64), color_black, TEXT_ALIGN_RIGHT )
	end

	do
		local b_w, b_h = s(64+8), s(42)
		local b_x, b_y = c1, s(16)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( "TIME", "CNR_HUD_3", b_x + b, b_y + s(4), color_black, TEXT_ALIGN_LEFT )
		draw.SimpleText( string.FormattedTime( -CurTime()*1000, "%02i:%02i"), "CNR_HUD_4", b_x + b, b_y + s(12), color_black, TEXT_ALIGN_LEFT )
	end

	do
		local b_w, b_h = s(172), s(30)
		local b_x, b_y = c1, s(16) + b + s(42)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( "$", "CNR_HUD_3", b_x + b, b_y + s(8), color_black, TEXT_ALIGN_LEFT )
		draw.SimpleText( "100,000,000", "CNR_HUD_4", b_x + b_w - b, b_y, color_black, TEXT_ALIGN_RIGHT )
	end
end)