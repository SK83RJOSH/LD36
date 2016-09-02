local Interface = {}

Interface.Width = 320
Interface.Height = 200

function Interface.transform()
	local iWidth = Interface.Width
	local iHeight = Interface.Height
	local gWidth = love.graphics.getWidth()
	local gHeight = love.graphics.getHeight()
	local scale = math.min(gWidth / iWidth, gHeight / iHeight)

	love.graphics.translate((gWidth - iWidth * scale) / 2, (gHeight - iHeight * scale) / 2)
	love.graphics.scale(scale)
end

return Interface
