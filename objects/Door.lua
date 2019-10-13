local C = require "Constants"
local TILE_SIZE = C.TILE_SIZE
local REVERSE = C.REVERSE
local state = system.state
local newImage = love.graphics.newImage
local pairs = pairs
local draw = love.graphics.draw
local pi = math.pi
local print = print
local input = input
module("objects.Door")
local openImage = newImage("assets/objects/doorOpen (2).png")
local closeImage = newImage("assets/objects/doorClose (2).png")
return function(x, y, properties)
	local public = {}
	-- Object Body --

  public.x = x or 0
  public.y = y or 0
  local _level = properties.level
  public.on = properties.on or false
  local _horizontal = properties.horizontal
  public.isSolid = true

  public.update = function(dt,x,y)
    if public.on then
      if _level.objects[public.y][public.x] == public then
        _level.objects[public.y][public.x] = nil
      end
    else
      _level.objects[public.y][public.x] = public
    end
  end

  public.draw = function(x, y)
    local image = nil
    local angle = 0
    if public.on then
      image = openImage
    else
      image = closeImage
    end
    if not _horizontal then
      angle = pi/2
    end
    draw(image, x+(public.x-1)*TILE_SIZE+TILE_SIZE/2, y+(public.y-1)*TILE_SIZE+TILE_SIZE/2, angle, 1, 1, TILE_SIZE/2, TILE_SIZE/2)
  end

  -------------
  -- ACTIONS --
  -------------

	return public
end