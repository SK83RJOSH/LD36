local FontLoader = require('engine/fontloader')
local Palette = require('game/palette')

local Option = require('engine/class')("Option")

function Option:init(parent, title, action, predicate)
	self.parent = parent
	self.title = title
	self.action = action
	self.predicate = predicate
	self.active = false
	self.font = FontLoader:getFont('C64_Pro_Mono-STYLE', 8)
end

function Option:isEnabled()
	return not self.predicate or self.predicate()
end

function Option:getWidth()
	return self.font:getWidth(self.title)
end

function Option:getHeight()
	return self.font:getBaseline() * self.font:getLineHeight() * 2
end

function Option:activate()
	if self.action then
		self:action()
	end
end

function Option:draw(x, y, selected)
	love.graphics.push('all')
		love.graphics.setFont(self.font)
		love.graphics.setColor(selected and Palette.White or Palette.Grey2)
		love.graphics.print(self.title, x, y)
	love.graphics.pop()
end

return Option
