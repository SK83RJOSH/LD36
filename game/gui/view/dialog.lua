local FontLoader = require('engine/fontloader')
local Utils = require('engine/utils')
local Interface = require('game/interface')
local Palette = require('game/palette')

local Dialog = require('engine/class')("Dialog")

function Dialog:init(parent, title, message, action)
	self.parent = parent
	self.title = title
	self.message = message
	self.displayMessage = ""
	self.action = action
	self.font = FontLoader:getFont('C64_Pro_Mono-STYLE', 8)
	self.titleColor = Palette.Yellow
	self.messageColor = Palette.White
	self.indicatorColor = Palette.White
	self.indicator = "◢"
	self.indicatorOffset = 2
	self.indicatorTime = 1.5
	self.indicatorTimer = 0
	self.padding = 10
	self.width = Interface.Width
	self.characterTime = 0.1
	self.lifetime = 0
end

function Dialog:keypressed(key, scancode, isRepeat)
	if not isRepeat then
		if scancode == 'return' then
			if self.displayMessage ~= self.message then
				self.displayMessage = self.message
			elseif self.action then
				self:action()
			end
		end
	end
end

function Dialog:update(dt)
	if self.displayMessage ~= self.message then
		local messageLength = #self.message
		local length = math.min(Utils.round(self.lifetime / self.characterTime), messageLength)

		self.displayMessage = string.sub(self.message, 1, length)
		self.lifetime = self.lifetime + dt
	else
		self.indicatorTimer = self.indicatorTimer + dt

		if self.indicatorTimer >= self.indicatorTime then
			self.indicatorTimer = self.indicatorTimer % self.indicatorTime
		end
	end
end

function Dialog:draw(x, y)
	local font = self.font
	local padding = self.padding
	local width = self.width

	love.graphics.push('all')
		love.graphics.setFont(font)
		love.graphics.setColor(self.titleColor)
		love.graphics.print(self.title, x + padding, y + padding)

		love.graphics.setColor(self.messageColor)
		love.graphics.printf(self.displayMessage, x + padding, y + padding * 3, width - padding * 2)

		if self.displayMessage == self.message then
			local indicator = self.indicator
			local indicatorWidth = font:getWidth(indicator)
			local indicatorHeight = font:getHeight(indicator)
			local indicatorOffset = self.indicatorOffset

			if self.indicatorTimer > self.indicatorTime / 2 then
				indicatorOffset = 0
			end

			love.graphics.setColor(self.indicatorColor)
			love.graphics.print(indicator, width - padding - indicatorWidth - indicatorOffset, Interface.Height - padding - indicatorHeight - indicatorOffset)
		end
	love.graphics.pop()
end

return Dialog
