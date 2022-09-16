--[[  
    Addon: Hitman
    By: SlownLS
]]

local LANGUAGE = {
    firstName = "First name",
    lastName = "Last name",
    gender = "Gender",
    male = "Man",
    female = "Woman",
    unknown = "Unknown",
    choosePlayer = "Choose a player...",
    proposePrice = "Propose your price",
    detailPerson = "Detail the person",
    sendContract = "Send the contract",
    cancelContract = "Cancel the contract",
    info = "Info",
    award = "Award",
    target = "Target",
    contractAvailable = "Contract available",
    onGoingContract = "In progress contract",
    listOfContracts = "List of contracts",

    timeLeft = "Time left",
    occupation = "Occupation",
    distance = "Distance",

    contractCanceledVictimDeath = "The contract was cancelled because the victim is dead",
    contractCanceledDisconnect = "The contract was cancelled because the victim disconnected",
    contractCanceledDeath = "The contract was cancelled because you're dead",
    contractCanceledDeathClient = "Your contract was cancelled because the hitman is dead",   
    contractCanceledTime = "Contract cancelled, time limit exceeded",   
    contractCanceledRefunded = "Contract cancelled, you have been refunded",   
    
    contractFinishedClient = "A hitman made the hit",
    contractFinished = "You've been rewarded for completing your contract",
    contractTaken = "Contract successfully taken",

    contractSendedHitman = "A new contract has been received, you have to get rid of someone!",
    contractSended = "Contract successfully sent",
    contractAlready = "You already have a current contract",
    contractAlreadyTaken = "This contract is already in progress",
    contractNoTake = "You can't take this contract",
    contractDelay = "You have to wait to send another contract",

    priceMin = "The price is too low (minimum %s)",
    priceMax = "The price is too high (maximum %s)",
    descriptionShort = "The description is too short",
    descriptionLong = "The description is too long",
    noMoney = "You don't have enough money",

    targetUnknown = "UNKNOWN TARGET",
    targetLocked = "IDENTIFIED TARGET",
    night_vision = "NIGHT VISION",
}

SlownLS.Hitman:addLanguage("en",LANGUAGE)