AddCSLuaFile()
if SERVER then return end
include("sh_zfs_config_fruits.lua" )
include("sh_zfs_config_smoothies.lua" )
include("sh_zfs_config_toppings.lua" )

hook.Add("AddToolMenuCategories", "zfs_CreateCategories", function()
    spawnmenu.AddToolCategory("Options", "zfs_options", "Fruitslicer")
end)

hook.Add("PopulateToolMenu", "zfs_PopulateMenus", function()
    spawnmenu.AddToolMenuOption("Options", "zfs_options", "zfs_Admin_Settings", "Admin Settings", "", "", function(CPanel)
        zclib.Settings.OptionPanel("Shop", "Saves all Fruitslicer shops to the map as a public utility.", Color(219, 86, 81), zclib.colors["ui02"], CPanel, {
            [1] = {
                name = "Save",
                class = "DButton",
                cmd = "zfs_shop_save"
            },
            [2] = {
                name = "Remove",
                class = "DButton",
                cmd = "zfs_shop_remove"
            },
        })
        zclib.Settings.OptionPanel("Commands", "Some debug commands.", Color(219, 86, 81), zclib.colors["ui02"], CPanel, {
            [1] = {
                name = "Spawn FruitBoxes",
                class = "DButton",
                cmd = "zfs_fruitbox_spawnall"
            },
            [2] = {
                class = "Custom",
                content = function(panel)

                    local main = vgui.Create("DPanel", panel)
        			main:SetSize(200 * zclib.wM, 180 * zclib.hM)
        			main:Dock(TOP)
        			main:DockMargin(0,10,0,0)
        			main.Paint = function(s, w, h)
        				draw.RoundedBox(4, 0, 0, w, 5 * zclib.hM, zclib.colors["black_a100"])
        				draw.RoundedBox(4, 0, h - 5 * zclib.hM, w, 5 * zclib.hM, zclib.colors["black_a100"])
        			end

                    local function AddComboList(list,default,title,OnSelect)
                        local SelectionParent = vgui.Create("DPanel", main)
            			SelectionParent:SetSize(200 * zclib.wM, 55 * zclib.hM)
            			SelectionParent:Dock(TOP)
            			SelectionParent:DockMargin(0, 10, 0, 0)
            			SelectionParent.Paint = function(s, w, h)
                            draw.SimpleText(title, zclib.GetFont("zclib_font_mediumsmall"), 0, 0, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            			end

                        local Selection = zclib.vgui.ComboBox(SelectionParent,list[default].Name,function(index, value,pnl)
                            pcall(OnSelect,pnl:GetOptionData( index ))
                        end)
                        for k,v in ipairs(list) do Selection:AddChoice(v.Name,k) end
                        Selection:SetTall(30)
                        Selection:DockMargin(0,20,0,0)
                    end

                    local SmoothieID = 1
                    AddComboList(zfs.config.Smoothies,SmoothieID,"Smoothies",function(val) SmoothieID = val end)

                    local ToppingID = 1
                    AddComboList(zfs.config.Toppings,ToppingID,"Toppings",function(val) ToppingID = val end)

                    local BtnColor = Color(219, 86, 81)
                    local SpawnButton = vgui.Create("DButton", main)
        			SpawnButton:Dock(TOP)
        			SpawnButton:DockMargin(0,10,0,0)
        			SpawnButton:SetText( "Spawn Smoothie" )
        			SpawnButton:SetFont(zclib.GetFont("zclib_font_small"))
        			SpawnButton:SetTextColor(color_white)
        			SpawnButton.Paint = function(s, w, h)
        				draw.RoundedBox(4, 0, 0, w, h, BtnColor)
        				if s.Hovered then
        					draw.RoundedBox(4, 0, 0, w, h, zclib.colors["white_a15"])
        				end
        			end
        			SpawnButton.DoClick = function()

        				if zclib.Player.IsAdmin(LocalPlayer()) == false then return end

        				RunConsoleCommand( "zfs_smoothie_spawn",SmoothieID,ToppingID)
        			end
                end
            }
        })
    end)
end)
