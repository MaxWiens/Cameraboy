local C = require "Constants"
local TILE_SIZE = C.TILE_SIZE
local REVERSE = C.REVERSE
local state = state
local newImage = love.graphics.newImage
local pairs = pairs
local draw = love.graphics.draw

module("objects.MoveBlock")
local image = newImage("assets/objects/crate.png")
return function(x, y, properties)
	local public = {}
	-- Object Body --

  public.x = x or 0
  public.y = y or 0
  _level = properties.level
  _history = {}
  _historyCount = 0


  public.update = function(dt,x,y)
    if state.time == "rewind" then
      local hist = _history[_historyCount]
      while _historyCount > 0 and hist[1] >= state.timeSince do
        _historyCount = _historyCount - 1
        local fun = hist[2]
        local param1 = hist[3]
        local param2 = hist[4]
        
        if param2 then
          fun(param2)
        else
          fun(REVERSE[param1])
        end

        hist = _history[_historyCount]
        if not hist then
          break
        end
      end
    elseif state.time == "normal" then
    end
  end

  public.draw = function(x, y)
    draw(image, x+(public.x-1)*TILE_SIZE+TILE_SIZE/2, y+(public.y-1)*TILE_SIZE+TILE_SIZE/2)
  end

  -------------
  -- ACTIONS --
  -------------
  public.move = function(direction)
    local isSolid = _level.isSolid
    local isPushed = isPushed or false
    if direction == "up" then
      local newy = public.y - 1
      if not isSolid(public.x, newy) then
        local obj = _level.objectAt(public.x, newy)
        if obj and not obj.move and not obj.move(public.x, newy-1) then
          return false
        end
        public.y = newy
        _moveCooldown = MOVE_COOLDOWN
        return true
      end
    elseif direction == "down" then
      local newy = public.y + 1
      if not isSolid(public.x, newy) then
        local obj = _level.objectAt(public.x, newy)
        if obj and not obj.move and not obj.move(public.x, newy+1) then
          return false
        end
        public.y = newy
        _moveCooldown = MOVE_COOLDOWN
        return true
      end
    elseif direction == "left" then
      local newx = public.x - 1
      if not isSolid(newx, public.y) then
        local obj = _level.objectAt(newx, public.y)
        if obj and not obj.move and not obj.move(newx, public.y-1) then
          return false
        end
        public.x = newx
        _moveCooldown = MOVE_COOLDOWN
        return true
      end
    elseif direction == "right" then
      local newx = public.x + 1
      if not isSolid(newx, public.y) then
        local obj = _level.objectAt(newx, public.y)
        if obj and not obj.move and not obj.move(newx, public.y-1) then
          return false
        end
        public.x = newx
        _moveCooldown = MOVE_COOLDOWN
        return true
      end
    end
  end

	return public
end