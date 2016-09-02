local State = require('engine/state')
local FontLoader = require('engine/fontloader')
local Utils = require('engine/utils')
local Interface = require('game/interface')
local Palette = require('game/palette')

local Introduction = State:extend('Introduction')

local STATE_TITLE = 1
local STATE_PROLOGUE_1 = 2
local STATE_PROLOGUE_2 = 3
local STATE_PROLOGUE_3 = 4

function Introduction:init()
	self.timer = 0
	self.flashrate = 1.5
	self.state = STATE_TITLE
	self.title = {}
	self.prologue = {
		[STATE_PROLOGUE_1] = {
			Palette.White, "The year is 1982 and you've just started working at a local computer repair shop called ",
			Palette.Red, "PRIMITIVE TECHNOLOGY",
			Palette.White, "."
		},
		[STATE_PROLOGUE_2] = {
			Palette.White, "Earlier this morning a client dropped of their ",
			Palette.Yellow, "POMPADOUR 64",
			Palette.White, " and mentioned that they were having some issues running software. "
		},
		[STATE_PROLOGUE_3] = {
			Palette.White, "They didn't give you any details but you're pretty sure you can use the ",
			Palette.LightBlue, "DIAGNOSTIC ASSEMBLY KIT",
			Palette.White, " to find the issue..."
		}
	}
	self.continue = "Press any key to continue"

	local title = string.upper(love.window.getTitle())
	local colors = {Palette.Red, Palette.Orange, Palette.Yellow, Palette.LightGreen, Palette.LightBlue}

	for i = 1, #title do
		table.insert(self.title, colors[((i - 1) % #colors) + 1])
		table.insert(self.title, string.sub(title, i, i))
	end
end

function Introduction:keypressed(key, scancode, isRepeat)
	if not isRepeat then
		local char = string.byte(scancode)
		local inRange = #scancode == 1 and char > 33 and char < 127
		local isControl = scancode == 'space' or scancode == 'return'

		if inRange or isControl then
			self.timer = 0

			if self.state == STATE_TITLE then
				self.state = STATE_PROLOGUE_1
			elseif self.state == STATE_PROLOGUE_1 then
				self.state = STATE_PROLOGUE_2
			elseif self.state == STATE_PROLOGUE_2 then
				self.state = STATE_PROLOGUE_3
			else
				State.setState(require('game/states/game'))
			end

			return true
		elseif scancode == 'escape' then
			if self.state == STATE_PROLOGUE_1 then
				self.state = STATE_TITLE
			elseif self.state == STATE_PROLOGUE_2 then
				self.state = STATE_PROLOGUE_1
			elseif self.state == STATE_PROLOGUE_3 then
				self.state = STATE_PROLOGUE_2
			else
				return false
			end

			return true
		end
	end

	return false
end

function Introduction:update(dt)
	self.timer = self.timer + dt

	if self.timer >= self.flashrate then
		self.timer = self.timer % self.flashrate
	end
end

function Introduction:draw()
	love.graphics.push('all')
		local x = 16
		local y = Interface.Height / 4
		local w = Interface.Width - (x * 2)

		if self.state == STATE_TITLE then
			local font = FontLoader:getFont('C64_Pro_Mono-STYLE', 16)

			love.graphics.setFont(font)
			love.graphics.printf(self.title, x, y, w, 'center')
		elseif self.prologue[self.state] then
			local font = FontLoader:getFont('C64_Pro_Mono-STYLE', 8)

			love.graphics.setFont(font)
			love.graphics.printf(self.prologue[self.state], x, y, w)
		end

		if self.timer < self.flashrate / 2 then
			local font = FontLoader:getFont('C64_Pro_Mono-STYLE', 8)
			local x = 32
			local y = Interface.Height - Utils.round(Interface.Height / 4, 8)
			local w = Interface.Width - (x * 2)

			love.graphics.setFont(font)
			love.graphics.printf(self.continue, x, y, w, 'center')
		end
	love.graphics.pop()
end

return Introduction()
