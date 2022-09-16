ENT.Type = "anim"
ENT.Base = "jewelryrobbery_glass_base"
ENT.PrintName = "Jewelry glass corner"

AddCSLuaFile()
ENT.Category = "Jewelry Robbery"
ENT.Author = "Venatuss"
ENT.Spawnable = true
ENT.displayPos = Vector(66, 0, 55)

ENT.model = Model("models/sterling/ajr_cabnet2.mdl")

ENT.JewelryPos = {
	{
		up = 39,
		forward = 50,
		right = 0,
	},

	{
		up = 39,
		forward = 30,
		right = -30,
		ang = Angle(0, 45, 0)
	},
	{
		up = 39,
		forward = 10,
		right = -50,
		ang = Angle(0, 45, 0)
	},
	{
		up = 39,
		forward = -10,
		right = -70,
		ang = Angle(0, 45, 0)
	},

	{
		up = 39,
		forward = 30,
		right = 30,
		ang = Angle(0, -45, 0)
	},
	{
		up = 39,
		forward = 10,
		right = 50,
		ang = Angle(0, -45, 0)
	},
	{
		up = 39,
		forward = -10,
		right = 70,
		ang = Angle(0, -45, 0)
	},
}