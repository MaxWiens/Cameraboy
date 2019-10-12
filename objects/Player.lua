local C = require"Constants"
local state = system.state
local TILE_SIZE = C.TILE_SIZE
local REVERSE = C.REVERSE
local newImage = love.graphics.newImage
local draw = love.graphics.draw
local input = input
local pi = math.pi
local pairs = pairs

local circle = love.graphics.circle
local print = print
module("objects.GameObjectTemplate")

local image = newImage("assets/objects/tempmc.png")
local MOVE_COOLDOWN = 0.15

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
  public.update = function(dt, x, y)
    local isDown = input.isDown
    
    --print("time:",state.time, "record:",state.record, "timesince:", state.timeSince)
    
    if state.time == "rewind" then
      local hist = _history[_historyCount]
      while _historyCount > 0 and hist[1] >= state.timeSince do
        _historyCount = _historyCount - 1
        -- print("running", _historyCount)
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
    else
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
          if state.record then
            _historyCount = _historyCount
            _history[_historyCount+1] = {state.timeSince, move, "up"}
            _historyCount = _historyCount+2
            _history[_historyCount] = {state.timeSince, face, "up", public.looking}
          end
          face("up")
          move("up")
        elseif isDown"down" and not isSolid(curx, cury+1) then
          if state.record then
            _history[_historyCount+1] = {state.timeSince, move, "down"}
            _historyCount = _historyCount+2
            _history[_historyCount] = {state.timeSince, face, "down", public.looking}
          end
          face("down")
          move("down")
        elseif isDown"left" and not isSolid(curx-1, cury) then
          if state.record then
            _history[_historyCount+1] = {state.timeSince, move, "left"}
            _historyCount = _historyCount+2
            _history[_historyCount] = {state.timeSince, face, "left", public.looking}
          end
          face("left")
          move("left")
        elseif isDown"right" and not isSolid(curx+1, cury) then
          if state.record then
            _history[_historyCount+1] = {state.timeSince, move, "right"}
            _historyCount = _historyCount+2
            _history[_historyCount] = {state.timeSince, face, "right", public.looking}
          end
          face"right"
          move"right"
        end
      end
    end
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
    public.looking = direction
  end

  public.move = function(direction)
    local isSolid = _level.isSolid
    if direction == "up" then
      local newy = public.y - 1
      if not isSolid(public.x, newy) then
        public.y = newy
        _moveCooldown = MOVE_COOLDOWN
      end
    elseif direction == "down" then
      local newy = public.y + 1
      if not isSolid(public.x, newy) then
        public.y = newy
        _moveCooldown = MOVE_COOLDOWN
      end
    elseif direction == "left" then
      local newx = public.x - 1
      if not isSolid(newx, public.y) then
        public.x = newx
        _moveCooldown = MOVE_COOLDOWN
      end
    elseif direction == "right" then
      local newx = public.x + 1
      if not isSolid(newx, public.y) then
        public.x = newx
        _moveCooldown = MOVE_COOLDOWN
      end
    end
  end

  public.push = function(direction)
    if      direction == "up" then
      local newy = public.y - 1
      if not _level.isSolid(public.x, newy) then
        public.y = newy
      else
        public.kill()
      end
    elseif  direction == "down" then
      local newy = public.y + 1
      if _level.isSolid(public.x, newy) then
        public.kill()
      else
        public.y = newy
      end
    elseif  direction == "left" then
      local newx = public.x - 1
      if _level.isSolid(newx, public.y) then
        public.kill()
      else
        public.x = newx
      end
    elseif  direction == "right" then
      local newx = public.x + 1
      if _level.isSolid(newx, public.y) then
        public.kill()
      else
        public.x = newx
      end
    end
  end

  

	return public
end