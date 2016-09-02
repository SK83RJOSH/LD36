local FontLoader = require('engine/fontloader')
local Utils = require('engine/utils')
local Option = require('game/gui/view/menu/option')
local Interface = require('game/interface')
local Palette = require('game/palette')

local Menu = require('engine/class')("Menu")

function Menu:init(scene, title)
	self.scene = scene
	self.title = title
	self.options = {}
	self.enabledOptions = {}
	self.selected = 1
	self.font = FontLoader:getFont('C64_Pro_Mono-STYLE', 8)
	self.color = Palette.Yellow
	self.padding = 10
	self.width = Interface.Width
end

function Menu:addSubMenu(title, action, predicate)
	local option = self:addOption(title, function(self)
		self.parent.scene:pushView(self.menu)

		if action then
			action()
		end
	end, predicate)

	option.menu = Menu(self.scene, title)

	return option
end

function Menu:addOption(title, action, predicate)
	local option = Option(self, title, action, predicate)

	table.insert(self.options, option)

	return option
end

function Menu:removeOption(option)
	for i = #self.options, 1, -1 do
		if self.options[i] == option then
			table.remove(self.options, i)
		end
	end
end

function Menu:left()
	if #self.enabledOptions <= 1 then return end

	self.selected = self.selected - 1

	if self.selected == 0 then
		self.selected = #self.enabledOptions
	end
end

function Menu:right()
	if #self.enabledOptions <= 1 then return end

	self.selected = self.selected + 1

	if self.selected > #self.enabledOptions then
		self.selected = 1
	end
end

function Menu:up()
	if #self.enabledOptions <= 1 then return end

	local selected = self.enabledOptions[self.selected]
	local selectedX = selected.x + selected.option:getWidth() / 2
	local selectedY = selected.y + selected.option:getHeight() / 2

	local closest, distance

	for i, enabled in ipairs(self.enabledOptions) do
		if enabled.y < selected.y then
			local enabledX = enabled.x + enabled.option:getWidth() / 2
			local enabledY = enabled.y + enabled.option:getHeight() / 2
			local enabledDistance = Utils.distance(selectedX, selectedY, enabledX, enabledY)

			if not closest or enabledDistance < distance then
				closest = i
				distance = enabledDistance
			end
		end
	end

	self.selected = closest or self.selected
end

function Menu:down()
	if #self.enabledOptions <= 1 then return end

	local selected = self.enabledOptions[self.selected]
	local selectedX = selected.x + selected.option:getWidth() / 2
	local selectedY = selected.y + selected.option:getHeight() / 2

	local closest, distance

	for i, enabled in ipairs(self.enabledOptions) do
		if enabled.y > selected.y then
			local enabledX = enabled.x + enabled.option:getWidth() / 2
			local enabledY = enabled.y + enabled.option:getHeight() / 2
			local enabledDistance = Utils.distance(selectedX, selectedY, enabledX, enabledY)

			if not closest or enabledDistance < distance then
				closest = i
				distance = enabledDistance
			end
		end
	end

	self.selected = closest or self.selected
end

function Menu:select()
	local option = self.enabledOptions[self.selected]

	if option then
		option.option:activate()
	end
end

function Menu:keypressed(key, scancode, isRepeat)
	if not isRepeat then
		if scancode == 'left' then
			self:left()
		elseif scancode == 'right' then
			self:right()
		elseif scancode == 'up' then
			self:up()
		elseif scancode == 'down' then
			self:down()
		elseif scancode == 'return' then
			self:select()
		else
			return false
		end

		return true
	end

	return false
end

function Menu:update(dt)
	local options = self.enabledOptions

	for k, v in ipairs(options) do
		options[k] = nil
	end

	local padding = self.padding
	local x = 0
	local y = 0
	local width = Interface.Width

	for _, option in ipairs(self.options) do
		if option:isEnabled() then
			local optionWidth = option:getWidth() + padding * 2

			if x + optionWidth > width - padding then
				x = 0
				y = y + option:getHeight()
			end

			table.insert(options, {
				x = x,
				y = y,
				option = option
			})

			x = x + optionWidth
		end
	end

	self.selected = math.min(self.selected, #options)
end

function Menu:draw(x, y)
	x = x + self.padding
	y = y + self.padding

	love.graphics.push('all')
		love.graphics.setFont(self.font)
		love.graphics.setColor(self.color)
		love.graphics.print(self.title, x, y)

		love.graphics.translate(x, y + self.padding * 2)

		for i, option in ipairs(self.enabledOptions) do
			option.option:draw(option.x, option.y, i == self.selected)
		end
	love.graphics.pop()
end

return Menu
