if (not CLIENT) then return end
zfs = zfs or {}
zfs.Shop = zfs.Shop or {}

local function ImageButton(Shop,parent,img,action)
	local button_pnl = vgui.Create("DButton", parent)
	button_pnl:SetText("")
	button_pnl.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h,s.Hovered and zclib.colors["ui_highlight"] or zclib.colors["ui02"])
		zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 8,zclib.colors["white_a5"])

		surface.SetDrawColor(color_white)
		surface.SetMaterial(img)
		surface.DrawTexturedRect(0,0,w,h)

		if s.Hovered then
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["white_a5"])
		end
	end
	button_pnl.DoClick = function(s)
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		if Shop:GetOccupiedPlayer() ~= LocalPlayer() then return end
		pcall(action,button_pnl)
	end

	return button_pnl
end

local function TextButton(Shop,parent,txt,action)
	local button_pnl = vgui.Create("DButton", parent)
	button_pnl:SetText("")
	button_pnl.Paint = function(s, w, h)
		//draw.RoundedBox(0, 0, 0, w, h,s.Hovered and zclib.colors["ui_highlight"] or zclib.colors["ui02"])
		//zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2,color_white)

		draw.SimpleText(txt, zclib.GetFont("zclib_world_font_small"),w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if s.Hovered then
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["white_a5"])
		end
	end
	button_pnl.DoClick = function(s)
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		if Shop:GetOccupiedPlayer() ~= LocalPlayer() then return end
		pcall(action,button_pnl)
	end

	return button_pnl
end

local function TextButton01(Shop,parent,txt,action)
	local button_pnl = vgui.Create("DButton", parent)
	button_pnl:SetText("")
	button_pnl.TextFont = zclib.GetFont("zclib_world_font_small")
	button_pnl.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h,zclib.colors["ui_highlight"])
		//zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2,color_white)

		draw.SimpleText(txt,s.TextFont,w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if s.Hovered then
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["white_a5"])
		end
	end
	button_pnl.DoClick = function(s)
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		if Shop:GetOccupiedPlayer() ~= LocalPlayer() then return end
		pcall(action,button_pnl)
	end

	return button_pnl
end

local function BackButton(Shop,parent,action)
	local backbtn = TextButton(Shop,parent,"< " .. zfs.language.Shop.StorageBackButton,action)
	backbtn:SetWide(100)
	backbtn:Dock(LEFT)
	backbtn:DockMargin(5,0,0,0)
end

local function NextButton(Shop,parent,action)
	local backbtn = TextButton(Shop,parent,zfs.language.Shop.NextButton .. " >",action)

	backbtn:SetWide(zclib.util.GetTextSize(zfs.language.Shop.NextButton .. " >",zclib.GetFont("zclib_world_font_small")) + 10)
	backbtn:Dock(RIGHT)
	backbtn:DockMargin(5,0,0,0)
end

/////////////////////////////////////////////////////////////////////

function zfs.Shop.Initialize(Shop)
	zclib.EntityTracker.Add(Shop)

	Shop.CurrentState = 0
	Shop.initialdiff = 100000000000000000000
	Shop.lastHitItem = nil
	Shop.nearestItem = nil
	Shop.IsHovering = false
end

function zfs.Shop.SetupInterface(Shop)
	if IsValid(Shop.Interface) then Shop.Interface:Remove() end

	local pnl = vgui.Create("DPanel")
	pnl:ParentToHUD()
	pnl:SetMouseInputEnabled(true)
	pnl:SetPos(0,0)
	pnl:SetSize(540, 350)
	pnl.Paint = function(s, w, h)
		//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
	end
	Shop.Interface = pnl

	zfs.Shop.OnStateChange(Shop)
end

function zfs.Shop.Page(Shop,title,dock,content)
	if IsValid(Shop.Content) then Shop.Content:Remove() end

	local pnl = vgui.Create("DPanel",Shop.Interface)
	pnl:SetSize(540, 350)
	pnl.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui01"])
	end
	Shop.Content = pnl

	local topPanel = vgui.Create("DPanel",pnl)
	topPanel:SetTall(40)
	topPanel:Dock(TOP)
	topPanel.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, h - 2, w, 2, zfs.default_colors["white04"])
		if dock == TEXT_ALIGN_LEFT then
			draw.SimpleText(title, zclib.GetFont("zclib_world_font_mediumsmoll"), 10, 5, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		else
			draw.SimpleText(title, zclib.GetFont("zclib_world_font_mediumsmoll"), w / 2, 5, color_white, TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		end
	end

	pnl:InvalidateParent(true)
	topPanel:InvalidateParent(true)

	pcall(content,pnl,topPanel)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////
/////////////////////////// MAIN  ///////////////////////////
//////////////////////////////////////////////////////////////
zfs.Shop.List = zfs.Shop.List or {}
zclib.Hook.Add("PostDrawOpaqueRenderables", "zfs_DrawInterface", function(depth, skybox,isDraw3DSkybox)
	if isDraw3DSkybox == false then
		for machine, _ in pairs(zfs.Shop.List) do
			if IsValid(machine) then zfs.Shop.Draw(machine) end
		end
	end
end)

function zfs.Shop.GettingPushed(Shop)
	return IsValid(Shop:GetPushPlayer()) and (Shop:GetVelocity():Length() * 0.05) > 1
end

function zfs.Shop.AnimateWheel(Shop,Attach,Wheel,Rot)
	if not IsValid(Wheel) then return end

	if Attach then
		local ang = Attach.Ang
		ang:RotateAroundAxis(ang:Forward(),-90)
		ang:RotateAroundAxis(ang:Right(),Rot)
		Wheel:SetRenderAngles(ang)
		Wheel:SetPos(Attach.Pos)
	else
		Wheel:SetRenderAngles(Shop:GetAngles())
		Wheel:SetPos(Shop:GetPos())
	end
end

function zfs.Shop.Think(Shop)

	zfs.Shop.List[Shop] = true

	//Here we create or remove the client models
	if zclib.util.InDistance(LocalPlayer():GetPos(), Shop:GetPos(), 1000) then

		zfs.Shop.Lights(Shop)

		zfs.Shop.FrozzeEffect(Shop)

		zclib.util.LoopedSound(Shop, "zfs_sfx_sweetener", Shop.CurrentState == 10)

		local currentState = Shop:GetCurrentState()
		if Shop.CurrentState ~= currentState then
			Shop.CurrentState = currentState
			zfs.Shop.OnStateChange(Shop)
		end

		local curIsBusy = Shop:GetIsBusy()
		if Shop.IsBusy ~= curIsBusy then
			Shop.IsBusy = curIsBusy
			zfs.Shop.OnStateChange(Shop)
		end

		if Shop.ClientProps == nil then
			Shop.ClientProps = {}

			Shop.RightWheel = zfs.Shop.CreateClientModel(Shop,"models/zerochain/fruitslicerjob/fs_wheel.mdl",Shop:LookupAttachment("r_wheel"),Angle(0,0,-90),1)
			Shop.LeftWheel = zfs.Shop.CreateClientModel(Shop,"models/zerochain/fruitslicerjob/fs_wheel.mdl",Shop:LookupAttachment("l_wheel"),Angle(0,0,-90),1)
			zfs.Shop.CreateClientModel(Shop,"models/zerochain/fruitslicerjob/fs_shop_glass.mdl",0,Angle(0,0,0),1)
			zfs.Shop.CreateClientModel(Shop,"models/zerochain/fruitslicerjob/fs_fruitpile.mdl",Shop:LookupAttachment("fruitlift"),Angle(0,-90,-90),0.85)
		end

		zclib.util.LoopedSound(Shop, "zfs_sfx_squeek", zfs.Shop.GettingPushed(Shop))
		if zfs.Shop.GettingPushed(Shop) then
			local speed = Shop:GetVelocity():Length() * 0.05
			local fract = math.Clamp((1 / 10) * speed,0,10)
			Shop.WheelRot = (Shop.WheelRot or 0) + (4 * fract)
		else
			Shop.WheelRot = (Shop.WheelRot or 0)
		end

		if zfs.Shop.GettingPushed(Shop) and (Shop.NextPushEffect == nil or CurTime() > Shop.NextPushEffect) then
			zclib.Effect.ParticleEffect("zfs_shop_trail", Shop:GetPos(), angle_zero, Shop)
			Shop.NextPushEffect = CurTime() + 0.15
		end

		zfs.Shop.AnimateWheel(Shop,Shop:GetAttachment(Shop:LookupAttachment("r_wheel")),Shop.RightWheel,-Shop.WheelRot)
		zfs.Shop.AnimateWheel(Shop,Shop:GetAttachment(Shop:LookupAttachment("l_wheel")),Shop.LeftWheel,Shop.WheelRot)
	else
		zfs.Shop.RemoveClientModels(Shop)
	end
end

function zfs.Shop.Draw(Shop)
	if zclib.util.InDistance(Shop:GetPos(), LocalPlayer():GetPos(), zfs.dist_interaction) then

		zfs.Shop.DrawInterface(Shop)

		zfs.Shop.DrawOccupiedInfo(Shop)

		// Draw push indicator
		zfs.Shop.DrawPushIndicator(Shop)
	else
		if IsValid(Shop.Interface) then
			Shop.Interface:Remove()
		end
	end
end

function zfs.Shop.OnRemove(Shop)
	zfs.Shop.RemoveClientModels(Shop)

	if IsValid(Shop.Interface) then
		Shop.Interface:Remove()
	end

	Shop:StopSound("zfs_sfx_sweetener")
end

//This Draw the Main interface
function zfs.Shop.DrawInterface(Shop)
	zclib.vgui3d.Start3D2D(Shop:LocalToWorld(Vector(-10.8, 20.6, 73.6)), Shop:LocalToWorldAngles(Angle(0, 180, 105)),0.05)
		if IsValid(Shop.Interface) then
			// Draws the UI
			Shop.Interface:ZCLIBPaint3D2D()

			// Cursor
			if zclib.vgui3d.IsPointingPanel(Shop.Interface) then
				local x, y = zclib.vgui3d.GetCursorPosition(Shop.Interface)
				draw.RoundedBox(4, x - 3, y - 3, 6, 6, color_white)
			end
		else
			zfs.Shop.SetupInterface(Shop)
		end
	zclib.vgui3d.End3D2D()
end

// Called from client to force update
net.Receive("zfs_shop_forceupdate", function(len, ply)
	zclib.Debug_Net("zfs_shop_forceupdate",len)

	local Shop = net.ReadEntity()
	local UpdateUser = net.ReadBool()
	if IsValid(Shop) then
		zfs.Shop.OnStateChange(Shop,UpdateUser)
	end
end)

function zfs.Shop.OnStateChange(Shop,skip)
	if not IsValid(Shop.Interface) then return end

	if Shop.IsBusy then
		zfs.Shop.Busy(Shop)
		return
	end

	// Dont call if the occupied player is localplayer since we change the pages for him using buttons
	if skip == nil and Shop:GetOccupiedPlayer() == LocalPlayer() then return end

	Shop:EmitSound("zfs_sfx_item_select")

	if Shop.CurrentState == 0 then
		zfs.Shop.Disabled(Shop)
		return
	end

	if Shop.CurrentState == 1 then
		zfs.Shop.MainMenu(Shop)
		return
	end

	if Shop.CurrentState == 2 then
		zfs.Shop.Storage(Shop)
		return
	end

	/////////// Select
	if Shop.CurrentState == 3 then
		zfs.Shop.ProductSelection(Shop)
		return
	end

	if (Shop.CurrentState == 4) then
		zfs.Shop.ProductConfirmation(Shop,Shop:GetSmoothieID())
		return
	end

	if (Shop.CurrentState == 5) then
		zfs.Shop.ToppingSelection(Shop,Shop:GetSmoothieID())
		return
	end

	if (Shop.CurrentState == 6) then
		zfs.Shop.ToppingConfirmation(Shop,Shop:GetSmoothieID(),Shop:GetToppingID())
		return
	end
	///////////

	/////////// Create
	if (Shop.CurrentState == 7) then
		zfs.Shop.TakeCup(Shop)
		return
	end

	if (Shop.CurrentState == 8) then
		zfs.Shop.SliceFruits(Shop)
		return
	end

	if (Shop.CurrentState == 9) then
		zfs.Shop.ChooseSweetener(Shop)
		return
	end

	if (Shop.CurrentState == 11) then
		zfs.Shop.StartBlender(Shop)
	end
end

// Informs the server on which page we are currently on
function zfs.Shop.ChangeState(Shop,state)

	// Only the player who occupies the shop can change its state
	local OCPlayer = Shop:GetOccupiedPlayer()
	if OCPlayer ~= LocalPlayer() then return end

	Shop.CurrentState = state
	Shop:EmitSound("zfs_sfx_item_select")

	net.Start("zfs_shop_changestate")
	net.WriteEntity(Shop)
	net.WriteUInt(state,32)
	net.SendToServer()
end

//This Draws the Occupied Interface
function zfs.Shop.DrawOccupiedInfo(Shop)
	local OCPlayer = Shop:GetOccupiedPlayer()
	if IsValid(OCPlayer) and LocalPlayer() ~= OCPlayer then
		cam.Start3D2D(Shop:LocalToWorld(Vector(-10.9, 20.6, 73.6)), Shop:LocalToWorldAngles(Angle(0, 180, 105)), 0.07)
			zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, 384, 252, 4,zclib.colors["red01"])
			draw.RoundedBox(0, 0, 210, 384, 40, zclib.colors["red01"])
			draw.SimpleText("Occupied by " .. OCPlayer:Nick(), zclib.GetFont("zclib_world_font_small"), 192, 230, zclib.colors["black_a200"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

function zfs.Shop.DrawPushIndicator(Shop)
	if zclib.Player.IsOwner(LocalPlayer(), Shop) then
		cam.Start3D2D(Shop:LocalToWorld(Vector(-57,0, 33)), Shop:LocalToWorldAngles(Angle(0, -90, 90)), 0.07)
			draw.RoundedBox(0, -210, -25, 420, 50, zclib.colors["red01"])
			if zfs.Shop.OnPush(Shop,LocalPlayer()) then
				draw.RoundedBox(0, -210, -25, 420, 50, zclib.colors["white_a100"])
			end
			draw.SimpleText(zfs.language.Shop.Push, zclib.GetFont("zclib_world_font_small"), 0, 0, zclib.colors["black_a200"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			zclib.util.DrawOutlinedBox(-210, -25, 420, 50, 4,zclib.colors["black_a200"])
		cam.End3D2D()
	end
end

//////////////////////////////////////////////////////////////
////////////////////////// Pages /////////////////////////////
//////////////////////////////////////////////////////////////
function zfs.Shop.Disabled(Shop)
	zfs.Shop.Page(Shop, zfs.language.Shop.OS,TEXT_ALIGN_LEFT, function(main, top)
		local EnableBtn = ImageButton(Shop,main,zfs.default_materials["zfs_ui_assmble"],function(apnl)
			if zfs.Shop.CanInteract(Shop, LocalPlayer(),true) then
				net.Start("zfs_shop_enable")
				net.WriteEntity(Shop)
				net.SendToServer()
			end
			//zfs.Shop.MainMenu(Shop)
		end)
		EnableBtn:SetSize(200,200)
		EnableBtn:Center()
		//EnableBtn:Dock(FILL)
		//EnableBtn:DockMargin(120,20,120,20)
	end)
end

function zfs.Shop.MainMenu(Shop)

	zfs.Shop.ChangeState(Shop,1)

	zfs.Shop.Page(Shop, zfs.language.Shop.OS,TEXT_ALIGN_LEFT, function(main, top)

		local size = 162

		local pnl = vgui.Create("DPanel", main)
		pnl:SetTall(size + 20)
		pnl:DockPadding(15,10,10,10)
		pnl:Dock(TOP)
		pnl.Paint = function(s, w, h)
			//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
		end

		if Shop:GetPublicEntity() == false then
			local DisableBtn = ImageButton(Shop,pnl,zfs.default_materials["zfs_ui_desamble"],function(apnl)
				if zfs.Shop.CanInteract(Shop, LocalPlayer(),true) then
					net.Start("zfs_shop_disable")
					net.WriteEntity(Shop)
					net.SendToServer()
				end
			end)
			DisableBtn:SetSize(size,size)
			DisableBtn:Dock(LEFT)
			DisableBtn:DockMargin(0,0,0,0)
		end

		local MakeBtn = ImageButton(Shop,pnl,zfs.default_materials["zfs_ui_makeproduct"],function(apnl)
			zfs.Shop.ProductSelection(Shop)
		end)
		MakeBtn:SetSize(size,size)
		MakeBtn:Dock(LEFT)
		MakeBtn:DockMargin(10,0,0,0)

		local storageBtn = ImageButton(Shop,pnl,zfs.default_materials["fs_ui_storage"],function(apnl)
			zfs.Shop.Storage(Shop)
		end)
		storageBtn:SetSize(size,size)
		storageBtn:Dock(LEFT)
		storageBtn:DockMargin(10,0,0,0)
	end)
end

function zfs.Shop.Storage(Shop)

	zfs.Shop.ChangeState(Shop,2)

	zfs.Shop.Page(Shop, zfs.language.Shop.StorageTitle,TEXT_ALIGN_CENTER, function(main, top)

		BackButton(Shop,top,function()
			zfs.Shop.MainMenu(Shop)
		end)

		local list = vgui.Create("DIconLayout", main)
		list:DockMargin(10,10,-10,10)
		list:Dock(FILL)
		list:SetSpaceY(10)
		list:SetSpaceX(10)
		list.Paint = function(s, w, h)
			//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
		end

		for k, v in pairs(zfs.Shop.GetFruitStorage(Shop)) do
			if v == nil or v <= 0 then continue end

			local itm = list:Add("DPanel")
			itm:SetSize(96,96)
			itm.Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui02"])
				zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, zclib.colors["white_a5"])

				surface.SetDrawColor(color_white)
				surface.SetMaterial(zfs.Fruit.GetIcon(k))
				surface.DrawTexturedRect(w * 0.1, h * 0.1, w * 0.8, h * 0.8)

				draw.SimpleText("x" .. v, zclib.GetFont("zclib_world_font_mediumsmoll"), w - 7, h - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			end
		end
	end)
end

function zfs.Shop.Busy(Shop)
	zfs.Shop.Page(Shop, zfs.language.Shop.OS,TEXT_ALIGN_LEFT, function(main, top)
		local pnl = vgui.Create("DPanel", main)
		pnl:Dock(FILL)
		pnl.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui01"])
			draw.SimpleText(zfs.language.Shop.Screen_Wait, zclib.GetFont("zclib_world_font_medium"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end)
end

function zfs.Shop.ProductSelection(Shop)

	zfs.Shop.ChangeState(Shop,3)

	zfs.Shop.Page(Shop, zfs.language.Shop.Screen_Product_Select,TEXT_ALIGN_CENTER, function(main, top)

		BackButton(Shop,top,function()
			zfs.Shop.MainMenu(Shop)
		end)

		local list = vgui.Create("DIconLayout", main)
		list:DockMargin(10,10,-10,10)
		list:Dock(FILL)
		list:SetSpaceY(10)
		list:SetSpaceX(10)
		list.Paint = function(s, w, h)
			//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
		end

		for k, v in pairs(zfs.config.Smoothies) do
			if v == nil then continue end

			local itm = list:Add("DButton")
			itm:SetSize(96,96)
			itm:SetText("")
			itm.Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, s.Hovered and zclib.colors["ui_highlight"] or zclib.colors["ui02"])
				zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, zclib.colors["white_a5"])

				surface.SetDrawColor(color_white)
				surface.SetMaterial(v.Icon)
				surface.DrawTexturedRect(w * 0.15, h * 0.1, w * 0.7, h * 0.7)

				draw.SimpleText(v.Name, zclib.GetFont("zclib_world_font_supertiny"),w / 2, h - 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end
			itm.DoClick = function()
				if Shop:GetOccupiedPlayer() ~= LocalPlayer() then return end

				zclib.vgui.PlaySound("UI/buttonclick.wav")
				net.Start("zfs_shop_selectproduct")
				net.WriteEntity(Shop)
				net.WriteUInt(k,32)
				net.SendToServer()

				// Open Interface to confirm selection
				//zfs.Shop.ProductConfirmation(Shop,k)

				zfs.Shop.Busy(Shop)
			end
		end
	end)
end

function zfs.Shop.ProductConfirmation(Shop,id)

	zfs.Shop.ChangeState(Shop,4)

	zfs.Shop.Page(Shop, zfs.language.Shop.Screen_Confirm_Product,TEXT_ALIGN_CENTER, function(main, top)

		BackButton(Shop,top,function()
			zfs.Shop.ProductSelection(Shop)
		end)

		NextButton(Shop,top,function()

			// Verfiy if we got enough fruits
			if zfs.Shop.MissingFruits(Shop, LocalPlayer(),id) then
				zclib.Notify(LocalPlayer(), zfs.language.Shop.MissingFruits, 1)
				return
			end

			zfs.Shop.ToppingSelection(Shop,id)
		end)

		local SmoothieData = zfs.Smoothie.GetData(id)
		if SmoothieData == nil then return end

		local InfoPanel = vgui.Create("DPanel",main)
		InfoPanel:SetTall(150)
		InfoPanel:Dock(TOP)
		InfoPanel.Paint = function(s, w, h) end

		local ImgPanel = vgui.Create("DPanel",InfoPanel)
		ImgPanel:SetWide(130)
		ImgPanel:Dock(LEFT)
		ImgPanel:DockMargin(10,10,0,10)
		ImgPanel.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui02"])
			zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, zclib.colors["white_a5"])

			surface.SetDrawColor(color_white)
			surface.SetMaterial(SmoothieData.Icon)
			surface.DrawTexturedRect(h * 0.1, h * 0.1, h * 0.8, h * 0.8)
		end

		local NamePanel = vgui.Create("DLabel",InfoPanel)
		NamePanel:SetWide(150)
		NamePanel:SetTall(20)
		NamePanel:Dock(TOP)
		NamePanel:DockMargin(10,5,0,0)
		NamePanel:SetText(SmoothieData.Name)
		NamePanel:SetFont(zclib.GetFont("zclib_world_font_mediumsmall"))
		NamePanel:SetContentAlignment(7)
		NamePanel:SetTextColor(zfs.Smoothie.GetColor(id))
		NamePanel:SetWrap(true)

		local DescPanel = vgui.Create("DLabel",InfoPanel)
		DescPanel:SetWide(150)
		DescPanel:SetTall(50)
		DescPanel:Dock(TOP)
		DescPanel:DockMargin(10,20,10,0)
		DescPanel:SetText(SmoothieData.Info)
		DescPanel:SetFont(zclib.GetFont("zclib_world_font_tiny"))
		DescPanel:SetContentAlignment(7)
		DescPanel:SetTextColor(zclib.colors["text01"])
		DescPanel:SetWrap(true)

		// Here we calculate what the Fruit varation boni is
		local PriceBoni = zfs.Smoothie.GetFruitVarationBoni(id) * zfs.config.Price.FruitMultiplicator
		local ExtraFruitPrice = math.Round(SmoothieData.Price * PriceBoni)
		local finalPrice = SmoothieData.Price + ExtraFruitPrice

		if zfs.config.Price.Custom then
			finalPrice = Shop:GetCustomPrice()
		end

		local PricePanel = vgui.Create("DPanel",InfoPanel)
		PricePanel:Dock(BOTTOM)
		PricePanel:SetTall(50)
		PricePanel:DockMargin(0,0,0,10)
		local fontA = zclib.util.FontSwitch(zfs.language.Shop.Screen_Product_BasePrice,110,zclib.GetFont("zclib_world_font_small"),zclib.GetFont("zclib_world_font_tiny"))
		PricePanel.Paint = function(s, w, h)

			if zfs.config.Price.Custom == false then
				draw.SimpleText(zfs.language.Shop.Screen_Product_BasePrice, fontA, 10, 10, zclib.colors["text01"], TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
				draw.SimpleText(zfs.language.Shop.Screen_Product_FruitBoni, fontA, 10, 30, zclib.colors["text01"], TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

				// The Base Price
				draw.SimpleText(zclib.Money.Display(SmoothieData.Price), zclib.GetFont("zclib_world_font_small"), 235, 10, zclib.colors["blue01"], TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)

				// The FruitVariation Extra Cost
				draw.SimpleText("+" .. zclib.Money.Display(ExtraFruitPrice), zclib.GetFont("zclib_world_font_small"), 235, 30, zclib.colors["blue01"], TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)

				draw.RoundedBox(0, 250, 10, 2, h - 10, zclib.colors["text01"])
			end

			// The Final Price
			draw.SimpleText("+" .. zclib.Money.Display(finalPrice), zclib.GetFont("zclib_world_font_mediumsmall"), w - 10, 14, zclib.colors["green01"], TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
		end

		if zfs.config.Price.Custom then
			local priceEditBtn = TextButton01(Shop,PricePanel,zfs.language.Shop.EditPrice,function()
				// Open price changer
				zfs.Shop.OpenPriceEditor(Shop,finalPrice)
			end)
			priceEditBtn:SetWide(210)
			priceEditBtn:Dock(LEFT)
			priceEditBtn:DockMargin(10,0,0,0)
		end

		local IngredientPanel = vgui.Create("DPanel",main)
		IngredientPanel:DockMargin(10,0,-10,10)
		IngredientPanel:DockPadding(0,30,0,0)
		IngredientPanel:Dock(FILL)
		IngredientPanel.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w - 20, 2, zclib.colors["text01"])
			draw.SimpleText(zfs.language.Shop.Screen_Product_Ingrediens, zclib.GetFont("zclib_world_font_tiny"), 0, 5, zclib.colors["text01"], TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end

		local list = vgui.Create("DIconLayout", IngredientPanel)
		list:Dock(FILL)
		list:SetSpaceY(5)
		list:SetSpaceX(5)
		list.Paint = function(s, w, h)
			//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
		end

		local FruitStorage = table.Copy(zfs.Shop.GetFruitStorage(Shop))

		for fruit_id,fruit_amount in pairs(SmoothieData.recipe) do
			for i = 1,fruit_amount do

				local InStorage = FruitStorage[fruit_id] and FruitStorage[fruit_id] > 0

				local itm = list:Add("DPanel")
				itm:SetSize(60,60)
				itm.Paint = function(s, w, h)
					draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui02"])

					zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["white_a5"])

					surface.SetDrawColor(color_white)
					surface.SetMaterial(zfs.Fruit.GetIcon(fruit_id))
					surface.DrawTexturedRect(h * 0.1, h * 0.1, h * 0.8, h * 0.8)

					if not InStorage then
						draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a200"])
					end
				end

				FruitStorage[fruit_id] = (FruitStorage[fruit_id] or 0) - 1
			end
		end
	end)
end

function zfs.Shop.ToppingSelection(Shop,id)

	zfs.Shop.ChangeState(Shop,5)

	zfs.Shop.Page(Shop, zfs.language.Shop.Screen_Topping_Select,TEXT_ALIGN_CENTER, function(main, top)

		BackButton(Shop,top,function() zfs.Shop.ProductConfirmation(Shop,id) end)

		local list = vgui.Create("DIconLayout", main)
		list:DockMargin(10,10,-10,10)
		list:Dock(FILL)
		list:SetSpaceY(10)
		list:SetSpaceX(10)
		list.Paint = function(s, w, h)
			//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
		end

		for k, v in pairs(zfs.config.Toppings) do
			if v == nil then continue end

			local itm = list:Add("DPanel")
			itm:SetSize(96,90)
			itm.bg_color = zclib.colors["ui02"]
			itm.Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, itm.bg_color)
				zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, zclib.colors["white_a5"])

				if v.Icon then
					surface.SetDrawColor(zclib.colors["red01"])
					surface.SetMaterial(v.Icon)
					surface.DrawTexturedRect(w * 0.2, h * 0.15, w * 0.6, h * 0.6)
				end

				if v.Ranks_create and table.Count(v.Ranks_create) > 0 then
					surface.SetDrawColor(Color(209, 154, 102,50))
					surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
					surface.DrawTexturedRect(0,0,w,h)

					surface.SetDrawColor(zclib.colors["orange01"])
					surface.SetMaterial(zclib.Materials.Get("glow01"))
					surface.DrawTexturedRect(0,0,w,h)
				end
			end

			if v.Model then
				local imgpnl = vgui.Create("DImage", itm)
				imgpnl:SetSize(70,70)
				imgpnl:Center()
				imgpnl:SetY(0)
				//imgpnl:Dock(FILL)
				local img = zclib.Snapshoter.Get({class = "prop_physics",model = v.Model}, imgpnl)
				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			end

			local btn = vgui.Create("DButton", itm)
			btn:Dock(FILL)
			btn:SetText("")
			btn.Paint = function(s, w, h)
				draw.SimpleText(v.Name, zclib.GetFont("zclib_world_font_supertiny"),w / 2, h - 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				itm.bg_color = s.Hovered and zclib.colors["ui_highlight"] or zclib.colors["ui02"]
			end
			btn.DoClick = function()
				if Shop:GetOccupiedPlayer() ~= LocalPlayer() then return end
				zclib.vgui.PlaySound("UI/buttonclick.wav")
				net.Start("zfs_shop_selecttopping")
				net.WriteEntity(Shop)
				net.WriteUInt(k,32)
				net.SendToServer()

				zfs.Shop.Busy(Shop)
				//zfs.Shop.ToppingConfirmation(Shop,id,k)
			end
		end
	end)
end

function zfs.Shop.ToppingConfirmation(Shop,product_id,topping_id)

	zfs.Shop.Page(Shop, zfs.language.Shop.Screen_Confirm_Topping,TEXT_ALIGN_CENTER, function(main, top)

		BackButton(Shop,top,function() zfs.Shop.ToppingSelection(Shop,product_id) end)

		NextButton(Shop,top,function()

			// Check if this topping has a rank restriction for creation
			if zfs.Topping.CanAdd(Shop:GetToppingID(),LocalPlayer()) == false then return end

			// Send net message to server and start smoothie creation
			net.Start("zfs_shop_start")
			net.WriteEntity(Shop)
			net.SendToServer()

			zfs.Shop.TakeCup(Shop)
		end)

		local ToppingData = zfs.Topping.GetData(topping_id)

		local InfoPanel = vgui.Create("DPanel",main)
		InfoPanel:SetTall(150)
		InfoPanel:Dock(TOP)
		InfoPanel.Paint = function(s, w, h)
			draw.SimpleText(ToppingData.Name, zclib.GetFont("zclib_world_font_mediumsmoll"),h, 8, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

			if ToppingData.ToppingBenefit_Duration and ToppingData.ToppingBenefit_Duration > 0 then
				draw.SimpleText(ToppingData.ToppingBenefit_Duration .. "s", zclib.GetFont("zclib_world_font_small"),360, 10, zclib.colors["blue01"], TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
			end
		end

		local EffectPanel = vgui.Create("DPanel",InfoPanel)
		EffectPanel:SetWide(160)
		EffectPanel:Dock(RIGHT)
		EffectPanel:DockMargin(10,10,10,10)
		EffectPanel.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, 2, h, zclib.colors["text01"])
		end

		for k,v in pairs(ToppingData.ToppingBenefits) do

			local bInfo
			if (k == "Health") then
				bInfo = "+" .. tostring(v)
			elseif (k == "ParticleEffect") then
				bInfo = tostring(v)
			elseif (k == "SpeedBoost") then
				bInfo = "+" .. tostring(v)
			elseif (k == "AntiGravity") then
				bInfo = "+" .. tostring(v)
			elseif (k == "Ghost") then
				bInfo = "(" .. tostring(v) .. "/255)"
			elseif (k == "Drugs") then
				bInfo = tostring(v)
			end

			local itm = vgui.Create("DPanel",EffectPanel)
			itm:SetTall(40)
			itm:Dock(TOP)
			itm:DockMargin(10,0,0,10)
			itm.Paint = function(s, w, h)
				draw.RoundedBox(4, 0, 0, w, h, zclib.colors["white_a5"])

				surface.SetDrawColor(color_white)
				surface.SetMaterial(zfs.Benefit.GetIcon(k))
				surface.DrawTexturedRect(h * 0.1, h * 0.1, h * 0.8, h * 0.8)

				draw.SimpleText(bInfo, zclib.GetFont("zclib_world_font_verytiny"), h + 10, h / 2, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end


		local ImgPanel = vgui.Create("DPanel",InfoPanel)
		ImgPanel:SetWide(130)
		ImgPanel:Dock(LEFT)
		ImgPanel:DockMargin(10,10,0,10)
		ImgPanel.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui02"])
			zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, zclib.colors["white_a5"])

			if ToppingData.Icon then
				surface.SetDrawColor(zclib.colors["red01"])
				surface.SetMaterial(ToppingData.Icon)
				surface.DrawTexturedRect(h * 0.1, h * 0.1, h * 0.8, h * 0.8)
			end
		end

		if ToppingData.Model then
			local imgpnl = vgui.Create("DImage", ImgPanel)
			imgpnl:Dock(FILL)
			local img = zclib.Snapshoter.Get({class = "prop_physics",model = ToppingData.Model}, imgpnl)
			imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
		end

		local PricePanel = vgui.Create("DPanel", InfoPanel)
		PricePanel:DockMargin(10,35,0,0)
		PricePanel:Dock(TOP)
		PricePanel.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, h - 2, w, 2, zclib.colors["text01"])
			draw.SimpleText(zfs.language.Shop.Screen_Topping_Price, zclib.GetFont("zclib_world_font_tiny"), 0, 0, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("+" .. zclib.Money.Display(ToppingData.ExtraPrice), zclib.GetFont("zclib_world_font_tiny"), 210, 0, zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end

		local DescPanel = vgui.Create("DLabel",InfoPanel)
		DescPanel:SetWide(150)
		DescPanel:Dock(TOP)
		DescPanel:DockMargin(10,5,0,0)
		DescPanel:SetText(ToppingData.Info)
		DescPanel:SetFont(zclib.GetFont("zclib_world_font_tiny"))
		DescPanel:SetTextColor(zclib.colors["text01"])
		DescPanel:SetWrap(true)
		DescPanel:SetContentAlignment(7)


		local AddGroups
		if table.Count(ToppingData.Ranks_create) > 0 then
			AddGroups = zclib.table.ToString(ToppingData.Ranks_create)
		else
			AddGroups = zfs.language.Shop.Screen_Topping_NoRestricted
		end

		local ConsumRank
		if table.Count(ToppingData.Ranks_consume) > 0 then
			ConsumRank = zclib.table.ToString(ToppingData.Ranks_consume)
		else
			ConsumRank = zfs.language.Shop.Screen_Topping_NoRestricted
		end

		local ConsumJob
		if table.Count(ToppingData.Job_consume) > 0 then
			ConsumJob = zclib.table.ToString(ToppingData.Job_consume)
		else
			ConsumJob = zfs.language.Shop.Screen_Topping_NoRestricted
		end

		local RestrictPanel = vgui.Create("DPanel",main)
		RestrictPanel:SetTall(150)
		RestrictPanel:Dock(FILL)
		RestrictPanel.Paint = function(s, w, h)
			draw.RoundedBox(0, 10, 0, w - 20, 2, zclib.colors["text01"])

			draw.SimpleText(zfs.language.Shop.Screen_Topping_Add_Restricted, zclib.GetFont("zclib_world_font_tiny"),10, 10, zclib.colors["text01"], TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText(AddGroups, zclib.GetFont("zclib_world_font_verytiny"),10, 30, zclib.colors["orange01"], TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

			draw.SimpleText(zfs.language.Shop.Screen_Topping_Consum_Restricted, zclib.GetFont("zclib_world_font_tiny"),10, 60, zclib.colors["text01"], TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText("Ranks: " .. ConsumRank, zclib.GetFont("zclib_world_font_verytiny"), 10, 80, zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("Jobs: " .. ConsumJob, zclib.GetFont("zclib_world_font_verytiny"), 10, 100, zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end)
end

////////////

function zfs.Shop.TakeCup(Shop)
	zfs.Shop.Page(Shop, zfs.language.Shop.OS,TEXT_ALIGN_LEFT, function(main, top)
		local pnl = vgui.Create("DPanel", main)
		pnl:Dock(FILL)
		pnl.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui01"])


			surface.SetDrawColor(color_white)
			surface.SetMaterial(zfs.default_materials["zfs_ui_takeacup"])
			surface.DrawTexturedRect(0,-65,w * 0.95,h * 1.15)

			draw.SimpleText(zfs.language.Shop.Screen_Info01, zclib.GetFont("zclib_world_font_medium"), 15,0, zfs.default_colors["red05"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end)
end

function zfs.Shop.SliceFruits(Shop)
	zfs.Shop.Page(Shop, zfs.language.Shop.OS,TEXT_ALIGN_LEFT, function(main, top)
		local pnl = vgui.Create("DPanel", main)
		pnl:Dock(FILL)
		pnl.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui01"])

			surface.SetDrawColor(color_white)
			surface.SetMaterial(zfs.default_materials["zfs_ui_slicefruit"])
			surface.DrawTexturedRect(w * 0.05,0,w * 0.9,h * 0.95)

			draw.SimpleText(zfs.language.Shop.Screen_Info02, zclib.GetFont("zclib_world_font_medium"), 15,0, zfs.default_colors["red05"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end)
end

function zfs.Shop.ChooseSweetener(Shop)
	zfs.Shop.Page(Shop, zfs.language.Shop.OS,TEXT_ALIGN_LEFT, function(main, top)
		local pnl = vgui.Create("DPanel", main)
		pnl:Dock(FILL)
		pnl.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui01"])

			surface.SetDrawColor(color_white)
			surface.SetMaterial(zfs.default_materials["zfs_ui_chooseswetener"])
			surface.DrawTexturedRect(0,0,w,h)

			draw.SimpleText(zfs.language.Shop.Screen_Info04, zclib.GetFont("zclib_world_font_medium"), 15,0, zfs.default_colors["red05"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end)
end

function zfs.Shop.StartBlender(Shop)
	zfs.Shop.Page(Shop, zfs.language.Shop.OS,TEXT_ALIGN_LEFT, function(main, top)
		local pnl = vgui.Create("DPanel", main)
		pnl:Dock(FILL)
		pnl.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui01"])

			surface.SetDrawColor(color_white)
			surface.SetMaterial(zfs.default_materials["zfs_ui_starttheblender"])
			surface.DrawTexturedRect(0,40,w * 0.9,h)

			draw.SimpleText(zfs.language.Shop.Screen_Info03, zclib.GetFont("zclib_world_font_medium"), 15,0, zfs.default_colors["red05"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
/////////////////////// Storage //////////////////////////////
//////////////////////////////////////////////////////////////
net.Receive("zfs_shop_updatestorage", function(len, ply)
	zclib.Debug_Net("zfs_shop_updatestorage",len)
	local Shop = net.ReadEntity()
	local dataLength = net.ReadUInt(16)
	local d_Decompressed = util.Decompress(net.ReadData(dataLength))
	local list = util.JSONToTable(d_Decompressed)

	if IsValid(Shop) and list and istable( list ) then
		if Shop.StoredFruits == nil then Shop.StoredFruits = {} end
		Shop.StoredFruits = list
	end
end)
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
/////////////////////// Visuals //////////////////////////////
//////////////////////////////////////////////////////////////
// This creates the DynamicLight
function zfs.Shop.Lights(Shop)
	if (Shop.CurrentState ~= 0) then
		local dlight = DynamicLight(LocalPlayer():EntIndex())
		local attach = Shop:GetAttachment(Shop:LookupAttachment("workplace"))
		if (attach and dlight) then
			dlight.pos = attach.Pos + Shop:GetUp() * 30
			dlight.r = 255
			dlight.g = 8
			dlight.b = 60
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 256
			dlight.DieTime = CurTime() + 1
		end
	end
end

// This creates the frezzing effect
function zfs.Shop.FrozzeEffect(Shop)
	if ((Shop.lastFrozze or CurTime()) > CurTime()) then return end
	Shop.lastFrozze = CurTime() + 2

	if IsValid(Shop) and Shop.CurrentState ~= 0 then
		local attach = Shop:GetAttachment(9)

		if (attach) then
			local attachPos = attach.Pos

			if (attachPos) then
				local ang = Shop:GetAngles()
				local pos = attachPos + Shop:GetUp() * 36
				ParticleEffect("zfs_frozen_effect", pos, ang, Shop)
			end
		end
	end
end

zclib.CacheModel("models/zerochain/fruitslicerjob/fs_wheel.mdl")
zclib.CacheModel("models/zerochain/fruitslicerjob/fs_shop_glass.mdl")
zclib.CacheModel("models/zerochain/fruitslicerjob/fs_fruitpile.mdl")

function zfs.Shop.CreateClientModel(Shop,mdl,attachID,lang,scale)
	local ent = zclib.ClientModel.AddProp()
	if not IsValid(ent) then return end
	local attachData = Shop:GetAttachment(attachID)
	local pos,ang = Shop:GetPos(),Shop:GetAngles()

	if attachData then
		 pos = attachData.Pos
		 ang = attachData.Ang
	end

	ent:SetModel(mdl)
	ent:SetAngles(ang)
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	ent:SetRenderMode(RENDERMODE_NORMAL)

	ent:SetParent(Shop, attachID)
	ent:SetLocalPos(ang:Forward() * 0.01)
	ent:SetLocalAngles(lang)

	ent:SetModelScale(scale)

	table.insert(Shop.ClientProps,ent)
	return ent
end

function zfs.Shop.RemoveClientModels(Shop)
	if (Shop.ClientProps and table.Count(Shop.ClientProps) > 0) then
		for k, v in pairs(Shop.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
	Shop.ClientProps = nil
end
