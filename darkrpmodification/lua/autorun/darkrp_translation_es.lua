local hl = GetConVar( "gmod_language" ):GetString()

local function PreGamemodeLoaded()
	if hl=="es-ES" then
		local ListWeapon = list.GetForEdit( "Weapon" )
		local function TranslateWeaponName( class, PrintName )
			local SWEP = weapons.GetStored( class )
			if SWEP then
				SWEP.PrintName = PrintName
				weapons.Register( SWEP, class )
			elseif ListWeapon[class] then
				ListWeapon[class].PrintName = PrintName
			end
		end
		local ListEntity = list.GetForEdit( "SpawnableEntities" )
		local function TranslateEntityName( class, PrintName )
			local ENT = scripted_ents.GetStored( class )
			if ENT then
				ENT = ENT.t
				ENT.PrintName = PrintName
				scripted_ents.Register( ENT, class )
			elseif ListEntity[class] then
				ListEntity[class].PrintName = PrintName
			end
		end
		local ListVehicle = list.GetForEdit( "Vehicles" )
		local function TranslateVehicleName( identifier, PrintName )
			if ListVehicle[identifier] then
				ListVehicle[identifier].Name = PrintName
			end
		end
		-- DarkRP
		TranslateWeaponName( "arrest_stick", "Palo de arresto" )
		TranslateWeaponName( "door_ram", "Ariete" )
		TranslateWeaponName( "keys", "Llaves" )
		TranslateWeaponName( "lockpick", "Ganzua" )
		TranslateWeaponName( "ls_sniper", "Francotirador silencioso" )
		TranslateWeaponName( "med_kit", "Equipo médico" )
		TranslateWeaponName( "pocket", "Bolsillo" )
		TranslateWeaponName( "stunstick", "Bastón eléctrico" )
		TranslateWeaponName( "unarrest_stick", "Palo de libertad" )
		TranslateWeaponName( "weapon_keypadchecker", "Controlador de Keypads" )
		TranslateWeaponName( "weapon_pumpshotgun2", "Escopeta" )
		TranslateWeaponName( "weaponchecker", "Controlador de armas" )
		-- Sandbox
		TranslateWeaponName( "gmod_tool", "Pistola de herramientas" )
		TranslateWeaponName( "gmod_camera", "Cámara" )
		TranslateWeaponName( "manhack_welder", "Pistola de Manhacks" )
		TranslateEntityName( "edit_sun", "Editor de sol" )
		TranslateEntityName( "edit_sky", "Editor de cielo" )
		TranslateEntityName( "edit_fog", "Editor de niebla" )
		-- Garry's Mod
		TranslateEntityName( "sent_ball", "Pelota que rebota" )
		TranslateWeaponName( "weapon_physgun", "Physics Gun" )
		TranslateWeaponName( "weapon_fists", "Puños" )
		TranslateWeaponName( "weapon_medkit", "Equipo médico" )
		TranslateWeaponName( "weapon_flechettegun", "Pistola de dardos" )
		TranslateVehicleName( "Jeep", "Calesa" )
		TranslateVehicleName( "Airboat", "Hidrodeslizador" )
		TranslateVehicleName( "Pod", "Cápsula" )
		TranslateVehicleName( "Jalopy", "Cacharro" )
		TranslateVehicleName( "Chair_Wood", "Silla de madera" )
		TranslateVehicleName( "Chair_Plastic", "Silla de plástico" )
		TranslateVehicleName( "Seat_Jeep", "Asiento de Jeep" )
		TranslateVehicleName( "Seat_Airboat", "Asiento de hidrodeslizador" )
		TranslateVehicleName( "Chair_Office1", "Silla de oficina" )
		TranslateVehicleName( "Chair_Office2", "Silla de oficina grande" )
		TranslateVehicleName( "Seat_Jalopy", "Asiento de cacharro" )
		TranslateVehicleName( "phx_seat", "Asiento de coche" )
		TranslateVehicleName( "phx_seat2", "Asiento de coche 2" )
		TranslateVehicleName( "phx_seat3", "Asiento de coche 3" )
		-- Half-Life 2
		TranslateWeaponName( "weapon_357", "Magnum 357" )
		TranslateWeaponName( "weapon_ar2", "Fusil de pulso" )
		TranslateWeaponName( "weapon_bugbait", "Ferópodo" )
		TranslateWeaponName( "weapon_crossbow", "Ballesta" )
		TranslateWeaponName( "weapon_crowbar", "Palanca" )
		TranslateWeaponName( "weapon_physcannon", "Pistola antigravedad" )
		TranslateWeaponName( "weapon_frag", "Granada de fragmentación" )
		TranslateWeaponName( "weapon_pistol", "Pistola 9mm" )
		TranslateWeaponName( "weapon_rpg", "Lanzacohetes" )
		TranslateWeaponName( "weapon_shotgun", "Escopeta" )
		TranslateWeaponName( "weapon_slam", "Mina de control remoto" )
		TranslateWeaponName( "weapon_smg1", "Ametralladora" )
		TranslateWeaponName( "weapon_stunstick", "Bastón eléctrico" )
		TranslateEntityName( "item_ammo_ar2", "Municiones de impulso" ) --"Munitions d'Impulsion"
		TranslateEntityName( "item_ammo_pistol", "Munición de pistola" ) --"Munitions de Pistolet"
		TranslateEntityName( "item_box_buckshot", "Munición de escopeta" ) --"Munitions de Fusil à Pompe"
		TranslateEntityName( "item_ammo_357", "Municiones 357" ) --"Munitions 357"
		TranslateEntityName( "item_ammo_smg1", "Munición SMG" ) --"Munitions de FM"
		TranslateEntityName( "item_ammo_ar2_altfire", "Esfera Combine" ) --"Boule de Combine"
		TranslateEntityName( "item_ammo_crossbow", "Rollos de ballesta" ) --"Rouleaux d'Arbalète"
		TranslateEntityName( "item_ammo_smg1_grenade", "Granada de SMG" ) --"Grenade de FM"
		TranslateEntityName( "item_rpg_round", "Misil" ) --"Roquette"
		TranslateEntityName( "item_battery", "Batería de traje HEV" ) --"Batterie de Combinaison"
		TranslateEntityName( "item_healthvial", "Vial de Salud" ) --"Fiole de Santé"
		TranslateEntityName( "item_healthkit", "Equipamiento de Salud" ) --"Équipement de Santé"
		TranslateEntityName( "item_suitcharger", "Cargador de traje HEV" ) --"Chargeur de Combinaison"
		TranslateEntityName( "item_healthcharger", "Cargador de salud" ) --"Chargeur de Santé"
		TranslateEntityName( "item_suit", "Traje HEV" ) --"Combinaison"
		TranslateEntityName( "prop_thumper", "Restrictor" ) --"Frappeur violent"
		TranslateEntityName( "combine_mine", "Mina de Combine" ) --"Mine de Combine"
		TranslateEntityName( "grenade_helicopter", "Granada de helicóptero" ) --"Grenade d'Hélicoptère"
		TranslateEntityName( "npc_grenade_frag", "Granada de zombi" ) --"Grenade de Zombine"
		TranslateEntityName( "weapon_striderbuster", "Magnuson" ) --"Magnusson"
	end
end
hook.Add( "PreGamemodeLoaded", "darkrp_translation_es", PreGamemodeLoaded )

local function DarkRPFinishedLoading()
	if DarkRP then
		if DarkRP.addLanguage then
			DarkRP.addLanguage( "es-ES", {
				-- Admin things
                need_admin = "Necesita privilegios de administrador para poder %s",
                need_sadmin = "Necesita privilegios de superadministrador para poder %s",
                no_privilege = "No tiene los privilegios adecuados para realizar esta acción",
                no_jail_pos = "No jail position",
                invalid_x = "¡%s no válido! %s",
            
                -- F1 menu
                f1ChatCommandTitle = "Comandos de chat",
                f1Search = "Búsqueda...",
            
                -- Money things:
                price = "Precio: %s%d",
                priceTag = "Precio: %s",
                reset_money = "¡%s ha restablecido el dinero de todos los jugadores!",
                has_given = "%s te ha dado %s",
                you_gave = "Le diste a %s %s",
                npc_killpay = "¡%s por matar a un NPC!",
                profit = "lucro",
                loss = "pérdida",
                Donate = "Donar",
                you_donated = "¡Has donado %s a %s!",
                has_donated = "¡%s ha donado %s!",
            
                -- backwards compatibility
                deducted_x = "Deducido %s%d",
                need_x = "Necesito %s%d",
            
                deducted_money = "Deducido %s",
                need_money = "Necesitas %s",
            
                payday_message = "¡Día de pago! ¡Recibiste %s!",
                payday_unemployed = "¡No recibiste salario porque estás desempleado!",
                payday_missed = "¡Día de pago perdido! (Estás arrestado)",
            
                property_tax = "¡Impuesto a la propiedad! %s",
                property_tax_cant_afford = "¡No pudiste pagar los impuestos! ¡Te han quitado tu propiedad!",
                taxday = "¡Día de impuestos! ¡Se tomaron %s%% de sus ingresos!",
            
                found_cheque = "Ha encontrado %s%s en un cheque a su nombre de %s.",
                cheque_details = "Este cheque está a nombre de %s.",
                cheque_torn = "Has roto el cheque.",
                cheque_pay = "Pagar: %s",
                signed = "Firmado: %s",
            
                found_cash = "¡Has recogido %s%d!", -- compatibilidad con versiones anteriores
                found_money = "¡Has recogido a %s!",
            
                owner_poor = "¡El propietario de %s es demasiado pobre para subvencionar esta venta!",
            
                -- Police
                Wanted_text = "¡Querido!",
                wanted = "¡Buscado por la policía!\nRazón: %s",
                youre_arrested = "Ha sido arrestado. Tiempo restante: ¡%d segundos!",
                youre_arrested_by = "Has sido arrestado por %s.",
                youre_unarrested_by = "Has sido liberado por %s.",
                hes_arrested = "¡%s ha sido arrestado por %d segundos!",
                hes_unarrested = "¡%s ha sido liberado de la cárcel!",
                warrant_ordered = "%s ordenó una orden de allanamiento para %s. Motivo: %s",
                warrant_request = "%s solicita una orden de allanamiento para %s\nMotivo: %s",
                warrant_request2 = "¡Solicitud de orden de allanamiento enviada al presidente %s!",
                warrant_approved = "Orden de búsqueda aprobada para %s!\nMotivo: %s\nOrdenado por: %s",
                warrant_approved2 = "Ahora puedes registrar su casa.",
                warrant_denied = "El presidente %s ha denegado su solicitud de orden de allanamiento.",
                warrant_expired = "¡La orden de registro de %s ha expirado!",
                warrant_required = "Necesitas una orden para poder abrir esta puerta.",
                warrant_required_unfreeze = "Necesitas una orden judicial para poder descongelar este objeto.",
                warrant_required_unweld = "Necesitas una orden judicial para poder desoldar este puntal.",
                wanted_by_police = "¡%s es buscado por la policía!\nMotivo: %s\nOrdenado por: %s",
                wanted_by_police_print = "%s ha hecho que %s sea buscado, motivo: %s",
                wanted_expired = "%s ya no es buscado por la policía.",
                wanted_revoked = "%s ya no es buscado por la policía.\nRevocado por: %s",
                cant_arrest_other_cp = "¡No puedes arrestar a otros CP!",
                must_be_wanted_for_arrest = "El jugador debe ser buscado para poder arrestarlo",
                cant_arrest_fadmin_jailed = "No puedes arrestar a un jugador que ha sido encarcelado por un administrador.",
                cant_arrest_no_jail_pos = "¡No puedes arrestar a la gente ya que no hay puestos en la cárcel establecidos!",
                cant_arrest_spawning_players = "No puedes arrestar a los jugadores que están apareciendo.",
            
                suspect_doesnt_exist = "El sospechoso no existe.",
                actor_doesnt_exist = "El actor no existe.",
                get_a_warrant = "obtener una orden judicial",
                remove_a_warrant = "eliminar una orden judicial",
                make_someone_wanted = "hacer que alguien quisiera",
                remove_wanted_status = "eliminar estado buscado",
                already_a_warrant = "Ya hay una orden de allanamiento para este sospechoso.",
                not_warranted = "No hay orden de allanamiento para esta persona.",
                already_wanted = "El sospechoso ya es buscado.",
                not_wanted = "El sospechoso no es buscado.",
                need_to_be_cp = "Tienes que ser miembro de la fuerza policial.",
                suspect_must_be_alive_to_do_x = "El sospechoso debe estar vivo para %s.",
                suspect_already_arrested = "El sospechoso ya está en la cárcel.",
            
                -- Players
                health = "Salud: %s",
                job = "Trabajo: %s",
                salary = "Salario: %s%s",
                wallet = "Monedero: %s%s",
                weapon = "Arma: %s",
                kills = "Muertes: %s",
                deaths = "Muertes: %s",
                rpname_changed = "%s cambió su RPName a: %s",
                disconnected_player = "Jugador desconectado",
                player = "jugador",
            
                -- Teams
                need_to_be_before = "Necesitas ser %s primero para poder convertirte en %s",
                need_to_make_vote = "¡Tienes que votar para convertirte en %s!",
                team_limit_reached = "No se puede convertir en %s porque se alcanzó el límite",
                wants_to_be = "%s\nquiere ser\n%s",
                has_not_been_made_team = "¡%s no se ha hecho %s!",
                job_has_become = "¡%s se ha convertido en %s!",
            
                -- Disasters
                meteor_approaching = "ADVERTENCIA: ¡Se acerca una tormenta de meteoritos!",
                meteor_passing = "Tormenta de meteoritos pasando.",
                meteor_enabled = "Las tormentas de meteoritos ahora están habilitadas.",
                meteor_disabled = "Las tormentas de meteoritos ahora están deshabilitadas.",
                earthquake_report = "Reportan sismo de magnitud %sMw",
                earthtremor_report = "Reportan temblor de tierra de magnitud %sMw",
            
                -- Keys, vehicles and doors
                keys_allowed_to_coown = "Puedes ser copropietario de esto\n(Presiona Recargar con las teclas o presiona F2 para ser copropietario)\n",
                keys_other_allowed = "Permitido ser copropietario:",
                keys_allow_ownership = "(Presione Recargar con las teclas o presione F2 para permitir la propiedad)",
                keys_disallow_ownership = "(Presione Recargar con las teclas o presione F2 para no permitir la propiedad)",
                keys_owned_by = "Propiedad de:",
                keys_unowned = "Sin propietario\n(Presione Recargar con las teclas o presione F2 para poseer)",
                keys_everyone = "(Presione Recargar con las teclas o presione F2 para habilitar para todos)",
                door_unown_arrested = "¡No puedes poseer o desposeer cosas mientras estás detenido!",
                door_unownable = "¡Esta puerta no puede tener o no tener dueño!",
                door_sold = "Has vendido esto por %s",
                door_already_owned = "¡Esta puerta ya es propiedad de alguien!",
                door_cannot_afford = "¡No puedes permitirte esta puerta!",
                door_hobo_unable = "¡No puedes comprar una puerta si eres un vagabundo!",
                vehicle_cannot_afford = "¡No puedes permitirte este vehículo!",
                door_bought = "Has comprado esta puerta para %s%s",
                vehicle_bought = "Has comprado este vehículo por %s%s",
                door_need_to_own = "Necesitas ser el dueño de esta puerta para poder %s",
                door_rem_owners_unownable = "¡No puede eliminar propietarios si una puerta no se puede poseer!",
                door_add_owners_unownable = "¡No puede agregar propietarios si una puerta no es propiedad!",
                rp_addowner_already_owns_door = "¡%s ya posee (o ya tiene permitido poseer) esta puerta!",
                add_owner = "Añadir propietario",
                remove_owner = "Eliminar propietario",
                coown_x = "Copropietario %s",
                allow_ownership = "Permitir propiedad",
                disallow_ownership = "Rechazar la propiedad",
                edit_door_group = "Editar grupo de puertas",
                door_groups = "Grupos de puertas",
                door_group_doesnt_exist = "¡El grupo de puertas no existe!",
                door_group_set = "Grupo de puertas establecido con éxito.",
                sold_x_doors_for_y = "¡Ha vendido %d puertas por %s%d!", -- compatibilidad con versiones anteriores
                sold_x_doors = "¡Has vendido %d puertas por %s!",
            
                -- Entities
                drugs = "drogas",
                Drugs = "drogas",
                drug_lab = "Laboratorio de drogas",
                gun_lab = "Laboratorio de armas",
                any_lab = "cualquier laboratorio",
                gun = "pistola",
                microwave = "Microondas",
                food = "alimento",
                Food = "Alimento",
                money_printer = "Impresora de dinero",
                tip_jar = "Tarro de propinas",
            
                sign_this_letter = "Firma esta carta",
                signed_yours = "Tuya,",
            
                money_printer_exploded = "¡Tu impresora de dinero ha explotado!",
                money_printer_overheating = "¡Tu impresora de dinero se está sobrecalentando!",
            
                contents = "Contenido: ",
                amount = "Monto: ",
            
                picking_lock = "ganzando cerradura",
            
                cannot_pocket_x = "¡No puedes poner esto en tu bolsillo!",
                object_too_heavy = "Este objeto es demasiado pesado.",
                pocket_full = "¡Tu bolsillo está lleno!",
                pocket_no_items = "Tu bolsillo no contiene artículos.",
                drop_item = "Elemento descartado",
            
                bonus_destroying_entity = "destruyendo esta entidad ilegal.",
            
                switched_burst = "Cambiado al modo de disparo en ráfaga.",
                switched_fully_auto = "Cambiado al modo de disparo totalmente automático.",
                switched_semi_auto = "Cambiado a modo de disparo semiautomático.",
            
                keypad_checker_shoot_keypad = "Dispara a un teclado para ver qué controla.",
                keypad_checker_shoot_entity = "Dispara a una entidad para ver qué teclados están conectados a ella",
                keypad_checker_click_to_clear = "Haz clic derecho para borrar.",
                keypad_checker_entering_right_pass = "Ingresando la contraseña correcta",
                keypad_checker_entering_wrong_pass = "Ingresando la contraseña incorrecta",
                keypad_checker_after_right_pass = "después de haber ingresado la contraseña correcta",
                keypad_checker_after_wrong_pass = "después de haber ingresado la contraseña incorrecta",
                keypad_checker_right_pass_entered = "Contraseña correcta ingresada",
                keypad_checker_wrong_pass_entered = "Se ingresó una contraseña incorrecta",
                keypad_checker_controls_x_entities = "Este teclado controla %d entidades",
                keypad_checker_controlled_by_x_keypads = "Esta entidad está controlada por %d teclados",
                keypad_on = "ACTIVADO",
                keypad_off = "APAGADO",
                seconds = "segundos",
            
                persons_weapons = "Armas ilegales de %s:",
                returned_persons_weapons = "Se devolvieron las armas confiscadas de %s.",
                no_weapons_confiscated = "¡A %s no se le confiscaron armas!",
                no_illegal_weapons = "%s no tenía armas ilegales.",
                confiscated_these_weapons = "Confiscado estas armas:",
                checking_weapons = "Decomiso de armas",
            
                shipment_antispam_wait = "Por favor, espere antes de generar otro envío.",
                createshipment = "Crear un envío",
                splitshipment = "Dividir este envío",
                shipment_cannot_split = "No se puede dividir este envío.",
            
                -- Talking
                hear_noone = "¡Nadie puede oírte %s!",
                hear_everyone = "¡Todos pueden oírte!",
                hear_certain_persons = "Jugadores que pueden oírte %s: ",
            
                whisper = "susurro",
                yell = "gritar",
                broadcast = "[¡Transmisión!]",
                radio = "radio",
                request = "(¡SOLICITUD!)",
                group = "(grupo)",
                demote = "(DEGRADAR)",
                ooc = "OOC",
                radio_x = "Radio %d",
            
                talk = "hablar",
                speak = "hablar",
            
                speak_in_ooc = "hablar en OOC",
                perform_your_action = "realiza tu acción",
                talk_to_your_group = "habla con tu grupo",
            
                channel_set_to_x = "¡Canal establecido en %s!",
                channel = "canal",
            
                -- Notifies
                disabled = "¡%s ha sido deshabilitado! %s",
                gm_spawnvehicle = "El desove de los vehículos",
                gm_spawnsent = "El desove de entidades con secuencias de comandos (SENT)",
                gm_spawnnpc = "El desove de personajes no jugadores (PNJ)",
                see_settings = "Consulte la configuración de DarkRP.",
                limit = "¡Has alcanzado el límite de %s!",
                have_to_wait = "¡Tienes que esperar otros %d segundos antes de usar %s!",
                must_be_looking_at = "¡Tienes que estar mirando un %s!",
                incorrect_job = "No tienes el trabajo adecuado para %s",
                unavailable = "Este %s no está disponible",
                unable = "No puede %s. %s",
                cant_afford = "No puedes permitirte este %s",
                created_x = "%s creó un %s",
                cleaned_up = "Tus %s fueron limpiados.",
                you_bought_x = "Has comprado %s por %s%d.", -- compatibilidad con versiones anteriores
                you_bought = "Has comprado %s por %s.",
                you_got_yourself = "Obtuviste un %s.",
                you_received_x = "Ha recibido %s para %s.",
            
                created_first_jailpos = "¡Has creado el primer puesto en la cárcel!",
                added_jailpos = "¡Has agregado una posición adicional en la cárcel!",
                reset_add_jailpos = "Ha eliminado todas las posiciones de la cárcel y ha agregado una nueva aquí.",
                created_spawnpos = "Has agregado una posición de generación para %s.",
                updated_spawnpos = "Eliminó todas las posiciones de generación de %s y agregó una nueva aquí.",
                remove_spawnpos = "Has eliminado todas las posiciones de generación de %s.",
                do_not_own_ent = "¡No eres dueño de esta entidad!",
                cannot_drop_weapon = "¡No puedo soltar esta arma!",
                job_switch = "¡Trabajos cambiados con éxito!",
                job_switch_question = "¿Cambiar de trabajo con %s?",
                job_switch_requested = "Cambio de trabajo solicitado.",
                switch_jobs = "cambiar de trabajo",
            
                cooks_only = "Solo cocineros.",
            
                -- Misc
                unknown = "Desconocido",
                arguments = "argumentos",
                no_one = "nadie",
                door = "puerta",
                vehicle = "vehículo",
                door_or_vehicle = "puerta/vehículo",
                driver = "Conductor: %s",
                name = "Nombre: %s",
                locked = "Bloqueado.",
                unlocked = "Desbloqueado.",
                player_doesnt_exist = "El jugador no existe.",
                job_doesnt_exist = "¡El trabajo no existe!",
                must_be_alive_to_do_x = "Debes estar vivo para %s.",
                banned_or_demoted = "Prohibido/degradado",
                wait_with_that = "Espera con eso.",
                could_not_find = "No se pudo encontrar %s",
                f3tovote = "Presiona F3 para votar",
                listen_up = "Escucha:", -- En rp_tell o rp_tellall
                nlr = "Nueva regla de vida: no arrestar/matar por venganza.",
                reset_settings = "¡Has restablecido todas las configuraciones!",
                must_be_x = "Debes ser %s para poder %s.",
                agenda = "agenda",
                agenda_updated = "La agenda ha sido actualizada",
                job_set = "%s ha establecido su trabajo en '%s'",
                demote_vote = "degradar",
                demoted = "%s ha sido degradado",
                demoted_not = "%s no ha sido degradado",
                demote_vote_started = "%s ha iniciado una votación para la degradación de %s",
                demote_vote_text = "Nominado a la degradación:\n%s", -- '%s' es el motivo aquí
                cant_demote_self = "No puedes degradarte a ti mismo.",
                i_want_to_demote_you = "Quiero degradarte. Motivo: %s",
                tried_to_avoid_demotion = "Intentaste escapar de la degradación. Fallaste y has sido degradado.", --¡niño travieso!
                lockdown_started = "¡El presidente ha iniciado un Lockdown, por favor regresen a sus hogares!",
                lockdown_ended = "El confinamiento ha terminado",
                gunlicense_requested = "%s ha solicitado a %s una licencia de armas",
                gunlicense_granted = "%s ha otorgado a %s una licencia de armas",
                gunlicense_denied = "%s le ha negado a %s una licencia de armas",
                gunlicense_question_text = "¿Conceder a %s una licencia de armas?",
                gunlicense_remove_vote_text = "%s ha iniciado una votación para la eliminación de la licencia de armas de %s",
                gunlicense_remove_vote_text2 = "Revocar licencia de armas:\n%s", -- Donde %s es el motivo
                gunlicense_removed = "¡La licencia de %s ha sido eliminada!",
                gunlicense_not_removed = "¡La licencia de %s no ha sido eliminada!",
                vote_specify_reason = "¡Necesitas especificar una razón!",
                vote_started = "El voto ha sido creado",
                vote_alone = "Has ganado la votación ya que estás solo en el servidor.",
                you_cannot_vote = "¡No puedes votar!",
                x_cancelled_vote = "%s canceló la última votación.",
                cant_cancel_vote = "¡No se pudo cancelar la última votación porque no había una última votación para cancelar!",
                jail_punishment = "¡Castigo por desconectar! Encarcelado por: %d segundos.",
                admin_only = "¡Solo administrador!", -- Al hacer /addjailpos
                chief_or = "Jefe o",-- Al hacer /addjailpos
                frozen = "Congelado.",
                recipient = "recipiente",
                forbidden_name = "Nombre prohibido.",
                illegal_characters = "Caracteres ilegales.",
                too_long = "Demasiado largo.",
                too_short = "Demasiado corto.",
            
                dead_in_jail = "¡Ahora estás muerto hasta que se acabe tu tiempo en la cárcel!",
                died_in_jail = "¡%s ha muerto en la cárcel!",
            
                credits_for = "CRÉDITOS PARA %s\n",
                credits_see_console = "Créditos de DarkRP impresos en la consola.",
            
                rp_getvehicles = "Vehículos disponibles para vehículos personalizados:",
            
                data_not_loaded_one = "Tus datos aún no se han cargado. Por favor, espera.",
                data_not_loaded_two = "Si esto persiste, intente volver a unirse o comunicarse con un administrador.",
            
                cant_spawn_weapons = "No puedes generar armas.",
                drive_disabled = "Conducir inhabilitado por ahora.",
                property_disabled = "Propiedad deshabilitada por ahora.",
            
                not_allowed_to_purchase = "No tienes permiso para comprar este artículo.",
            
                rp_teamban_hint = "rp_teamban [nombre/identificación del jugador] [nombre/identificación del equipo]. Úselo para prohibir a un jugador de un determinado equipo.",
                rp_teamunban_hint = "rp_teamunban [nombre/identificación del jugador] [nombre/identificación del equipo]. Usa esto para desbanear a un jugador de un determinado equipo.",
                x_teambanned_y_for_z = "%s ha prohibido a %s ser %s durante %s minutos.",
                x_teamunbanned_y = "%s ha desbaneado a %s para ser %s.",
            
                -- Backwards compatibility:
                you_set_x_salary_to_y = "Estableciste el salario de %s en %s%d.",
                x_set_your_salary_to_y = "%s establece tu salario en %s%d.",
                you_set_x_money_to_y = "Configuró el dinero de %s en %s%d.",
                x_set_your_money_to_y = "%s establece tu dinero en %s%d.",
            
                you_set_x_salary = "Estableciste el salario de %s en %s.",
                x_set_your_salary = "%s estableció tu salario en %s.",
                you_set_x_money = "Configuró el dinero de %s en %s.",
                x_set_your_money = "%s estableció tu dinero en %s.",
                you_set_x_name = "Configuraste el nombre de %s en %s",
                x_set_your_name = "%s estableció tu nombre en %s",
            
                someone_stole_steam_name = "Alguien ya está usando tu nombre de Steam como su nombre de RP, así que te dimos un '1' después de tu nombre", -- Uh oh
                already_taken = "Ya apartadas.",
            
                job_doesnt_require_vote_currently = "¡Este trabajo no requiere un voto en este momento!",
            
                x_made_you_a_y = "¡%s te ha convertido en %s!",
            
                cmd_cant_be_run_server_console = "Este comando no se puede ejecutar desde la consola del servidor.",
            
                -- The lottery
                lottery_started = "¡Hay una lotería! ¿Participas por %s%d?", -- compatibilidad con versiones anteriores
                lottery_has_started = "¡Hay una lotería! ¿Participas por %s?",
                lottery_entered = "Participaste en la lotería por %s",
                lottery_not_entered = "%s no entró en la lotería",
                lottery_noone_entered = "Nadie ha entrado en la lotería",
                lottery_won = "¡%s ha ganado la lotería! Ha ganado %s",
                lottery = "lotería",
                lottery_please_specify_an_entry_cost = "Por favor, especifique un costo de entrada (%s-%s)",
                too_few_players_for_lottery = "Hay muy pocos jugadores para comenzar una lotería. Debe haber al menos %d jugadores",
                lottery_ongoing = "No se puede iniciar una lotería, ya hay una lotería en curso",
            
                -- Animations
                custom_animation = "¡Animación personalizada!",
                bow = "Arco",
                sexy_dance = "Baile sensual",
                follow_me = "¡Sígueme!",
                laugh = "Risa",
                lion_pose = "postura del león",
                nonverbal_no = "Non-verbal no",
                thumbs_up = "Pulgares hacia arriba",
                wave = "Ola",
                dance = "Baile",
            
                -- Hungermod
                starving = "¡Morirse de hambre!",
            
                -- AFK
                afk_mode = "Moda AFK",
                unable_afk_spam_prevention = "Por favor, espera antes de volver a AFK.",
                salary_frozen = "Tu salario ha sido congelado.",
                salary_restored = "Bienvenido de nuevo, tu salario ahora ha sido restaurado.",
                no_auto_demote = "No serás degradado automáticamente.",
                youre_afk_demoted = "Fuiste degradado por estar AFK durante demasiado tiempo. La próxima vez usa /afk.",
                hes_afk_demoted = "%s ha sido degradado por estar AFK durante demasiado tiempo.",
                afk_cmd_to_exit = "Escriba /afk para salir del modo AFK.",
                player_now_afk = "%s ahora está AFK.",
                player_no_longer_afk = "%s ya no está AFK.",
            
                -- Hitmenu
                hit = "hit",
                hitman = "Sicario",
                current_hit = "Hit: %s",
                cannot_request_hit = "¡No se puede solicitar hit! %s",
                hitmenu_request = "Solicitud",
                player_not_hitman = "¡Este jugador no es un asesino a sueldo!",
                distance_too_big = "Distancia demasiado grande.",
                hitman_no_suicide = "El asesino a sueldo no se suicidará.",
                hitman_no_self_order = "Un asesino a sueldo no puede ordenar un golpe para sí mismo.",
                hitman_already_has_hit = "El asesino a sueldo ya tiene un golpe en curso.",
                price_too_low = "¡Precio demasiado bajo!",
                hit_target_recently_killed_by_hit = "El objetivo fue asesinado recientemente por un golpe",
                customer_recently_bought_hit = "El cliente ha solicitado recientemente una visita.",
                accept_hit_question = "¿Aceptar hit de %s\ncon respecto a %s para %s%d?", -- compatibilidad con versiones anteriores
                accept_hit_request = "¿Aceptar respuesta de %s\ncon respecto a %s para %s?",
                hit_requested = "¡Golpe solicitado!",
                hit_aborted = "¡Golpe abortado! %s",
                hit_accepted = "¡Golpe aceptado!",
                hit_declined = "¡El sicario declinó el golpe!",
                hitman_left_server = "¡El sicario se ha ido del servidor!",
                customer_left_server = "¡El cliente ha abandonado el servidor!",
                target_left_server = "¡El objetivo ha abandonado el servidor!",
                hit_price_set_to_x = "Precio de éxito establecido en %s%d.", -- compatibilidad con versiones anteriores
                hit_price_set = "Precio de éxito establecido en %s.",
                hit_complete = "¡Golpeado por %s completo!",
                hitman_died = "¡El sicario murió!",
                target_died = "¡El objetivo ha muerto!",
                hitman_arrested = "¡El sicario fue arrestado!",
                hitman_changed_team = "¡El sicario cambió de equipo!",
                x_had_hit_ordered_by_y = "%s tuvo un hit activo ordenado por %s",
                place_a_hit = "¡coloca un hit!",
                hit_cancel = "¡pulsar cancelación!",
                hit_cancelled = "¡El golpe fue cancelado!",
                no_active_hit = "¡No tienes ningún golpe activo!",
            
                -- Vote Restrictions
                hobos_no_rights = "¡Los vagabundos no tienen derecho a voto!",
                gangsters_cant_vote_for_government = "¡Los gánsteres no pueden votar por cosas del gobierno!",
                government_cant_vote_for_gangsters = "¡Los funcionarios del gobierno no pueden votar por cosas de gánsteres!",
            
                -- VGUI and some more doors/vehicles
                vote = "Votar",
                time = "Hora: %d",
                yes = "Sí",
                no = "No",
                ok = "De acuerdo",
                cancel = "Cancelar",
                add = "Agregar",
                remove = "Remover",
                none = "Ninguna",
            
                x_options = "%s opciones",
                sell_x = "Vender %s",
                set_x_title = "Establecer %s título",
                set_x_title_long = "Establece el título del %s que estás viendo.",
                jobs = "Trabajos",
                buy_x = "Comprar %s",
            
                -- F4menu
                ammo = "pero",
                weapon_ = "arma",
                no_extra_weapons = "Este trabajo no tiene armas adicionales.",
                become_job = "Conviértete en trabajo",
                create_vote_for_job = "Crear voto",
                shipment = "envío",
                Shipments = "Envíos",
                shipments = "envíos",
                F4guns = "Armas",
                F4entities = "Misceláneas",
                F4ammo = "Pero",
                F4vehicles = "Vehículos",
            
                -- Tab 1
                give_money = "Dale dinero al jugador que estás mirando",
                drop_money = "Soltar dinero",
                change_name = "Cambia tu nombre DarkRP",
                go_to_sleep = "Ir a dormir/despertar",
                drop_weapon = "Soltar el arma actual",
                buy_health = "Comprar salud(%s)",
                request_gunlicense = "Solicitar licencia de armas",
                demote_player_menu = "Degradar a un jugador",
            
                searchwarrantbutton = "Hacer un jugador querido",
                unwarrantbutton = "Eliminar el estado de búsqueda de un jugador",
                noone_available = "Nadie disponible",
                request_warrant = "Solicitar una orden de allanamiento para un jugador",
                make_wanted = "Hacer que alguien quisiera",
                make_unwanted = "Hacer que alguien no sea deseado",
                set_jailpos = "Establecer la posición de la cárcel",
                add_jailpos = "Añadir una posición de cárcel",
            
                set_custom_job = "Establecer un trabajo personalizado (presione enter para activar)",
            
                set_agenda = "Configurar la agenda (presione enter para activar)",
            
                initiate_lockdown = "Iniciar un bloqueo",
                stop_lockdown = "Alto al confinamiento",
                start_lottery = "Empezar una lotería",
                give_license_lookingat = "Dale a <mirando> una licencia de armas",
            
                laws_of_the_land = "LEYES DE LA TIERRA",
                law_added = "Ley añadida.",
                law_removed = "Ley eliminada.",
                law_reset = "Reinicio de las leyes.",
                law_too_short = "Ley demasiado breve.",
                laws_full = "Las leyes están llenas.",
                default_law_change_denied = "No tienes permitido cambiar las leyes predeterminadas.",
            
                -- Second tab
                job_name = "Nombre: ",
                job_description = "Descripción: ",
                job_weapons = "Armas: ",
            
                -- Entities tab
                buy_a = "Comprar %s: %s",
            
                -- Licenseweaponstab
                license_tab = [[licencia de armas

                ¡Marque las armas que la gente debería poder obtener SIN licencia!
                ]],
                license_tab_other_weapons = "Otras armas:",

				zombie_spawn_removed = "Has eliminado este spawn de zombis.", -- Vous avez supprimé ce spawn de zombie.
				zombie_spawn = "Spawn de zombis", -- Zombie Spawn
				zombie_disabled = "Los zombis ahora están desactivados.", -- Les zombies sont maintenant désactivés.
				zombie_enabled = "Los zombis ahora están habilitados.", -- Les zombies sont maintenant activés.
				zombie_maxset = "El número máximo de zombis ahora está establecido en %s", -- Le nombre maximum de zombies est désormais réglé à %s
				zombie_spawn_added = "Has agregado un spawn de zombis.", -- Vous avez ajouté un spawn de zombie.
				zombie_spawn_not_exist = "El Spawn de zombi %s no existe.", -- Le Spawn de Zombie %s n'existe pas.
				zombie_leaving = "Los zombis se van.", -- Les zombies partent.
				zombie_approaching = "ADVERTENCIA: ¡Se acercan zombis!", -- AVERTISSEMENT : des Zombies approchent !
				zombie_toggled = "Zombis encendido/apagado.", -- Zombies activés/désactivés.
			} )
			
			-- Force reload strings for character animations:
			local loadCustomDarkRPItems = hook.GetTable()["loadCustomDarkRPItems"]
			if loadCustomDarkRPItems then
				local loadAnimations = loadCustomDarkRPItems["loadAnimations"]
				if loadAnimations then
					loadAnimations()
				end
			end
		end
		
		if DarkRP.addChatCommandsLanguage then
			DarkRP.addChatCommandsLanguage( "es-ES", {
                ["/"]                     = "Charla global del servidor.",
                ["a"]                     = "Charla global del servidor.",
                ["addjailpos"]            = "Agrega una posición en la cárcel donde estás parado.",
                ["addlaw"]                = "Agregue una ley al tablero de leyes.",
                ["addowner"]              = "Invita a alguien a ser copropietario de la puerta que estás mirando.",
                ["addspawn"]              = "Agregue una posición de generación para algún trabajo (use el nombre del comando del trabajo como argumento)",
                ["addzombie"]             = "Agregue una posición de generación de zombis.",
                ["advert"]                = "Anuncie algo para todos en el servidor.",
                ["agenda"]                = "Establece la agenda.",
                ["ao"]                    = "Invita a alguien a ser copropietario de la puerta que estás mirando.",
                ["broadcast"]             = "Transmitir algo como presidente.",
                ["buy"]                   = "Comprar una pistola",
                ["buyammo"]               = "Compra munición",
                ["buydruglab"]            = "Compra un laboratorio de drogas",
                ["buygunlab"]             = "Compra un laboratorio de armas",
                ["buymoneyprinter"]       = "Compra una impresora de dinero",
                ["buyshipment"]           = "Compra un cargamento",
                ["buyvehicle"]            = "Comprar un vehiculo",
                ["channel"]               = "Sintonice un canal de radio.",
                ["check"]                 = "Escriba un cheque para una persona específica.",
                ["cheque"]                = "Escriba un cheque para una persona específica.",
                ["chief"]                 = "Conviértete en Jefe de Protección Civil.",
                ["citizen"]               = "Conviértete en ciudadano.",
                ["cp"]                    = "Conviértete en Protección Civil y sáltate la votación.",
                ["cr"]                    = "¡Llora por ayuda, la policía vendrá (con suerte)!.",
                ["credits"]               = "Envía los créditos de DarkRP a alguien.",
                ["demote"]                = "Degradar a un jugador de su trabajo",
                ["demotelicense"]         = "Inicie una votación para revocar la licencia de alguien.",
                ["disablestorm"]          = "Desactiva las tormentas de meteoritos.",
                ["disablezombie"]         = "Deshabilitar modo zombi.",
                ["dropmoney"]             = "Tira el dinero al suelo.",
                ["enablestorm"]           = "Habilitar tormentas de meteoritos.",
                ["enablezombie"]          = "Habilitar modo zombi.",
                ["g"]                     = "Grupo de chat.",
                ["gangster"]              = "Conviértete en gángster.",
                ["give"]                  = "Dale dinero al jugador que estás mirando.",
                ["givelicense"]           = "Darle a alguien una licencia de armas",
                ["gundealer"]             = "Conviértete en traficante de armas.",
                ["hitprice"]              = "Establece el precio de tus hits",
                ["hobo"]                  = "Conviértete en vagabundo.",
                ["jailpos"]               = "Restablezca las posiciones de la cárcel y cree una nueva en su posición.",
                ["job"]                   = "Cambia el nombre de tu trabajo",
                ["jobswitch"]             = "Cambia de trabajo con el jugador que estás viendo",
                ["lockdown"]              = "Iniciar un confinamiento. Todos tendrán que quedarse adentro",
                ["lottery"]               = "Empezar una lotería",
                ["makeshipment"]          = "Crea un cargamento a partir de un arma arrojada.",
                ["maxzombie"]             = "Establece la cantidad máxima de zombis que puede haber en un nivel.",
                ["maxzombies"]            = "Establece la cantidad máxima de zombis que puede haber en un nivel.",
                ["mayor"]                 = "Conviértete en presidente y sáltate la votación.",
                ["me"]                    = "Juegos de rol de chat para decir que estás haciendo cosas que no puedes mostrar de otra manera.",
                ["medic"]                 = "Conviértete en médico.",
                ["mobboss"]               = "Conviértete en el jefe de la mafia.",
                ["moneydrop"]             = "Tira el dinero al suelo.",
                ["name"]                  = "Establezca su nombre de RP",
                ["nick"]                  = "Establezca su nombre de RP",
                ["ooc"]                   = "Charla global del servidor.",
                ["placelaws"]             = "Coloca un tablero de leyes.",
                ["pm"]                    = "Envía un mensaje privado a alguien.",
                ["price"]                 = "Establezca el precio del horno de microondas o del laboratorio de armas que está buscando.",
                ["radio"]                 = "Di algo a través de la radio.",
                ["removelaw"]             = "Eliminar una ley del tablero de leyes.",
                ["removeletters"]         = "Elimina todas tus cartas.",
                ["removeowner"]           = "Elimina a un propietario de la puerta que estás mirando.",
                ["removespawn"]           = "Elimine una posición de generación para algún trabajo (use el nombre del comando del trabajo como argumento)",
                ["removezombie"]          = "Elimine una posición de generación de zombis por identificación (obtenga la identificación con /showzombie).",
                ["requesthit"]            = "Solicita un hit del jugador que estás viendo",
                ["requestlicense"]        = "Solicite una licencia de armas.",
                ["ro"]                    = "Elimina a un propietario de la puerta que estás mirando.",
                ["rpname"]                = "Establezca su nombre de RP",
                ["setprice"]              = "Establezca el precio del horno de microondas o del laboratorio de armas que está buscando.",
                ["setspawn"]              = "Restablezca la posición de generación para algún trabajo y coloque uno nuevo en su posición (use el nombre de comando del trabajo como argumento)",
                ["showzombie"]            = "Muestra las posiciones de aparición de zombis.",
                ["sleep"]                 = "Vete a dormir o despierta",
                ["splitshipment"]         = "Divida el cargamento que está viendo.",
                ["switchjob"]             = "Cambia de trabajo con el jugador que estás viendo",
                ["switchjobs"]            = "Cambia de trabajo con el jugador que estás viendo",
                ["teamban"]               = "Prohibir que alguien consiga cierto trabajo",
                ["teamunban"]             = "Deshacer en el equipo",
                ["title"]                 = "Establezca el título de la puerta que está mirando.",
                ["togglegroupownable"]    = "Configure este grupo de puertas como propio.",
                ["toggleown"]             = "Sea dueño o no de la puerta que está mirando.",
                ["toggleownable"]         = "Cambia el estado de propiedad de esta puerta.",
                ["toggleteamownable"]     = "Cambia esta puerta a propiedad de un equipo determinado.",
                ["type"]                  = "Escribe una letra.",
                ["unlockdown"]            = "Detener un bloqueo",
                ["unownalldoors"]         = "Vende todas tus puertas.",
                ["unwanted"]              = "Eliminar el estado de búsqueda de un jugador.",
                ["votecp"]                = "Vota para convertirte en Protección Civil.",
                ["votemayor"]             = "Vota para convertirte en presidente.",
                ["w"]                     = "Di algo en voz baja.",
                ["wake"]                  = "Vete a dormir o despierta",
                ["wakeup"]                = "Vete a dormir o despierta",
                ["wanted"]                = "Hacer un jugador buscado. Esto es necesario para que los arresten.",
                ["warrant"]               = "Consigue una orden de registro para cierto jugador. Con esta orden puedes registrar su casa",
                ["write"]                 = "Escribir una carta.",
                ["y"]                     = "Grita algo en voz alta.",
                ["zombiemax"]             = "Establece la cantidad máxima de zombis que puede haber en un nivel.",

				-- Add new chat command translations under this line:
				["000"]                   =	"¡Grito de ayuda, la policía vendrá (con suerte)!",
				["112"]                   =	"¡Grito de ayuda, la policía vendrá (con suerte)!",
				["911"]                   =	"¡Grito de ayuda, la policía vendrá (con suerte)!",
				["999"]                   =	"¡Grito de ayuda, la policía vendrá (con suerte)!",
				["addagenda"]             =	"Añadir una línea de texto al calendario.",
				["addmoney"]              =	"Agregar dinero a la billetera de un jugador.",
				["admintell"]             =	"Envía un mensaje privado muy intimidante a alguien.",
				["admintellall"]          =	"Enviando un mensaje muy intimidante para todos.",
				["arrest"]                =	"Detener a la fuerza a un jugador.",
				["buyfood"]               =	"Comprar comida.",
				["buymicrowave"]          =	"Comprar un horno de microondas",
				["cook"]                  =	"Conviértete en cocinero.",
				["forcecancelvote"]       =	"Cancelar enérgicamente una votación.",
				["forcelock"]             =	"Obliga a cerrar la puerta que estás mirando. Esto queda grabado.",
				["forceown"]              =	"Haz que alguien sea dueño de la puerta que estás mirando.",
				["forceremoveowner"]      =	"Quitar fuertemente a un dueño de la puerta que estás mirando.",
				["forcerpname"]           =	"Modificar a la fuerza el nombre de RP de un jugador",
				["forceunlock"]           =	"Obliga a abrir la puerta que estás mirando. Esto queda grabado.",
				["forceunown"]            =	"Elimine enérgicamente a todos los propietarios de la puerta que está mirando.",
				["forceunownall"]         =	"Obligar a un jugador a que ya no sea dueño de las puertas y vehículos que tiene.",
				["freerpname"]            =	"Eliminar un nombre de RP de la base de datos para que un jugador pueda usarlo",
				["resetlaws"]             =	"Restablecer todas las leyes.",
				["sellalldoors"]          =	"Vende todas tus puertas.",
				["setjailpos"]            =	"Restablezca las posiciones de la cárcel y cree una nueva en su ubicación.",
				["setlicense"]            =	"Enérgicamente dar un día un permiso.",
				["setmoney"]              =	"Establecer el valor de la cartera de un jugador.",
				["unarrest"]              =	"Detener a la fuerza a un jugador.",
				["unsetlicense"]          =	"Revocar enérgicamente la licencia de un jugador.",
				["unwarrant"]             =	"Retirar una orden de allanamiento para un jugador dado. Con una orden puedes allanar su casa.",
			} )
		end
	end
end
hook.Add( "DarkRPFinishedLoading", "darkrp_translation_es", DarkRPFinishedLoading )

local function InitPostEntity()
	if DarkRP then
		if hl=="es-ES" and DarkRP.getChatCommands and DarkRP.getChatCommandDescription and DarkRP.addChatCommandsLanguage then
			local translated
			local len
			for command,tbl in pairs( DarkRP.getChatCommands() ) do
				translated = DarkRP.getChatCommandDescription( command )
				if tbl.description and ( not translated or tbl.description==translated ) then
					if string.sub( tbl.description, 1, 7 )=="Become " then
						len = string.len( tbl.description )
						if string.sub( tbl.description, len-18, len )~=" and skip the vote." then
							translated = "Volverse "..string.sub( tbl.description, 8 )
						else
							translated = "Volverse "..string.sub( tbl.description, 8, len-19 ).." y ignorar la votacion."
						end
						DarkRP.addChatCommandsLanguage( "es-ES", {[command]=translated} )
					elseif string.sub( tbl.description, 1, 15 )=="Vote to become " then
						translated = "Vota para convertirte "..string.sub( tbl.description, 16 )
						DarkRP.addChatCommandsLanguage( "es-ES", {[command]=translated} )
					end
				end
			end
		end
	end
end
hook.Add( "InitPostEntity", "darkrp_translation_es", InitPostEntity )

local loading = false
hook.Add( "OnReloaded", "darkrp_translation_es", function()
	if not loading then
		loading = true -- prevent multiple reloads (only accept 2nd OnReloaded event)
	else
		loading = false
		DarkRPFinishedLoading()
		InitPostEntity()
	end
end )