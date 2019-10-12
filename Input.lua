-- TODO
-- * add controler functions in _controller
--   and uncomment the "or _controller[i]()" in the update function 
local isDown = love.keyboard.isDown
module("Input")

return function()
	local public = {}
	local _inputs = {
		-- "up",
		-- "down",
		-- "left",
		-- "right"
	}
	local _inputCount = #_inputs

	local _keyboard = {
		-- function() return isDown("w") end,
		-- function() return isDown("s") end,
		-- function() return isDown("a") end,
		-- function() return isDown("d") end
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

	public.isDown = function()
		return _current[input]
	end

	return public
end