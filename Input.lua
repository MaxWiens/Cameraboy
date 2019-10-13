-- TODO
-- * add controler functions in _controller
--   and uncomment the "or _controller[i]()" in the update function 
local isDown = love.keyboard.isDown
module("Input")

return function()
	local public = {}
	local _inputs = {
		"up",
		"down",
		"left",
		"right",

		"action",
		"record",
		"rewind",
		"play",
		"delete",

		"reset",
	}
	local _inputCount = #_inputs

	local _keyboard = {
		function() if isDown("w") or isDown("up")		then return true end return false end,
		function() if isDown("s") or isDown("down")	then return true end return false end,
		function() if isDown("a") or isDown("left")	then return true end return false end,
		function() if isDown("d") or isDown("right")then return true end return false end,

		function() return isDown("space") end,
		function() if isDown("z") or isDown("j")		then return true end return false end,
		function() if isDown("x") or isDown("k")		then return true end return false end,
		function() if isDown("c") or isDown("l")		then return true end return false end,
		function() if isDown("v") or isDown(";")		then return true end return false end,

		function() if isDown("r")	then return true end return false end,

	}

	local _controller = {
		
	}
	local _current = {}
	local _previous = {}
	
	public.update = function()
		_previous = _current
		_current = {}
		for i=1,_inputCount do
			_current[_inputs[i]] =_keyboard[i]() -- or _controller[i]()
		end
	end

	public.held = function(input)
		return _previous[input] and _current[input]
	end

	public.pressed = function(input)
		return not _previous[input] and _current[input]
	end

	public.released = function(input)
		return _previous[input] and not _current[input]
	end

	public.isDown = function(input)
		return _current[input]
	end

	return public
end