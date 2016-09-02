local Item = require('engine/class')("Item")

function Item:init(x, y, image, predicate)
	self.x = x
	self.y = y
	self.image = image
	self.predicate = predicate
end

function Item:draw()
	if self.predicate() then
		love.graphics.draw(self.image, self.x, self.y)
	end
end

return Item
