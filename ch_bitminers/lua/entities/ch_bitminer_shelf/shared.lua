ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Bitminer Shelf"
ENT.Author = "Crap-Head"
ENT.Category = "Bitminers by Crap-Head"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()	
	self:NetworkVar( "Int", 0, "HP" )
	self:NetworkVar( "Int", 1, "MinersInstalled" )
	self:NetworkVar( "Int", 2, "MinersAllowed" )
	self:NetworkVar( "Int", 3, "UPSInstalled" )
	self:NetworkVar( "Int", 4, "FansInstalled" )
	self:NetworkVar( "Int", 5, "CryptoIntegrationIndex" )
	
	self:NetworkVar( "Float", 0, "Temperature" )
	self:NetworkVar( "Float", 1, "BitcoinsMined" )
	self:NetworkVar( "Float", 2, "WattsRequired" )
	self:NetworkVar( "Float", 3, "WattsGenerated" )
	
	self:NetworkVar( "Bool", 0, "RGBInstalled" )
	self:NetworkVar( "Bool", 1, "RGBEnabled" )
	self:NetworkVar( "Bool", 2, "HasPower" )
	self:NetworkVar( "Bool", 3, "IsMining" )
	self:NetworkVar( "Bool", 4, "IsHacked" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end

CH_Bitminers.Config.ScreenPositions = CH_Bitminers.Config.ScreenPositions or {
	withdraw_one = Vector( 4.974997, 15.155769, 48.283577 ), 
	withdraw_two = Vector( 5.793915, 24.367191, 45.947006 ),
	
	rgb_btn_one = Vector( 4.971034, 25.934856, 48.294861 ),
	rgb_btn_two = Vector( 5.786088, 28.407360, 45.969444 ),
	
	power_btn_one = Vector( 2.770266, 21.995148, 54.574265 ),
	power_btn_two = Vector( 4.824709, 28.136887, 48.712364 ),
	
	power_btn_small_one = Vector( 4.982971, 32.667717, 48.260895 ),
	power_btn_small_two = Vector( 5.784596, 35.163403, 45.973717 ),
	
	eject_bitminer_btn_one = Vector( 4.028358, 25.934856, 51.001400 ),
	eject_bitminer_btn_two = Vector( 4.819342, 28.407360, 48.527772 ),
	
	change_mined_crypto_btn_one = Vector( 4.028358, 29.163786, 51.001400 ),
	change_mined_crypto_btn_two = Vector( 4.819342, 31.904657, 48.527772 )
}