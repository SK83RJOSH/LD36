local Palette = {}

Palette.Black		= {0, 0, 0}
Palette.White		= {255, 255, 255}
Palette.Red			= {136, 0, 0}
Palette.Cyan		= {170, 255, 238}
Palette.Violet		= {204, 68, 204}
Palette.Green		= {0, 204, 85}
Palette.Blue		= {0, 0, 170}
Palette.Yellow		= {238, 238, 119}
Palette.Orange		= {221, 136, 85}
Palette.Brown		= {102, 68, 0}
Palette.LightRed	= {255, 119, 119}
Palette.Grey1		= {51, 51, 51}
Palette.Grey2		= {119, 119, 119}
Palette.LightGreen	= {170, 255, 102}
Palette.LightBlue	= {0, 136, 255}
Palette.Grey3		= {187, 187, 187}

Palette.POKE = {
	Palette.Black, Palette.White, Palette.Red, Palette.Cyan,
	Palette.Violet, Palette.Green, Palette.Blue, Palette.Yellow,
	Palette.Orange, Palette.Brown, Palette.LightRed, Palette.Grey1,
	Palette.Grey2, Palette.LightGreen, Palette.LightBlue, Palette.Grey3
}

function Palette:nearest(r, g, b)
	local abs = math.abs
	local nearest, nearestDistance
	local unpack = unpack

	for _, color in ipairs(self.POKE) do
		local distance = abs(r - color[1]) + abs(g - color[2]) + abs(b - color[3])

		if not nearest or distance < nearestDistance then
			nearest = color
			nearestDistance = distance
		end
	end

	return unpack(nearest)
end

return Palette
