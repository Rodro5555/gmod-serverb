--[[  
    Addon: Hitman
    By: SlownLS
]]

local LANGUAGE = {
    firstName = "Nombre",
    lastName = "Apellido",
    gender = "Género",
    male = "Hombre",
    female = "Mujer",
    unknown = "Desconocido",
    choosePlayer = "Elige un jugador...",
    proposePrice = "Proponga su precio",
    detailPerson = "Detallar a la persona",
    sendContract = "Enviar el contrato",
    cancelContract = "Cancelar el contrato",
    info = "Información",
    award = "Premio",
    target = "Objetivo",
    contractAvailable = "Contrato disponible",
    onGoingContract = "Contrato en curso",
    listOfContracts = "Lista de contratos",

    timeLeft = "Tiempo restante",
    occupation = "Ocupación",
    distance = "Distancia",

    contractCanceledVictimDeath = "El contrato fue cancelado porque la víctima está muerta",
    contractCanceledDisconnect = "Se canceló el contrato porque la víctima se desconectó",
    contractCanceledDeath = "El contrato fue cancelado porque estás muerto",
    contractCanceledDeathClient = "Tu contrato fue cancelado porque el sicario está muerto", 
    contractCanceledTime = "Contrato cancelado, límite de tiempo excedido", 
    contractCanceledRefunded = "Contrato cancelado, te han reembolsado", 
    
    contractFinishedClient = "Un asesino a sueldo hizo el golpe",
    contractFinished = "Has sido recompensado por completar tu contrato",
    contractTaken = "Contrato realizado con éxito",

    contractSendedHitman = "Se ha recibido un nuevo contrato, ¡tienes que deshacerte de alguien!",
    contractSended = "Contrato enviado con éxito",
    contractAlready = "Ya tienes contrato vigente",
    contractAlreadyTaken = "Este contrato ya está en curso",
    contractNoTake = "No puedes tomar este contrato",
    contractDelay = "Hay que esperar 5 minutos para enviar otro contrato",

    priceMin = "El precio es demasiado bajo (mínimo %s)",
    priceMax = "El precio es demasiado alto (máximo %s)",
    descriptionShort = "La descripción es demasiado corta",
    descriptionLong = "La descripción es demasiado larga",
    noMoney = "No tienes suficiente dinero",

    targetUnknown = "OBJETIVO DESCONOCIDO",
    targetLocked = "OBJETIVO IDENTIFICADO",
    night_vision = "VISION NOCTURNA",
}

SlownLS.Hitman:addLanguage("es",LANGUAGE)