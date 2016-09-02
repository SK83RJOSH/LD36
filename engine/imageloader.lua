local ImageLoader = {}

ImageLoader.directory = 'assets/images/'
ImageLoader.extension = '.png'
ImageLoader.cache = {}

function ImageLoader:getImage(name)
	local image = self.cache[name]

	if not image then
		image = love.graphics.newImage(self.directory .. name .. self.extension, size)
		self.cache[name] = image
	end

	return image
end

function ImageLoader:clear()
	self.cache = {}
end

return ImageLoader
