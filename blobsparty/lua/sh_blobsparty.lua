BlobsPartyConfig = BlobsPartyConfig or {}

-- 1.0.7
BlobsPartyConfig.DefaultTopUISpacing = 5 -- The distance between the top of the screen and the start of the Party members UI (Use this if you have a HUD that is being overlapped by the party members display)

-- 1.0.6 and below
BlobsPartyConfig.PartyCommands = { "!party" } -- The command(s) that opens the party UI
BlobsPartyConfig.PartyChatCommands = { "!pchat", "/p", "/party", "!pc", "/pc" } -- The commands to use party chat (which is then followed by the message. example: /pc Hey everyone!)
BlobsPartyConfig.MinNameSize = 3 -- Minimum name length for party name
BlobsPartyConfig.MaxNameSize = 28 -- Maximum name length for party name
BlobsPartyConfig.MinSize = 1 -- Minimum size for party
BlobsPartyConfig.MaxSize = 100 -- Maximum size for party

BlobsPartyConfig.FriendlyFireToggle = true -- If this is set to true, then party owners have the option to enable/disable friendly fire within their party

--[[ HUD Styling ]]--
BlobsPartyConfig.FirstColor = Color(41,48,54) -- This is the darkest color on the UI
BlobsPartyConfig.SecondColor = Color(54,61,69) -- Slightly lighter than the previous color
BlobsPartyConfig.ThirdColor = Color(73,83,94) -- The colour of the UI's main background
BlobsPartyConfig.BarColor = Color(47,163,161) -- This is the light blue color
BlobsPartyConfig.PartyChatColor = Color(255,255,255) -- The text color that party chat appears in
BlobsPartyConfig.PartyChatPrefixColor = Color(0,255,255) -- The color that the party chat prefix is -- (PARTY) default yellow

--[[ Language / Localization ]]--
-- When a language config setting contains {p}, this will be replaced by the name of the player that is relevant to that message!
BlobsPartyConfig.FriendlyFire = "¿Habilitar fuego amigo?" -- Enable Friendly Fire?
BlobsPartyConfig.PartyList = "Lista de Parties" -- Party List
BlobsPartyConfig.PartyMenu = "Menú de party" -- Party Menu
BlobsPartyConfig.PartyName = "Nombre de la party" -- Party Name
BlobsPartyConfig.PartySize = "Tamaño de la party" -- Party Size
BlobsPartyConfig.Owner = "Dueño" -- Owner
BlobsPartyConfig.CreateParty = "Crear party" -- Create Party
BlobsPartyConfig.EditParty = "Editar party" -- Edit Party
BlobsPartyConfig.PartySettings = "Configuración de la Party" -- Party Settings
BlobsPartyConfig.ManagePlayers = "Administrar jugadores" -- Manage Players
BlobsPartyConfig.NoOtherPlys = "Ningún otro jugador" -- No other players
BlobsPartyConfig.KickPly = "Kickear al jugador" -- Kick Player
BlobsPartyConfig.GiveOwner = "Transferir dueño" -- Give Ownership
BlobsPartyConfig.ReqToJoin = "Solicitud para unirse" -- Request to join
BlobsPartyConfig.Join = "Unirse" -- Join
BlobsPartyConfig.Ply = "Jugador" -- Player
BlobsPartyConfig.AcceptReq = "Aceptar solicitud de ingreso" -- Accept Join Request
BlobsPartyConfig.OnlyLeaderCan = "¡Solo el líder del grupo puede hacer esto!" -- Only the party leader can do this!
BlobsPartyConfig.NotInParty = "¡No estás en una party!" -- You are not in a party!
BlobsPartyConfig.EnRing = "¿Habilitar Anillo?" -- Enable Ring?
BlobsPartyConfig.EnGlow = "¿Habilitar Brillo?" -- Enable Glow?
BlobsPartyConfig.SetClr = "Establecer color" -- Set Color
BlobsPartyConfig.PartyLeader = "Líder de la party:" -- Party leader:
BlobsPartyConfig.PartyMmbs = "Miembros de la party:" -- Party members:
BlobsPartyConfig.Mmbs = "Miembros" -- Members
BlobsPartyConfig.OpenParty = "¿party abierta?" -- Open party?
BlobsPartyConfig.Yes = "Sí" -- Yes
BlobsPartyConfig.No = "No" -- No
BlobsPartyConfig.CopyName = "Copiar nombre" -- Copy name
BlobsPartyConfig.CopySteamID = "Copiar ID de Steam" -- Copy SteamID
BlobsPartyConfig.ViewSteamProfile = "Ver perfil de Steam" -- View steam profile
BlobsPartyConfig.AlreadyOwn = "¡Ya tienes una party!" -- You already own a party!
BlobsPartyConfig.AlreadyIn = "¡Ya estás en una party!" -- You are already in a party!
BlobsPartyConfig.Disband = "Disolver" -- Disband
BlobsPartyConfig.Leave = "Abandonar" -- Leave
BlobsPartyConfig.HP = "HP" -- HP
BlobsPartyConfig.PartyChatPrefix = "(PARTY)" -- (PARTY)
BlobsPartyConfig.NameTooShort = "Nombre de la party demasiado corto (mínimo 3 caracteres)" -- Party name too short (min 3 characters)
BlobsPartyConfig.NameTooLong = "El nombre de la party es demasiado largo (28 caracteres como máximo)" -- Party name too long (max 28 characters)
BlobsPartyConfig.SizeTooSmall = "Tamaño del grupo demasiado pequeño (mínimo 1 jugadores)" -- Party size too small (min 1 players)
BlobsPartyConfig.SizeTooBig = "Tamaño del grupo demasiado grande (máximo 100 jugadores)" -- Party size too big (max 100 players)
BlobsPartyConfig.PartyNameExists = "¡El nombre de la party ya existe!" -- Party name already exists!
BlobsPartyConfig.Full = "¡Esta party está llena!" -- This party is full!
BlobsPartyConfig.ReqSent = "¡Has enviado una solicitud para unirte a la Party!" -- You have sent a request to join the party!
BlobsPartyConfig.AlreadyRequested = "¡Ya has solicitado unirte a la Party!" -- You have already requested to join the party!
BlobsPartyConfig.OwnerLeaveDisband = "¡La party se ha disuelto porque el dueño se ha ido!" -- The party has been disbanded because the owner has left!
BlobsPartyConfig.PartyDisbanded = "¡La party se ha disuelto!" -- The party has been disbanded!
BlobsPartyConfig.PlayerLeave = "¡{p} se ha ido de la party!" -- {p} has left the party!
BlobsPartyConfig.PlayerJoin = "¡{p} se ha unido a la party!" -- {p} has joined the party!
BlobsPartyConfig.PlayerKicked = "¡{p} fue expulsado de la party!" -- {p} was kicked from the party!
BlobsPartyConfig.PlayerReqToJoin = "¡{p} ha solicitado unirse a tu grupo!" -- {p} has requested to join your party!
BlobsPartyConfig.NewOwner = "¡{p} ahora es el dueño de la party!" -- {p} is now the owner of the party!