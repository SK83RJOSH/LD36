local Dialog = require('game/gui/view/dialog')

local Cactus = require('game/gui/decoratedscene'):extend("Cactus")

function Cactus:init(parent)
	Cactus.super.init(self, parent, "cactus")

	local Game = parent

	self:pushView(Dialog(self, "YOU:", "HOW'S IT GOING?", function(self)
		self.parent:swapView(Dialog(self.parent, "PRICKLEY PETE:", "...", function(self)
			Game:popScene()
		end))
	end))
end

return Cactus
