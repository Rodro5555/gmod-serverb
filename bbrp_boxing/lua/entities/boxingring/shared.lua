ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Boxing Ring"

ENT.Spawnable = true

-- Storage of all boxing rings in existence
BoxingRings = {}

-- Player lookup to see if they're currently signed up to a boxing ring
PlayerReserve = {}

-- Leaderboard table
boxGlobalLeaderboard = {}

ENT.countdownNum = "0"