-- Thanks to Roland (https://www.gmodstore.com/users/roland) for this translation

local LANGUAGE = {
    firstName = "Имя",
    lastName = "Фамилия",
    gender = "Пол",
    male = "Мужчина",
    female = "Женщина",
    unknown = "Неизвестно",
    choosePlayer = "Выберите игрока...",
    proposePrice = "Укажите цену",
    detailPerson = "Комментарий",
    sendContract = "Отправить заказ",
    cancelContract = "Отменить заказ",
    info = "Информация",
    award = "Награда",
    target = "Цель",
    contractAvailable = "Доступен заказ",
    onGoingContract = "Заказ выполняется",
    listOfContracts = "Список заказов",

    timeLeft = "Времени осталось",
    occupation = "Работа",
    distance = "Расстояние",

    contractCanceledVictimDeath = "Заказ был провален,потому что цель мертва",
    contractCanceledDisconnect = "Заказ был провален,потому что цель вышла с сервера",
    contractCanceledDeath = "Заказ был провален потому что вы умерли",
    contractCanceledDeathClient = "Ваш заказ был провален,киллер умер",  
    contractCanceledTime = "Заказ провален,время вышло",  
    contractCanceledRefunded = "Заказ провален,вам вернули деньги",  

    contractFinishedClient = "Киллер выполнил заказ",
    contractFinished = "Вы получили награду за выполнение заказа",
    contractTaken = "Заказ успешно принят",
    contractSendedHitman = "Поступил новый заказ",
    contractSended = "Заказ успешно отправлен",
    contractAlready = "У вас уже есть действующий заказ",
    contractAlreadyTaken = "Этот заказ уже выполняется",
    contractNoTake = "Вы не можете принять этот заказ",
    contractDelay = "Вам нужно подождать перед новым заказов",

    priceMin = "Цена слишком низкая (Минимум %s)",
    priceMax = "Цена слишком высокая (Максимум %s)",
    descriptionShort = "Комментарий слишком короткий",
    descriptionLong = "Комментарий слишком длинный",
    noMoney = "У вас недостаточно денег",

    targetUnknown = "НЕИЗВЕСТНО",
    targetLocked = "Цель идентифицирована",
    night_vision = "Ночное зрение",
}

SlownLS.Hitman:addLanguage("ru",LANGUAGE)