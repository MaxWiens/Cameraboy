local C = require "Constants"
local TILE_SIZE = C.TILE_SIZE
local REVERSE = C.REVERSE
local state = system.state
local newImage = love.graphics.newImage
local pairs = pairs
local draw = love.graphics.draw

local print = print
local input = input
module("objects.MoveBlock")
local image = newImage("assets/objects/crate.png")
return function(x, y, properties)
	local public = {}
	-- Object Body --

  public.x = x or 0
  public.y = y or 0
  local _level = properties.level
  local _history = {}
  local _historyCount = 0
  local _playbackCount = 0
  public.disabled = false

  public.update = function(dt,x,y)
    if state.time == "rewind" then
      local hist = _history[_historyCount]
      while _historyCount > 0 and hist[1] >= state.timeSince do
        _historyCount = _historyCount - 1
        _playbackCount = _playbackCount + 1
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
    elseif state.time == "play" then
      local hist = _history[_historyCount+1]
      while _playbackCount > 0 and hist[1] <= state.timeSince do
        _playbackCount = _playbackCount - 1
        local fun = hist[2]
        local param1 = hist[3]
        local param2 = hist[4]
        fun(param1)
        _historyCount = _historyCount + 1
        hist = _history[_historyCount+1]
        if not hist then
          break
        end
      end
    end
    public.disabled = false
  end

  public.draw = function(x, y)
    draw(image, x+(public.x-1)*TILE_SIZE, y+(public.y-1)*TILE_SIZE)
  end

  -------------
  -- ACTIONS --
  -------------
  public.move = function(direction)
    if public.disabled then return false end

    local isSolid = _level.isSolid
    local isPushed = isPushed or false
    if direction == "up" then
      local newy = public.y - 1
      if not isSolid(public.x, newy) then
        local obj = _level.objectAt(public.x, newy)
        if obj and obj.move then
          if not obj.move("up") then
            return false
          else
            obj.disabled = true
          end
        end
        _level.objects[public.y][public.x] = nil
        public.y = newy
        _moveCooldown = MOVE_COOLDOWN
        _level.objects[public.y][public.x] = public 
        if state.record then
          _historyCount = _historyCount + 1
          _history[_historyCount] = {state.timeSince, public.move, "up"}
        end
        return true
      end
    elseif direction == "down" then
      local newy = public.y + 1
      if not isSolid(public.x, newy) then
        local obj = _level.objectAt(public.x, newy)
        if obj and obj.move then
          if not obj.move("down") then
            return false
          else
            obj.disabled = true
          end
        end
        _level.objects[public.y][public.x] = nil
        public.y = newy
        _moveCooldown = MOVE_COOLDOWN
        _level.objects[public.y][public.x] = public
        if state.record then
          _historyCount = _historyCount + 1
          _history[_historyCount] = {state.timeSince, public.move, "down"}
        end 
        return true
      end
    elseif direction == "left" then
      local newx = public.x - 1
      if not isSolid(newx, public.y) then
        local obj = _level.objectAt(newx, public.y)
        if obj and obj.move then
          if not obj.move("left") then
            return false
          else
            obj.disabled = true
          end
        end
        _level.objects[public.y][public.x] = nil
        public.x = newx
        _moveCooldown = MOVE_COOLDOWN
        _level.objects[public.y][public.x] = public 
        if state.record then
          _historyCount = _historyCount + 1
          _history[_historyCount] = {state.timeSince, public.move, "left"}
        end
        return true
      end
    elseif direction == "right" then
      local newx = public.x + 1
      if not isSolid(newx, public.y) then
        local obj = _level.objectAt(newx, public.y)
        if obj and obj.move then
          if not obj.move("right") then
            return false
          else
            obj.disabled = true
          end
        end
        _level.objects[public.y][public.x] = nil
        public.x = newx
        _moveCooldown = MOVE_COOLDOWN
        _level.objects[public.y][public.x] = public 
        if state.record then
          _historyCount = _historyCount + 1
          _history[_historyCount] = {state.timeSince, public.move, "right"}
        end
        return true
      end
    end
  end

	return public
end