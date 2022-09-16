--[[  
    Addon: Hitman
    By: SlownLS
]]

local LANGUAGE = {
    firstName = "Imię",
    lastName = "Nazwisko",
    gender = "Płeć",
    male = "Mężczyzna",
    female = "Kobieta",
    unknown = "Nieznana",
    choosePlayer = "Wybierz gracza...",
    proposePrice = "Zaproponuj cenę",
    detailPerson = "Opisz osobę",
    sendContract = "Wyślij kontrakt",
    cancelContract = "Anuluj kontrakt",
    info = "Info",
    award = "Nagroda",
    target = "Cel",
    contractAvailable = "Kontrakt dostępny",
    onGoingContract = "Kontrakt w trakcie",
    listOfContracts = "Lista kontraktów",

    timeLeft = "Pozostały czas",
    occupation = "Zawód",
    distance = "Dystans",

    contractCanceledVictimDeath = "Kontrakt został anulowany ponieważ cel zmarł",
    contractCanceledDisconnect = "Kontrakt został anulowany ponieaż cel wyszedł",
    contractCanceledDeath = "Kontrakt został anulowany ponieważ zmarłeś",
    contractCanceledDeathClient = "Kontrakt został anulowany ponieważ hitman zmarł",   
    contractCanceledTime = "Kontrakt został anulowany, czas minął",   
    contractCanceledRefunded = "Kontrakt został anulowany, otrzymałeś zwrot pieniędzy",   
    
    contractFinishedClient = "Hitman wykonał hit",
    contractFinished = "Zostałeś wynagrodzony za wykonanie kontraktu",
    contractTaken = "Kontrakt pomyślnie przyjęty",

    contractSendedHitman = "Nowy kontrakt został otrzymany, musisz kogoś się pozbyć!",
    contractSended = "Kontrakt pomyślnie wysłany",
    contractAlready = "Już posiadasz kontrakt",
    contractAlreadyTaken = "Ten kontrakt jest już w toku",
    contractNoTake = "Nie możesz wziąść tego kontraktu",
    contractDelay = "Musisz poczekać przed wysłaniem następnego kontraktu",

    priceMin = "Cena jest za niska (minimum %s)",
    priceMax = "Cena jest za wysoka (maksymalnie %s)",
    descriptionShort = "Opis jest za krótki",
    descriptionLong = "Opis jest za długi",
    noMoney = "Nie masz wystarczająco pieniędzy",

    targetUnknown = "NIEZNANY CEL",
    targetLocked = "ZIDENTYFIKOWANO CEL",
    night_vision = "WIDZENIE W CIEMNOŚCI",
}

SlownLS.Hitman:addLanguage("pl",LANGUAGE)