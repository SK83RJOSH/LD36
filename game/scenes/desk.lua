local Menu = require('game/gui/view/menu')

local Desk = require('game/gui/decoratedscene'):extend("Desk")

function Desk:init(parent)
	Desk.super.init(self, parent, "desk")

	local Game = parent

	local DIAGNOSTIC_HARNESS = self:addItem(145, 80, "diagnostic_harness", function()
		return not Game:foundItem("DIAGNOSTIC_HARNESS")
	end)

	local DIAGNOSTIC_CARTRIDGE = self:addItem(256, 77, "diagnostic_cart", function()
		return not Game:foundItem("DIAGNOSTIC_CARTRIDGE")
	end)

	self:addItem(184, 43, "pompadour_off", function()
		return not Game:get('POMPADOUR_POWERED')
	end)

	self:addItem(184, 43, "pompadour_on", function()
		return not Game:get("POMPADOUR_CARTRIDGE") and Game:get("POMPADOUR_POWERED")
	end)

	self:addItem(184, 43, "pompadour_on_diagnostics", function()
		return Game:get("POMPADOUR_CARTRIDGE") == "DIAGNOSTIC_CARTRIDGE" and Game:get("POMPADOUR_POWERED")
	end)

	self:addItem(240, 81, "diagnostic_harness_overlay", function()
		return Game:get("POMPADOUR_HARNESSED")
	end)

	local DESK_MENU = Menu(self, "DESK")

	self:pushView(DESK_MENU)

	--
	-- // INSPECT //
	--
	local INSPECT_MENU = DESK_MENU:addSubMenu("INSPECT").menu

	-- // INSPECT: POMPADOUR //

	local POMPADOUR_MENU = INSPECT_MENU:addSubMenu("POMPADOUR").menu

	POMPADOUR_MENU:addOption("POWER ON", function()
		Game:set("POMPADOUR_POWERED", true)
	end, function()
		return not Game:get("POMPADOUR_POWERED") and (Game:get("POMPADOUR_CARTRIDGE") ~= "DIAGNOSTIC_CARTRIDGE" or Game:get("POMPADOUR_HARNESSED"))
	end)

	POMPADOUR_MENU:addOption("POWER OFF", function()
		Game:set("POMPADOUR_POWERED", false)
	end, function()
		return Game:get("POMPADOUR_POWERED")
	end)

	POMPADOUR_MENU:addOption("USE", function()
		if Game:get("POMPADOUR_CARTRIDGE") == "DIAGNOSTIC_CARTRIDGE" then
			Game:pushScene(require('game/scenes/diagnostics')(Game))
		else
			Game:pushScene(require('game/scenes/pompadour')(Game))
		end
	end, function()
		return Game:get("POMPADOUR_POWERED")
	end)

	POMPADOUR_MENU:addOption("INSERT DIAGNOSTIC CART", function()
		Game:removeItem("DIAGNOSTIC_CARTRIDGE")
		Game:set("POMPADOUR_CARTRIDGE", "DIAGNOSTIC_CARTRIDGE")
	end, function()
		return not Game:get("POMPADOUR_POWERED") and not Game:get("POMPADOUR_CARTRIDGE") and Game:hasItem("DIAGNOSTIC_CARTRIDGE")
	end)

	POMPADOUR_MENU:addOption("EJECT CARTRIDGE", function()
		Game:addItem(Game:get("POMPADOUR_CARTRIDGE"))
		Game:set("POMPADOUR_CARTRIDGE", nil)
	end, function()
		return not Game:get("POMPADOUR_POWERED") and Game:get("POMPADOUR_CARTRIDGE") and not Game:get("POMPADOUR_HARNESSED")
	end)

	POMPADOUR_MENU:addOption("CONNECT HARNESS", function()
		Game:removeItem("DIAGNOSTIC_HARNESS")
		Game:set("POMPADOUR_HARNESSED", true)
	end, function()
		return not Game:get("POMPADOUR_HARNESSED") and Game:get("POMPADOUR_CARTRIDGE") == "DIAGNOSTIC_CARTRIDGE"
	end)

	POMPADOUR_MENU:addOption("DISCONNECT HARNESS", function()
		Game:addItem("DIAGNOSTIC_HARNESS")
		Game:set("POMPADOUR_HARNESSED", false)
	end, function()
		return Game:get("POMPADOUR_HARNESSED") and not Game:get("POMPADOUR_POWERED")
	end)

	-- // INSPECT: CACTUS //
	INSPECT_MENU:addOption("CACTUS", function(self)
		Game:pushScene(require('game/scenes/cactus')(Game))
	end)

	--
	-- // PICK UPS //
	--
	local PICKUP_MENU = DESK_MENU:addSubMenu("PICK UP", nil, function()
		return not Game:foundItem("DIAGNOSTIC_HARNESS") or not Game:foundItem("DIAGNOSTIC_CARTRIDGE")
	end).menu

	-- // PICK UPS: HARNESS //
	PICKUP_MENU:addOption("DIAG. HARNESS", function(self)
		self.parent.scene:popView()
		Game:addItem("DIAGNOSTIC_HARNESS")
	end, function()
		return not Game:foundItem("DIAGNOSTIC_HARNESS")
	end)

	-- // PICK UPS: CARTRIDGE //
	PICKUP_MENU:addOption("DIAG. CARTRIDGE", function(self)
		self.parent.scene:popView()
		Game:addItem("DIAGNOSTIC_CARTRIDGE")
	end, function()
		return not Game:foundItem("DIAGNOSTIC_CARTRIDGE")
	end)
end

return Desk
