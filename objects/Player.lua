local C = require"Constants"
local TILE_SIZE = C.TILE_SIZE
local REVERSE = C.REVERSE
local state = system.state
local newImage = love.graphics.newImage
local draw = love.graphics.draw
local input = input
local pi = math.pi
local pairs = pairs

local circle = love.graphics.circle
local print = print
module("objects.GameObjectTemplate")

local image = newImage("assets/objects/pc.png")
local MOVE_COOLDOWN = 0.13

return function(x, y, properties)
  local public = {}
  -- Object Body --
  public.x = x or 0
  public.y = y or 0
  _level = properties.level
  public.looking = properties.looking or "down" -- "up" "down" "left" "right"
  _moveCooldown = 0
  _history = {}
  _historyCount = 0
  _playbackCount = 0
  public.disabled = false



  public.update = function(dt, x, y)
    local isDown = input.isDown

    --print("time:",state.time, "record:",state.record, "timesince:", state.timeSince)
    if state.record then
      _playbackCount = 0  
    end

    if _moveCooldown > 0 then
      _moveCooldown = _moveCooldown - dt
      if _moveCooldown < 0 then
        _moveCooldown = 0
      end
    else
      local move = public.move
      local face = public.face
      local isSolid = _level.isSolid
      local curx = public.x
      local cury = public.y
      if isDown"up" and not isSolid(curx, cury-1) then
        if move("up") then
          face("up")
        end
      elseif isDown"down" and not isSolid(curx, cury+1) then
        if move("down") then
          face("down")
        end
      elseif isDown"left" and not isSolid(curx-1, cury) then
        if move("left") then
          face("left")
        end
      elseif isDown"right" and not isSolid(curx+1, cury) then
        if move("right") then
          face("right")
        end
      end
    end
    public.disabled = false
  end


  public.draw = function(x, y)
    local angle = 0
    local looking = public.looking
    if      looking == "up" then
      angle = pi
    elseif  looking == "left" then
      angle = pi/2
    elseif  looking == "right" then
      angle = 3*pi/2
    end
    draw(image, x+(public.x-1)*TILE_SIZE+TILE_SIZE/2, y+(public.y-1)*TILE_SIZE+TILE_SIZE/2, angle, 1,1, TILE_SIZE/2, TILE_SIZE/2)
  end

  public.kill = function()
    print("ouch!")
  end

  ----------
  -- TIME --
  ----------
  public.rewind = function()
    for i,v in pairs(_history) do
      print(i,v[1], v[2], v[3])
    end
    print()
  end

  -------------
  -- ACTIONS --
  -------------
  public.face = function(direction)
    if state.record then
      _historyCount = _historyCount + 1
      _history[_historyCount] = {state.timeSince, public.face, direction, public.looking}
    end
    public.looking = direction
  end

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