AddCSLuaFile()
DEFINE_BASECLASS("zrms_refiner")
ENT.Type = "anim"
ENT.Base = "zrms_refiner"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.PrintName = "Refinery - Coal"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"

ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

ENT.RefinerType = "Coal"

ENT.RefiningTime = zrmine.config.Coal_RefiningTime
