local ADDON_NAME, namespace = ...
local L = namespace.L

function WoofSettingsFrame_OnLoad(self)
	-- Set the name for the Category for the Panel
	self.name = L["Woof"]

	-- When the player clicks okay, run this function.
	self.okay = function (self) end

	-- When the player clicks cancel, run this function.
	self.cancel = function (self) end

	-- Add the panel to the Interface Options
	InterfaceOptions_AddCategory(self)
end