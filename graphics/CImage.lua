local system = system
local draw = love.graphics.draw
local getDimensions = love.graphics.getDimensions

module("graphics.CImage")

return function(loveImage)
	local public = {}
	public.x = 0
	public.y = 0
	local _image = loveImage
	local _width, _height = loveImage:getDimensions()
	local _visible = false
	local _graphx = 0
	local _graphy = 0

	public.update = function(_, x, y)
		_visible = false
		_graphx = public.x + x
		_graphy = public.y + y

		local camWidth, camHeight = system.getCamera().getDimensions()

		if _graphx <= camWidth and _graphy <= camHeight and _graphx+_width > 0 and _graphy+_height > 0 then
		   	_visible = true
		end
	end

	public.draw = function()
		if _visible then
			draw(_image, _graphx, _graphy)	
		end
	end

	return public
end