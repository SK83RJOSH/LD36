local FontLoader = {}

FontLoader.directory = 'assets/fonts/'
FontLoader.extension = '.ttf'
FontLoader.cache = {}

function FontLoader:getFont(name, size, lineheight)
	local lineheight = lineheight or 1.4
	local font = self.cache[name] and self.cache[name][size] and self.cache[name][size][lineheight]

	if not font then
		font = love.graphics.newFont(self.directory .. name .. self.extension, size)
		font:setLineHeight(lineheight)

		self.cache[name] = self.cache[name] or {}
		self.cache[name][size] = self.cache[name][size] or {}
		self.cache[name][size][lineheight] = font
	end

	return font
end

function FontLoader:clear()
	self.cache = {}
end

return FontLoader
