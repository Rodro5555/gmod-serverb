if SERVER then
    AddCSLuaFile()
end

local function AddPlayerModel( name, model, hands )
    list.Set( "PlayerOptionsModel", name, model )
    player_manager.AddValidModel( name, model )

    if hands then
        player_manager.AddValidHands( name, hands, 0, "00000000" )
    end
end

AddPlayerModel( "Arnold Schwarzenegger", "models/player/arnold_schwarzenegger.mdl" )

AddPlayerModel( "Police Shepherd", "models/scvtt/police_shepherd/belgian_shepherd.mdl" )

AddPlayerModel( "Manobo", "models/player/chimp/chimp.mdl")

AddPlayerModel( "csgo_gsg91", "models/csgogsg91pm.mdl", "models/weapons/c_arms_cstrike.mdl" )
AddPlayerModel( "csgo_gsg92", "models/csgogsg92pm.mdl", "models/weapons/c_arms_cstrike.mdl" )
AddPlayerModel( "csgo_gsg93", "models/csgogsg93pm.mdl", "models/weapons/c_arms_cstrike.mdl" )
AddPlayerModel( "csgo_gsg94", "models/csgogsg94pm.mdl", "models/weapons/c_arms_cstrike.mdl" )

AddPlayerModel( "cyox_goc_jagger", "models/cyox/goc/jagger.mdl" )
AddPlayerModel( "cyox_goc_soldier", "models/cyox/goc/soldier_1.mdl" )

AddPlayerModel( "FBI_01", "models/fbi_pack/fbi_01.mdl" )
AddPlayerModel( "FBI_02", "models/fbi_pack/fbi_02.mdl" )
AddPlayerModel( "FBI_03", "models/fbi_pack/fbi_03.mdl" )
AddPlayerModel( "FBI_04", "models/fbi_pack/fbi_04.mdl" )
AddPlayerModel( "FBI_05", "models/fbi_pack/fbi_05.mdl" )
AddPlayerModel( "FBI_06", "models/fbi_pack/fbi_06.mdl" )
AddPlayerModel( "FBI_07", "models/fbi_pack/fbi_07.mdl" )
AddPlayerModel( "FBI_08", "models/fbi_pack/fbi_08.mdl" )
AddPlayerModel( "FBI_09", "models/fbi_pack/fbi_09.mdl" )

AddPlayerModel( "normal", "models/player/normal.mdl" )
AddPlayerModel( "teslapower", "models/player/teslapower.mdl" )
AddPlayerModel( "spytf2", "models/player/drpyspy/spy.mdl" )
AddPlayerModel( "shaun", "models/player/shaun.mdl" )
AddPlayerModel( "isaac", "models/player/security_suit.mdl" )
AddPlayerModel( "midna", "models/player/midna.mdl" )
AddPlayerModel( "maskedbreen", "models/player/Sunabouzu.mdl" )
AddPlayerModel( "zoey", "models/player/zoey.mdl" )
AddPlayerModel( "sniper", "models/player/robber.mdl" )
AddPlayerModel( "spacesuit", "models/player/spacesuit.mdl" )
AddPlayerModel( "scarecrow", "models/player/scarecrow.mdl" )
AddPlayerModel( "smith", "models/player/smith.mdl" )
AddPlayerModel( "libertyprime", "models/player/sam.mdl" )
AddPlayerModel( "rpcop", "models/player/azuisleet1.mdl" )
AddPlayerModel( "altair", "models/player/altair.mdl" )
AddPlayerModel( "dinosaur", "models/player/foohysaurusrex.mdl" )
AddPlayerModel( "rorschach", "models/player/rorschach.mdl" )
AddPlayerModel( "aphaztech", "models/player/aphaztech.mdl" )
AddPlayerModel( "faith", "models/player/faith.mdl" )
AddPlayerModel( "robot", "models/player/robot.mdl" )
AddPlayerModel( "niko", "models/player/niko.mdl" )
AddPlayerModel( "zelda", "models/player/zelda.mdl" )
AddPlayerModel( "dude", "models/player/dude.mdl" )
AddPlayerModel( "leon", "models/player/leon.mdl" )
AddPlayerModel( "chris", "models/player/chris.mdl" )
AddPlayerModel( "gmen", "models/player/gmen.mdl" )
AddPlayerModel( "joker", "models/player/joker.mdl" )
AddPlayerModel( "hunter", "models/player/hunter.mdl" )
AddPlayerModel( "steve", "models/player/mcsteve.mdl" )
AddPlayerModel( "gordon", "models/player/gordon.mdl" )
AddPlayerModel( "masseffect", "models/player/masseffect.mdl" )
AddPlayerModel( "scorpion", "models/player/scorpion.mdl" )
AddPlayerModel( "subzero", "models/player/subzero.mdl" )
AddPlayerModel( "undeadcombine", "models/player/clopsy.mdl" )
AddPlayerModel( "boxman", "models/player/nuggets.mdl" )
AddPlayerModel( "classygentleman", "models/player/macdguy.mdl" )
AddPlayerModel( "rayman", "models/player/rayman.mdl" )
AddPlayerModel( "raz", "models/player/raz.mdl" )
AddPlayerModel( "knight", "models/player/knight.mdl" )
AddPlayerModel( "bobafett", "models/player/bobafett.mdl" )
AddPlayerModel( "chewbacca", "models/player/chewbacca.mdl" )
AddPlayerModel( "assassin", "models/player/dishonored_assassin1.mdl" )
AddPlayerModel( "haroldlott", "models/player/haroldlott.mdl" )
AddPlayerModel( "harry_potter", "models/player/harry_potter.mdl" )
AddPlayerModel( "jack_sparrow", "models/player/jack_sparrow.mdl" )
AddPlayerModel( "jawa", "models/player/jawa.mdl" )
AddPlayerModel( "marty", "models/player/martymcfly.mdl" )
AddPlayerModel( "samuszero", "models/player/samusz.mdl" )
AddPlayerModel( "skeleton", "models/player/skeleton.mdl" )
AddPlayerModel( "stormtrooper", "models/player/stormtrooper.mdl" )
AddPlayerModel( "luigi", "models/player/suluigi_galaxy.mdl" )
AddPlayerModel( "mario", "models/player/sumario_galaxy.mdl" )
AddPlayerModel( "zero", "models/player/lordvipes/MMZ/Zero/zero_playermodel_cvp.mdl" )
AddPlayerModel( "yoshi", "models/player/yoshi.mdl" )
AddPlayerModel( "grayfox", "models/player/lordvipes/Metal_Gear_Rising/gray_fox_playermodel_cvp.mdl" )
AddPlayerModel( "crimsonlance", "models/player/lordvipes/bl_clance/crimsonlanceplayer.mdl", "models/player/lordvipes/bl_clance/Arms/crimsonlanceamrs.mdl" )
AddPlayerModel( "walterwhite", "models/Agent_47/agent_47.mdl" )
AddPlayerModel( "jackskellington", "models/vinrax/player/Jack_player.mdl", "models/vinrax/weapons/c_arms_jack.mdl" )
AddPlayerModel( "deadpool", "models/player/deadpool.mdl" )
AddPlayerModel( "deathstroke", "models/norpo/ArkhamOrigins/Assassins/Deathstroke_ValveBiped.mdl", "models/norpo/ArkhamOrigins/Assassins/Viewmodel/Deathstroke_ValveBiped_HandModel.mdl" )
AddPlayerModel( "carley", "models/nikout/carleypm.mdl" )
AddPlayerModel( "solidsnake", "models/player/big_boss.mdl", "models/player/big_boss_hands.mdl" )
AddPlayerModel( "tronanon", "models/player/anon/anon.mdl", "models/weapons/arms/anon_arms.mdl" )
AddPlayerModel( "alice", "models/player/alice.mdl" )
AddPlayerModel( "windrunner", "models/heroes/windrunner/windrunner.mdl", "models/heroes/windrunner/c_arms_windrunner.mdl" )
AddPlayerModel( "ash", "models/player/red.mdl" )
AddPlayerModel( "megaman", "models/vinrax/player/megaman64_no_gun_player.mdl" )
AddPlayerModel( "kilik", "models/player/hhp227/kilik.mdl" )
AddPlayerModel( "bond", "models/player/bond.mdl" )
AddPlayerModel( "ironman", "models/Avengers/Iron Man/mark7_player.mdl" )
AddPlayerModel( "masterchief", "models/player/lordvipes/haloce/spartan_classic.mdl" )
AddPlayerModel( "doomguy", "models/ex-mo/quake3/players/doom.mdl" )
AddPlayerModel( "freddykruger", "models/player/freddykruger.mdl" )
AddPlayerModel( "greenarrow", "models/player/greenarrow.mdl" )
AddPlayerModel( "linktp", "models/player/linktp.mdl" )
AddPlayerModel( "roman", "models/player/romanbellic.mdl" )

AddPlayerModel( "XV Global Occult Coalition", "models/player/xuvon/xuvon_goc_re_base.mdl", "models/weapons/xuvon/xuvon_goc_re_arms.mdl" )

AddPlayerModel( "Gordon Ramsay", "models/dannio/noahg/gordonramsay.mdl" )

AddPlayerModel( "Juggernaut", "models/gta5/juggernautpm.mdl", "models/weapons/c_arms_combine.mdl" )

AddPlayerModel( "Russian Mafia 02", "models/hotlinemiami/russianmafia/mafia02pm.mdl" )
AddPlayerModel( "Russian Mafia 04", "models/hotlinemiami/russianmafia/mafia04pm.mdl" )
AddPlayerModel( "Russian Mafia 06", "models/hotlinemiami/russianmafia/mafia06pm.mdl" )
AddPlayerModel( "Russian Mafia 07", "models/hotlinemiami/russianmafia/mafia07pm.mdl" )
AddPlayerModel( "Russian Mafia 08", "models/hotlinemiami/russianmafia/mafia08pm.mdl" )
AddPlayerModel( "Russian Mafia 09", "models/hotlinemiami/russianmafia/mafia09pm.mdl" )

AddPlayerModel( "Javier Milei", "models/argentina/javier_milei.mdl", "models/argentina/c_arms.mdl" )

AddPlayerModel( "Miner", "models/player/miner_m.mdl" )
AddPlayerModel( "Minerf", "models/player/miner_f.mdl" )

AddPlayerModel( "Mortal Kombat - Baby", "models/player/dewobedil/mortal_kombat/baby_default_p.mdl", "models/player/dewobedil/mortal_kombat/c_arms/baby_default_p.mdl" )

AddPlayerModel( "Moxxie_Helluvaboss", "models/custom/cmankarthecat/helluvaboss/moxxie_pm.mdl", "models/custom/cmankarthecat/helluvaboss/moxxie_arms.mdl" )

AddPlayerModel( "PMC1_01", "models/player/PMC_1/PMC__01.mdl" )
AddPlayerModel( "PMC1_02", "models/player/PMC_1/PMC__02.mdl" )
AddPlayerModel( "PMC1_03", "models/player/PMC_1/PMC__03.mdl" )
AddPlayerModel( "PMC1_04", "models/player/PMC_1/PMC__04.mdl" )
AddPlayerModel( "PMC1_05", "models/player/PMC_1/PMC__05.mdl" )
AddPlayerModel( "PMC1_06", "models/player/PMC_1/PMC__06.mdl" )
AddPlayerModel( "PMC1_07", "models/player/PMC_1/PMC__07.mdl" )
AddPlayerModel( "PMC1_08", "models/player/PMC_1/PMC__08.mdl" )
AddPlayerModel( "PMC1_09", "models/player/PMC_1/PMC__09.mdl" )
AddPlayerModel( "PMC1_10", "models/player/PMC_1/PMC__10.mdl" )
AddPlayerModel( "PMC1_11", "models/player/PMC_1/PMC__11.mdl" )
AddPlayerModel( "PMC1_12", "models/player/PMC_1/PMC__12.mdl" )
AddPlayerModel( "PMC1_13", "models/player/PMC_1/PMC__13.mdl" )
AddPlayerModel( "PMC1_14", "models/player/PMC_1/PMC__14.mdl" )
AddPlayerModel( "PMC2_01", "models/player/PMC_2/PMC__01.mdl" )
AddPlayerModel( "PMC2_02", "models/player/PMC_2/PMC__02.mdl" )
AddPlayerModel( "PMC2_03", "models/player/PMC_2/PMC__03.mdl" )
AddPlayerModel( "PMC2_04", "models/player/PMC_2/PMC__04.mdl" )
AddPlayerModel( "PMC2_05", "models/player/PMC_2/PMC__05.mdl" )
AddPlayerModel( "PMC2_06", "models/player/PMC_2/PMC__06.mdl" )
AddPlayerModel( "PMC2_07", "models/player/PMC_2/PMC__07.mdl" )
AddPlayerModel( "PMC2_08", "models/player/PMC_2/PMC__08.mdl" )
AddPlayerModel( "PMC2_09", "models/player/PMC_2/PMC__09.mdl" )
AddPlayerModel( "PMC2_10", "models/player/PMC_2/PMC__10.mdl" )
AddPlayerModel( "PMC2_11", "models/player/PMC_2/PMC__11.mdl" )
AddPlayerModel( "PMC2_12", "models/player/PMC_2/PMC__12.mdl" )
AddPlayerModel( "PMC2_13", "models/player/PMC_2/PMC__13.mdl" )
AddPlayerModel( "PMC2_14", "models/player/PMC_2/PMC__14.mdl" )
AddPlayerModel( "PMC3_01", "models/player/PMC_3/PMC__01.mdl" )
AddPlayerModel( "PMC3_02", "models/player/PMC_3/PMC__02.mdl" )
AddPlayerModel( "PMC3_03", "models/player/PMC_3/PMC__03.mdl" )
AddPlayerModel( "PMC3_04", "models/player/PMC_3/PMC__04.mdl" )
AddPlayerModel( "PMC3_05", "models/player/PMC_3/PMC__05.mdl" )
AddPlayerModel( "PMC3_06", "models/player/PMC_3/PMC__06.mdl" )
AddPlayerModel( "PMC3_07", "models/player/PMC_3/PMC__07.mdl" )
AddPlayerModel( "PMC3_08", "models/player/PMC_3/PMC__08.mdl" )
AddPlayerModel( "PMC3_09", "models/player/PMC_3/PMC__09.mdl" )
AddPlayerModel( "PMC3_10", "models/player/PMC_3/PMC__10.mdl" )
AddPlayerModel( "PMC3_11", "models/player/PMC_3/PMC__11.mdl" )
AddPlayerModel( "PMC3_12", "models/player/PMC_3/PMC__12.mdl" )
AddPlayerModel( "PMC3_13", "models/player/PMC_3/PMC__13.mdl" )
AddPlayerModel( "PMC3_14", "models/player/PMC_3/PMC__14.mdl" )
AddPlayerModel( "PMC4_01", "models/player/PMC_4/PMC__01.mdl" )
AddPlayerModel( "PMC4_02", "models/player/PMC_4/PMC__02.mdl" )
AddPlayerModel( "PMC4_03", "models/player/PMC_4/PMC__03.mdl" )
AddPlayerModel( "PMC4_04", "models/player/PMC_4/PMC__04.mdl" )
AddPlayerModel( "PMC4_05", "models/player/PMC_4/PMC__05.mdl" )
AddPlayerModel( "PMC4_06", "models/player/PMC_4/PMC__06.mdl" )
AddPlayerModel( "PMC4_07", "models/player/PMC_4/PMC__07.mdl" )
AddPlayerModel( "PMC4_08", "models/player/PMC_4/PMC__08.mdl" )
AddPlayerModel( "PMC4_09", "models/player/PMC_4/PMC__09.mdl" )
AddPlayerModel( "PMC4_10", "models/player/PMC_4/PMC__10.mdl" )
AddPlayerModel( "PMC4_11", "models/player/PMC_4/PMC__11.mdl" )
AddPlayerModel( "PMC4_12", "models/player/PMC_4/PMC__12.mdl" )
AddPlayerModel( "PMC4_13", "models/player/PMC_4/PMC__13.mdl" )
AddPlayerModel( "PMC4_14", "models/player/PMC_4/PMC__14.mdl" )
AddPlayerModel( "PMC5_01", "models/player/PMC_5/PMC__01.mdl" )
AddPlayerModel( "PMC5_02", "models/player/PMC_5/PMC__02.mdl" )
AddPlayerModel( "PMC5_03", "models/player/PMC_5/PMC__03.mdl" )
AddPlayerModel( "PMC5_04", "models/player/PMC_5/PMC__04.mdl" )
AddPlayerModel( "PMC5_05", "models/player/PMC_5/PMC__05.mdl" )
AddPlayerModel( "PMC5_06", "models/player/PMC_5/PMC__06.mdl" )
AddPlayerModel( "PMC5_07", "models/player/PMC_5/PMC__07.mdl" )
AddPlayerModel( "PMC5_08", "models/player/PMC_5/PMC__08.mdl" )
AddPlayerModel( "PMC5_09", "models/player/PMC_5/PMC__09.mdl" )
AddPlayerModel( "PMC5_10", "models/player/PMC_5/PMC__10.mdl" )
AddPlayerModel( "PMC5_11", "models/player/PMC_5/PMC__11.mdl" )
AddPlayerModel( "PMC5_12", "models/player/PMC_5/PMC__12.mdl" )
AddPlayerModel( "PMC5_13", "models/player/PMC_5/PMC__13.mdl" )
AddPlayerModel( "PMC5_14", "models/player/PMC_5/PMC__14.mdl" )
AddPlayerModel( "PMC6_01", "models/player/PMC_6/PMC__01.mdl" )
AddPlayerModel( "PMC6_02", "models/player/PMC_6/PMC__02.mdl" )
AddPlayerModel( "PMC6_03", "models/player/PMC_6/PMC__03.mdl" )
AddPlayerModel( "PMC6_04", "models/player/PMC_6/PMC__04.mdl" )
AddPlayerModel( "PMC6_05", "models/player/PMC_6/PMC__05.mdl" )
AddPlayerModel( "PMC6_06", "models/player/PMC_6/PMC__06.mdl" )
AddPlayerModel( "PMC6_07", "models/player/PMC_6/PMC__07.mdl" )
AddPlayerModel( "PMC6_08", "models/player/PMC_6/PMC__08.mdl" )
AddPlayerModel( "PMC6_09", "models/player/PMC_6/PMC__09.mdl" )
AddPlayerModel( "PMC6_10", "models/player/PMC_6/PMC__10.mdl" )
AddPlayerModel( "PMC6_11", "models/player/PMC_6/PMC__11.mdl" )
AddPlayerModel( "PMC6_12", "models/player/PMC_6/PMC__12.mdl" )
AddPlayerModel( "PMC6_13", "models/player/PMC_6/PMC__13.mdl" )
AddPlayerModel( "PMC6_14", "models/player/PMC_6/PMC__14.mdl" )

AddPlayerModel( "Police Chicago 1", "models/kerry/player/police_chicago_01.mdl" )
AddPlayerModel( "Police Chicago 2", "models/kerry/player/police_chicago_02.mdl" )
AddPlayerModel( "Police Chicago 3", "models/kerry/player/police_chicago_03.mdl" )
AddPlayerModel( "Police Chicago 4", "models/kerry/player/police_chicago_04.mdl" )
AddPlayerModel( "Police Chicago 5", "models/kerry/player/police_chicago_05.mdl" )
AddPlayerModel( "Police Chicago 6", "models/kerry/player/police_chicago_06.mdl" )
AddPlayerModel( "Police Chicago 7", "models/kerry/player/police_chicago_07.mdl" )
AddPlayerModel( "Police Chicago 8", "models/kerry/player/police_chicago_08.mdl" )
AddPlayerModel( "Police Chicago 9", "models/kerry/player/police_chicago_09.mdl" )

AddPlayerModel( "Policia Municipal", "models/player/jackbauer.mdl" )

AddPlayerModel( "PUTIN", "models/player/putin.mdl", "models/player/putin_arms.mdl" )

AddPlayerModel( "robberplayer", "models/code_gs/robber/robberplayer.mdl", "models/weapons/c_arms_cstrike.mdl" )

AddPlayerModel( "Bloodz 1", "models/player/bloodz/slow_1.mdl" )
AddPlayerModel( "Bloodz 2", "models/player/bloodz/slow_2.mdl" )
AddPlayerModel( "Bloodz 3", "models/player/bloodz/slow_3.mdl" )
AddPlayerModel( "Cripz 1", "models/player/cripz/slow_1.mdl" )
AddPlayerModel( "Cripz 2", "models/player/cripz/slow_2.mdl" )
AddPlayerModel( "Cripz 3", "models/player/cripz/slow_3.mdl" )
AddPlayerModel( "Hans Grosse", "models/player/hans_grosse/slow.mdl" )
AddPlayerModel( "Zombie Hans Grosse", "models/player/hans_grosse/slow_zombie.mdl" )
AddPlayerModel( "Elvis", "models/player/elvis_fix/t_leet.mdl" )
AddPlayerModel( "Hitler", "models/player/hitler/hitler.mdl" )
AddPlayerModel( "Niko Bellic", "models/player/niko_bellic/slow.mdl" )
AddPlayerModel( "Pink Soldier", "models/player/pink_soldier_fix/ct_urban.mdl" )
AddPlayerModel( "Polizei", "models/player/polizei/ct_gsg9.mdl" )
AddPlayerModel( "Specnaz", "models/player/specnaz/slow_specnaz.mdl" )
AddPlayerModel( "Trenchcoat", "models/player/trenchcoat/slow.mdl" )
AddPlayerModel( "Umbrella Soldier", "models/player/umbrella_ct/umbrella_ct.mdl" )
AddPlayerModel( "Vin Diesel", "models/player/vin_diesel/slow.mdl" )
AddPlayerModel( "VIP G-Man", "models/player/vip/slow_vip.mdl" )
AddPlayerModel( "Zeus Admin", "models/player/zeus_combine_v2/zeus_combine_v2.mdl" )
AddPlayerModel( "c3po", "models/player/b4p_c3po_remake/slow_c3po.mdl" )

AddPlayerModel( "Batman", "models/player/superheroes/batman.mdl" )
AddPlayerModel( "Superman", "models/player/superheroes/superman.mdl" )
AddPlayerModel( "Green Lantern", "models/player/superheroes/greenlantern.mdl" )
AddPlayerModel( "Flash", "models/player/superheroes/flash.mdl" )

AddPlayerModel( "SWAT_1", "models/player/kerry/swat_ls.mdl" )
AddPlayerModel( "SWAT_2", "models/player/kerry/swat_ls_2.mdl" )

AddPlayerModel( "Tommy Vercetti", "models/player/tommy_vercetti.mdl" )
