local State = require('engine/class')("State")

local activeState = nil

function State.setState(state)
	activeState = state
end

function State.getState()
	return activeState
end

function State.event(name, ...)
	if activeState and activeState[name] and type(activeState[name]) == 'function' then
		return activeState[name](activeState, ...)
	end

	return false
end

return State
