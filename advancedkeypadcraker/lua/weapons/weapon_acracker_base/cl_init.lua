include("shared.lua")


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Create fonts
---------------------------------------------------------------------------------------------------------------------------------------------
*/ 

surface.CreateFont ("HackerFont", {
	size = 24,
    weight = 20,
    font = "default"}) 

	surface.CreateFont ("HackerFont05", {
	size = 34,
    weight = 20,
    font = "default"}) 
	
surface.CreateFont ("HackerFont1", {
	size = 18,
    weight = 0,
    font = "Joystix Monospace"}) 
	
surface.CreateFont ("HackerFont2", {
	size = 24,
    weight = 0,
    font = "Joystix Monospace"}) 
 

surface.CreateFont ("HackerFont3", {
	size = 48,
    weight = 0,
    font = "Joystix Monospace"}) 
	
local fontUsed = "HackerFont2";
local fontUsed2 = "HackerFont3";
	
/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Variables
---------------------------------------------------------------------------------------------------------------------------------------------
*/

local blackcolor = Color(25,25,25);

local wdh = 925;
local hgt = 534;


local startDrawTextX = 210; 
local startDrawTextY = 100; 
local offsetY = 20;
local selectedWord = "";
local selectedLine = 0;
local selectedPos = 0;
SWEP.targetEntity = nil;

local drawposY = 0;
local drawposX = 0;

local hideH = 6;  
local hideDraw = SWEP.hideDraw;
local timeDraw = CurTime() + hideDraw;

local loadTime = 2;

local screenOffset = 1;
SWEP.loadTime = CurTime() + SWEP.loadTimeCFG;


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Mouse Pressed
---------------------------------------------------------------------------------------------------------------------------------------------
*/


hook.Add("VGUIMousePressed","PKMPressed",function(pnl,mouseCode)
	if LocalPlayer != nil and LocalPlayer() != NULL then
		local weap = LocalPlayer():GetActiveWeapon();
		if weap != nil and weap != NULL and weap.IsACracker then
			if mouseCode == MOUSE_RIGHT then
				weap.targetEntity = nil;
				weap:pressM2();
				net.Start("getAKeypadExit") net.SendToServer();
		
			end
			if mouseCode == MOUSE_LEFT and selectedWord != "" and hideH >= 22 then
				net.Start("getAKeypadInput") net.WriteString(selectedWord) net.WriteInt(selectedLine,6) net.WriteInt(selectedPos,4) net.SendToServer();
			end
			
			
		end
	end
end);


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Some default shit
---------------------------------------------------------------------------------------------------------------------------------------------
*/ 
local tableText = {};
tableText[1] = "!@!@!@!@!@!@";
tableText[2] = "!@#$%^&*()/_";
tableText[3] = "!@!@!#!@!@!@";
tableText[4] = "!@#$%^&*()/'";
tableText[5] = "!@!SUKA@!@!@";
tableText[6] = "!@!@!@!@!@!@";
tableText[7] = "!@!@!@!@!@!@";
tableText[8] = "!@!@!@!@!@!@";
tableText[9] = "!@!@!@!@!@!@";
tableText[10] = "!@!@!@!@!@!@";
tableText[11] = "!@!@!@!@!@!@";
tableText[12] = "!@!@!@!@!@!@";
tableText[13] = "!@!@!@!@!@!@";
tableText[14] = "!@!@!@!@!@!@";
tableText[15] = "!@!@!@!@!@!@";
tableText[16] = "!@!@!@!@!@!@";
tableText[17] = "!@!@!@!@!@!@";
tableText[18] = "!@!@!@!@!@!@";
tableText[19] = "!@!@!@!@!@!@";
tableText[20] = "!@!@!@!@!@!@";
tableText[21] = "!@!@!@!@!@!@";
tableText[22] = "!@!@!@!@!@!@";
tableText[23] = "!@!@!@!@!@!@";
tableText[24] = "!@!@!@!@!@!@";
tableText[25] = "!@!@!@!@!@!@";
tableText[26] = "!@!@!@!@!@!@";
tableText[27] = "!@!@!@!@!@!@";
tableText[28] = "!@!@!@!@!@!@";
tableText[29] = "!@!@!@!@!@!@";
tableText[30] = "!@!@!@!@!@!@";
tableText[31] = "!@!@!@!@!@!@";
tableText[32] = "!@!@!@!@!@!@";


local tableRules = {};

tableRules[1] = {};
tableRules[1].rtype = 1;
tableRules[1].start = 4;
tableRules[1].ends = 7;

tableRules[5] = {};
tableRules[5].rtype = 2;
tableRules[5].start = 4;
tableRules[5].ends = 7;


local tableLog = {};

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Receive info from SERVER
---------------------------------------------------------------------------------------------------------------------------------------------
*/
net.Receive("sendAKeypadCrackerInfo",function()
	tableText = net.ReadTable();
	tableRules = net.ReadTable();
	local bbool = net.ReadBool();
	hideDraw = net.ReadFloat();
	if bbool then
		tableLog = {};
	end

	hideH = 6;  
	timeDraw = CurTime() + hideDraw;
end)


net.Receive("sendAKeypadLog",function()
	local tableRec = net.ReadTable();
	for i=1,#tableRec do
		table.insert(tableLog,1,tableRec[i]);
	end
end)



/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Get Hovered Symbol && Line
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:GetHoveredSymbol(line)
	if line == 0 then return 0 end;
	local x;
	local y;
	x,y = gui.MousePos();
	
	surface.SetFont( fontUsed );
	local word = tableText[line];
	local length = surface.GetTextSize(word)/screenOffset;
	local startX = drawposX+160/screenOffset;
	local endX = startX + length;
	
	local offset = 0;
	if line > 16 then
		offset = 290/screenOffset;
	end
	
	if (x < (startX) or x > endX) and line <=16 then return 0 end; 
	if (x < startX + offset or x > endX + offset) and line > 16 then return 0 end;
	local symbol = 0;
	local spos = 0;
	local epos = 0;
	
	for i=1,#word do
		local symbolsize = surface.GetTextSize(word[i])/screenOffset;
		local checkedsymbol = string.sub(word,1,i-1);
		local startsymbol =  startX +offset + surface.GetTextSize(checkedsymbol)/screenOffset;
		local endsymbol = startsymbol + symbolsize;
		if x >= startsymbol and x <= endsymbol then 
			symbol = i;
			rpos = startsymbol;
			epos = endsymbol;
			break;
		end
	end
	return symbol,rpos,epos;
end


function SWEP:GetHoveredLine()
	local x;
	local y;
	x,y = gui.MousePos();
	local line = 0;	
	for i = 1,16 do
		if y > (drawposY+100/screenOffset)+ i*offsetY/screenOffset and y < (drawposY+100/screenOffset)+ i*offsetY/screenOffset + 22 then
			line = i;
			if x > drawposX + 450/screenOffset then
				line = i + 16; 
			end
		end	
	end
	return line;
end


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Loading mem tables
---------------------------------------------------------------------------------------------------------------------------------------------
*/


function SWEP:DrawMemTables()
	if hideH >= 27 then return end;
	surface.SetDrawColor(blackcolor);
	surface.DrawRect( 0,hideH * 20, wdh,hgt - hideH*20);
	
	
	local x = wdh - ((wdh/hideDraw) * (timeDraw - CurTime()));  
	x = math.Clamp(x,0,wdh);
	if x >= wdh then
		timeDraw = CurTime() + hideDraw ;
		hideH = hideH + 1;
		hideH = math.Clamp(hideH,6,27);
	end
	surface.SetDrawColor(blackcolor);
	surface.DrawRect( x, (hideH-1) * 20, wdh-x,20);
	
	
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Loading device
---------------------------------------------------------------------------------------------------------------------------------------------
*/
local blackblood = {};

blackblood[1] = [[ ____  _            _    ____  _                 _ ]];
blackblood[2] = [[|  _ \| |          | |  |  _ \| |               | |]];
blackblood[3] = [[| |_) | | __ _  ___| | _| |_) | | ___   ___   __| |]];
blackblood[4] = [[|  _ <| |/ _` |/ __| |/ /  _ <| |/ _ \ / _ \ / _` |]];
blackblood[5] = [[| |_) | | (_| | (__|   <| |_) | | (_) | (_) | (_| |]];
blackblood[6] = [[|____/|_|\__,_|\___|_|\_\____/|_|\___/ \___/ \__,_|]];



function SWEP:DrawLoading()
	surface.SetDrawColor( blackcolor);
	surface.DrawRect( 0,0, wdh,hgt );
	
	surface.SetDrawColor(blackcolor);
	surface.DrawRect( 0,0 + 100, wdh,hgt-100 );
	
	surface.SetFont( fontUsed );
	surface.SetTextColor( 2, 255, 2);
	surface.SetTextPos( startDrawTextX -60, startDrawTextY - 70 );

	for i,v in pairs(blackblood) do
		surface.SetTextPos( startDrawTextX -140, startDrawTextY - 70 +i*15);
		surface.DrawText(v);
	end
	
	local x = 300 - ((300/self.loadTimeCFG) * (self.loadTime - CurTime()));  
	x = math.Clamp(x,0,300);

	local txt = "";
	local xpos = 300;
	
	
	
	if x >= 300 then
		txt = "Click Izquierdo para hackear";
		xpos = 15;
	else
		local int = math.floor(math.abs(math.sin(CurTime())*4));
		for i=1,int do
			txt = txt..".";
		end	
		txt = "Cargando"..txt;
		surface.SetDrawColor( 2, 222, 2, 255 );
		surface.DrawRect( 300,310, 300,30 );
	
		surface.SetDrawColor(blackcolor );
		surface.DrawRect( 301,311, 298,28 );
		surface.SetDrawColor( 2, 222, 2, 255 );
		surface.DrawRect( 300,310, x,30 );
	end
	surface.SetFont( fontUsed2 );
	surface.SetTextPos( xpos, startDrawTextY + 155);
	surface.DrawText(txt);
	
	surface.SetFont( "HackerFont05" );
	if x >= 300 and self.haveManual then
		surface.SetTextPos(50, startDrawTextY + 200);
		surface.DrawText("Presione la tecla 'R' para ver el manual");
	end
	surface.SetFont( "HackerFont" );
	surface.SetTextPos(10, startDrawTextY + 410);
	surface.DrawText("Kali 2016.1, linux, kernel 4.3");
	
	local sizew = surface.GetTextSize(self.PrintName);
	surface.SetTextPos(925-sizew-10, startDrawTextY + 410);
	surface.DrawText(self.PrintName);
	  
end


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Draw HUD
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:CalculateOffset()
	local vm = self.Owner:GetViewModel()
	if !IsValid(vm) then return end
	local bone = vm:LookupBone("hack");
	if !bone then return end
		
	pos, ang = Vector(0,0,0), Angle(0,0,0);
	local m = vm:GetBoneMatrix(bone);
	if (m) then
		pos, ang = m:GetTranslation(), m:GetAngles();
	else
		return;
	end
	
	pos = pos + ang:Right()*(3.15)+ang:Forward()*-0.3+ ang:Up()*(3.5);
	pos2 = pos + ang:Right()*(3.15-534*0.008)+ang:Forward()*-0.3+ ang:Up()*(3.5);
	
	pos = pos:ToScreen();
	pos2 = pos2:ToScreen();
	
	screenOffset = hgt / (pos.y + pos2.y);
	screenOffset = screenOffset - 0.05;
end

function SWEP:ViewModelDrawn()
	local vm = self.Owner:GetViewModel()
	if !IsValid(vm) then return end
	local bone = vm:LookupBone("hack");
	if !bone then return end
		
	pos, ang = Vector(0,0,0), Angle(0,0,0);
	local m = vm:GetBoneMatrix(bone);
	if (m) then
		pos, ang = m:GetTranslation(), m:GetAngles();
	else
		return;
	end
	
	pos = pos + ang:Right()*3.15+ang:Forward()*-0.3+ ang:Up()*3.5;
	ang:RotateAroundAxis(ang:Forward(),180);
	ang:RotateAroundAxis(ang:Right(), 90);	
	ang:RotateAroundAxis(ang:Up(), 0);	
		
	local scr = (pos):ToScreen();
	drawposX = scr.x;
	drawposY = scr.y;
	cam.Start3D2D(pos, ang, 0.008);
		self:DrawScreen();
	cam.End3D2D() 
	self:CalculateOffset();

end

local lastVoice = CurTime();
function SWEP:DrawScreen()
	self.loadTime = self:GetNWInt("delay",0);
	if CurTime() < self.loadTime and self.targetEntity!= nil and self.targetEntity:GetPos():Distance(LocalPlayer():GetPos()) < 200 and self.targetEntity == LocalPlayer():GetEyeTrace().Entity and self:GetNWInt("attempts",0) > 0 then
		self:DrawLoading();	
		return true;
	end

	if self.targetEntity == nil or self.targetEntity:GetPos():Distance(LocalPlayer():GetPos()) > 200 or self.targetEntity != LocalPlayer():GetEyeTrace().Entity or self:GetNWInt("attempts",0) <= 0 then
		self:DrawLoading();	
		return;	
	end
	-- if not self.targetEntity.IsKeypad then
	-- 	print("4")
	-- 	return
	-- end;

    surface.SetDrawColor( blackcolor );
	surface.DrawRect( 0,0, wdh,hgt );
	
	surface.SetFont( "HackerFont1" );

	surface.SetTextColor( 2, 255, 2);
	
	surface.SetTextPos(startDrawTextX -160, startDrawTextY - 70 );
	surface.DrawText("Bienvenido a telnet del keypad");
	
	surface.SetTextPos( startDrawTextX -160, startDrawTextY - 50 );
	surface.DrawText("Se requiere contraseña");
	
	local attempts = self:GetNWInt("attempts",0);
	local attxt = "Intentos restantes: ";
	surface.SetTextPos( startDrawTextX -160, startDrawTextY - 20 );
	surface.DrawText(attxt);
	attxt = "";
	for i=1,attempts do
		attxt  = attxt .. "* ";
	end
	if attempts <=1 then 
		surface.SetTextColor( 2, 255, 2,math.sin(CurTime()*5)*255);
	end
	surface.SetTextPos( startDrawTextX + 70, startDrawTextY - 20 );
	surface.DrawText(attxt);
	
	
	surface.SetTextColor( 2, 255, 2);
	surface.SetFont( fontUsed );
	for i,v in pairs(tableText) do  
		if i <= 16 then
			surface.SetTextPos( startDrawTextX - 125, startDrawTextY+ i*offsetY );
			surface.SetFont("HackerFont");
			surface.DrawText( "0x"..string.upper(tostring(bit.tohex(45000+i*12,4)))..": ");
			surface.SetTextPos( startDrawTextX - 50, startDrawTextY+ i*offsetY );
			surface.SetFont( fontUsed );
			surface.DrawText(v);
		else
			surface.SetTextPos( startDrawTextX +165, startDrawTextY+ (i-16)*offsetY );
			surface.SetFont("HackerFont");
			surface.DrawText( "0x"..string.upper(tostring(bit.tohex(45000+i*12,4)))..": ");
			surface.SetTextPos( startDrawTextX +240, startDrawTextY+ (i-16)*offsetY );
			surface.SetFont( fontUsed );
			surface.DrawText(v);
		end
	end 
		
	if hideH >= 22 then
	local line = self:GetHoveredLine();
	local symbol,spos,rpos = self:GetHoveredSymbol(line);
	
	
	selectedPos = symbol;
	local dinput = "";
	if symbol != 0 then
		local word = tableText[line];
		local offset = 0; 
		if line > 16 then
			offset = 240;
		end
		local symbolsize = surface.GetTextSize(word[symbol]);
		local checkedsymbol = string.sub(word,1,symbol-1);
		if line <=16 then		
			spos =  startDrawTextX +offset + surface.GetTextSize(checkedsymbol);
			rpos = spos + symbolsize;			
		else
			spos =  startDrawTextX +offset + surface.GetTextSize(checkedsymbol);
			rpos = spos + symbolsize;
		end
		local txt = tableText[line][symbol];
		if tableRules[line] != nil then
			if tableRules[line].rtype == 1 then
				if symbol == tableRules[line].start then
					local offset = 0;
					if line > 16 then offset = 240 end;
					local word = tableText[line];
					local checkedsymbol = string.sub(word,1,tableRules[line].start-1);
					local checkedsymbol2 = string.sub(word,tableRules[line].start,tableRules[line].ends);
					spos =  startDrawTextX + offset + surface.GetTextSize(checkedsymbol);
					rpos = spos + surface.GetTextSize(checkedsymbol2);
					txt = checkedsymbol2;				
				end
			elseif tableRules[line].rtype == 2 then
				if symbol >= tableRules[line].start and symbol <= tableRules[line].ends then
					local offset = 0;
					if line > 16 then offset = 240 end;
					local word = tableText[line];
					local checkedsymbol = string.sub(word,1,tableRules[line].start-1);
					local checkedsymbol2 = string.sub(word,tableRules[line].start,tableRules[line].ends);
					spos =  startDrawTextX + offset + surface.GetTextSize(checkedsymbol);
					rpos = spos + surface.GetTextSize(checkedsymbol2);
					txt = checkedsymbol2;				
				end
			end
			
		end
		
		surface.SetDrawColor(1,255,1);
		surface.SetTextColor(2,2,2);
		if line <=16 then
			surface.DrawRect( spos-51,startDrawTextY+ line*offsetY+4,rpos-spos+4,18);			
			surface.SetTextPos(spos-50, startDrawTextY+ line*offsetY);
			surface.DrawText(txt);
		else
			surface.DrawRect( spos-1,startDrawTextY+ (line-16)*offsetY+4,rpos-spos+4,18);
			surface.SetTextPos(spos, startDrawTextY+ (line-16)*offsetY);
			surface.DrawText(txt);
		end
		dinput = txt;
	end
	
	surface.SetTextColor(2,222,2);
	for i,v in pairs(tableLog) do
		if v != nil then
			if i <= 15 then
				surface.SetTextPos( startDrawTextX + 440, startDrawTextY + 320 - i*offsetY );
				surface.DrawText(">"..v);
			end 
		end
	end  
	
	if (selectedWord != dinput or selectedLine != line) and lastVoice + 0.1 < CurTime() then
		self:EmitSound("buttons/blip1.wav", 30, 200);
		lastVoice = CurTime();
	end
	
	selectedWord = dinput;
	selectedLine = line;
	surface.SetTextPos( startDrawTextX + 440, startDrawTextY + 320);
	surface.DrawText(">"..dinput);
	
	surface.SetTextColor(2,222,2,math.sin(CurTime()*7)*255);
	surface.DrawText("|");
	  
	surface.SetTextColor( 2, 255, 2);
	surface.SetTextPos( startDrawTextX+100, startDrawTextY +400 );
	surface.DrawText("[Click derecho para salir]");
	end
	self:DrawMemTables();
end
 

 

