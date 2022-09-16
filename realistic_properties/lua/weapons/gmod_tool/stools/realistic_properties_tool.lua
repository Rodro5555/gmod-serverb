--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

AddCSLuaFile()
TOOL.Category = "Realistic Properties"
TOOL.Name = "Rps-Setup"
TOOL.Author = "Kobralost"
TOOL.StepId = 1
TOOL.RealisticPropertiesCamPos = {}
TOOL.RealisticPropertiesTableDoorsData = {} 
TOOL.RealisticPropertiesTableDoors = {} 

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "use" },
		{ name = "reload" },
	}
	language.Add("tool.realistic_properties_tool.name", "Configuración de propiedades" )
	language.Add("tool.realistic_properties_tool.desc", "Crea o modifica Propiedades en tu servidor" )
	language.Add("tool.realistic_properties_tool.left", "Haga clic con el botón izquierdo para configurar el buzón de entrega, las cámaras y la zona" )
	language.Add("tool.realistic_properties_tool.right", "Haz clic con el botón derecho mientras apuntas al NPC o la computadora para abrir el menú de administración" )
	language.Add("tool.realistic_properties_tool.use", "USE para volver al paso anterior" )
	language.Add("tool.realistic_properties_tool.reload", "RECARGAR para ir al siguiente paso" )
end

function TOOL:Deploy()
	if not Realistic_Properties.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	RPSBlackListDoor = {}
	if CLIENT then 
		self.RealisticPropertiesCamPos = {}
		RealisticPropertiesTableDoors = {}
		RealisticPropertiesTableDoorsData = {}
	end 
	if SERVER then 
		local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    	local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
		local CompressTable = util.Compress(RealisticPropertiesFil)
		net.Start("RealisticProperties:SendTableTool")
			net.WriteInt(CompressTable:len(), 32)
			net.WriteData( CompressTable, CompressTable:len() )
		net.Send(self:GetOwner())
	end 
	self.StepId = 1 
end 

function TOOL:LeftClick() 
	if not Realistic_Properties.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	local RealisticPropertiesEnt = self:GetOwner():GetEyeTrace().Entity
	local angle = self:GetOwner():GetAngles()
	self.rws = self.rws or CurTime()
	if self.rws > CurTime() then return end
	self.rws = CurTime() + 0.05
	if self.StepId == 1 then 
		self:CreateRWSEnt(self:GetOwner():GetEyeTrace().HitPos, Angle(0,angle.y,0), Realistic_Properties.ModelOfTheBox, true) 
	elseif self.StepId == 2 then 
		if #self.RealisticPropertiesCamPos < 3 then  
			if CLIENT then 
				local pos = LocalPlayer():GetPos() + (LocalPlayer():Crouching() && LocalPlayer():GetViewOffsetDucked() || LocalPlayer():GetViewOffset())
				self:CreateRWSEnt(pos, self:GetOwner():GetAngles(), "models/dav0r/camera.mdl", false) 
			end 
		else 
			if IsValid(self.RealisticPropertiesCamPos[#self.RealisticPropertiesCamPos]) then 
				self.RealisticPropertiesCamPos[#self.RealisticPropertiesCamPos]:Remove()
				table.remove(self.RealisticPropertiesCamPos, #self.RealisticPropertiesCamPos)
				if CLIENT then 
					local pos = LocalPlayer():GetPos() + (LocalPlayer():Crouching() && LocalPlayer():GetViewOffsetDucked() || LocalPlayer():GetViewOffset())
					self:CreateRWSEnt(pos, self:GetOwner():GetAngles(), "models/dav0r/camera.mdl", false) 
				end 
			end 
		end 
	elseif self.StepId == 3 then 
		if CLIENT then 
			local tr = util.TraceLine( {
				start = LocalPlayer():EyePos(),
				endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 100,
				filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			} )
			if RealisticPropertiesActivate == false then 
				self:RealisticPropertiesZonePos(self, self:GetOwner():GetEyeTrace().HitPos, nil)
			else 
				self:RealisticPropertiesZonePos(self, nil, tr.HitPos)
			end 
			RealisticPropertiesActivate = true 
		end 
	end 
end 

function TOOL:RightClick()
	print("[REALISTIC PROPERTIES]checkowner.....")
	if not Realistic_Properties.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	print("[REALISTIC PROPERTIES] valid rank!")
	local RealisticPropertiesEnt = self:GetOwner():GetEyeTrace().Entity
	local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
	self.rps = self.rps or CurTime()
	print("[REALISTIC PROPERTIES] check self.rps...")
	if self.rps > CurTime() then return end
	self.rps = CurTime() + 0.1
	print("[REALISTIC PROPERTIES] check entity...")
	if RealisticPropertiesEnt:GetClass() != "realistic_properties_computer" && RealisticPropertiesEnt:GetClass() != "realistic_properties_npc" && RealisticPropertiesEnt:GetClass() != "func_door_rotating" && RealisticPropertiesEnt:GetClass() != "prop_door_rotating" && RealisticPropertiesEnt:GetClass() != "func_door" then 
		print("[REALISTIC PROPERTIES] invalid entity!")
		if self.StepId == 1 then 
			if IsValid(self.RWSEnt) then 
				self.RWSEnt:Remove()
			end 
		elseif self.StepId == 2 then 
			if IsValid(self.RealisticPropertiesCamPos[#self.RealisticPropertiesCamPos]) then 
				self.RealisticPropertiesCamPos[#self.RealisticPropertiesCamPos]:Remove()
				table.remove(self.RealisticPropertiesCamPos, #self.RealisticPropertiesCamPos)
			end 
		elseif self.StepId == 3 then 
			RealisticPropertiesActivate = false
			RealisticPropertiesPos1 = nil
			RealisticPropertiesPosGhost2 = nil 
			RealisticPropertiesTableDoors = {}
			RealisticPropertiesTableDoorsData = {}
			RPSBlackListDoor = {}
		end 
	elseif RealisticPropertiesEnt:GetClass() != "func_door_rotating" && RealisticPropertiesEnt:GetClass() != "prop_door_rotating" && RealisticPropertiesEnt:GetClass() != "func_door"  then 
		print("[REALISTIC PROPERTIES] check computer/npc entity...")
		if SERVER then
			print("[REALISTIC PROPERTIES] valid computer/npc entity!")
			if RealisticPropertiesEnt:GetClass() == "realistic_properties_computer" or RealisticPropertiesEnt:GetClass() == "realistic_properties_npc" then 
				net.Start("RealisticProperties:ModificationNpc")
				net.WriteTable(RealisticPropertiesTab)
				net.WriteTable(RealisticPropertiesEnt.TableEnt)
				net.WriteEntity(RealisticPropertiesEnt)
				net.Send(self:GetOwner())
			end 
		end
	elseif RealisticPropertiesEnt:GetClass() == "func_door_rotating" or RealisticPropertiesEnt:GetClass() == "prop_door_rotating" or RealisticPropertiesEnt:GetClass() == "func_door" then
		if self.StepId == 3 then 
			if SERVER then 
				if not istable(RPSBlackListDoor) then 
					RPSBlackListDoor = {}
				end
				if not table.HasValue(RPSBlackListDoor, RealisticPropertiesEnt:MapCreationID()) then 
					table.insert(RPSBlackListDoor, tostring(RealisticPropertiesEnt:MapCreationID())) 
				else 
					table.RemoveByValue(RPSBlackListDoor, tostring(RealisticPropertiesEnt:MapCreationID())) 
				end 
			else 	
				if not istable(RPSBlackListDoor) then 
					RPSBlackListDoor = {}
				end 
				if table.HasValue(RealisticPropertiesTableDoors, RealisticPropertiesEnt) then 
					if not table.HasValue(RPSBlackListDoor, RealisticPropertiesEnt) then 
						table.insert(RPSBlackListDoor, RealisticPropertiesEnt )
					else 
						table.RemoveByValue(RPSBlackListDoor, RealisticPropertiesEnt)
					end 
				end 
			end 
		end 
	end 
end 

function TOOL:DrawToolScreen( w, h )
	if CLIENT then 
		surface.SetDrawColor( Realistic_Properties.Colors["darkblue"] )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( Realistic_Properties.Colors["lightblue2"] )
		surface.DrawRect( 15, 20 + ( self.StepId * 58 ) - 58, w-30, 53 )
		surface.SetDrawColor( Realistic_Properties.Colors["white"] )
		surface.DrawRect( 15, 20 + ( self.StepId * 58 ) - 58, w-30, 2 )
		surface.SetDrawColor( Realistic_Properties.Colors["white"] )
		surface.DrawRect( 15, 20 + ( self.StepId * 58 ) - 5, w-30, 2 )
		if IsValid(self.RWSEnt) then 
			draw.SimpleText( Realistic_Properties.GetSentence("deliveryPoint").." (1)", "rps_font_12", w / 2, h / 5.7, Realistic_Properties.Colors["green"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( Realistic_Properties.GetSentence("deliveryPoint"), "rps_font_12", w / 2, h / 5.7, Realistic_Properties.Colors["graywhite"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end 
		if IsEntity(self.RealisticPropertiesCamPos[3]) then 
			draw.SimpleText( Realistic_Properties.GetSentence("cameraPos").." ("..#self.RealisticPropertiesCamPos.."/3)", "rps_font_12", w / 2, h / 2.4, Realistic_Properties.Colors["green"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif IsEntity(self.RealisticPropertiesCamPos[1]) then 
			draw.SimpleText( Realistic_Properties.GetSentence("cameraPos").." ("..#self.RealisticPropertiesCamPos.."/3)", "rps_font_12", w / 2, h / 2.4, Realistic_Properties.Colors["graywhite"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( Realistic_Properties.GetSentence("cameraPos").." (0/3)", "rps_font_12", w / 2, h / 2.4, Realistic_Properties.Colors["graywhite"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end 
		if isvector(RealisticPropertiesPos1) && isvector(RealisticPropertiesPosGhost2) then 
			draw.SimpleText( Realistic_Properties.GetSentence("selectZone"), "rps_font_12", w / 2, h / 1.57, Realistic_Properties.Colors["green"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else 
			draw.SimpleText( Realistic_Properties.GetSentence("selectZone"), "rps_font_12", w / 2, h / 1.57, Realistic_Properties.Colors["graywhite"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end 
		if IsEntity(self.RealisticPropertiesCamPos[3]) && IsValid(self.RWSEnt) && istable(RealisticPropertiesTableDoors) && #RealisticPropertiesTableDoorsData == 0 then  
			if #RealisticPropertiesTableDoors != 0 then 
				draw.SimpleText( Realistic_Properties.GetSentence("finalStep"), "rps_font_12", w / 2, h / 1.16, Realistic_Properties.Colors["green"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else 
				draw.SimpleText( Realistic_Properties.GetSentence("finalStep"), "rps_font_12", w / 2, h / 1.16, Realistic_Properties.Colors["graywhite"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end 
		else 
			draw.SimpleText( Realistic_Properties.GetSentence("finalStep"), "rps_font_12", w / 2, h / 1.16, Realistic_Properties.Colors["graywhite"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end 
	end 
end

function TOOL:CreateRWSEnt(pos, ang, model, bool)
	if not Realistic_Properties.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	if CLIENT then 
		if bool == true then 
			if IsValid(self.RWSEnt) then 
				self.RWSEnt:Remove()
			end 
			self.RWSEnt = ClientsideModel(model, RENDERGROUP_OPAQUE)
			self.RWSEnt:SetModel(model)
			self.RWSEnt:SetMaterial("models/wireframe")
			self.RWSEnt:SetPos(pos)
			self.RWSEnt:SetAngles(ang)
			self.RWSEnt:Spawn()
			self.RWSEnt:Activate()	
			self.RWSEnt.Ang = ang
			self.RWSEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
			self.RWSEnt:SetColor(Realistic_Properties.Colors["white150"] ) 
		elseif bool == false then 
			self.RWSEntCam = ClientsideModel(model, RENDERGROUP_OPAQUE)
			self.RWSEntCam:SetModel(model)
			self.RWSEntCam:SetMaterial("models/wireframe")
			self.RWSEntCam:SetPos(pos)
			self.RWSEntCam:SetAngles(ang)
			self.RWSEntCam:Spawn()
			self.RWSEntCam:Activate()	
			self.RWSEntCam.Ang = ang
			self.RWSEntCam:SetRenderMode(RENDERMODE_TRANSALPHA)
			self.RWSEntCam:SetColor( Realistic_Properties.Colors["white150"] )
			table.insert(self.RealisticPropertiesCamPos, self.RWSEntCam)
		end 
	end 
end 

function TOOL:CreateGhostRWSEnt()	
	if CLIENT then
		if not IsValid(self.RWSGhostEnt) then
 			self.RWSGhostEnt = ClientsideModel(Realistic_Properties.ModelOfTheBox, RENDERGROUP_OPAQUE)
			self.RWSGhostEnt:SetModel(Realistic_Properties.ModelOfTheBox)
			self.RWSGhostEnt:SetMaterial("models/wireframe")
			self.RWSGhostEnt:SetPos(Vector(0,0,0))
			self.RWSGhostEnt:SetAngles(self:GetOwner():GetAngles())
			self.RWSGhostEnt:Spawn()
			self.RWSGhostEnt:Activate()	
			self.RWSGhostEnt.Ang = self:GetOwner():GetAngles()

			self.RWSGhostEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
			self.RWSGhostEnt:SetColor(Realistic_Properties.Colors["white150"])
		end
	end 
end

function TOOL:Think()
	if not Realistic_Properties.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	local RealisticPropertiesEnt = self:GetOwner():GetEyeTrace().Entity
	hook.Add("KeyPress", "RealisticProperties:KeyPress", function(ply, key)
		if ( key == IN_RELOAD ) then 
			self.rws = self.rws or CurTime()
			if self.StepId >= 1 && self.StepId < 3 then
				if self.rws > CurTime() then return end
				self.rws = CurTime() + 0.001
				self.StepId = self.StepId + 1 
			end 
			if self.StepId == 1 then 
				self:CreateGhostRWSEnt() 
			end
			if IsValid(self.RWSGhostEnt) then 
				self.RWSGhostEnt:Remove() 
			end 
		end
		if ( key == IN_USE ) then
			self.rws = self.rws or CurTime()
			if self.StepId > 1 && self.StepId <= 4 then
				if self.rws > CurTime() then return end
				self.rws = CurTime() + 0.001
				self.StepId = self.StepId - 1 
			end 
			if self.StepId == 3 then 
				self:CreateGhostRWSEnt() 
			end 
			if IsValid(self.RWSGhostEnt) then 
				self.RWSGhostEnt:Remove()
			end 
		end
	end )
	if self.StepId == 1 then 
		if IsValid(self.RWSGhostEnt) then
			ply = self:GetOwner()
			trace = util.TraceLine(util.GetPlayerTrace(ply))
			angle = ply:GetAimVector():Angle()
			ang = Angle(0,angle.yaw,0) 
			Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)
			self.RWSGhostEnt:SetPos(Pos)
			self.RWSGhostEnt:SetAngles(ang)
		else 
			self:CreateGhostRWSEnt()
		end
	end 
end 

if CLIENT then 
	RealisticPropertiesActivate = false 
	net.Receive("RealisticProperties:SendTableTool", function()
		if not Realistic_Properties.AdminRank[LocalPlayer():GetUserGroup()] then return end 
		local Number = net.ReadInt(32)
		local RPSInformationDecompress = util.Decompress(net.ReadData(Number)) or {}
		RealisticPropertiesTableZone = util.JSONToTable(RPSInformationDecompress)
	end ) 
	function Realistic_Properties:CheckIfDoorIsInTheData(doorsent) -- Check if the door is already in the data 
		if not IsValid(doorsent) or not IsEntity(doorsent) then return end 
		local doorsid = doorsent:EntIndex()
		if not isnumber(doorsid) then return end 
		if not istable(RealisticPropertiesTableZone) then return end 
		local DoorData = false 
		for k,v in pairs(RealisticPropertiesTableZone) do 
			for _,doors in pairs(RealisticPropertiesTableZone[k]["RealisticPropertiesDoorId"]) do 
				if doorsid == doors then 
					DoorData = true 
					break 
				end 
			end     
		end 
		return DoorData
	end 
	function TOOL:RealisticPropertiesZonePos(self, pos1, pos2) 
		if self.StepId == 3 then 
			if isvector(pos1) then 
				RealisticPropertiesPos1 = pos1  
				RealisticPropertiesPos2 = nil
			end 
			if isvector(pos2) then 
				RealisticPropertiesPos2 = pos2
			end   
		end
	end
	hook.Add("PostDrawTranslucentRenderables", "RealisticProperties:PostDrawTranslucentRenderables", function()
		if RealisticPropertiesActivate then 
			if isvector(RealisticPropertiesPos1) && not isvector(RealisticPropertiesPos2) then 
				local tr = util.TraceLine( {
					start = LocalPlayer():EyePos(),
					endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 100,
					filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
				} )
				RealisticPropertiesPosGhost2 = tr.HitPos
			elseif isvector(RealisticPropertiesPos1) && isvector(RealisticPropertiesPos2) then 
				RealisticPropertiesPosGhost2 = RealisticPropertiesPos2
			end 
			render.DrawWireframeBox( vector_origin, angle_zero, Vector(RealisticPropertiesPos1), RealisticPropertiesPosGhost2, Realistic_Properties.Colors["green"], true) 
			RealisticPropertiesTableDoors = {}
			RealisticPropertiesTableDoorsData = {}
			for k,v in pairs(ents.FindInBox(Vector(RealisticPropertiesPos1), RealisticPropertiesPosGhost2)) do 
				if v:GetClass() == "func_door_rotating" or v:GetClass() == "prop_door_rotating" or v:GetClass() == "func_door" then 
					if not Realistic_Properties:CheckIfDoorIsInTheData(v) then 
						if not table.HasValue(RealisticPropertiesTableDoors, v) then 
							table.insert(RealisticPropertiesTableDoors, v)
						end 
					else 
						if not table.HasValue(RealisticPropertiesTableDoorsData, v) then 
							table.insert(RealisticPropertiesTableDoorsData, v)
						end 
					end 
				end  
			end  
		end
	end ) 
end 

function TOOL:Reload()
	if not Realistic_Properties.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	if CLIENT then 
		self.rws = self.rws or CurTime()
		if self.rws > CurTime() then return end
		self.rws = CurTime() + 0.001
		if not istable(RealisticPropertiesTableDoors) then return end 
		if #RealisticPropertiesTableDoors != 0 then
			if IsValid(self.RWSEnt) then
				if IsEntity(self.RealisticPropertiesCamPos[3]) then  
					if isvector(RealisticPropertiesPos1) && isvector(RealisticPropertiesPosGhost2) then 
						if #RealisticPropertiesTableDoorsData == 0 then 
							if self.StepId == 3 then 
								local RealisticPropertiesCam = {}
								for k,v in pairs(self.RealisticPropertiesCamPos) do
									table.insert(RealisticPropertiesCam, v:GetPos())
									table.insert(RealisticPropertiesCam, v:GetAngles())
								end
								RealisticPropertiesTableSave = {
									RealisticPropertiesCam = RealisticPropertiesCam,
									RealisticPropertiesDelivery = self.RWSEnt:GetPos(),
									RealisticPropertiesDoors = RealisticPropertiesTableDoors, 
									RealisticPropertiesboxMax = RealisticPropertiesPosGhost2,
									RealisticPropertiesboxMins = RealisticPropertiesPos1,
								}
								net.Start("RealisticProperties:SendTable")
								net.WriteTable(RealisticPropertiesTableSave)
								net.SendToServer()
								self.StepId = 1 
								if IsValid(self.RWSGhostEnt) then 
									self.RWSGhostEnt:Remove()
								end 
								if IsValid(self.RWSEnt) then 
									self.RWSEnt:Remove()
								end 
								if istable(self.RealisticPropertiesCamPos) then 
									for k,v in pairs(self.RealisticPropertiesCamPos) do
										v:Remove()
									end
								end 
								RealisticPropertiesTableDoors = {}
								RealisticPropertiesTableDoorsData = {}
								RealisticPropertiesActivate = false
								RealisticPropertiesPos1 = nil
								RealisticPropertiesPosGhost2 = nil 
								RPSBlackListDoor = {}
								self.RealisticPropertiesCamPos = {}
							end 
						else 
							RealisticPropertiesNotify( Realistic_Properties.GetSentence("duplicatedDoor"), 3 )
						end 
					end 
				end 
			end 
		else 
			if #RealisticPropertiesTableDoorsData != 0 then 
				RealisticPropertiesNotify( Realistic_Properties.GetSentence("duplicatedDoor"), 3 )
			end 
		end 
	end 
	if SERVER then 
		net.Receive("RealisticProperties:SendTable", function(len, ply)
			ply.countdownName = ply.countdownName or CurTime()
			if ply.countdownName > CurTime() then return end
			ply.countdownName = CurTime() + 1
			
			self.StepId = 1 
			local RealisticPropertiesTable = net.ReadTable()
			local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    		local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
			
			RealisticPropertiesTable["RealisticPropertiesBlacklist"] = RPSBlackListDoor
			local CompressTable = util.Compress(RealisticPropertiesFil)
			net.Start("RealisticProperties:PropertiesAdd")
                net.WriteTable(RealisticPropertiesTable)
                net.WriteInt(CompressTable:len(), 32)
                net.WriteData( CompressTable, CompressTable:len() )
            net.Send(ply)
		end )
	end 
end 

function TOOL:Holster()
	if not Realistic_Properties.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	if CLIENT then 
		if IsValid(self.RWSGhostEnt) then 
			self.RWSGhostEnt:Remove()
		end 
		if IsValid(self.RWSEnt) then 
			self.RWSEnt:Remove()
		end 
		if istable(self.RealisticPropertiesCamPos) then 
			for k,v in pairs(self.RealisticPropertiesCamPos) do
				v:Remove()
			end
		end 
		RealisticPropertiesActivate = false
		RealisticPropertiesPos1 = nil
		RealisticPropertiesPosGhost2 = nil
		RealisticPropertiesTableDoors = {}
		RealisticPropertiesTableDoorsData = {}
		RPSBlackListDoor = {}
		self.RealisticPropertiesCamPos = {}
	end 
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl("label", {
	Text = "Guardar todas las entidades en los datos" })
	CPanel:Button("Guardar Entidades", "rps_saveentities")

	CPanel:AddControl("label", {
	Text = "Eliminar todas las entidades en los datos" })  
	CPanel:Button("Eliminar datos de entidades", "rps_removedata")

	CPanel:AddControl("label", {
	Text = "Eliminar todas las entidades en el mapa" })
	CPanel:Button("Eliminar mapa de entidades", "rps_cleaupentities")

	CPanel:AddControl("label", {
	Text = "Recargar todas las entidades en el mapa" })
	CPanel:Button("Recargar mapa de entidades", "rps_reloadentities")
end