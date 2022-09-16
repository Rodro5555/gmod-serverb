function TPRSAExtensions()
	local function DefaultLanguages()
		Diablos.RS.Strings = { 
			speedgunname = "Pistola de velocidad", --"Speed Gun"
			speedguninstructions = "Coge el arma y apunta el vehículo para saber su velocidad", --"Take the weapon and aim the vehicule to know its speed"
			speed = "VELOCIDAD", --"SPEED"
			notarget = "NO TARGET", --"NO TARGET"
			found = "FUNDAR", --"FOUND"
			governement = "GOBIERNO", --"GOVERNEMENT"
			vehicle = "VEHÍCULO", --"VEHICLE"
			havebeencaught = "Te han pillado en", --"You have been caught at"
			youpaidfine = "Usted pagó una multa de", --"You paid a fine of"
			youwin = "Usted gana", --"You earn"
			fortakingacar = "por tomar un vehículo en", --"for taking a vehicle at"
			speedrecord = "RECORDS DE VELOCIDAD", --"SPEED RECORDS"
			norecords = "¡Sin records!", --"No records!"
			nologs = "¡Sin registros!", --"No logs!"
			nocameras = "¡Sin cámaras!", --"No cameras!"
			playertxt = "Jugador", --"Player"
			speedtxt = "Velocidad", --"Speed"
			datetxt = "Fecha", --"Date"
			vehtxt = "Vehículo", --"Vehicle"
			speedradar = "Velocidad de tu pistola rápida:", --"Speed of your speedgun:"
			radarsystem = "[Sistema de radar]", --"[Radar System]"
			speedzero = "¡No puedes guardar un radar con un límite de velocidad de 0 MPH/0 KMH!", --"You can't save a radar with a speedlimit of 0MPH/0KMH!"
			speedcamera = "Camara rápida", --"Speed Camera"
			speedlimit = "Límite de velocidad", --"Speed limit"
			fineprice = "Precio de multa", --"Fine price"
			finesnotpaid = "Multas no pagadas", --"Fines not paid"
			taker = "Infractor", --"Taker"
			owner = "Dueño", --"Owner"
			server = "Servidor", --"Server"
			close = "CERRAR", --"CLOSE"
			view = "VISTA", --"VIEW"
			save = "GUARDAR", --"SAVE"
			valuebetween = "El valor debe estar entre", --"Value must be between"
			andtxt = "y", --"and"
			trafficviolation = "Violación de tráfico", --"Traffic Violation"
			youearned = "Usted ganó", --"You earned"
			dueown = "debido a que alguien ha sido captado por un radar de tu propiedad!", --"due to someone who has been caught by a speed camera you own!"
			duegeneral = "debido a alguien que ha sido captado por una cámara de velocidad propiedad del gobierno!", --"due to someone who has been caught by a speed camera owned by the governement!"
			trucktxt = "Camión", --"Truck"
			leftroad = "Izquierda", --"Left"
			rightroad = "Derecha", --"Right"
			falseroad = "Falso", --"False"
			trueroad = "Verdadero", --"True"
			vehs = "Uf", --"Vehs"
			trucks = "Camiones", --"Trucks"
			avgblink = "Enlace de inicio promedio", --"Average begin link"
			distbegin = "Distancia con inicio", --"Distance with begin"
			axisx = "Eje X", --"Axis X"
			distdetect = "Detección de distancia", --"Distance detection"
			roadside = "Lado de la carretera", --"Road side"
			frontroad = "Frente a la carretera", --"Front of road"
			length = "Longitud", --"Length"
			english = "Cámara inglesa", --"English camera"
			french = "Cámara francesa", --"French camera"
			discr = "Cámara discriminatoria", --"Discriminating camera"
			edu = "Cámara educativa", --"Educational camera"
			avg = "Cámara promedio", --"Average camera"
			beginavg = "Empezar", --"Begin"
			endavg = "Final", --"End"
			ped = "Cámara peatonal", --"Pedestrian camera"
			stop = "Detener la cámara", --"Stop camera"
			car = "Cámara de coche", --"Car camera"
			undefined = "Indefinido", --"Undefined"
			home = "INICIO", --"HOME"
			camerarepart = "REPARTICIÓN DE CÁMARA DE VELOCIDAD", --"SPEED CAMERA REPARTITION"
			statistics = "ESTADÍSTICAS", --"STATISTICS"
			speedcameras = "CÁMARAS DE VELOCIDAD", --"SPEED CAMERAS"
			globalrecords = "REGISTROS GLOBALES", --"GLOBAL RECORDS"
			governementlogs = "REGISTROS DEL GOBIERNO", --"GOVERNEMENT LOGS"
			showonly = "Mostrar solo", --"Show only"
			thereare = "Existen", --"There are"
			governementflashes = "destellos del gobierno", --"governement flashes"
			including = "Incluido", --"Including"
			differentpeople = "diferentes personas atrapadas", --"different people caught"
			bestgap = "es el mejor gap de velocidad", --"is the best gap of speed"
			madesincebegin = "hecho desde el principio", --"made since the beginning"
			finetotal = "de multa total", --"of fine total"
			ownerrisk = "¡Cambiar el propietario a otro policía hará que ya no puedas cambiar ningún parámetro!", --"Changing the owner to another cop will result in you no more able to change any parameter!"
			frontroadtip = "Establecer en verdadero si la cámara está mirando a la carretera", --"Set to true if the camera is looking at the road"
			roadsidetip = "Izquierda o derecha según el lado de la carretera en el que esté colocada la cámara", --"Left or right depending on the road side your camera is placed on"
			sorttype = "Ordenar por tipo", --"Sort by type"
			dontsort = "No ordenar", --"Don't sort"
			disconnected = "Jugador desconectado", --"Disconnected player"
			hasbeentaken = "ha sido tomado en", --"has been taken at"
			takenby = "ha sido tomado por un", --"has been taken by a"
			insteadof = "en vez de", --"instead of"
			finepricewas = "El precio de multa estaba en", --"The fine price was at"
			amountpaid = "y la cantidad pagada fue", --"and the amount paid was"
			myrecords = "Mis registros", --"My records"
			changed = "cambió", --"changed"
			youdriveat = "Estás conduciendo en", --"You are driving at"
			caughtped = "Te han pillado porque te olvidaste de dar prioridad a los peatones", --"You have been caught because you forgot to give pedestrian priority"
			caughtstop = "Te han pillado porque no marcaste la parada", --"You have been caught because you didn't mark the stop"
			holdradarinfosswep = "¡Tienes que mantener presionado Radar Infos SWEP para cambiar los parámetros!", --"You have to hold the Radar Infos SWEP to change parameters!"
			avgbeginlinkradarinfos = "¡Presione USE en el promedio para comenzar a confirmar la entidad vinculada!", --"Press USE on the average begin to confirm the entity linked!"
			avgbeginlinkedradarinfos = "¡Has vinculado el comienzo promedio con su final!", --"You linked the average begin with it's end!"
			youhavetopay = "Tienes que pagar", --"You have to pay"
			finemanager = "al ir al gerente multas!", --"by going to the fine manager!"
			notenoughmoney = "No tienes suficiente dinero", --"You don't have enough money"
			nofinetopay = "¡No tienes ninguna multa que pagar!", --"You don't have any fine to pay!"
			togovernement = "al gobierno, presione E para pagar!", --"to the governement, press USE to pay!"
			finespaid = "¡Las multas han sido pagadas, gracias!", --"Fines have been paid, thanks!"
			paidremainingfine = "debido a alguien que pagó el dinero restante de una multa!", --"due to someone who paid remaining money of a fine!"
		}
	end

	DefaultLanguages()

	local scrid, scrver = "3660", "3.1.2"
	local lng = string.lower(Diablos.RS.Language)
	local codename = "tprsa"

	if Diablos.RS.MPHCounter then
		Diablos.RS.MPHKMHText = "MPH"
	else
		Diablos.RS.MPHKMHText = "KMH"
	end

	Diablos.RS.FrameBasicColors = {
		rndbox = Color(100, 100, 100, 100),
		r = Color(100, 40, 40, 100),
		g = Color(40, 100, 40, 100),
		rl = Color(200, 100, 100, 200),
		gl = Color(100, 200, 100, 255),
		bl = Color(100, 100, 200, 255),
		pre1 = Color(200, 40, 40, 255),
		pre2 = Color(100, 255, 100, 255),
		b = Color(0, 0, 0, 255),
		basicframe = Color(50, 50, 50, 200),
		basicheader = Color(80, 80, 140, 200),
	}

	Diablos.RS.SpeedCameraList = {
		["english_speed_camera"] = true,
		["french_speed_camera"] = true,
		["discriminating_camera"] = true,
		["educational_camera"] = true,
		["average_camera_begin"] = true,
		["average_camera_end"] = true,
		["stop_camera"] = true,
		["pedestrian_camera"] = true,
	}

	Diablos.RS.SignList = {
		["camera_sign"] = true,
		["give_way_sign"] = true,
		["speed_limit_sign"] = true,
		["stop_sign"] = true,
	}

	Diablos.RS.SignHeight = {
		["camera_sign"] = 15,
		["give_way_sign"] = 8,
		["speed_limit_sign"] = 18.5,
		["stop_sign"] = 8.5,
	}
end