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
	elseif msg == "data" then
		DumpData(Woof_SavedItems)
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

function DumpData(dumpTable)
	for k,v in pairs(dumpTable) do
		print(k,v)
		if type(v) == "table" then  -- DumpData(dumpTable) end
			for k1,v1 in pairs(v) do
				print(k1,v1)
			end
		end
	end
end

-- Frame functionality
function WoofFrame_OnLoad(self)
end

function WoofFrame_OnShow(self)
end

function WoofFrame_OnHide()
	ClearCurrentItem()
	heldItem = nil
	WoofFrame_UpdateItem()
end

function WoofFrame_OnEvent(self, event, ...)
end

-- Updates the frame with new information.
function WoofFrame_Update()
	WoofFrame_UpdateItem();
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

	message = "WTS "..itemLink.." "..price.."G "..WoofFrameText:GetText()
	
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

	WoofFrame_UpdateItem()
end

function ClearCurrentItem()
	SaveBark(currentItem)
	currentItem = nil
end

function WoofFrameText_OnTextChanged(self)
	ScrollingEdit_OnTextChanged(self, self:GetParent());
	WoofFrame_UpdateItem()
end

function UpdateCharacterCount()
	WoofCharacterCount:Show();
	WoofCharacterCount:SetText((255 - GetWoofMessageText():len()).." characters left.")
end

-- Button Functions
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
	print("|cFF33FF33 Woof|r "..msg)
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
		buttonText:SetText("No item to bark.")
		SetItemButtonTexture(woofItemButton, nil)
		return
	end

	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(currentItem)

	buttonText:SetText(itemName)
	SetItemButtonTexture(woofItemButton, itemTexture)
	woofItemCount.hidden = true
	if ( texture ) then
		WoofItem.hasItem = 1;
	else
		WoofItem.hasItem = nil;
	end

	UpdateCharacterCount()
end

-- On load
do
	WoofPrint("has loaded successfully.")
end

