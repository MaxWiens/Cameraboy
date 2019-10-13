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
module("objects.MoveBlock")
local image = newImage("assets/objects/conveyorbelt.png")

local MOVE_COOLDOWN = 0.13
return function(x, y, properties)
	local public = {}
	-- Object Body --

  public.x = x or 0
  public.y = y or 0
  local _level = properties.level
  public.on = properties.on or false
  local _horizontal = properties.horizontal
  public.isSolid = true
  local _looking = properties.looking
  
  local _moveCooldown = 0


  public.update = function(dt,x,y)
    if public.on then
      if _moveCooldown == 0 then 
        local obj = _level.objects[public.y][public.x]
        if obj and obj.move then
          obj.move(_looking)
        end
        _moveCooldown = MOVE_COOLDOWN
      elseif _moveCooldown  > 0 then
        _moveCooldown = _moveCooldown - dt
      elseif _moveCooldown  < 0 then
        _moveCooldown = 0
      end
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
    draw(image, x+(public.x-1)*TILE_SIZE+TILE_SIZE/2, y+(public.y-1)*TILE_SIZE+TILE_SIZE/2, angle, 1,1, TILE_SIZE/2, TILE_SIZE/2)
  end

  -------------
  -- ACTIONS --
  -------------

	return public
end