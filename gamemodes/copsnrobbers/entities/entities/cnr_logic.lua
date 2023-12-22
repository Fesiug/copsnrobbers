
AddCSLuaFile()

ENT.Type = "point"

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "RoundStartedAt" )
	self:NetworkVar( "Float", 1, "PregameStartedAt" )
	self:NetworkVar( "Float", 2, "RoundFinishedAt" )

	self:NetworkVar( "Int", 0, "State" )
	self:NetworkVar( "Int", 1, "Round" )
	self:NetworkVar( "Int", 2, "Money" )
	self:NetworkVar( "Int", 3, "SwappedAtRound" )

	self:NetworkVar( "Bool", 0, "TeamSwap" )

	self:SetRound( 1 )
	self:SetSwappedAtRound( 1 )
end

function ENT:Initialize()
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS 
end