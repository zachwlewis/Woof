function WoofSettingsFrame_OnLoad(self)
	-- Set the name for the Category for the Panel
	self.name = "Woof"

	-- When the player clicks okay, run this function.
	self.okay = function (self) print("Okay clicked") end

	-- When the player clicks cancel, run this function.
	self.cancel = function (self) print("Cancel clicked.") end

	-- Add the panel to the Interface Options
	InterfaceOptions_AddCategory(self)
end