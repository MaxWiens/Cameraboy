module("Camera")

return function(width, height)
	local public = {}
	public.x = 0
	public.y = 0
	public.lock = nil
	local _width = width
	local _height = height
	public.update = function()
	end
	public.getDimensions = function()
		return _width,_height
	end

	return public
end