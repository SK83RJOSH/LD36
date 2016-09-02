local ImageLoader = require('engine/ImageLoader')
local Item = require('game/gui/decoratedscene/item')

local DecoratedScene = require('game/gui/scene'):extend("DecoratedScene")

function DecoratedScene:init(parent, name)
	DecoratedScene.super.init(self, parent, name)

	self.items = {}
	self.background = self:getImage('background')
end

function DecoratedScene:getImage(name)
	return ImageLoader:getImage('scenes/' .. self.name .. '-assets/' .. name)
end

function DecoratedScene:addItem(x, y, name, predicate)
	local item = Item(x, y, self:getImage(name), predicate)

	table.insert(self.items, item)

	return item
end

function DecoratedScene:draw()
	love.graphics.draw(self.background, 0, 0)

	for _, item in ipairs(self.items) do
		item:draw()
	end

	self:viewEvent('draw', 0, self.background:getHeight())
end

return DecoratedScene
