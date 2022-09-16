include("shared.lua")

function ARMORY_RestartCooldown( um )
	LocalPlayer().ArmoryCooldown = CurTime() + um:ReadLong()
end
usermessage.Hook("ARMORY_RestartCooldown", ARMORY_RestartCooldown)

function ARMORY_KillCooldown() 
	LocalPlayer().ArmoryCooldown = 0
end
usermessage.Hook("ARMORY_KillCooldown", ARMORY_KillCooldown)

function ARMORY_RestartCountdown( um )
	LocalPlayer().ArmoryRobberyCountdown = CurTime() + um:ReadLong()
end
usermessage.Hook("ARMORY_RestartTimer", ARMORY_RestartCountdown)

function ARMORY_KillCountdown() 
	LocalPlayer().ArmoryRobberyCountdown = 0
end
usermessage.Hook("ARMORY_KillTimer", ARMORY_KillCountdown)

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
	
	local ARMORY_RequiredTeamsCount = 0
	local ARMORY_RequiredPlayersCounted = 0
	
	local pos = self:GetPos() + Vector(0, 0, 70)
	local PlayersAngle = LocalPlayer():GetAngles()
	local ang = Angle( 0, PlayersAngle.y - 180, 0 )
	
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	cam.Start3D2D(pos, ang, 0.11)
		if LocalPlayer().ArmoryCooldown and LocalPlayer().ArmoryCooldown > CurTime() then
			draw.SimpleTextOutlined("Tiempo de espera para robo", "ARMORY_ScreenTextBig", 0, -115, ARMORY_DESIGN_CooldownTextColor, 1, 1, 1.5, ARMORY_DESIGN_CooldownTextBoarder)
			draw.SimpleTextOutlined(string.ToMinutesSeconds(math.Round(LocalPlayer().ArmoryCooldown - CurTime())), "ARMORY_ScreenText", 0, -65, ARMORY_DESIGN_CooldownTimerTextColor, 1, 1, 1.5, ARMORY_DESIGN_CooldownTimerTextBoarder)
		elseif LocalPlayer().ArmoryRobberyCountdown and LocalPlayer().ArmoryRobberyCountdown > CurTime() then
			draw.SimpleTextOutlined("Cuenta regresiva de robo", "ARMORY_ScreenTextBig", 0, -115, ARMORY_DESIGN_CountdownTextColor, 1, 1, 1.5, ARMORY_DESIGN_CountdownTextBoarder)
			draw.SimpleTextOutlined(string.ToMinutesSeconds(math.Round(LocalPlayer().ArmoryRobberyCountdown - CurTime())), "ARMORY_ScreenText", 0, -65, ARMORY_DESIGN_CountdownTimerTextColor, 1, 1, 1.5, ARMORY_DESIGN_CountdownTimerTextBoarder)
		else
			draw.SimpleTextOutlined("Armería de la Policía", "ARMORY_ScreenTextHeader", 0, -120, ARMORY_DESIGN_ArmoryTextColor, 1, 1, 1.5, ARMORY_DESIGN_ArmoryTextBoarder)
			
			for k, v in pairs(player.GetAll()) do
				ARMORY_RequiredPlayersCounted = ARMORY_RequiredPlayersCounted + 1
				
				if v:isCP() then
					ARMORY_RequiredTeamsCount = ARMORY_RequiredTeamsCount + 1
				end
				
				if ARMORY_RequiredPlayersCounted == #player.GetAll() then
					if ARMORY_RequiredTeamsCount >= ARMORY_Custom_PoliceRequired then
						draw.SimpleTextOutlined("Suficientes Oficiales: Si", "ARMORY_ScreenText", 0, -70, ARMORY_DESIGN_TheYes, 1, 1, 1.4, ARMORY_DESIGN_TheBoarder)
					else
						draw.SimpleTextOutlined("Suficientes Oficiales: No ("..ARMORY_RequiredTeamsCount.."/"..ARMORY_Custom_PoliceRequired..")", "ARMORY_ScreenText", 0, -70, ARMORY_DESIGN_TheNo, 1, 1, 1.4, ARMORY_DESIGN_TheBoarder)
					end
				end
			end
			if table.HasValue( ARMORY_AllowedTeams, team.GetName( LocalPlayer():Team() ) ) then
				draw.SimpleTextOutlined("Trabajo Permitido: Si", "ARMORY_ScreenText", 0, -40, ARMORY_DESIGN_TheYes, 1, 1, 1.4, ARMORY_DESIGN_TheBoarder)
			else
				draw.SimpleTextOutlined("Trabajo Permitido: No", "ARMORY_ScreenText", 0, -40, ARMORY_DESIGN_TheNo, 1, 1, 1.4, ARMORY_DESIGN_TheBoarder)
			end
			if #player.GetAll() >= ARMORY_Custom_PlayerLimit then
				draw.SimpleTextOutlined("Suficientes Jugadores: Si", "ARMORY_ScreenText", 0, -10, ARMORY_DESIGN_TheYes, 1, 1, 1.4, ARMORY_DESIGN_TheBoarder)
			else
				draw.SimpleTextOutlined("Suficientes Jugadores: No ("..#player.GetAll().."/"..ARMORY_Custom_PlayerLimit..")", "ARMORY_ScreenText", 0, -10, ARMORY_DESIGN_TheNo, 1, 1, 1.4, ARMORY_DESIGN_TheBoarder)
			end
		end
    cam.End3D2D()
end

local screenmodel = ClientsideModel("models/props/cs_office/TV_plasma.mdl", RENDERGROUP_TRANSLUCENT)
screenmodel:SetNoDraw(true)

local function DrawArmoryScreen() // front 1 back 2
	local armory = ents.FindByClass("police_armory")
	local scale = Vector( 1, 1, 1 )

	local mat = Matrix()
	mat:Scale(scale)
	screenmodel:EnableMatrix("RenderMultiply", mat)
	
	local eyePos = EyePos()
	
	local ArmoryMoneyAmount = GetGlobalInt( "ARMORY_MoneyAmount" )
	local ArmoryAmmoAmount = GetGlobalInt( "ARMORY_AmmoAmount" )
	local ArmoryShipmentAmount = GetGlobalInt( "ARMORY_ShipmentsAmount" )
	
	for i=1, #armory do
		if (armory[i]:GetPos()-eyePos):Length2DSqr() < 5923535 then
			
			local ang = armory[i]:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 90)
			local textpos = armory[i]:GetPos() + ang:Right() * 15 + ang:Up() * 52
			local screenpos = armory[i]:GetPos() + ang:Right() * 10 + ang:Up() * 15

			ang:RotateAroundAxis(ang:Forward(), 90)

			local armoryangle = armory[i]:GetAngles()
			armoryangle:RotateAroundAxis(armoryangle:Forward(), 180)
			armoryangle:RotateAroundAxis(armoryangle:Forward(), 180)
			armoryangle:RotateAroundAxis(armoryangle:Right(), 90)
			
			local screenangle = armory[i]:GetAngles()
			screenmodel:SetRenderOrigin(screenpos)
			screenmodel:SetRenderAngles(screenangle)
			screenmodel:SetupBones()
			screenmodel:DrawModel()
			
			textpos = textpos + ang:Up()
			cam.Start3D2D(textpos, ang, 0.5)
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
					draw.RoundedBoxEx( 4, -60, 0, 117, 69, ARMORY_DESIGN_ScreenColor, false, false, false, false )
					-- boxes
					--                size, y, x, lenght, height
					draw.RoundedBoxEx( 4, -50, 10, 100, 25, ARMORY_DESIGN_ScreenBoxColor, false, false, false, false ) -- top left
					draw.RoundedBoxEx( 4, -50, 40, 50, 25, ARMORY_DESIGN_ScreenBoxColor, false, false, false, false ) -- bottom left
					draw.RoundedBoxEx( 4, 5, 40, 45, 25, ARMORY_DESIGN_ScreenBoxColor, false, false, false, false ) -- bottom right
				render.PopFilterMin()
			cam.End3D2D()
			
			cam.Start3D2D(textpos, ang, 0.11)
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
					draw.SimpleTextOutlined("Dinero:", "ARMORY_ScreenText", 0, 70, ARMORY_DESIGN_MoneyTextColor, 1, 1, 1.4, ARMORY_DESIGN_MoneyTextBoarder)
					draw.SimpleTextOutlined(DarkRP.formatMoney(ArmoryMoneyAmount), "ARMORY_ScreenTextBig", 0, 120, ARMORY_DESIGN_MoneyTextColor, 1, 1, 1, ARMORY_DESIGN_MoneyTextBoarder)
					
					draw.SimpleTextOutlined("Munición:", "ARMORY_ScreenText", -110, 205, ARMORY_DESIGN_AmmoTextColor, 1, 1, 1.4, ARMORY_DESIGN_AmmoTextBoarder)
					draw.SimpleTextOutlined(DarkRP.formatMoney(ArmoryAmmoAmount), "ARMORY_ScreenTextBig", -110, 250, ARMORY_DESIGN_AmmoTextColor, 1, 1, 1, ARMORY_DESIGN_AmmoTextBoarder)
					
					draw.SimpleTextOutlined("Cargamentos:", "ARMORY_ScreenText", 125, 205, ARMORY_DESIGN_ShipmentsTextColor, 1, 1, 1.4, ARMORY_DESIGN_ShipmentsTextBoarder)
					draw.SimpleTextOutlined(DarkRP.formatMoney(ArmoryShipmentAmount), "ARMORY_ScreenTextBig", 125, 250, ARMORY_DESIGN_ShipmentsTextColor, 1, 1, 1, ARMORY_DESIGN_ShipmentsTextBoarder)
				render.PopFilterMin()
			cam.End3D2D()

		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "DrawArmoryScreen", DrawArmoryScreen)