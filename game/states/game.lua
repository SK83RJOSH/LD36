local Stack = require('engine/stack')
local State = require('engine/state')
local FontLoader = require('engine/fontloader')
local ImageLoader = require('engine/imageloader')

local Game = State:extend("Game")

function Game:init()
	self.inventory = {}
	self.acquired = {}
	self.data = {}
	self.scenes = Stack({require('game/scenes/desk')(self)})
end

function Game:set(name, data)
	self.data[name] = data
end

function Game:get(name)
	return self.data[name]
end

function Game:addItem(name)
	self.acquired[name] = true
	self.inventory[name] = true
end

function Game:removeItem(name)
	self.inventory[name] = false
end

function Game:hasItem(name)
	return self.inventory[name]
end

function Game:foundItem(name)
	return self.acquired[name]
end

function Game:pushScene(scene)
	self.scenes:push(scene)
end

function Game:popScene()
	if self.scenes:count() <= 1 then return end

	self:sceneEvent('reset')

	return self.scenes:pop()
end

function Game:currentScene()
	return self.scenes:peek()
end

function Game:swapScene(scene)
	self:sceneEvent('reset')

	self.scenes:pop()
	self.scenes:push(scene)
end

function Game:sceneEvent(name, ...)
	local scene = self:currentScene()

	if scene and type(scene[name]) == 'function' then
		return scene[name](scene, ...)
	end

	return false
end

function Game:textinput(text)
	self:sceneEvent('textinput', text)
end

function Game:keypressed(key, scancode, isRepeat)
	local consumed = self:sceneEvent('keypressed', key, scancode, isRepeat)

	if not isRepeat and not consumed then
		if scancode == 'r' and love.keyboard.isScancodeDown('lctrl') then
			function begins(str1, str2)
				return string.sub(str1, 1, #str2) == str2
			end

			for k, v in pairs(package.loaded) do
				if begins(k, 'game/') then
					package.loaded[k] = nil
				end
			end

			FontLoader:clear()
			ImageLoader:clear()

			State.setState(require('game/states/game'))
		elseif scancode == 'escape' then
			if not self:popScene() then
				package.loaded['game/states/intro'] = nil
				package.loaded['game/states/game'] = nil

				FontLoader:clear()
				ImageLoader:clear()

				State.setState(require('game/states/intro'))
			end
		else
			return false
		end

		return true
	end

	return consumed
end

function Game:update(dt)
	self:sceneEvent('update', dt)
end

function Game:draw()
	self:sceneEvent('draw')
end

return Game()
