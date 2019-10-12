-- TODO
-- Make a version without arrayImage
local system = system
local getDimensions = love.graphics.getDimensions
local drawLayer = love.graphics.drawLayer
module("graphics.CAnimation")

return function(arrayImage, msDelay, loop)
	local public = {}
	public.x = 0
	public.y = 0
	local _arrayImage = arrayImage
	local _msDelay = msDelay
	local _loop = loop or false

	local _frameCount = arrayImage:getLayerCount()
	local _width, _height = arrayImage:getDimensions()

	local _finished = false
	local _msTimer = 0
	local _frameCursor = 1
	local _graphx = 0
	local _graphy = 0
	local _visible = false

	public.update = function(dt, x, y)
		local camWidth, camHeight = system.getCamera().getDimensions()
		_graphx = public.x + x
		_graphy = public.y + y

		_visible = false
		if _graphx <= camWidth and _graphy <= camHeight and _graphx+_width > 0 and _graphy+_height > 0 then
		   	_visible = true
		end

		if not _finished then
			_msTimer = _msTimer + dt

			if _msTimer >= _msDelay then
				_msTimer = _msTimer - _msDelay
				_frameCursor = _frameCursor + 1
			end

			if _frameCursor > _frameCount then
				if _loop then
					_frameCursor = 1
				else
					_finished = true
				end
			end
		end
	end

	public.draw = function()
		if _visible then
			drawLayer(arrayImage, _frameCursor, _graphx, _graphy)
		end
	end

	public.reset = function()
		_frameCursor = 1
		_msTimer = 0
		_finished = false
	end

	return public
end