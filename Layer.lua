local system = system
local pairs = pairs
module("Layer")

return function(xParalax, yParalax)
	local public = {}

	local _xParalax = xParalax
	local _yParalax = yParalax
	local _updateFunctions = {}
	local _drawFunctions = {}
	local _xMod = 0
	local _yMod = 0

	public.addUpdate = function(updateFun, ID)
		_updateFunctions[ID] = updateFun
	end

	public.addDraw = function(drawFun, ID)
		_drawFunctions[ID] = drawFun
	end

	public.remove = function(ID)
		_updateFunctions[ID] = nil
		_drawFunctions[ID] = nil
	end

	public.update = function(dt, x, y)
		_xMod = x*_xParalax
		_yMod = y*_yParalax
		for _, updateFun in pairs(_updateFunctions) do
			updateFun(dt, _xMod, _yMod)
		end
	end

	public.draw = function()
		for _, drawFun in pairs(_drawFunctions) do
			drawFun(_xMod, _yMod)
		end
	end

	return public
end