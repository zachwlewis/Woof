-- Saved variables
Woof_Settings = {}
Woof_SavedItems = {}

-- 1. Pick WOOF as the unique identifier.
-- 2. Pick /woof and /wf as slash commands
SLASH_WOOF1, SLASH_WOOF2 = '/woof', '/wf'

function SlashCmdList.WOOF(msg, editbox)
	if msg == "" or msg == "show" then
		LoadBark(nil)
		WoofFrame:Show()
	elseif msg == "hide" then
		WoofFrame:Hide()
	elseif GetItemInfo(msg) ~= nil then
		SetCurrentItem(msg)
		WoofFrame:Show()
	else
		WoofPrint("Usage is /wf [show||hide||<item link>].")
	end
end

local heldItem, currentItem

-- Saving and Loading saved data

function SaveBark(item)
	-- Early out if item doesn't exist.
	if item == nil then return false end

	-- Get data from fields and error check
	local currentValue = MoneyInputFrame_GetCopper(WoofItemValueFrame)
	local currentMessage = WoofFrameText:GetText()
	if currentValue == nil then currentValue = 0 end
	if currentMessage == nil then currentMessage = "" end

	-- Save item, value, and message.
	Woof_SavedItems[item] = {
		value = currentValue,
		message = currentMessage }

	return true
end


function LoadBark(item)
	
	MoneyInputFrame_SetCopper(WoofItemValueFrame, 0)
	WoofFrameText:SetText("")
	
	if Woof_SavedItems[item] == nil then return false end

	-- Get data from fields and error check
	local itemData = Woof_SavedItems[item]
	local itemValue = itemData["value"]
	local itemMessage = itemData["message"]
	if itemValue == nil then itemValue = 0 end
	if itemMessage == nil then itemMessage = "" end

	MoneyInputFrame_SetCopper(WoofItemValueFrame, itemValue)
	WoofFrameText:SetText(itemMessage)

	WoofFrame_Update()
	return true
end

-- Frame functionality

function UpdateWoofVersionString()
	WOOF_VERSION = WOOF_NAME.." ("..GetAddOnMetadata("Woof","Version")..")"
end

-- Deal with text input.
function GetWoofMessageText()
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice
	local price = MoneyInputFrame_GetCopper(WoofItemValueFrame) * 0.0001
	local message = ""
	if currentItem == nil or currentItem == "" then
		itemName = ""
		itemLink = ""
	else
		itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(currentItem)
	end

	message = "{skull} WTS "..itemLink.." "..price.."G {skull} "..WoofFrameText:GetText()
	
	if message == nil then message = "" end

	return message
end

function SetCurrentItem(item)
	-- If an item already exists, save that data first.
	SaveBark(currentItem)

	-- Update the current item.
	currentItem = item

	-- Load the values for that item.
	LoadBark(currentItem)
end

function ClearCurrentItem()
	SaveBark(currentItem)
	currentItem = nil
	WoofFrame_Update()
end

function UpdateCharacterCount()
	if currentItem ~= nil then
		WoofCharacterCount:Show()
		WoofCharacterCount:SetText((255 - GetWoofMessageText():len()).." characters left.")
	else
		WoofCharacterCount:Hide()
	end
end

------------------------
-- Frame Events
------------------------

function WoofFrame_OnEvent(self, event, ...)
	-- Not currently dealing with every event.
end

-- Register Woof as a special frame to be closed with <Escape>.
function WoofFrame_OnLoad(self)
	UpdateWoofVersionString()
	tinsert(UISpecialFrames, self:GetName())
	WoofPrint("has loaded successfully.")
end

-- Play a dialog open sound.
function WoofFrame_OnShow(self)
	PlaySound("igCharacterInfoOpen")
end

-- Reset the dialog and play a dialog close sound.
function WoofFrame_OnHide()
	ClearCurrentItem()
	heldItem = nil
	PlaySound("igCharacterInfoClose")
end

-- Updates the dialog with new information.
function WoofFrame_Update()
	WoofFrame_UpdateItem()
	if currentItem == nil or WoofFrameText:GetText() == "" or MoneyInputFrame_GetCopper(WoofItemValueFrame) == nil or MoneyInputFrame_GetCopper(WoofItemValueFrame) == 0 then
		WoofFrameTestButton:Disable()
		WoofFrameBarkButton:Disable()
	else
		WoofFrameTestButton:Enable()
		WoofFrameBarkButton:Enable()
	end
end

-- Request an update when text changes.
function WoofFrameText_OnTextChanged(self)
	ScrollingEdit_OnTextChanged(self, self:GetParent());
	WoofFrame_Update()
end

------------------------
-- Button Events
------------------------

function WoofFrameTestButton_OnClick()
	WoofPrint(GetWoofMessageText())
end

function WoofFrameBarkButton_OnClick()
	local message = GetWoofMessageText()
	local index = GetChannelName("Trade - City")

	-- Check for valid item.
	if currentItem == nil then
		WoofPrint("You have not selected an item to bark.")
		return
	end

	-- Check for valid channel.
	if index ~= nil and index > 0 then 
	  SendChatMessage(message , "CHANNEL", nil, index); 
	  PlaySoundFile("Sound/Creature/PugDog/PugDog_Clickable_02.ogg")
	else
		WoofPrint("You are not currently in any trade channels.")
	end

	-- Save the item and information for later.
	SaveBark(currentItem)
end

-- Helper functionality.
function WoofPrint(msg)
	if msg == nil then msg = "nil" end
	print("|cFF4BA0FFWoof|r "..msg)
end

function LearnCurrentHeldItem()
	local type, id, link = GetCursorInfo()
	if type == "item" then
		heldItem = link
	end
end

function ForgetCurrentHeldItem()
	heldItem = nil
end

function ItemDropped()
	ClearCursor()
	SetCurrentItem(heldItem)
	heldItem = nil
end

function ItemPicked()
	-- heldItem = currentItem
	-- currentItem = nil
end		

function SetTooltip()
	if currentItem == nil then return end
	GameTooltip:SetHyperlink(currentItem)
end

function WoofFrame_UpdateItem()
	local buttonText = _G["WoofItemName"];
	local woofItemButton = _G["WoofItemItemButton"]
	local woofItemCount = _G["WoofItemItemButtonCount"]

	if currentItem == nil or currentItem == "" then
		currentItem = nil
		buttonText:SetText("No item to bark.")
		SetItemButtonTexture(woofItemButton, nil)
	else

		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(currentItem)

		buttonText:SetText(itemName)
		SetItemButtonTexture(woofItemButton, itemTexture)
		woofItemCount.hidden = true

		if ( texture ) then
			WoofItem.hasItem = 1
		else
			WoofItem.hasItem = nil
		end

	end

	UpdateCharacterCount()

end
