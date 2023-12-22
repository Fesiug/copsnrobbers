
local teams = {
	{
		Name = "Side A",
		ID = TEAM_SIDEA,
	},
	{
		Name = "Side B",
		ID = TEAM_SIDEB,
	},
	{
		Name = "Spectate",
		ID = TEAM_SPECTATOR,
	},
}

function GM:ShowTeam()
	if IsValid( teampanel ) then teampanel:Remove() return end
	local s = ScreenScaleH
	teampanel = vgui.Create( "DFrame" )
	teampanel:SetSize( s(320), s(160) )
	teampanel:Center()
	teampanel:MakePopup()

	function teampanel:Paint( w, h )
		surface.SetDrawColor( color_white )
		surface.DrawRect( 0, 0, w, h )
		return true
	end

	for i, v in ipairs( teams ) do
		local button = teampanel:Add( "DButton" )
		button:SetSize( s(320), s(32) )
		button:DockMargin( 0, s(2), 0, 0 )
		button:Dock( TOP )

		function button:Paint( w, h )
			surface.SetDrawColor( color_white )
			surface.DrawRect( 0, 0, w, h )
			surface.SetDrawColor( color_black )
			surface.DrawOutlinedRect( 0, 0, w, h, s(1) )

			draw.SimpleText( v.Name, "CNR_HUD_1", s(4), s(4), color_black )
			return true
		end

		function button:DoClick()
			RunConsoleCommand( "changeteam", v.ID )
			teampanel:Remove()
		end
	end
end