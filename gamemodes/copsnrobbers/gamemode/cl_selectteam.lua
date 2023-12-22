
function GM:ShowTeam()
	if IsValid( teampanel ) then teampanel:Remove() return end
	local s = ScreenScaleH
	teampanel = vgui.Create( "DFrame" )
	teampanel:SetSize( s(320), s(240) )
	teampanel:Center()
	teampanel:MakePopup()

	function teampanel:Paint( w, h )
		surface.SetDrawColor( color_white )
		surface.DrawRect( 0, 0, w, h )
		return true
	end
	
	-- the ids are undefined pretty early and whatever
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
		{
			Name = "Auto-Select",
			ID = true,
		},
	}

	for i, v in ipairs( teams ) do
		local button = teampanel:Add( "DButton" )
		button:SetSize( s(320), s(48) )
		button:DockMargin( 0, s(2), 0, 0 )
		button:Dock( TOP )

		function button:Paint( w, h )
			surface.SetDrawColor( color_white )
			surface.DrawRect( 0, 0, w, h )
			surface.SetDrawColor( color_black )
			surface.DrawOutlinedRect( 0, 0, w, h, s(1) )

			draw.SimpleText( v.Name, "CNR_SEL_1", s(4), s(4), color_black )

			local plys = team.GetPlayers( v.ID )
			local mew = { [1] = {} }
			local curr = 1
			
			for _, v in ipairs( plys ) do
				local concat = ""
				local nick = v:Nick()
				if #nick > 8 then
					nick = nick:Left(8) .. ".."
				end
				concat = concat .. nick
				--if i!= #plys then
				--	concat = concat .. ", "
				--end
				if #mew[curr] > 5 then
					curr = curr + 1
				end
				if !mew[curr] then
					mew[curr] = {}
				end
				table.insert( mew[curr], concat )
			end

			local bump = 0
			for _, row in ipairs( mew ) do
				bump = 0
				for i, v in ipairs( row ) do
					local tada = v .. ((i!=#row) and ", " or "")
					draw.SimpleText( tada, "CNR_SEL_2", s(4)+bump, s(4+16 + s((_-1)*4)), color_black )
					surface.SetFont( "CNR_SEL_2" )
					bump = bump + surface.GetTextSize( tada )
				end
			end
			return true
		end

		function button:DoClick()
			if v.ID == true then
				RunConsoleCommand( "changeteam", team.BestAutoJoinTeam() )
			else
				RunConsoleCommand( "changeteam", v.ID )
			end
			teampanel:Remove()
		end
	end
end