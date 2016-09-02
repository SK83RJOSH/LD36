local Utils = require('engine/utils')
local TextBuffer = require('game/gui/view/textbuffer')
local Interface = require('game/interface')
local Palette = require('game/palette')

local Diagnostics = require('game/gui/scene'):extend("Diagnostic")

function Diagnostics:init(parent)
	Diagnostics.super.init(self, parent, "cactus")

	local chance = 1 - 10/100

	self.foreground = Palette.Blue
	self.background = Palette.White
	self.accent = Palette.Red
	self.status = parent:get("DIAGNOSTIC_STATUS")
	self.timer = 1

	if not self.status then
		self.status = {
			{
				{ "ZERO PAGE",		true },
				{ "STACK PAGE",		true },
				{ "SCREEN RAM",		true },
				{ "RAM TEST1",		true },
				{ "RAM TEST2",		true },
				{ "PLA TEST",		true },
				{ "COLOR ROM",		true },
				{ "KERNEL ROM",		true },
				{ "BASIC ROM",		true },
				{ "CHARAC ROM",		true }
			}, {
				{ "CASSETTE",		true },
				{ "KEYBOARD",		true },
				{ "CONTROL PORT",	true },
				{ "SERIAL PORT",	true },
				{ "USER PORT",		true },
				{ "TIMER1 A",		true },
				{ "       B",		true },
				{ "TIMER2 A",		true },
				{ "       B",		true },
				{ "INTERRUPT",		true },
				{ "SOUND TEST",		nil }
			}
		}

		local failedCount = 2 + math.random(3)

		for i = 1, failedCount do
			local colSize = #self.status[1]
			local index = math.random(colSize + #self.status[2] - 1)
			local column = 1

			if index > colSize then
				index = index - colSize
				column = 2
			end

			self.status[column][index][2] = false
		end

		parent:set("DIAGNOSTIC_STATUS", self.status)
	end

	self.buffer = TextBuffer(self, Interface.Width / 8, Interface.Height / 8)
	self.buffer:clear(nil, self.foreground, self.background)
	self.buffer:write(9, 1, "P-64 DIAGNOSTIC REV 506220", self.foreground, self.background)

	local height = 0

	for column, rows in ipairs(self.status) do
		local width = 0

		for row, status in ipairs(rows) do
			width = math.max(#status[1], width)
		end

		width = width + 3

		for row, status in ipairs(rows) do
			local title, status = unpack(status)
			local x = (column - 1) * (self.buffer.width / 2) + column
			local y = 2 + row

			self.buffer:write(x, y, title, self.foreground, self.background)
			self.buffer:write(x + width, y, status == nil and "" or status and "OK" or "BAD", status and self.foreground or self.accent, self.background)
		end

		height = math.max(height, #rows)
	end

	height = height + 4

	local boxHeight = 6

	self.buffer:write(1, height, "╭" .. string.rep("─", self.buffer.width - 2) .. "╮", self.accent, self.background)

	for i = 1, boxHeight do
		self.buffer:write(1, height + i, "┃", self.accent, self.background)
		self.buffer:write(self.buffer.width, height + i, "┃", self.accent, self.background)
	end

	self.buffer:write(1, height + boxHeight + 1, "╰" .. string.rep("─", self.buffer.width - 2) .. "╯", self.accent, self.background)
	self.buffer:write(1, self.buffer.height, "COUNT 0000", self.foreground, self.background)

	self:pushView(self.buffer)
end

function Diagnostics:update(dt)
	Diagnostics.super.update(self, dt)

	self.timer = self.timer + dt

	if self.timer >= 1 then
		local date = os.date("%I:%M:%S%p"):upper()

		self.timer = self.timer % 1
		self.buffer:write(self.buffer.width - #date + 1, self.buffer.height, date, self.foreground, self.background)
	end
end

return Diagnostics
