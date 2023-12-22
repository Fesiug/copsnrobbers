
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

local special1 = {
	normal = 12,
	colon = 5,
	clean1 = 2,
}

local special2 = {
	normal = 16+4,
	colon = 0,
	clean1 = 6,
}

function MonoDraw( text, font, x, y, color, rightalign, special )
	local s = ScreenScaleH
	local bump = 0
	text = tostring(text)

	if rightalign then
		local ogbump = 0
		for i=1, #text do
			local td = text[i]
			if td == ":" or td == "," or td == "." then
				ogbump = ogbump + special.colon
			else
				ogbump = ogbump + special.normal
			end
		end
		x = x - s(ogbump)
	end
	for i=1, #text do
		local td = text[i]
		local clean = 0
		if td == "1" then
			clean = special.clean1
		end
		draw.SimpleText( td, font, x + s(bump) + s(clean), y, color )
		if td == ":" or td == "," or td == "." then
			bump = bump + special.colon
		else
			bump = bump + special.normal
		end
	end
end

-- State Look-up Table
local slut = {
	[0] = "UNINIT",
	[1] = "WAITING",
	[2] = "PREGAME",
	[3] = "TIME",
	[4] = "POSTGAME",
}

local gamelogic = NULL

hook.Add("HUDPaint", "CNR_HUD", function()
	local p, sw, sh = LocalPlayer(), ScrW(), ScrH()
	local c = sw/2
	local s = ScreenScaleH
	local c1 = sw*0.125
	local c2 = sw*(1-0.125)
	local b = s(8)

	local w = p:GetActiveWeapon()
	w = IsValid(w) and w or false

	
	if !gamelogic:IsValid() then
		for i, ent in ents.Iterator() do
			if ( ent:GetClass() == "cnr_logic" ) then gamelogic = ent print("Located CNR game logic entity") break end
		end
	end

	do
		local b_w, b_h = s(64+8), s(64)
		local b_x, b_y = c1, sh - b_h - s(16)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( "HP", "CNR_HUD_1", c1 + b, sh - s(64+12), color_black )
		local dumbfuck = tostring(p:Health()):Left(1) == "1" and s(4) or 0
		MonoDraw( p:Health(), "CNR_HUD_2", c1 + b - dumbfuck, sh - s(64), color_black, false, special2 )
	end

	if w then
		local b_w, b_h = s(64+8), s(64)
		local b_x, b_y = c2 - b_w, sh - b_h - s(16)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( "AMMO", "CNR_HUD_1", c2 - b, sh - s(64+12), color_black, TEXT_ALIGN_RIGHT )
		MonoDraw( w:Clip1(), "CNR_HUD_2", c2 - b, sh - s(64), color_black, true, special2 )
	end

	local state = gamelogic:GetState()
	do
		local b_w, b_h = s(64+12), s(42)
		local b_x, b_y = c1, s(16)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( slut[ gamelogic:GetState() ], "CNR_HUD_3", b_x + b, b_y + s(4), color_black, TEXT_ALIGN_LEFT )
		local fuckhead = ""
		local ltime = LOGIC:GetTimeLeft()
		if ltime > 60 then
			fuckhead = string.FormattedTime( LOGIC:GetTimeLeft(), "%02i:%02i")
		else
			fuckhead = string.FormattedTime( ltime )
			fuckhead = string.format( "%02i.%02i", fuckhead.s, fuckhead.ms )
		end
		MonoDraw( fuckhead, "CNR_HUD_4", b_x + b, b_y + s(12), color_black, false, special1 )

		do
			local n_w, n_h = s(128), s(42)
			local n_x, n_y = b_x + b + b_w, b_y
			surface.SetDrawColor( color_white )
			surface.DrawRect( n_x, n_y, n_w, n_h )
			draw.SimpleText( "ROUND NUMBER", "CNR_HUD_3", n_x + b, n_y + s(4), color_black )
			draw.SimpleText( gamelogic:GetRound() .. " - " .. gamelogic:GetSwappedAtRound() .. " : " .. (gamelogic:GetTeamSwap() and "Swap" or "Not"), "CNR_HUD_4", n_x + b, n_y + s(12), color_black )
		end
	end

	if state == STATE_INGAME or state == STATE_POSTGAME then
		local b_w, b_h = s(172), s(30)
		local b_x, b_y = c1, s(16) + b + s(42)
		surface.SetDrawColor( color_white )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		draw.SimpleText( "$", "CNR_HUD_3", b_x + b, b_y + s(8), color_black, TEXT_ALIGN_LEFT )

		local fuckhead = gamelogic:GetMoney()
		fuckhead = string.Comma( fuckhead )
		MonoDraw( fuckhead, "CNR_HUD_4", b_x + b_w - b, b_y, color_black, true, special1 )
	end
end)