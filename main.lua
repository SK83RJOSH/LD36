local State = require('engine/state')
local Interface = require('game/interface')

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.keyboard.setKeyRepeat(true)

	State.setState(require('game/states/intro'))
end

function love.focus(focus)
	love.mouse.setVisible(not focus)
end

function love.mousemoved(x, y, dx, dy, isTouch)
	State.event('mousemoved', x, y, dx, dy, isTouch)
end

function love.mousepressed(x, y, button, isTouch)
	State.event('mousepressed', x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
	State.event('mousereleased', x, y, button, isTouch)
end

function love.textinput(text)
	State.event('textinput', text)
end

function love.keypressed(key, scancode, isRepeat)
	local consumed = State.event('keypressed', key, scancode, isRepeat)

	if not isRepeat and not consumed then
		if scancode == 'f11' then
			love.window.setFullscreen(not love.window.getFullscreen())
		elseif scancode == 'escape' then
			love.event.quit()
		end
	end
end

function love.keyreleased(key, scancode)
	State.event('keyreleased', key, scancode)
end

function love.update(delta)
	State.event('update', delta)
	collectgarbage('step', 512)
end

function love.draw()
	love.graphics.push()
		Interface.transform()
		State.event('draw')
	love.graphics.pop()

	local stats = love.graphics.getStats()
	local fps = love.timer.getFPS()
	local ram = collectgarbage('count') / 1024
	local vram = stats.texturememory / 1024 / 1024
	local drawcalls = stats.drawcalls
	local string = ("FPS: %i, RAM: %.2fMB, VRAM: %.2fMB, Drawcalls: %i"):format(fps, ram, vram, drawcalls)

	-- love.graphics.print(string, 2, 2)
end
