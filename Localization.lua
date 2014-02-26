-- Globals for XML
-- Override these in the desired locale.
WOOF_DIALOG_TITLE = "Woof"
WOOF_NO_ITEM = "No item to bark."
WOOF_BUTTON_TEST = "Test"
WOOF_BUTTON_BARK = "Bark"
WOOF_VERSION = ""
WOOF_NAME = "Woof"

local _, namespace = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

namespace.L = L

local LOCALE = GetLocale()

if LOCALE:match("^en") then
return end

if LOCALE == "deDE" then
	-- German translations go here
	L["Hello!"] = "Hallo!"
return end

if LOCALE == "frFR" then
	-- French translations go here
	WOOF_NO_ITEM = "Vous n'avez pas selectionné d'item pour votre annonce"
	WOOF_BUTTON_TEST = "Tester"
	WOOF_BUTTON_BARK = "Annoncer"

	L["{skull} WTS "] ="{crâne} Vends "
	L["G {skull} "] = "PO {crâne} "
	L[" characters left."] = " caractères restants."
	L["Trade - City"] = "Commerce - Capitales"
	L["You have not selected an item to bark."] = "Vous n'avez pas selectionné d'item pour votre annonce."
	L["You are not currently in any trade channels."] = "Vous n’êtes pas actuellement dans un canal commerce."
	L["No item to bark."] = "Aucun objet à annoncer."
	
	
return end

if LOCALE == "esES" or LOCALE == "esMX" then
	-- Spanish translations go here
	L["Hello!"] = "¡Hola!"
return end

if LOCALE == "ptBR" then
	-- Brazilian Portuguese translations go here
	L["Hello!"] = "Olá!"
return end

if LOCALE == "ruRU" then
	-- Russian translations go here
	L["Hello!"] = "Привет!"
return end

if LOCALE == "koKR" then
	-- Korean translations go here
	L["Hello!"] = "안녕하세요!"
return end

if LOCALE == "zhCN" then
	-- Simplified Chinese translations go here
	L["Hello!"] = "您好!"
return end

if LOCALE == "zhTW" then
	-- Traditional Chinese translations go here
	L["Hello!"] = "您好!"
return end