--[[  
    Addon: Hitman
    By: SlownLS
]]

local LANGUAGE = {
    firstName = "Prénom",
    lastName = "Nom",
    gender = "Sexe",
    male = "Homme",
    female = "Femme",
    unknown = "Inconnu",
    choosePlayer = "Choisissez un joueur...",
    proposePrice = "Proposez votre prix",
    detailPerson = "Détaillez la personne",
    sendContract = "Envoyer le contrat",
    cancelContract = "Annuler le contrat",
    info = "Info",
    award = "Récompense",
    target = "Cible",
    contractAvailable = "Contrat disponible",
    onGoingContract = "Contrat en cours",
    listOfContracts = "Liste des contrats",

    timeLeft = "Temps restant",
    occupation = "Occupation",
    distance = "Distance",

    contractCanceledVictimDeath = "Le contrat à été annulé car la victime est morte",
    contractCanceledDisconnect = "Le contrat à été annulé car la victime s'est déconnectée",
    contractCanceledDeath = "Le contrat à été annulé car vous êtes mort",
    contractCanceledDeathClient = "Votre contrat à été annulé car le tueur à gage est mort",   
    contractCanceledTime = "Contrat annulé, temps limite dépassé",   
    contractCanceledRefunded = "Contrat annulé, vous avez été remboursé",   
    
    contractFinishedClient = "Un tueur à gage a effectué le contrat",
    contractFinished = "Vous avez été récompensé pour avoir effectué votre contrat",
    contractTaken = "Contrat pris avec succès",

    contractSendedHitman = "Un nouveau contrat a été reçu, vous devez vous débarrasser de quelqu'un !",
    contractSended = "Contrat envoyé avec succès",
    contractAlready = "Vous avez déjà un contrat en cours",
    contractAlreadyTaken = "Ce contrat est déjà en cours",
    contractNoTake = "Vous ne pouvez pas prendre ce contrat",
    contractDelay = "Vous devez patienter avec de renvoyer un contrat",

    priceMin = "Le prix est insuffisant (minimum %s)",
    priceMax = "Le prix est trop élevé (maximum %s)",
    descriptionShort = "La description est trop courte",
    descriptionLong = "La description est trop longue",
    noMoney = "Vous n'avez pas assez d'argent",

    targetUnknown = "CIBLE INCONNUE",
    targetLocked = "CIBLE IDENTIFIÉE",
    night_vision = "VISION NOCTURNE",
}

SlownLS.Hitman:addLanguage("fr",LANGUAGE)