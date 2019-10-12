-- TODO
-- Make a version without arrayImage
local system = system
local draw = love.graphics.draw
local newSpriteBatch = love.graphics.newSpriteBatch
local floor = math.floor
local ceil = math.ceil
module("graphics.CTileGraphic")

return function(arrayImage, tileMap, mapWidth, mapHeight)
	local public = {}
	public.x = 0
	public.y = 0
	local _spriteBach = newSpriteBatch(arrayImage)
	local _tileWidth = arrayImage:getWidth()
	local _tileMap = tileMap
	local _mapWidth = mapWidth
	local _mapHeight = mapHeight

	public.update = function(_, x, y)
		local camWidth, camHeight = system.getCamera().getDimensions()
		local graphx = public.x + x
		local graphy = public.y + y

		_spriteBach:clear()

		local xstart = 1
		if graphx<0 then
			xstart = floor((-graphx)/_tileWidth)+1
		end
		
		local xstop = _mapWidth
		if graphx+(_mapWidth*_tileWidth) > camWidth then
			xstop = ceil((camWidth-graphx)/_tileWidth)
		end

		if xstop >= xstart then
			local ystart = 0
			if graphy<0 then
				ystart = floor((-graphy)/_tileWidth)
			end

			local ystop = _mapHeight-1
			if graphy+_mapHeight*_tileWidth > camHeight then
				ystop = ceil((camHeight - graphy)/_tileWidth)-1
			end
			
			for i=ystart,ystop do
				local tiley = i*_tileWidth+graphy
				for j=xstart,xstop do
					local tilex = (j-1)*_tileWidth+graphx
					local tileID = _tileMap[i*_mapWidth+j]
					if tileID ~= 0 then
						_spriteBach:addLayer(tileID, tilex, tiley)
					end
				end
			end
		end
		_spriteBach:flush()
	end

	public.draw = function()
		draw(_spriteBach)
	end

	return public
end