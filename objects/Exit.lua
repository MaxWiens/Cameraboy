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
local system = system
module("objects.MoveBlock")
local openImage = newImage("assets/objects/doorOpen (2).png")
return function(x, y, properties)
	local public = {}
	-- Object Body --

  public.x = x or 0
  public.y = y or 0
  local _level = properties.level
  local _nextStage = properties.nextStage
  local _looking = properties.looking

  public.update = function(dt,x,y)
    obj = _level.objects[public.y][public.x]
    if obj and obj.isPlayer then
      system.loadStage(require(_nextStage)())
    end
  end

  public.draw = function(x, y)
    local angle = 0
    if      _looking == "down" then
      angle = pi
    elseif  _looking == "right" then
      angle = pi/2
    elseif  _looking == "left" then
      angle = 3*pi/2
    end
    draw(image, x+(public.x-1)*TILE_SIZE+TILE_SIZE/2, y+(public.y-1)*TILE_SIZE+TILE_SIZE/2, angle, TILE_SIZE/2, TILE_SIZE/2)
  end

  -------------
  -- ACTIONS --
  -------------

	return public
end