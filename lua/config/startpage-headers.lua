local headers = {
	{
		[[]],
		[[]],
		[[]],
		[[🛸         🌎  °    🌓  •    .°•      🚀 ✯   ]],
		[[      ★  *          °        🛰   °·      🪐 ]],
		[[.      •  ° ★  •  ☄                          ]],
		[[                 ▁▂▃▄▅▆▇▇▆▅▄▃▂▁.             ]],
		[[]],
		[[]],
	},
	{
		"                   ██          ██                    ",
		"                 ██▒▒██      ██▒▒██                  ",
		"                 ██▒▒▓▓██████▓▓▒▒██                  ",
		"               ██▓▓▒▒▒▒▓▓▓▓▓▓▒▒▒▒▓▓██                ",
		"               ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                ",
		"             ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██              ",
		"             ██▒▒▒▒██▒▒▒▒██▒▒▒▒██▒▒▒▒██              ",
		"             ██▒▒▒▒▒▒▒▒██▒▒██▒▒▒▒▒▒▒▒██              ",
		"           ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██            ",
		"           ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██            ",
		"           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██            ",
		"           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██            ",
		"         ██▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██          ",
		"         ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██          ",
		"         ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ████  ",
		"         ██▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██  ██▒▒▒▒██",
		"         ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██    ██▓▓██",
		"         ██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒██    ██▒▒██",
		"         ██▓▓▒▒▒▒██▒▒██▒▒▒▒▒▒██▒▒██▒▒▒▒▓▓██████▒▒▒▒██",
		"           ██▓▓▒▒██▒▒██▒▒▒▒▒▒██▒▒██▒▒▓▓██▒▒▒▒▓▓▒▒██  ",
		"             ██████▒▒██████████▒▒████████████████    ",
		"                 ██████      ██████                  ",
	},
	{
		[[                               __                ]],
		[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
		[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
		[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
		[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
		[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
		[[]],
	},
}

local fixset = { 2, 3, 4, 10, 12, 13, 14, 15 }
-- Function to get header based on index or random flag
--- Get a header from the list of headers.
-- Description.
-- @param name type Parameter description.
-- @return type  Description of the returned object.
-- @usage Example about how to use it.
local function get_header(index, random)
	if random then
		-- Return a random header if random is true
		math.randomseed(os.time()) -- Seed to get a different random each time
		return headers[math.random(1, #headers)]
	elseif index then
		-- Return the header at the specified index
		return headers[index]
	else
		-- Default to the first header if neither is specified
		return headers[1]
	end
end

return get_header