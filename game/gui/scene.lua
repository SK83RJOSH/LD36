local Stack = require('engine/stack')

local Scene = require('engine/class')("Scene")

function Scene:init(parent, name)
	self.parent = parent
	self.name = name
	self.views = Stack()
end

function Scene:pushView(view)
	self.views:push(view)
end

function Scene:popView()
	if self.views:count() <= 1 then return end

	self:viewEvent('reset')

	return self.views:pop()
end

function Scene:currentView()
	return self.views:peek()
end

function Scene:swapView(view)
	self:viewEvent('reset')

	self.views:pop()
	self.views:push(view)
end

function Scene:viewEvent(name, ...)
	local view = self:currentView()

	if view and type(view[name]) == 'function' then
		return view[name](view, ...)
	end

	return false
end

function Scene:keypressed(key, scancode, isRepeat)
	local consumed = self:viewEvent('keypressed', key, scancode, isRepeat)

	if not isRepeat and not consumed then
		if scancode == 'escape' then
			return self:popView()
		else
			return false
		end

		return true
	end

	return consumed
end

function Scene:update(dt)
	self:viewEvent('update', dt)
end

function Scene:draw()
	self:viewEvent('draw', 0, 0)
end

return Scene
