local Utils = {}

function Utils.distance(x1, y1, x2, y2)
	return math.abs(x1 - x2) + math.abs(y1 - y2)
end

function Utils.round(value, nearest)
	if not nearest then
		return math.floor(value + 0.5)
	else
		return math.floor(value / nearest + 0.5) * nearest
	end
end

function Utils.chance(chance)
	return math.random() <= chance
end

function Utils.coalesce(value1, value2)
	return value1 ~= nil and value1 or value2
end

return Utils
