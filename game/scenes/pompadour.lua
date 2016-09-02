local utf8 = require('utf8')
local TextBuffer = require('game/gui/view/textbuffer')
local Interface = require('game/interface')
local Palette = require('game/palette')

local Pompadour = require('game/gui/scene'):extend("Pompadour")

function Pompadour:init(parent)
	Pompadour.super.init(self, parent, "cactus")

	self.line = 7
	self.character = 1
	self.text = ""
	self.flashrate = 0.6
	self.foreground = Palette.LightBlue
	self.background = Palette.Blue

	self:resetIndicator()

	self.buffer = TextBuffer(self, Interface.Width / 8, Interface.Height / 8)
	self.buffer:clear(nil, self.foreground, self.background)
	self.buffer:write(5, 2, "**** POMPADOUR 64 BASIC V2 ****", self.foreground, self.background)
	self.buffer:write(2, 4, "64K RAM SYSTEM  38911 BASIC BYTES FREE", self.foreground, self.background)
	self.buffer:write(1, 6, "READY.", self.foreground, self.background)

	self:pushView(self.buffer)
end

function Pompadour:resetIndicator()
	self.timer = 0
	self.indicatorVisible = false
end

function Pompadour:writeLine(text, newline)
	local padding = string.rep(' ', self.buffer.width - utf8.len(text))
	self.buffer:write(1, self.line, text .. padding, self.foreground, self.background)

	if newline then
		self.line = self.line + 1

		if self.line > self.buffer.height then
			self.line = self.buffer.height
			self.buffer:scroll(1, nil, self.foreground, self.background)
		end
	end
end

function Pompadour:textinput(text)
	self:resetIndicator()

	if utf8.len(self.text) < self.buffer.width - 1 then
		if self.character > utf8.len(self.text) then
			self.text = self.text .. text
		else
			local charStart = utf8.offset(self.text, self.character - 1)
			local charEnd = utf8.offset(self.text, self.character)

			self.text = self.text:sub(1, charStart) .. text .. self.text:sub(charEnd, -1)
		end

		self.character = self.character + 1
		self:writeLine(self.text)
	end
end

function Pompadour:keypressed(key, scancode, isRepeat)
	local consumed = Pompadour.super.update(self, dt)

	if not consumed then
		if scancode == 'backspace' then
			self:resetIndicator()

			if self.character > 1 then
				local length = utf8.len(self.text)

				if self.character <= length + 1 then
					local charStart = self.character > 2 and utf8.offset(self.text, self.character - 2)
					local charEnd = utf8.offset(self.text, self.character)

					self.text = (charStart and self.text:sub(1, charStart) or '') .. self.text:sub(charEnd, -1)
				end

				self:writeLine(self.text)
				self.character = self.character - 1
			end
		elseif scancode == 'left' then
			self:resetIndicator()
			self:writeLine(self.text)

			self.character = math.max(1, self.character - 1)
		elseif scancode == 'right' then
			self:resetIndicator()
			self:writeLine(self.text)

			self.character = math.min(self.character + 1, utf8.len(self.text) + 1)
		elseif scancode == 'return' then
			self:resetIndicator()

			self:writeLine(self.text, true)
			self:writeLine("", true)
			self:writeLine("?SYNTAX  ERROR", true)
			self:writeLine("READY.", true)

			self.text = ""
			self.character = 1
		else
			return false
		end

		return true
	end

	return consumed
end

function Pompadour:update(dt)
	Pompadour.super.update(self, dt)

	self.timer = self.timer + dt

	if self.timer >= self.flashrate then
		self.timer = self.timer % self.flashrate
	end

	if self.indicatorVisible ~= (self.timer < self.flashrate / 2) then
		local entry = self.buffer:getCharacter(self.character, self.line)
		local character = entry.character
		local foreground = self.indicatorVisible and self.foreground or self.background
		local background = self.indicatorVisible and self.background or self.foreground

		self.buffer:setCharacter(self.character, self.line, character, foreground, background)
		self.indicatorVisible = not self.indicatorVisible
	end
end

return Pompadour
