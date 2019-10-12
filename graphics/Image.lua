local system = system
local draw = love.graphics.draw
module("graphics.image")

return function(loveImage)
	local public = {}
	public.x = 0
	public.y = 0
	local _image = loveImage

	public.draw = function(x, y)
		draw(_image, public.x+x, public.y+y)
	end

	return public
end