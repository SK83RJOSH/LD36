local utf8 = require('utf8')
local FontLoader = require('engine/fontloader')
local Palette = require('game/palette')

local TextBuffer = require('engine/class')("TextBuffer")

function TextBuffer:init(parent, width, height)
	self.parent = parent
	self.width = width
	self.height = height
	self.font = FontLoader:getFont('C64_Pro_Mono-STYLE', 8, 1)
	self.texture = love.graphics.newCanvas(self.width * 8, self.height * 8)
	self.map = {}

	for y = 1, self.height do
		self.map[y] = {}

		for x = 1, self.width do
			self.map[y][x] = {
				background = Palette.Black,
				foreground = Palette.White,
				character = nil
			}
		end
	end

	self.texture:renderTo(function()
		love.graphics.clear(Palette.Black)
	end)
end

function TextBuffer:getCharacter(x, y)
	return self.map[y] and self.map[y][x]
end

function TextBuffer:setCharacter(x, y, character, foreground, background)
	local entry = self.map[y] and self.map[y][x]

	if entry then
		local entry = self.map[y][x]
		local foreground = foreground or entry.foreground
		local background = background or entry.background
		local x = (x - 1) * 8
		local y = (y - 1) * 8

		self.texture:renderTo(function()
			love.graphics.push('all')
				love.graphics.setColor(background)
				love.graphics.rectangle('fill', x, y, 8, 8)

				if character then
					love.graphics.setFont(self.font)
					love.graphics.setColor(foreground)
					love.graphics.print(character, x, y - self.font:getDescent())
				end
			love.graphics.pop()
		end)

		entry.background = background
		entry.foreground = foreground
		entry.character = character
	end
end

function TextBuffer:clear(character, foreground, background, x, y, width, height)
	local x = x or 1
	local y = y or 1
	local width = width or self.width
	local height = height or self.height

	for x = x, width do
		for y = y, height do
			self:setCharacter(x, y, character, foreground, background)
		end
	end
end

function TextBuffer:write(x, y, text, foreground, background)
	for c = 1, utf8.len(text) do
		local character = text:sub(utf8.offset(text, c), utf8.offset(text, c + 1) - 1)

		self:setCharacter(x + (c - 1), y, character, foreground, background)
	end
end

function TextBuffer:scroll(lines, character, foreground, background)
	local foreground = foreground or Palette.Black
	local background = background or Palette.Black

	for i = 1, lines do
		local buffer = {}

		for x = 1, self.width do
			buffer[x] = {
				background = background or Palette.Black,
				foreground = foreground or Palette.White,
				character = character
			}
		end

		table.remove(self.map, 1)
		table.insert(self.map, buffer)
	end

	self.texture:renderTo(function()
		local lines = lines * 8
		local image = love.graphics.newImage(self.texture:newImageData(0, lines, self.texture:getWidth(), self.texture:getHeight() - lines))

		love.graphics.clear(background or Palette.Black)
		love.graphics.draw(image)
	end)
end

function TextBuffer:draw(x, y)
	love.graphics.push('all')
		love.graphics.draw(self.texture, x, y)
	love.graphics.pop()
end

return TextBuffer
