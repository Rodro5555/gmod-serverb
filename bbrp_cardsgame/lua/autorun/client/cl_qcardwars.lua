-- // QCardWars - By MerekiDor & toobeduge

MsgN("[ QCardWars Client Initialized! ] - By MerekiDor & toobeduge | Traduccion para BlackBloodRP")

qcwAuthList = {}
local idnames = {}
local lua_type = type
local color_black = Color(0,0,0)
local abilClipboard, abilClipboardFrom

local textValidator = function(ch)
    local b = string.byte(ch)
    if (b>=65 and b<=90) or (b==95) or (b>=97 and b<=122) or (b>=48 and b<=57) then
        return ch
    else
        return ""
    end
end

local getLaneColor = function(lane,a)
    if lane then
        return Color(lane.cr,lane.cg,lane.cb,a or 255)
    end
end

local closeTab = function(self,tab) -- GMOD's :CloseTab() is a fucking disaster. I had to rewrite it.
    for k,v in ipairs(self.Items) do
        if v.Tab==tab then
            table.remove(self.Items, k)
            break
        end
    end
    
    for k,v in ipairs(self.tabScroller.Panels) do
        if v.Tab==tab then
            table.remove(self.tabScroller.panels, k)
            break
        end
    end
    
    self.tabScroller:InvalidateLayout(true)
    self.m_pActiveTab = nil
    tab:GetPanel():Remove()
    tab:Remove()
    self:InvalidateLayout(true)
end

local openAbilEditor = function(b)
    local frame = vgui.Create("DFrame")
    frame:SetSize(720,450)
    frame:Center()
    frame:SetTitle(b.info.name..": "..b:GetText())
    frame:MakePopup()
    local old = frame.Think
    function frame:Think()
        if not IsValid(b) then
            self:Remove()
        end
    end
    
    -- // Tutorials {{{
        local cats = frame:Add("DCategoryList")
        cats:Dock(RIGHT)
        cats:SetWide(256)
        cats:DockMargin(4,0,0,0)
        
        -- How does it work {{{
        local c = cats:Add("¿Como funciona?"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            c:DoExpansion(false)
            
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(200)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("    Los especiales son conjuntos de acciones que se ejecutan en el orden en que las pones.\n Ejemplo: 'Establecer HP': establece HP de la unidad en un número determinado.\n\n Las acciones tienen argumentos, donde especificas cosas, como * qué* unidad se ve afectada.\n Ejemplo: la acción 'Establecer ATK' tiene 2 argumentos:\n • ID de la unidad\n • ¿Cuánto ATK?\n\n La mayoría de las acciones tienen algo que ver con las unidades, pero hay acciones como 'Establecer maná', que afecta a los jugadores, o 'Terminar', que aborta más la ejecución de la habilidad actual.")
            desc:SetMultiline(true)
        end -- }}}
        
        -- Card IDs {{{
        c = cats:Add("identificaciones de tarjetas"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            c:DoExpansion(false)
            
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(200)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("    Todas las cartas tienen ID. ID son 2 números:\n • ID de jugador (1 o 2)\n • ID de carril (0 - 3)\n Ejemplo: la primera carta del jugador 1 tiene ID 10, porque 1 es su ID, y 0 es el ID de carril (el primer carril es 0, el segundo es 1, ¡téngalo en cuenta!)\n\n Los carriles van de izquierda a derecha. El carril de la izquierda es id 0, y el carril de la derecha es 3, dos carriles en el medio son 1 y 2.\n\n Si desea conocer la identificación de un edificio, simplemente agregue cualquier dígito después de la identificación de la unidad.\n Ejemplo: el edificio que está en el carril de la unidad 23 es 230. O 231. O 236. No importa .\n\n Si tu carril es 1, entonces el carril del enemigo frente al tuyo es 2, porque el orden es diferente desde su perspectiva.")
            desc:SetMultiline(true)
        end -- }}}
        
        -- Variables {{{
        c = cats:Add("Variables"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            c:DoExpansion(false)
            
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(200)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("   ¿Cómo sabes cuál es el ID de tu tarjeta? Es decir, no puedes simplemente adivinarlo, ¿verdad?\n\n Las variables son palabras mágicas que se reemplazan con números.\n • !SELF - ID de la tarjeta actual. Si la tarjeta actual tiene ID 23, entonces !SELF también es 23.\n • !AID - su ID de jugador. Puede ser 1 o 2. Es el primer número de ID de tarjeta.\n • !LID - ID de carril, número entre 0 y 3. Si el ID de la tarjeta es 12, entonces !LID es 2.\n • !SELF es lo mismo que !AID!LID, solo que más corto y más fácil de leer.\n\n Hay más variables, como !ENEMY, !TURN, !RAND... los usarás mucho. La lista completa está al final.")
            desc:SetMultiline(true)
        end -- }}}
        
        -- Values {{{
        c = cats:Add("Valores"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            c:DoExpansion(false)
            
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(200)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("    Cada tarjeta tiene valores dentro de ellas. Por ejemplo, el ATK de la tarjeta o HP.\n • !SELF::hp - HP de la tarjeta\n • !ENEMY::atk - ATK del enemigo\n\n Básicamente, escribes la ID de la tarjeta , luego ::, luego el nombre del valor, como ATK o HP, y lo tienes. Son como variables. Los edificios también las tienen, solo digo. ¡No pongas espacios!\n\n Si quieres aumentar ATK de la unidad por 2, usas:\n • Establecer ATK; id; id::atk+2\n\n Todos los valores se enumeran en la parte inferior, después de las variables.")
            desc:SetMultiline(true)
        end -- }}}
        
        -- Maths {{{
        c = cats:Add("Matemáticas"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            c:DoExpansion(false)
            
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(200)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("    Puede usar las siguientes operaciones matemáticas en cualquier número, valor o variable:\n • '+' - Sumar\n • '-' - Restar\n • '*' - Multiplicar\n • '^' - Exponente (potencia )\n • '%' - Modulo\n\n NOTA: No existe el operador '/' (división). Si desea dividir por 2, multiplique por 0,5.")
            desc:SetMultiline(true)
        end -- }}}
        
        -- Conditions {{{
        c = cats:Add("Condiciones"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            c:DoExpansion(false)
            
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(200)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("    Las condiciones son difíciles de explicar. Son como preguntas en las que respondes sí o no. Y dependiendo de la respuesta, el resultado que dan es diferente.\n Si eres programador, estas cosas se llaman operadores ternarios. Si no lo son, vea ejemplos e intente entender cómo funciona.\n\n Se escriben así:\n [ condición ? sí : no ]\n\n • condición - por ejemplo, 2>3, o ! SELF::atk > !SELF::hp. Puede ser verdadero o falso.\n • sí - número o texto a usar SI la condición anterior es verdadera\n • no - si la condición es falsa.\n\n Ejemplo: [2 >3?4:-3]. Aquí, la condición es 2>3. Si esta afirmación es verdadera, tienes 4. Si no, tienes -3. Obviamente, 2>3 es una mierda, así que eso es falso, de ahí el resultado es -3.\n\n Las condiciones usan operadores lógicos, como 'igual', 'menor que', etc.\n • < - menor\n • <= - menor o igual\n • > - mayor\n • >= mayor o igual\n • == - igual (¡dos signos!)\n • ~= - no igual\n\n Puede poner condiciones dentro de condiciones. Y puede usar variables o valores allí también.")
            desc:SetMultiline(true)
        end -- }}}
        
        -- List {{{
        c = cats:Add("Lista de Variables"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(300)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("    Puedes usarlos en argumentos de habilidades. Serán reemplazados por los números que representan.\n\n• !SELF: identificación completa de la unidad actual.\n• !ENEMY: identificación de la unidad enemiga directamente frente a ti.\n \n• !AID: ID del jugador actual.\n• !EID: ID del jugador enemigo.\n• !LID: ID del carril actual (0-3).\n• !OLID: ID del carril enemigo frente a este (0-3).\n• !SID - ID del carril seleccionado (solo para algunas habilidades).\n\n• !AHP - Tu (jugador) HP.\n• !EHP - HP del jugador enemigo.\n• !MANA: tu maná.\n• !TURN: turno actual.\n\n• !RAND: número aleatorio entre 0 y 1.\n• !RN1, !RN2, !RN3, !RN4: números aleatorios ( 0-1) que están garantizados para ser iguales para la habilidad actual.")
            desc:SetMultiline(true)
        end -- }}}
        
        -- List {{{
        c = cats:Add("Lista de valores"); local p = vgui.Create("DPanel"); c:SetContents(p) do
            local desc = p:Add("DTextEntry")
            desc:Dock(TOP)
            desc:SetTall(300)
            desc:SetEnabled(false)
            desc:SetPaintBackground(false)
            desc:SetVerticalScrollbarEnabled(true)
            desc:SetText("    Esta es una lista de valores almacenados dentro de unidades, algunos de ellos también están en edificios.\n\n• hp - HP actual\n• hpm - Max HP\n• atk\n• name\n• class - Nombre de la clase\n• costo - costo de MP\n• tipo - tipo de tarjeta (edificio, unidad, poder)\n• mdl - Ruta al modelo\n• mdlAlt - Alt. Modelo\n• material\n• mdlScale - Escala de model\n• mdlYaw - Rotación\n• elev - Elevación\n• sdesc - Descripción de habilidad especial\n• scost - Costo de habilidad especial\n• spick - Modo de selección de habilidad (0, 1 o 2)\n• carril \n• cr,cg,cb,ca: rojo, verde, azul, opacidad\n• eMissMul: multiplicador de probabilidad de fallo del enemigo (cuanto más grande, mejor para ti)\n• eCritMul: multiplicador de críticos del enemigo (cuanto más grande, peor)\n• sMissMul - Tu propio multiplicador de probabilidad de fallo (menos es mejor)\n• sCritMul - Tu multiplicador de probabilidad de golpe crítico (cuanto más grande mejor)\n• float - Animación de vuelo (verdadero/falso)\n• spinning - Rotaciones por segundo\n• uid - Identificación única de esta tarjeta (siempre diferente para cada tarjeta individual, nunca verá dos UID iguales)")
            desc:SetMultiline(true)
        end -- }}}
    -- // }}}
    
    local p1 = frame:Add("DPanel")
    p1:Dock(FILL)
    p1:DockPadding(8,40,8,40)
    
    local seq = p1:Add("DScrollPanel")
    seq:Dock(FILL)
    seq.actions = {}
    function seq:PaintOver(w,h)
        surface.SetDrawColor(0,0,0,75)
        surface.DrawOutlinedRect(0,0,w,h,2)
    end
    
    local function addAction(a,data)
        local specData = qcwSpecials[a]
        if specData then
            seq.edited = true
            local ttip = specData.desc and tostring(a).."\n"..specData.desc or tostring(a)
            
            local panel = seq:Add("DPanel")
            panel:SetSize(seq:GetWide()-8,32)
            panel:SetPos(4,4+(32+2)*#seq.actions)
            panel:SetBackgroundColor(Color(a=="Terminate" and 255 or 128,128,128))
            panel:DockPadding(8,2,8,2)
            panel:SetTooltip(ttip)
            
            local remove = panel:Add("DImageButton")
            remove:SetPos(0,0)
            remove:SetSize(16,16)
            remove:SetImage("icon16/cancel.png")
            function remove:DoClick()
                local myKey
                for id,a in ipairs(seq.actions) do
                    if a[1]==panel then
                        print("mi id es",id)
                        myKey = id
                        break
                    end
                end
                
                if myKey then
                    surface.PlaySound("garrysmod/ui_click.wav")
                    panel:Remove()
                    table.remove(seq.actions,myKey)
                    
                    for id,a in ipairs(seq.actions) do
                        if a[1] then
                            a[1]:MoveTo(4,4+(32+2)*(id-1),0.25,0,0.1*id)
                        end
                    end
                    seq.edited = true
                end
            end
            
            local upDownClick = function(b)
                local myKey
                for id,a in ipairs(seq.actions) do
                    if a[1]==panel then
                        print("mi id es",id)
                        myKey = id
                        break
                    end
                end
                
                if myKey then
                    local old = myKey
                    myKey = math.Clamp(myKey+b.p,1,#seq.actions)
                    print("yendo desde",old,myKey)
                    
                    if myKey~=old then
                        local ref = seq.actions[myKey]
                        seq.actions[myKey] = seq.actions[old]
                        seq.actions[old]   = ref
                        
                        for id,a in ipairs(seq.actions) do
                            if a[1] then
                                a[1]:MoveTo(4,4+(32+2)*(id-1),0.25,0,0.1*id)
                            end
                        end
                        surface.PlaySound("garrysmod/ui_hover.wav")
                        seq.edited = true
                    end
                else
                    -- Invalid for some reason
                    panel:Remove()
                end
            end
            
            local up = panel:Add("DImageButton")
            up:SetPos(16+2,0)
            up:SetSize(16,16)
            up:SetImage("icon16/arrow_up.png")
            up.DoClick =  upDownClick
            up.p = -1
            local down = panel:Add("DImageButton")
            down:SetPos(32+4,0)
            down:SetSize(16,16)
            down:SetImage("icon16/arrow_down.png")
            down.DoClick =  upDownClick
            down.p = 1
            
            local actionData = istable(data) and table.Copy(data) or {a}
            panel.actionData = actionData
            
            local label = panel:Add("DLabel")
            label:Dock(LEFT)
            label:SetWidth(80)
            label:SetColor(color_white)
            label:SetFont("Trebuchet18")
            label:SetText(a)
            label:SetContentAlignment(1)
            
            local ovc = function(self,to)
                seq.edited = true
                panel.actionData[self.argn] = to
            end
            
            for i=1,#specData.argDescs do
                local entry = panel:Add("DTextEntry")
                entry:SetPlaceholderText(specData.argDescs[i])
                entry:Dock(LEFT)
                entry:DockMargin(2,2,2,2)
                entry:SetWide( (panel:GetWide()-16-label:GetWide())/#specData.argDescs-3 )
                entry:SetText(actionData[i+1] or "")
                entry:SetTooltip(ttip)
                entry:SetUpdateOnType(true)
                entry.OnValueChange = ovc
                entry.argn = i+1
            end
            
            table.insert(seq.actions,{panel,actionData})
        end
    end
    
    local picker = p1:Add("DComboBox")
    picker:SetPos(8,8)
    picker:SetSize(200,24)
    for id,info in SortedPairs(qcwSpecials) do
        if id:sub(1,2)~="C_" then
            picker:AddChoice(id,info)
        end
    end
    
    picker:SetValue("Añadir acción...")
    function picker:OnSelect(id,val,data)
        addAction(val)
        surface.PlaySound("garrysmod/ui_click.wav")
        picker:SetValue("Añadir acción...")
    end
    
    local abilSeq = istable(b.info[b.type]) and table.Copy(b.info[b.type]) or {}
    
    local save = p1:Add("DButton")
    save:SetPos(8,384)
    save:SetText("Save")
    save:SetEnabled(false)
    function save:Think()
        self:SetEnabled(seq.edited)
    end
    function save:DoClick()
        table.Empty(abilSeq)
        
        for i,t in ipairs(seq.actions) do
            abilSeq[i] = t[2]
            print(t[2])
        end
        
        b.item.edited  = true
        b.info[b.type] = abilSeq
        notification.AddLegacy("Cambios en la habilidad aplicados, pero no guardados.",3,4)
    end
    
    local copy = p1:Add("DButton")
    copy:SetPos(8+save:GetWide()+4,384)
    copy:SetText("Copiar")
    function copy:DoClick()
        abilClipboard     = table.Copy(abilSeq)
        abilClipboardFrom = b.info and b.info.name.." ("..b.info.class..")" or "en algún lugar"
    end
    
    local paste = p1:Add("DButton")
    paste:SetPos(8+save:GetWide()*2+8,384)
    paste:SetText("Pegar")
    paste:SetWide(200)
    function paste:Think()
        self:SetEnabled(abilClipboard and abilClipboardFrom)
        self:SetText(abilClipboardFrom and "Pegado desde "..abilClipboardFrom or "Pegado")
    end
    function paste:DoClick()
        abilSeq = table.Copy(abilClipboard)
        
        for id,n in ipairs(seq.actions) do
            if IsValid( n[1] ) then
                n[1]:Remove()
            end
            seq.actions[id] = nil
        end
        
        for id,info in ipairs(abilSeq) do
            addAction(info[1],info)
        end
    end
    
    timer.Simple(0.01,function()
        if IsValid(seq) then
            local pre = seq.edited
            for id,info in ipairs(abilSeq) do
                addAction(info[1],info)
            end
            seq.edited = pre
        end
    end)
end

local pickDescs = {
    [0] = "Simplemente se le pide confirmación, sin tener que elegir ninguna unidad.",
    [1] = "Tienes que seleccionar uno de tus propios carriles.",
    [2] = "Tienes que seleccionar uno de los carriles enemigos opuestos."
}

local mulDescs = {
    {
        base = "[Nivel 1] Tarjetas de inicio. Cuestan 1 MP. ",
        unit = "Cada tipo de carril debe tener estos, de lo contrario, el jugador comienza con un mazo vacío. También se pueden usar para cubrir carriles expuestos.",
        building = "Los edificios se presentarán un poco más tarde, por lo que puede que no sea una buena idea crear un edificio de nivel 1. Pero tú sí, supongo.",
        power = "Poderes muy débiles que apenas pueden hacer una mierda."
    },
    {
        base = "[El nivel 2] ",
        unit = "Cartas débiles. Cuestan 2-4 MP. Poseen habilidades bastante débiles, pero son bastante numerosos y pueden mantener una pelea decente, especialmente al principio.",
        building = "Edificios que brindan pequeños beneficios por 2-4 MP. Solo un pequeño empujón para ti.",
        power = "Poderes básicos, nada interesante. Son baratos, solo a 2-4 MP."
    },
    {
        base = "[Nivel 3] ",
        unit = "Cartas de luchador. Cuestan 5-7 MP. ¡Son numerosos y constituyen la mayor parte de tu fuerza de ataque, siendo los tipos de cartas más comunes con los que peleas una vez que la ronda se calienta!",
        building = "Estos edificios proporcionan efectos bastante poderosos y benefician a las unidades en el carril. Cuesta 5-7 PM.",
        power = "Poderes que tienen un buen impacto en el curso de la batalla. Cuesta 5-7 PM."
    },
    {
        base = "[Nivel 4] ",
        unit = "Cartas de héroe. Cuestan 8-14 MP. Poseen fuertes habilidades, estadísticas y pueden patear traseros bastante bien, pero solo unos pocos generan por mazo. Úsalos con cuidado.",
        building = "Edificios extremadamente fuertes que cuestan entre 8 y 14 MP y brindan grandes beneficios al carril en el que se colocan. Objetivo prioritario para los enemigos.",
        power = "Habilidades de cambio de marea o realmente poderosas que cuestan 8-14 MP y posiblemente pueden cambiar la batalla a tu favor, ¡incluso si estás perdiendo!"
    },
    {
        base = "[Nivel 5] Cartas legendarias. 15 MP+. ",
        unit = "Son mortales y capaces de destrucción masiva, sin embargo, solo se genera 1 carta de este tipo en un mazo. ¡Raro y poderoso!",
        building = "Un edificio realmente malditamente poderoso. Algo que haría que la unidad fuera indestructible. Solo uno de estos se genera en tu mazo, ¡así que ten cuidado con la ubicación!",
        power = "Estos poderes son capaces de destrozar totalmente a tu oponente. Solo uno de estos genera en tu mazo."
    }
}
local function getMul(mana) -- power tiers of cards (ctrl+c ctrl+v from ent_qcardwars.lua)
    if not mana then return 2 end
    if mana <= 1 then
        return 1
    elseif mana <= 4 then
        return 2
    elseif mana <= 7 then
        return 3
    elseif mana<=14 then
        return 4
    else
        return 5
    end
end

-- // Menu {{{

    local qcwRainbow  = Color(0,0,0)
    local qcwBuilding = Color(0,0,0)
    local qcwPower    = Color(0,0,0)

    local shown = false
    
    function qcwOpenMenu()
        if IsValid(qcwMenu) then
            qcwMenu:Remove()
        end
        
        if not shown then
            shown = true
            
            local frame = vgui.Create("DFrame")
            frame:SetSize(600,400)
            frame:Center()
            frame:MakePopup()
            frame:SetTitle("Attention!")
            frame:DoModal()
            frame:SetBackgroundBlur(true)
            frame:ShowCloseButton(true)
            
            local text = frame:Add("DTextEntry")
            text:Dock(FILL)
            text:SetMultiline(true)
            text:SetPaintBackground(false)
            text:SetTextColor(color_white)
            text:SetVerticalScrollbarEnabled(true)
            text:SetText("Esta es una traducción hecha para BlackBloodRP, considere unirse al discord del servidor: https://discord.gg/3HbAtxvtjF \n\nConsidere también unirse al discord del autor, donde publica vistas previas de 2.0: https://discord.gg/YxEC5tZPmd\n vk.com/octantiscommunity\n\n - MerekiDor")
            function text:AllowInput() return true end
        end
        
        local frame = vgui.Create("DFrame")
        frame:SetSize(650,500)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("QCardWars Menu   //   By MerekiDor & toobeduge | Traduccion para BlackBloodRP")
        qcwMenu = frame
        
        local old = frame.Think
        frame.Think = function(self)
            old(self)
            
            local ct = CurTime()
            qcwRainbow  = HSVToColor( (ct*200)%360, 0.6, 1 )
            qcwBuilding = HSVToColor( 120,0.75-ct%0.5,0.5 )
            qcwPower = HSVToColor( 15+(math.sin(ct*10)+1)*15, 1, 1 )
        end
        
        local sheets = frame:Add("DPropertySheet")
        sheets:Dock(FILL)
        
        function sheets:OnActiveTabChanged(old,new)
            if old~=new then
                local t = new:GetText()
                local cond1 = t=="Admin"
                      t = old:GetText()
                local cond2 = t=="Admin"
            end
        end
        
        -- Admin {{{
        if LocalPlayer():IsSuperAdmin() then
            local cats = sheets:Add("DCategoryList")
            sheets:AddSheet("Admin", cats, "icon16/shield.png",false,false,"¡Administre ajustes preestablecidos y datos!")
            
            local c1 = cats:Add("Presets") do
                local p = vgui.Create("DPanel")
                p:DockPadding(8,8,8,8)
                c1:SetContents(p)
                
                local presets = vgui.Create("DListView",p)
                presets:Dock(TOP)
                presets:SetTall(128)
                presets:InvalidateParent(true)
                
                presets:AddColumn("Preset")
                presets:SetMultiSelect(false)
                for id,preset in ipairs(file.Find("qcardwars/*.dat","DATA")) do
                    local n = preset:gsub("%.dat","")
                    local l = presets:AddLine(n)
                    l.n     = n
                end
                
                function presets:netRefresh()
                    local _,linen = self:GetSelectedLine()
                    linen = linen and linen.n
                    
                    self:Clear()
                    for id,preset in ipairs(file.Find("qcardwars/*.dat","DATA")) do
                        local n = preset:gsub("%.dat","")
                        local l = self:AddLine(n)
                        l.n     = n
                        if n==linen then
                            self:SelectItem(l)
                        end
                    end
                end
                qcwNetRefreshables[presets] = -1
                
                local entry = vgui.Create("DTextEntry",p)
                entry:SetPos(presets:GetX()+100,presets:GetY()+presets:GetTall()+4)
                entry:SetSize(254,24)
                entry:SetPlaceholderText("Preset name")
                local save = vgui.Create("DButton",p)
                save:SetPos(entry:GetX()-100,entry:GetY())
                save:SetSize(96,24)
                save:SetText("Save")
                save:SetTooltip("Saves current game data as a preset.")
                function save:DoClick()
                    local txt = entry:GetText()
                    local cor = txt:gsub(".",textValidator)
                    
                    if txt~=cor then
                        notification.AddLegacy("[QCW] ¡Se detectaron caracteres no válidos en el nombre del archivo!\nSe eliminaron. Utilice números y letras latinas únicamente.",1,4)
                        entry:SetText(cor)
                    else
                        net.Start("qcw_communicate")
                            net.WriteUInt(3,3)
                            net.WriteString(cor)
                        net.SendToServer()
                        entry:SetText("")
                    end
                end
                
                local btnThink = function(self)
                    local _,line = presets:GetSelectedLine()
                    self:SetEnabled(line)
                    if not line and self:GetText()=="Confirm" then
                        self:SetText("Delete preset")
                    end
                end
                
                local btnLoadFunc = function(self)
                    local _,line = presets:GetSelectedLine()
                    if line then
                        net.Start("qcw_communicate")
                            net.WriteUInt(2,3)
                            net.WriteString(line.n)
                            net.WriteUInt(self._mode,2)
                        net.SendToServer()
                    end
                end
                
                local load1 = vgui.Create("DButton",p)
                load1:SetPos(save:GetX(),save:GetY()+save:GetTall()+4)
                load1:SetSize(356/3-2,24)
                load1:SetText("Load preset")
                load1:SetTooltip("Los datos de la tarjeta/carril con los que estás jugando se perderán.\nPreset anulará por completo los datos actuales.")
                load1._mode = 0
                load1.DoClick = btnLoadFunc
                load1.Think   = btnThink
                local load2 = vgui.Create("DButton",p)
                load2:SetPos(save:GetX()+356/3+0.5,save:GetY()+save:GetTall()+4)
                load2:SetSize(356/3-2,24)
                load2:SetText("Add cards from preset")
                load2:SetTooltip("Los datos de este ajuste preestablecido se cargarán encima de los existentes.\nSi se encuentran dos tarjetas coincidentes, se prefieren los nuevos datos.")
                load2._mode = 1
                load2.DoClick = btnLoadFunc
                load2.Think   = btnThink
                local load3 = vgui.Create("DButton",p)
                load3:SetPos(save:GetX()+356/3*2+1,save:GetY()+save:GetTall()+4)
                load3:SetSize(356/3-2,24)
                load3:SetText("Add without overriding")
                load3:SetTooltip("Los datos de este ajuste preestablecido se cargarán sin anular los existentes.\nSi se encuentran dos tarjetas coincidentes, los datos nuevos no se cargan y se mantienen los datos antiguos.")
                load3._mode = 2
                load3.DoClick = btnLoadFunc
                load3.Think   = btnThink
                local del = vgui.Create("DButton",p)
                del:SetPos(load1:GetX(),load1:GetY()+load1:GetTall()+4)
                del:SetSize(354,24)
                del:SetText("Eliminar preestablecido")
                function del:DoClick()
                    local _,line = presets:GetSelectedLine()
                    if line then
                        if self:GetText()=="Confirmar" then
                            net.Start("qcw_communicate")
                                net.WriteUInt(4,3)
                                net.WriteString(line.n)
                            net.SendToServer()
                            self:SetText("Eliminar preestablecido")
                        else
                            self:SetText("Confirmar")
                        end
                    end
                end
                del.Think   = btnThink
                local label = vgui.Create("DLabel",p)
                label:SetPos(del:GetX(),del:GetY()+del:GetTall()+4)
                label:SetText("Tenga en cuenta que solo los datos que están actualmente en el servidor se guardan\nen un ajuste preestablecido. Los cambios no guardados no se escriben en los archivos.\n\nLas tarjetas y carriles predeterminados y sin editar NO se guardan en el valor predeterminado.\nSi guarda un valor predeterminado que tiene tarjetas personalizadas y predeterminadas combinadas,\n¡solo se guardarán las personalizadas! Entonces, cuando cargues ese ajuste preestablecido, ninguna de las\ntarjetas predeterminadas estará allí. Debido a esto, asegúrese de presionar\n'Agregar tarjetas desde preestablecido', y no 'Cargar preestablecido'.")
                label:SetSize(350,108)
                label:SetTextColor(color_black)
            end
            
            local c2 = cats:Add("Quick actions") do
                local p = vgui.Create("DPanel")
                p:DockPadding(8,8,8,8)
                c2:SetContents(p)
                
                local entry = p:Add("DTextEntry")
                entry:Dock(TOP)
                entry:SetPlaceholderText("Filter")
                entry:SetTall(24)
                entry:InvalidateParent()
                
                local label = vgui.Create("DLabel",p)
                label:Dock(TOP)
                label:SetTall(32)
                label:SetText("Las acciones a continuación solo se aplicarán a las tarjetas que se ajusten a la consulta de filtro.\nE.g. 'combine_' solo afectará a las cartas que contengan 'combine_' en su nombre.\nTambién puedes usar patrones lua. Si sabe cuáles son, ¡eso es!\nSi el filtro está en blanco, las acciones se aplican a todas las tarjetas.")
                label:SetSize(350,64)
                label:SetTextColor(color_black)
                
                local btnQuickAct = function(self)
                    if self:GetText()=="Confirmar" then
                        net.Start("qcw_communicate")
                            net.WriteUInt(6,3)
                            net.WriteString(self.mode)
                            net.WriteString(utf8.sub(entry:GetText(),1,32))
                        net.SendToServer()
                        self:SetText(self._t)
                    else
                        self._t = self:GetText()
                        self:SetText("Confirmar")
                    end
                end
                
                local b = p:Add("DButton")
                b:Dock(TOP)
                b:SetText("Activar todas las tarjetas")
                b:DockMargin(0,0,0,4)
                b.DoClick = btnQuickAct
                b.mode = "c1"
                
                b = p:Add("DButton")
                b:Dock(TOP)
                b:SetText("Desactivar todas las tarjetas")
                b:DockMargin(0,0,0,12)
                b.DoClick = btnQuickAct
                b.mode = "c0"
                
                b = p:Add("DButton")
                b:Dock(TOP)
                b:SetText("Eliminar todas las unidades")
                b:DockMargin(0,0,0,4)
                b.DoClick = btnQuickAct
                b.mode = "runit"
                
                b = p:Add("DButton")
                b:Dock(TOP)
                b:SetText("Eliminar todos los edificios")
                b:DockMargin(0,0,0,4)
                b.DoClick = btnQuickAct
                b.mode = "rbuilding"
                
                b = p:Add("DButton")
                b:Dock(TOP)
                b:SetText("Eliminar todos los poderes")
                b:DockMargin(0,0,0,4)
                b.DoClick = btnQuickAct
                b.mode = "rpower"
                
                b = p:Add("DButton")
                b:Dock(TOP)
                b:SetText("Eliminar todos los carriles")
                b:DockMargin(0,0,0,4)
                b.DoClick = btnQuickAct
                b.mode = "l"
            end
            
            local c3 = cats:Add("Permissions") do
                local p = vgui.Create("DPanel")
                p:DockPadding(8,8,8,8)
                c3:SetContents(p)
                
                local players
                
                local auth = vgui.Create("DListView",p)
                auth:SetPos(8,8)
                auth:SetSize(356/2-4,128-8)
                auth:InvalidateParent(true)
                auth:AddColumn("Name")
                auth:AddColumn("Steam ID")
                auth:SetMultiSelect(false)
                function auth:netRefresh()
                    auth:Clear()
                    for sid in pairs(qcwAuthList) do
                        if not idnames[sid] then
                            idnames[sid] = "Loading..."
                            local l = auth:AddLine(idnames[sid],sid)
                            l.sid = sid
                            steamworks.RequestPlayerInfo(util.SteamIDTo64(sid), function(n)
                                idnames[sid] = n
                                if IsValid(l) then
                                    l:SetColumnText(1,n)
                                end
                            end)
                        else
                            local l = auth:AddLine(idnames[sid],sid)
                            l.sid = sid
                        end
                    end
                end
                auth:netRefresh()
                function auth:DoDoubleClick(lid, line)
                    local _,l = players:GetSelectedLine()
                    if l then
                        l:SetSelected(false)
                    end
                    
                    if line.sid then
                        net.Start("qcw_communicate")
                            net.WriteUInt(5,3)
                            net.WriteString(line.sid)
                            net.WriteBool(false)
                        net.SendToServer()
                    end
                end
                qcwNetRefreshables[auth] = 1
                
                players = vgui.Create("DListView",p)
                players:SetPos(8+356/2+2,8)
                players:SetSize(356/2-4,128-8)
                players:InvalidateParent(true)
                players:AddColumn("Name")
                players:AddColumn("Friend")
                players:SetMultiSelect(false)
                players.t = {}
                function players:Think()
                    local needRebuild = false
                    if not needRebuild then
                        for pl in pairs(self.t) do if not IsValid(pl) then self.t[pl] = 0 end end
                        for id,pl in ipairs(player.GetHumans()) do
                            local nick = pl:Nick()
                            if self.t[pl]~=nick then
                                needRebuild = true
                            end
                            self.t[pl] = nick
                        end
                        for pl,v in pairs(self.t) do 
                            if v==0 then
                                self.t[pl] = nil
                                needRebuild = true
                            end
                        end
                    end
                    
                    if needRebuild then
                        self:Clear()
                        for pl in pairs(self.t) do
                            self:AddLine(pl:Nick(),pl==LocalPlayer() and "Maybe?" or (pl:GetFriendStatus() and "Yes" or "No")).pl = pl
                        end
                    end
                end
                function players:DoDoubleClick(lid, line)
                    local _,l = auth:GetSelectedLine()
                    if l then
                        l:SetSelected(false)
                    end
                    
                    if line.pl then
                        net.Start("qcw_communicate")
                            net.WriteUInt(5,3)
                            net.WriteString(line.pl:SteamID())
                            net.WriteBool(true)
                        net.SendToServer()
                    end
                end
                
                local label = vgui.Create("DLabel",p)
                label:SetPos(auth:GetX(),auth:GetY()+auth:GetTall()+4)
                label:SetText("Los jugadores de la lista de la izquierda pueden editar y eliminar unidades en este servidor.\nHaz doble clic en cualquier jugador en línea para autorizarlo.\nHaz doble clic en un jugador autorizado para eliminar sus privilegios.")
                label:SetSize(350,48)
                label:SetTextColor(color_black)
            end
        end    
        -- }}}
        
        -- Editables {{{
            
            local panels = {}
            local lists  = {}
            
            -- Units {{{
            do
                local p = sheets:Add("DPanel"); p.qcwType = "unidad"
                sheets:AddSheet("Units", p, "icon16/monkey.png",false,false,"Crea y edita unidades para luchar."..(math.random()<0.034 and "\nEllos tienen familias. Tú, monstruo." or ""))
                table.insert(panels,p)
            end
            -- }}}
            
            -- Buildings {{{
            do
                local p = sheets:Add("DPanel"); p.qcwType = "Building"
                sheets:AddSheet("Buildings", p, "icon16/bricks.png",false,false,"Crea y edita edificios que brinden beneficios a las unidades.")
                table.insert(panels,p)
            end
            -- }}}
            
            -- Powers {{{
            do
                local p = sheets:Add("DPanel"); p.qcwType = "Power"
                sheets:AddSheet(math.random()<0.005 and "Powerz" or "Powers", p, "icon16/lightning.png",false,false,"Crea y edita poderes con efecto inmediato.")
                table.insert(panels,p)
            end
            -- }}}
            
            -- Lanes {{{
            do
                local p = sheets:Add("DPanel"); p.qcwType = "Lane"
                sheets:AddSheet("Lanes", p, "icon16/map.png",false,false,"Crea y edita carriles en los que puedes poner unidades.")
                table.insert(panels,p)
            end
            -- }}}
            
            -- Locals {{{
                local c1, c2 = Color(255,255,255,150), Color(255,200,200,50)
                local linePaintOver = function(self,w,h)
                    local card  = self.qcwInfo
                    if card.active or self.qcwType=="lane" then
                        local color = color_black
                        if self.qcwType == "card" then
                            if card.type=="unidad" then
                                if card.lane=="todos" then
                                    color = qcwRainbow
                                else
                                    local lane = qcwLaneTypes[card.lane]
                                    if lane then
                                        color = getLaneColor(lane) or color_black
                                    end
                                end
                            else
                                color = card.type and (card.type=="estructura" and qcwBuilding or qcwPower) or color_black
                            end
                        else
                            color = getLaneColor(card)
                        end
                        
                        if card.nodeck then
                            surface.SetDrawColor(c2)
                            surface.DrawRect(0,0,w,h)
                        end
                        
                        draw.SimpleTextOutlined("•","ScoreboardDefault",self:GetChildren()[1]:GetWide()-h/2,h/2-2,color,1,1,1,color_black)
                    else
                        surface.SetDrawColor(c1)
                        surface.DrawRect(0,0,w,h)
                    end
                end
                
                local listNetRefresh = function(self)
                    local _,line = self:GetSelectedLine()
                    local info   = line and line.qcwInfo
                    local lclass = info and info.class
                    local ltype  = info and info.type
                    
                    self:Clear()
                    
                    if self.qcwType=="lane" then
                        for class,info in pairs(qcwLaneTypes) do
                            if class~="null" then
                                local l = self:AddLine(tostring(info.name),class)
                                l.PaintOver  = linePaintOver
                                l.qcwInfo = info
                                l.qcwType = "lane"
                                
                                if ltype=="lane" and lclass==class then
                                    self:SelectItem(l)
                                end
                            end
                        end
                    else
                        for class,info in pairs(qcwCards) do
                            if (not info.hidden) and info.type==self.qcwType then
                                local l = self:AddLine(tostring(info.name),class)
                                l.PaintOver  = linePaintOver
                                l.qcwInfo = info
                                l.qcwType = "card"
                                
                                if ltype~="lane" and lclass==class then
                                    self:SelectItem(l)
                                end
                            end
                        end
                    end
                    
                    self:SortByColumn(2)
                end
            -- }}}
            
            -- All panels {{{
            do
            
                -- Carrier networking {{{
                    
                    local cedit = Color(200,50,40)
                    local onEdit = function(self,carrier)
                        if self._tempNoEdit then
                            return
                        end
                        
                        local f = self.SetTextColor or self.SetColor
                        if self.edited then
                            if f then
                                f(self,cedit)
                            else
                                self:SetText("* "..self:GetText():gsub("^%* ",""))
                            end
                        elseif f then
                            f(self,color_black)
                        else
                            self:SetText(self:GetText():gsub("^%* ",""))
                        end
                        
                        carrier.item.edited = false
                        for id,elem in ipairs(carrier.editables) do
                            if elem:getFunc()~=elem.def then
                                carrier.item.edited = true
                                break
                            end
                        end
                    end
                    
                    local setNetworked = function(elem,carrier,item,i,key,valChangeFunc,type)
                        table.insert(carrier.editables, elem)
                        elem.info  = i
                        local info = elem.info
                        
                        elem.item = item
                        elem.key  = key
                        elem.def  = info[key]
                        elem.carrier = carrier
                        elem.type = type
                        
                        if type=="number" then
                            elem[valChangeFunc] = function(self,to)
                                local snap = self.snap or 1
                                to = math.Round(to/snap)*snap
                                if self:GetValue()~=to then
                                    self:SetValue(to)
                                end
                                
                                self.info[key] = to
                                self.edited = self.info[key] ~= self.def
                                onEdit(self,carrier)
                            end
                            elem.setFunc = elem.SetValue
                            elem.getFunc = elem.GetValue
                            
                            elem._tempNoEdit = true
                            elem:SetValue(elem.def)
                            elem._tempNoEdit = false
                            if elem.SetDefaultValue then
                                elem:SetDefaultValue(elem.def)
                            end
                        elseif type=="string" then
                            elem.def = tostring(elem.def or "")
                            if elem.SetUpdateOnType then
                                elem:SetUpdateOnType(true)
                            end
                            elem[valChangeFunc] = function(self,to)
                                to = utf8.sub(to:gsub("[\r\n\t]",""),1,self.limit or 24)
                                if self:GetText()~=to then
                                    local cp = self:GetCaretPos()
                                    self:SetText(to)
                                    self:SetCaretPos(math.Clamp(cp,0,utf8.len(to)))
                                end
                                
                                self.info[key] = to
                                self.edited = self.info[key] ~= self.def
                                onEdit(self,carrier)
                            end
                            elem.setFunc = elem.SetText
                            elem.getFunc = elem.GetText
                            elem._tempNoEdit = true
                            elem:SetText(elem.def)
                            elem._tempNoEdit = false
                        elseif type=="bool" then
                            elem[valChangeFunc] = function(self,to)
                                to = tobool(to)
                                if self:GetChecked()~=to then
                                    self:SetChecked(to)
                                end
                                
                                self.info[key] = to
                                self.edited = self.info[key] ~= self.def
                                onEdit(self,carrier)
                            end
                            elem.setFunc = elem.SetChecked
                            elem.getFunc = elem.GetChecked
                            elem:SetChecked(elem.def)
                        elseif type=="combobox" then
                            elem[valChangeFunc] = function(self,to,text,data)
                                self.info[key] = data
                                
                                if not self._blockEdit then
                                    self.edited = self.info[key] ~= self.def
                                    onEdit(self,carrier)
                                end
                            end
                            elem.setFunc = function(self,to)
                                for i=1,#self.Data do
                                    if self.Data[i]==to then
                                        self:ChooseOptionID(i)
                                        self:SetText(self:GetOptionText(i))
                                        break
                                    end
                                end
                            end
                            elem.getFunc = function(self)
                                self:GetOptionData(self:GetSelectedID())
                            end
                            
                            elem._blockEdit = true
                            elem:setFunc(elem.def)
                            elem._blockEdit = false
                        end
                    end
                    
                    local carrierNetRefresh = function(self)
                        local item, info = self.item, self.item.card
                        local t = info.type=="lane" and qcwLaneTypes or qcwCards
                        if not t[info.class] then
                            local tabs = item.Tab.m_pPropertySheet
                            if #tabs:GetItems()>1 then
                                tabs:CloseTab(item.Tab,true)
                            else
                                closeTab(tabs,item.Tab)
                            end
                        else
                            self.item.card = t[info.class]
                            local svData = t[info.class]
                            for id,editable in ipairs(self.editables) do
                                editable.item.card = svData
                                editable.def  = svData[editable.key]
                                editable.edited = editable.info[editable.key] ~= editable.def
                                if editable.item.saved then
                                    if editable.type == "string" then
                                        editable:setFunc(svData[editable.key] or "")
                                    else
                                        editable:setFunc(svData[editable.key])
                                    end
                                    editable.item.saved = false
                                end
                                onEdit(editable,editable.carrier)
                            end
                        end
                    end
                    
                -- }}}
                
                local prepCarrier = function(p)
                    local item, info = p.item, p.item.temp
                    qcwNetRefreshables[p] = 0
                    p.netRefresh = carrierNetRefresh
                    p.editables  = {}
                    
                    if info.type~="lane" then
                        local c1, c1p = p:Add("Basic"), vgui.Create("DPanel")
                        c1:SetContents(c1p); c1p:DockPadding(16,8,16,8)
                        
                        local cba = c1p:Add("DCheckBoxLabel")
                        cba:Dock(TOP)
                        cba:SetText("Activo")
                        cba:SetTooltip("La unidad no aparecerá en el juego si está inactiva.")
                        cba:SetDark(true)
                        setNetworked(cba,p,item,info,"active","OnChange","bool")
                        cba:DockMargin(0,0,0,8)
                        
                        local cgd = c1p:Add("DCheckBoxLabel")
                        cgd:SetPos(cba:GetX()+108,8)
                        cgd:SetText("No genera en cubiertas")
                        cgd:SetTooltip("Si está marcada, esta unidad no aparecerá en el juego normalmente y solo\nse podrá obtener mediante el uso de habilidades especiales u otros métodos.")
                        cgd:SetDark(true)
                        setNetworked(cgd,p,item,info,"nodeck","OnChange","bool")
                        
                        local name = c1p:Add("DTextEntry")
                        name:Dock(TOP)
                        name:SetPlaceholderText("Nombre visible")
                        name:SetTall(24)
                        name:InvalidateParent()
                        setNetworked(name,p,item,info,"name","OnValueChange","string")
                        
                        if info.type=="unidad" then
                            local lane = c1p:Add("DTextEntry")
                            lane:Dock(TOP)
                            lane:SetPlaceholderText("Tipo de carril")
                            lane:SetTall(18)
                            lane:DockMargin(0,4,0,0)
                            lane:InvalidateParent()
                            setNetworked(lane,p,item,info,"lane","OnValueChange","string")
                        end
                        
                        local cost = c1p:Add("DNumSlider")
                        cost:Dock(TOP)
                        cost:SetText("Costo MP")
                        cost:SetDecimals(0)
                        cost:SetMinMax(1,20)
                        cost:SetDark(true)
                        setNetworked(cost,p,item,info,"cost","OnValueChanged","number")
                        local desc = c1p:Add("DTextEntry")
                        desc:SetMultiline(true)
                        desc:SetPaintBackground(false)
                        desc:Dock(TOP)
                        desc:SetTall(48)
                        function desc:AllowInput() return true end
                        function desc:Think()
                            local t = mulDescs[getMul(cost:GetValue())]
                            desc:SetText(t   .base..t[info.tipo])
                        end
                        
                        if info.type~="hechizo" then
                            if info.type=="unidad" then
                                local atk = c1p:Add("DNumSlider")
                                atk:Dock(TOP)
                                atk:SetText("ATK")
                                atk:SetDecimals(0)
                                atk:SetMinMax(0,25)
                                atk:SetDark(true)
                                setNetworked(atk,p,item,info,"atk","OnValueChanged","number")
                                
                                local hp = c1p:Add("DNumSlider")
                                hp:Dock(TOP)
                                hp:SetText("HP")
                                hp:SetDecimals(0)
                                hp:SetMinMax(1,50)
                                hp:SetDark(true)
                                setNetworked(hp,p,item,info,"hp","OnValueChanged","number")
                                
                                local arm = c1p:Add("DNumSlider")
                                arm:Dock(TOP)
                                arm:SetText("Armadura")
                                arm:SetDecimals(0)
                                arm:SetMinMax(0,15)
                                arm:SetDark(true)
                                arm:SetTooltip("Incoming damage will be reduced by this amount. Can't decrease below 1.")
                                setNetworked(arm,p,item,info,"armor","OnValueChanged","number")
                            end
                            
                            local c2, c2p = p:Add("Apariencia"), vgui.Create("DPanel")
                            c2:SetContents(c2p)
                            
                            util.PrecacheModel(info.mdl)
                            
                            local mdl = vgui.Create("DModelPanel", c2p)
                            mdl.info = info
                            mdl:SetPos(16+221,8)
                            mdl:SetSize(120,162)
                            mdl:SetAnimated(false)
                            mdl:SetModel(info.mdl)
                            function mdl:PaintOver(w,h)
                                surface.SetDrawColor(0,0,0,75)
                                surface.DrawOutlinedRect(0,0,w,h,2)
                            end
                            function mdl:PreDrawModel(ent)
                                local card = self.info
                                ent.validModel = CurTime()%2<1 and card.mdlAlt or card.mdl
                                if ent:GetModel()~=ent.validModel then
                                    ent:SetModel(ent.validModel)
                                end
                                ent:SetMaterial(card.material)
                                ent:SetSequence(tonumber(card.mdlSeq) or (isstring(card.mdlSeq) and #card.mdlSeq>0 and card.mdlSeq) or 1)
                                ent:SetModelScale(0.5*(card.mdlScale or 1))
                                ent:SetAngles(Angle(0,(card.mdlYaw or 0)+15+(CurTime()*360*(card.spinning or 0)),0))
                                ent:SetPos(Vector(0,0,(card.elev or 0)*6+(tobool(card.float) and math.sin(CurTime()*5) or 0)-12))
                                mdl:SetLookAt(Vector(0,0,(card.elev or 0)*4))
                                mdl:SetFOV(30)
                                
                                render.SetColorModulation(card.cr or 1, card.cg or 1, card.cb or 1)
                                render.SetBlend(card.ca or 1)
                            end
                            
                            c2p:DockPadding(16,8+24+4,16,8)
                            
                            local mpath = c2p:Add("DTextEntry")
                            mpath:SetPos(16,8)
                            mpath:SetSize(128,24)
                            mpath:SetPlaceholderText("Ruta al modelo")
                            mpath:SetTooltip("Ruta al modelo mdl de esta unidad.")
                            mpath:InvalidateParent(true)
                            mpath:DockMargin(0,0,120+8,4)
                            mpath.limit = 128
                            setNetworked(mpath,p,item,info,"mdl","OnValueChange","string")
                            local mpath2 = c2p:Add("DTextEntry")
                            mpath2:SetPos(mpath:GetX()+mpath:GetWide()+4,mpath:GetY())
                            mpath2:SetSize(81,24)
                            mpath2:SetPlaceholderText("Alt. Model")
                            mpath2:SetTooltip("Este modelo se usará si no se encuentra el modelo principal.\nPor ejemplo, si su modelo usa activos de otro juego (CSS, EP2, etc.),\nentonces no todos podrán verlo. Para compatibilidad, proporcione\naquí un modelo alternativo.")
                            mpath2:InvalidateParent()
                            mpath2:DockMargin(0,0,120+8,4)
                            mpath2.limit = 128
                            setNetworked(mpath2,p,item,info,"mdlAlt","OnValueChange","string")
                            
                            local mat = c2p:Add("DTextEntry")
                            mat:Dock(TOP)
                            mat:SetTall(18)
                            mat:SetPlaceholderText("Material")
                            mat:InvalidateParent()
                            mat:SetTooltip("Camino al material. Dejar en blanco para el material predeterminado.")
                            mat:DockMargin(0,0,120+8,4)
                            mat.limit = 128
                            setNetworked(mat,p,item,info,"material","OnValueChange","string")
                            
                            local an = c2p:Add("DTextEntry")
                            an:Dock(TOP)
                            an:SetTall(18)
                            an:SetPlaceholderText("Animación (ID de secuencia o nombre)")
                            an:InvalidateParent()
                            an:SetTooltip("Identificación de animación. Puede ser un número o un nombre.")
                            an:DockMargin(0,0,120+8,4)
                            an.limit = 128
                            setNetworked(an,p,item,info,"mdlSeq","OnValueChange","string")
                            
                            local yaw = c2p:Add("DNumSlider")
                            yaw:Dock(TOP)
                            yaw:SetText("Rotación")
                            yaw:SetDecimals(0)
                            yaw:SetMinMax(-180,180)
                            yaw:SetDark(true)
                            yaw:DockMargin(0,0,120+8,0)
                            yaw.snap = 15
                            setNetworked(yaw,p,item,info,"mdlYaw","OnValueChanged","number")
                            
                            local scale = c2p:Add("DNumSlider")
                            scale:Dock(TOP)
                            scale:SetText("Escala")
                            scale:SetDecimals(2)
                            scale:SetMinMax(0.05,5)
                            scale:SetDark(true)
                            scale:DockMargin(0,0,120+8,0)
                            scale.snap = 0.05
                            setNetworked(scale,p,item,info,"mdlScale","OnValueChanged","number")
                            
                            local elev = c2p:Add("DNumSlider")
                            elev:Dock(TOP)
                            elev:SetText("Elevación")
                            elev:SetDecimals(0)
                            elev:SetMinMax(-32,32)
                            elev:DockMargin(0,0,120+8,8)
                            elev:SetDark(true)
                            setNetworked(elev,p,item,info,"elev","OnValueChanged","number")
                            
                            local cols = { Color(255,0,0), Color(0,255,0), Color(0,0,255), color_white }
                            local n = {"Red","Green","Blue","Opacity"}
                            for id,short in ipairs {"cr","cg","cb","ca"} do
                                local c = c2p:Add("DNumSlider")
                                c:Dock(TOP)
                                c:SetTall(18)
                                c:DockMargin(0,0,0,2)
                                c:SetText(n[id])
                                c:SetDecimals(1)
                                c:SetMinMax(0,id==4 and 1 or 5)
                                c:SetDark(true)
                                c.snap = 0.1
                                function c.Slider.Knob:Paint(w,h)
                                    draw.SimpleTextOutlined("⛊","QCWDesc",w/2,h/2,cols[id],1,1,1,color_black)
                                end
                                setNetworked(c,p,item,info,short,"OnValueChanged","number")
                            end
                            
                            local spin = c2p:Add("DNumSlider")
                            spin:Dock(TOP)
                            spin:SetText("Hilado")
                            spin:SetDecimals(2)
                            spin:SetMinMax(-5,5)
                            spin:DockMargin(0,0,0,4)
                            spin:SetDark(true)
                            spin.snap = 0.05
                            setNetworked(spin,p,item,info,"spinning","OnValueChanged","number")
                            
                            local float = c2p:Add("DCheckBoxLabel")
                            float:Dock(TOP)
                            float:SetText("Animación voladora")
                            float:SetDark(true)
                            setNetworked(float,p,item,info,"float","OnChange","bool")
                                
                            if info.type=="unidad" then
                                local c3, c3p = p:Add("Accuracy"), vgui.Create("DPanel")
                                c3:SetContents(c3p); c3p:DockPadding(16,8,16,8)
                                
                                local paintInfo = function(self,w,h)
                                    draw.SimpleText(self.text,"ScoreboardDefault",4,4,color_black)
                                    if self.miss and self.crit then
                                        local miss, crit = 
                                            math.Clamp(math.floor(0.2*self.miss:GetValue()*100)/100,0,1), 
                                            math.Clamp(math.floor(0.1*self.crit:GetValue()*100)/100,0,1)
                                        crit = math.Clamp(crit,0,1-miss)
                                        
                                        local bx,by,bw,bh = 0,30,w-0,h-34
                                        surface.SetDrawColor(0,0,0)
                                        surface.DrawRect(bx,by,bw,bh)
                                        
                                        bx,by,bw,bh = bx+2,by+2,bw-4,bh-4
                                        surface.SetDrawColor(63, 171, 54)
                                        surface.DrawRect(bx,by,bw,bh)
                                        surface.SetDrawColor(157, 42, 42)
                                        local xp1 = bx+bw*(1-miss)
                                        surface.DrawRect(xp1,by,math.ceil(bw*miss),bh)
                                        surface.SetDrawColor(51, 193, 255)
                                        if bw*miss>=18 then
                                            draw.SimpleTextOutlined((miss*100).."%","DermaDefault",xp1+bw*miss*0.5,by+bh/2,color_white,1,1,1,color_black)
                                        end
                                        local xp2 = xp1 - bw*crit
                                        surface.DrawRect(xp2,by,math.ceil(bw*crit),bh)
                                        surface.SetDrawColor(0,0,0)
                                        surface.DrawRect(xp1-1,by,2,bh)
                                        surface.DrawRect(xp2-1,by,2,bh)
                                        if bw*crit>=18 then
                                            draw.SimpleTextOutlined((crit*100).."%","DermaDefault",xp2+bw*crit*0.5,by+bh/2,color_white,1,1,1,color_black)
                                        end
                                        
                                        if (1-crit-miss)*bw>=18 then
                                            draw.SimpleTextOutlined(((1-crit-miss)*100).."%","DermaDefault",bw*(1-crit-miss)*0.5,by+bh/2,color_white,1,1,1,color_black)
                                        end
                                    end
                                end
                                
                                for i=1,2 do
                                    local ip = c3p:Add("DPanel")
                                    ip:Dock(TOP)
                                    ip:SetTall(58)
                                    ip.Paint = paintInfo  
                                    ip.text  = i==1 and "Estadísticas de la unidad VS enemigos:" or "Estadísticas enemigas VS esta unidad:"
                                    
                                    for j=1,2 do
                                        local what = (j==1 and "Miss" or "Crit")
                                        
                                        local m = c3p:Add("DNumSlider")
                                        m:Dock(TOP)
                                        m:SetTall(18)
                                        m:DockMargin(0,2,0,2)
                                        m:SetText(what.." Chance Multiplier")
                                        m:SetDecimals(2)
                                        m:SetMinMax(0,j==1 and 3 or 6)
                                        m:SetDark(true)
                                        m.snap = 0.01
                                        ip[j==1 and "miss" or "crit"] = m
                                        
                                        setNetworked(m,p,item,info,
                                            (i==1 and "s" or "e") .. what .."Mul",
                                        "OnValueChanged","number")
                                    end
                                end
                            end
                        end
                        
                        local c, cp = p:Add("Special"), vgui.Create("DPanel")
                        c:SetContents(cp); cp:DockPadding(16,8,16,8)
                        
                        local order = {"special","specialOnce","specialKill","specialDeath"}
                        local names = {
                            special = info.type=="estructura" and "efecto pasivo" or (info.type=="unidad" and "Habilidad especial" or "Efecto"),
                            specialOnce = "Efecto en la unidad",
                            specialDeath = info.type=="estructura" and "Efecto sobre la muerte de la unidad" or "Efecto sobre la muerte",
                            specialKill = info.type=="estructura" and "Efecto sobre la matanza de unidades" or "Efecto al matar",
                        }
                        local tooltips = {
                            special = info.type=="estructura" and "Efecto que ocurre al comienzo de cada uno de tus turnos." or (info.type=="unidad" and "Efecto de habilidad especial de la unidad, precio, modo de activación, etc." or "Modificar el efecto del poder."),
                            specialOnce = "Este efecto ocurre cuando colocas el edificio junto a una unidad, o cuando una unidad se coloca en el mismo carril que este edificio.\nDe cualquier manera, no se activa más de una vez por unidad, y NO se activa si el edificio estaba colocado en un carril vacío.",
                            specialDeath = info.type=="estructura" and "Este efecto se activa cuando la unidad en el mismo carril que el edificio muere." or "Este efecto ocurre en la muerte de la unidad.",
                            specialKill = info.type=="estructura" and "Este efecto se activa cuando una unidad en el mismo carril que el edificio mata a una unidad enemiga (por medios normales)." or "Este efecto ocurre cuando esta unidad mata a una unidad enemiga por medios normales."
                        }
                        
                        local desc = cp:Add("DTextEntry")
                        desc:Dock(TOP)
                        desc:SetPlaceholderText("Descripción de habilidad especial")
                        desc:SetTall(32)
                        desc:InvalidateParent()
                        desc:DockMargin(0,0,0,4)
                        desc.limit = 100
                        desc:SetMultiline(true)
                        setNetworked(desc,p,item,info,"sdesc","OnValueChange","string")
                        
                        if info.type == "hechizo" then
                            order[3] = nil
                            order[4] = nil
                            order[2] = nil
                        elseif info.type == "unidad" then
                            table.remove(order,2)
                            
                            local cost = cp:Add("DNumSlider")
                            cost:Dock(TOP)
                            cost:SetText("Costo MP")
                            cost:SetDecimals(0)
                            cost:SetMinMax(0,10)
                            cost:SetDark(true)
                            cost.snap = 1
                            setNetworked(cost,p,item,info,"scost","OnValueChanged","number")
                            
                            local uses = cp:Add("DNumSlider")
                            uses:Dock(TOP)
                            uses:SetText("Usos máximos")
                            uses:SetDecimals(0)
                            uses:SetMinMax(1,10)
                            uses:SetDark(true)
                            uses.snap = 1
                            setNetworked(uses,p,item,info,"suses","OnValueChanged","number")
                            
                            local pick = cp:Add("DNumSlider")
                            pick:Dock(TOP)
                            pick:SetText("Modo de activación")
                            pick:SetDecimals(0)
                            pick:SetMinMax(0,2)
                            pick:SetDark(true)
                            pick.snap = 1
                            setNetworked(pick,p,item,info,"spick","OnValueChanged","number")
                            local desc = cp:Add("DTextEntry")
                            desc:SetMultiline(true)
                            desc:SetPaintBackground(false)
                            desc:Dock(TOP)
                            desc:SetTall(24)
                            function desc:AllowInput() return true end
                            function desc:Think()
                                local t = pickDescs[pick:GetValue()]
                                desc:SetText(t   )
                            end
                            
                            local cond = cp:Add("DComboBox")
                            cond:Dock(TOP)
                            cond:SetTooltip("Condición para activar la habilidad")
                            cond:AddChoice("Sin condición (disparar en cualquier momento)","C_Always")
                            cond:AddSpacer()
                            cond:AddChoice("Un enemigo tiene que estar delante de esta unidad.","C_EnemyFront")
                            cond:AddChoice("Su propia unidad tiene que ser seleccionada","C_AllySel")
                            cond:AddChoice("Seleccione cualquiera de sus unidades, excepto esta","C_AllySelNotSelf")
                            cond:AddSpacer()
                            cond:AddChoice("Tu carril tiene un edificio","C_AllyBuilding")
                            cond:AddChoice("El carril enemigo tiene un edificio.","C_EnemyBuilding")
                            cond:AddSpacer()
                            cond:AddChoice("El carril está vacío a tu lado","C_AllyEmptyLane")
                            cond:AddChoice("El carril está vacío en el enemigo.side","C_EnemyEmptyLane")
                            cond:AddChoice("El carril está vacío en ambos lados.","C_EmptyLane")
                            cond:DockMargin(0,0,0,16)
                            cond:SetSortItems(false)
                            setNetworked(cond,p,item,info,"specialCheck","OnSelect","combobox")
                        end
                        
                        local pover = function(b,w,h)
                            if b.info[b.type] then
                                surface.SetDrawColor(100,150,255)
                                surface.DrawOutlinedRect(2,2,w-4,h-4,2)
                            else
                                surface.SetDrawColor(255,255,255,20)
                                surface.DrawRect(2,2,w-4,h-4,2)
                            end
                        end
                        
                        for i,t in ipairs(order) do
                            local b = cp:Add("DButton")
                            b:Dock(TOP)
                            b:SetTall(24)
                            b:DockMargin(0,0,0,4)
                            b:SetText("Editar"..names[t])
                            b.type = t
                            b.info = info
                            b:SetTooltip(tooltips[t])
                            b.DoClick = openAbilEditor
                            b.PaintOver = pover
                            b.item = item
                        end
                    else
                        local c, cp = p:Add("Lane properties"), vgui.Create("DPanel")
                        c:SetContents(cp); cp:DockPadding(16,8,16,8)
                        
                        local name = cp:Add("DTextEntry")
                        name:Dock(TOP)
                        name:SetPlaceholderText("Nombre de carril visible")
                        name:SetTall(24)
                        name:InvalidateParent()
                        name:DockMargin(0,0,0,8)
                        setNetworked(name,p,item,info,"name","OnValueChange","string")
                        
                        local desc = cp:Add("DTextEntry")
                        desc:Dock(TOP)
                        desc:SetPlaceholderText("Descripción")
                        desc:SetTall(64)
                        desc:InvalidateParent()
                        desc:DockMargin(0,0,0,8)
                        desc.limit = 250
                        desc:SetMultiline(true)
                        setNetworked(desc,p,item,info,"desc","OnValueChange","string")
                        
                        local vis = cp:Add("DPanel")
                        vis:Dock(TOP)
                        vis:SetTall(32)
                        vis:DockMargin(0,0,0,4)
                        vis:SetBackgroundColor(Color(0,0,0))
                        vis:SetTooltip(false)
                        
                        local cols = { Color(255,0,0), Color(0,255,0), Color(0,0,255) }
                        local n = {"Red","Green","Blue"}
                        for id,shorter in ipairs {"r","g","b"} do
                            local c = cp:Add("DNumSlider")
                            c:Dock(TOP)
                            c:SetTall(18)
                            c:DockMargin(0,0,0,2)
                            c:SetText(n[id])
                            c:SetDecimals(0)
                            c:SetMinMax(0,255)
                            c:SetDark(true)
                            function c.Slider.Knob:Paint(w,h)
                                vis:GetBackgroundColor()[shorter] = c:GetValue()
                                draw.SimpleTextOutlined("⛊","QCWDesc",w/2,h/2,cols[id],1,1,1,color_black)
                            end
                            setNetworked(c,p,item,info,"c"..shorter,"OnValueChanged","number")
                        end
                    end
                end
                
                local newClick = function(self)
                    local l = self.l
                    local cname = utf8.sub(self.entry:GetText():gsub(".",textValidator):lower(),1,16)
                    if cname == self.entry:GetText() then
                        if #cname>0 then
                            if (l.qcwType=="lane" and qcwLaneTypes or qcwCards)[cname] then
                                notification.AddLegacy("[QCW] "..(l.qcwType=="lane" and "Carril" or "Carta").." con esta clase ya existe!",1,3)
                            else
                                if l.qcwType == "lane" then
                                    net.Start("qcw_communicate")
                                        net.WriteUInt(1,3)
                                        net.WriteBool(true)
                                        net.WriteBool(false)
                                        net.WriteString(cname)
                                        net.WriteTable {
                                            name = "New lane"
                                        }
                                    net.SendToServer()
                                else
                                    net.Start("qcw_communicate")
                                        net.WriteUInt(1,3)
                                        net.WriteBool(true)
                                        net.WriteBool(true)
                                        net.WriteString(cname)
                                        net.WriteTable {
                                            name = "New "..l.qcwType,
                                            type = l.qcwType
                                        }
                                    net.SendToServer()
                                end
                                
                                timer.Simple(0.12,function()
                                    local sb = l:GetChildren()[4]
                                    if IsValid(l) then
                                        for id,line in ipairs(l:GetLines()) do
                                            if line.qcwInfo and line.qcwInfo.class==cname then
                                                l:SelectItem(line)
                                                if IsValid(sb) then
                                                    local sorted = {}
                                                    for id,line in ipairs(l:GetLines()) do
                                                        if line.qcwInfo then
                                                            table.insert(sorted,line.qcwInfo.class)
                                                        end
                                                    end
                                                    table.sort(sorted)
                                                    
                                                    local pos = 0
                                                    for i=1,#sorted do
                                                        if sorted[i]==cname then
                                                            pos = i
                                                            break
                                                        end
                                                    end
                                                    
                                                    local lc = #l:GetLines()
                                                    sb:AnimateTo(math.Remap(pos,1,lc,0,math.max(0,lc-20))*16-8, 0.12)
                                                end
                                                break
                                            end
                                        end
                                    end
                                end)
                                
                                self.entry:SetText("")
                            end
                        else
                            notification.AddLegacy("[QCW] Nombre en blanco",1,4)
                        end
                    else
                        notification.AddLegacy("[QCW] Caracteres no válidos en el nombre de la clase... ¿de alguna manera?",1,4)
                    end
                end
                
                local entryChange = function(self,to)
                    local cor = utf8.sub(self:GetText():gsub(".",textValidator):lower(),1,16)
                    if cor~=to then
                        local cp = self:GetCaretPos()
                        self:SetText(cor)
                        self:SetCaretPos(math.Clamp(cp,0,utf8.len(cor)))
                    end
                end
                
                local cediting = Color(255,60,55)
                local rowSelect = function(self,lid,line)
                    local card = line.qcwInfo
                    if card then
                        local tabs = self.tabs
                        local sb   = tabs:GetChildren()[1]
                        
                        local found = false
                        for id,item in ipairs(tabs:GetItems()) do
                            if item.Name == card.class then
                                tabs:SetActiveTab(item.Tab)
                                sb:ScrollToChild(item.Tab)
                                found = item
                            end
                        end
                        
                        if not found then
                            local cp = vgui.Create("DCategoryList")
                            local item  = tabs:AddSheet(card.class,cp)
                            item.card   = card
                            item.temp   = table.Copy(card)
                            item.edited = false
                            item.Panel.item = item
                            item.Tab  .item = item
                            local old = item.Tab.Think
                            item.Tab.Think = function(self)
                                old(self)
                                
                                local b = self.item.edited
                                if self._e ~= b then
                                    self._e = b
                                    if b then
                                        tabs.editing = tabs.editing + 1
                                        self:SetTextColor(cediting)
                                        item.Name = self:GetText()
                                    else
                                        tabs.editing = tabs.editing - 1
                                        self:SetTextColor(color_white)
                                        item.Name = self:GetText()
                                    end
                                end
                            end
                            
                            prepCarrier(cp)
                            
                            tabs:SetActiveTab(item.Tab)
                            sb:ScrollToChild(item.Tab)
                            found = item
                        end
                        
                        for id,item in ipairs(tabs:GetItems()) do
                            if item~=found and not item.edited then
                                tabs:CloseTab(item.Tab,true)
                            end
                        end
                    end
                end
                
                for id,panel in ipairs(panels) do
                    -- List {{{
                        local l = panel:Add("DListView")
                        lists[id] = l
                        l.qcwType = panel.qcwType:lower()
                        
                        l:AddColumn(panel.qcwType)
                        l:AddColumn("Class")
                        l:SetPos(8,8)
                        l:SetSize(196,385)
                        l:SetMultiSelect(false)
                        l.OnRowSelected = rowSelect
                        l.netRefresh = listNetRefresh
                        
                        local new = panel:Add("DButton")
                        new:SetText("Nuevo")
                        new:SetPos(l:GetWide()-64+8,8+l:GetTall()+4)
                        new:SetSize(64,409-l:GetTall())
                        new.DoClick = newClick
                        new.l = l
                        
                        entry = panel:Add("DTextEntry")
                        entry:SetPlaceholderText("Nuevo nombre de clase")
                        entry:SetPos(8,new:GetY())
                        entry:SetSize(new:GetX()-l:GetX()-4,new:GetTall())
                        entry:SetUpdateOnType(true)
                        entry.OnValueChange = entryChange
                        new.entry = entry
                        
                        qcwNetRefreshables[l] = 0
                        listNetRefresh(l)
                    -- }}}
                    
                    -- Tabs {{{
                        local tabs = panel:Add("DPropertySheet")
                        tabs.editing = 0
                        tabs.list = l
                        l.tabs = tabs
                        
                        tabs:SetPos(8+196+4,8)
                        tabs:SetSize(408,385)
                        
                        local btnThink = function(self)
                            local mode, tab = self.mode, tabs:GetActiveTab()
                            if mode==0 then
                                self:SetEnabled(tab and tab.item.edited)
                            elseif mode==1 or mode==4 then
                                self:SetEnabled(tab)
                            elseif mode==2 then
                                local found = false
                                for id,item in ipairs(tabs:GetItems()) do
                                    if item.edited then
                                        found = true
                                        break
                                    end
                                end
                                self:SetEnabled(found)
                            elseif mode==3 then
                                self:SetEnabled(#tabs:GetItems()>=1)
                            end
                        end
                        
                        local btnClick = function(self)
                            local mode, tab = self.mode, tabs:GetActiveTab()
                            local card = tab.item.card
                            
                            if mode==0 then
                                tab.item.saved = true
                                net.Start("qcw_communicate")
                                    net.WriteUInt(1,3)
                                    net.WriteBool(true)
                                    net.WriteBool(l.qcwType~="lane")
                                    net.WriteString(tab.item.card.class)
                                    net.WriteTable(tab.item.temp)
                                net.SendToServer()
                            elseif mode==1 then
                                local n = #tabs:GetItems()
                                if n>1 then
                                    tabs:CloseTab(tab,true)
                                else
                                    closeTab(tabs,tab)
                                end
                            elseif mode==2 then
                                for id,item in ipairs(tabs:GetItems()) do
                                    if item.edited and item.card then
                                        local bool, data, class = l.qcwType~="lane", item.temp, item.card.class
                                        timer.Simple(0.15*id,function()
                                            if data and class then
                                                if IsValid(tab) then
                                                    tab.item.saved = true
                                                    tab.item.edited = false
                                                end
                                                
                                                net.Start("qcw_communicate")
                                                    net.WriteUInt(1,3)
                                                    net.WriteBool(true)
                                                    net.WriteBool(bool)
                                                    net.WriteString(class)
                                                    net.WriteTable(data)
                                                net.SendToServer()
                                            end
                                        end)
                                    end
                                end
                            elseif mode==3 then
                                local items = tabs:GetItems()
                                for id=#items,1,-1 do
                                    local item = items[id]
                                    if id==1 then
                                        closeTab(tabs,item.Tab)
                                    else
                                        tabs:CloseTab(item.Tab,true)
                                    end
                                end
                            elseif mode==4 then
                                if self:GetText()=="Confirmar" then
                                    net.Start("qcw_communicate")
                                        net.WriteUInt(1,3)
                                        net.WriteBool(false)
                                        net.WriteBool(l.qcwType~="lane")
                                        net.WriteString(tab.item.card.class)
                                        net.WriteTable {}
                                    net.SendToServer()
                                    self:SetText("Remover")
                                else
                                    self:SetText("Confirmar")
                                end
                            end
                        end
                        
                        local save = panel:Add("DButton")
                        save:SetText("Guardar")
                        save:SetPos(tabs:GetX(),tabs:GetY()+385+4)
                        save:SetSize(408/5,24)
                        save.DoClick = btnClick
                        save.Think   = btnThink
                        save.mode    = 0
                        local close = panel:Add("DButton")
                        close:SetText("Cerrar")
                        close:SetPos(tabs:GetX()+408/5,tabs:GetY()+385+4)
                        close:SetSize(408/5,24)
                        close.DoClick = btnClick
                        close.Think   = btnThink
                        close.mode    = 1
                        local savea = panel:Add("DButton")
                        savea:SetText("Guardar todo")
                        savea:SetPos(tabs:GetX()+408/5*2,tabs:GetY()+385+4)
                        savea:SetSize(408/5,24)
                        savea.DoClick = btnClick
                        savea.Think   = btnThink
                        savea.mode    = 2
                        local closea = panel:Add("DButton")
                        closea:SetText("Cerrar todo")
                        closea:SetPos(tabs:GetX()+408/5*3,tabs:GetY()+385+4)
                        closea:SetSize(408/5,24)
                        closea.DoClick = btnClick
                        closea.Think   = btnThink
                        closea.mode    = 3
                        local remove = panel:Add("DButton")
                        remove:SetText("Remover")
                        remove:SetPos(tabs:GetX()+408/5*4,tabs:GetY()+385+4)
                        remove:SetSize(408/5,24)
                        remove.DoClick = btnClick
                        remove.Think   = btnThink
                        remove.mode    = 4
                    -- }}}
                end
            end
            -- }}}
            
        -- }}}
    end

-- // }}}

-- // CVars & ToolMenu {{{

    hook.Add("AddToolMenuCategories", "qcwAddToolMenuCategories", function()
        spawnmenu.AddToolCategory("Utilities", "QCardWars", "QCardWars")
    end)

    hook.Add("PopulateToolMenu", "qcwPopulateToolMenu", function()
        spawnmenu.AddToolMenuOption("Utilities", "QCardWars", "QCardWarsMenu", "Menú abierto", "qcw_menu")
    end)

    concommand.Add("qcw_menu", qcwOpenMenu)

-- // }}}
    
-- // Net {{{

    local lastRefreshes = {}
    qcwNetRefreshables  = {}
    function qcwNetRefresh(id)
        local fr = FrameNumber()
        for el,pr in pairs(qcwNetRefreshables) do
            if IsValid(el) and el.netRefresh then
                if pr==id or pr==-1 and (lastRefreshes[el]~=fr) then
                    el:netRefresh()
                    lastRefreshes[el] = fr
                end
            else
                lastRefreshes[el] = nil
                qcwNetRefreshables[el] = nil
            end
        end
    end

    local lastSoundTime = 0
    net.Receive("qcw_communicate", function(len, ply)
        local msgType = net.ReadUInt(3)
        if msgType == 0 then 
            -- // Receiving unit and lane data
            local mode = net.ReadUInt(2)
            if mode==0 then
                table.Empty(qcwCards)
            end
            if mode~=2 then
                for k,v in pairs(net.ReadTable()) do
                    qcwCards[k] = v
                end
            else
                qcwLaneTypes = net.ReadTable()
                qcwNetRefresh(0)
            end
        elseif msgType == 1 then
            -- // Server edit response
            notification.AddLegacy(net.ReadString(),3,4)
            if CurTime()-lastSoundTime>0.1 then
                surface.PlaySound("garrysmod/content_downloaded.wav")
                lastSoundTime = CurTime()
            end
            qcwNetRefresh(0,false)
        elseif msgType == 2 then
            -- // Receiving auth list
            qcwAuthList = net.ReadTable()
            qcwNetRefresh(1)
        elseif msgType == 3 then
            -- // Updating valid lanes
            local desk = net.ReadEntity()
            local lanesValid = net.ReadTable()
            desk.lanesValid = lanesValid
        end
    end)

-- }}}
