local Stack = require('engine/class')("Stack")

function Stack:init(stack)
	self.stack = stack or {}
end

function Stack:count()
	return #self.stack
end

function Stack:push(item)
	table.insert(self.stack, item)
end

function Stack:pop()
	return table.remove(self.stack, #self.stack)
end

function Stack:peek()
	return self.stack[#self.stack]
end

return Stack
