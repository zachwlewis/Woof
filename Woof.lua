-- 1. Pick WOOF as the unique identifier.
-- 2. Pick /woof and /wf as slash commands
SLASH_WOOF1, SLASH_WOOF2 = '/woof', '/wf'

function SlashCmdList.WOOF(msg, editbox)
	if msg == "" or msg == "show" then
		WoofFrame:Show()
	elseif msg == "hide" then
		WoofFrame:Hide()
	else
		WoofPrint("Usage is /wf [show||hide].")
	end
end

local heldItem, currentItem

-- Frame functionality
function WoofFrame_OnLoad(self)
end

function WoofFrame_OnShow(self)
end

function WoofFrame_OnHide()
	heldItem = nil
	currentItem = nil
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
local index = GetChannelName("Trade - City") -- It finds General is a channel at index 1
	if index ~= nil then 
	  SendChatMessage(message , "CHANNEL", nil, index); 
	  PlaySoundFile("Sound/Creature/PugDog/PugDog_Clickable_02.ogg")
	else
		WoofPrint("You are not currently in any trade channels.")
	end
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
	currentItem = heldItem
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

