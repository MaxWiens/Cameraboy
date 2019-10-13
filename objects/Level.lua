local input = input
local state = system.state
local RECORD_TOTAL = require "Constants".RECORD_TOTAL

local print = print
module("objects.GameObjectTemplate")

local MOVE_COOLDOWN = 0.1

return function(x, y, properties)
  local public = {}
	-- Object Body --
  local _map = properties.map
  local _player = properties.player
  local _height = properties.height
  local _width = properties.width

  public.objects = properties.objects
  local _stepCount = 0
  state.time = "normal"
  state.record = false
  state.timeSince = 0
  local _previousRecording = 0
  public.moveCooldown = 0
  public.move = false
  local _currentStage = properties.currentStage

  public.update = function(dt)
    if public.moveCooldown > 0 then
      print("no")
      public.move = false
      public.moveCooldown = public.moveCooldown - dt
    else
      public.move = true
      print("Yes")
      public.moveCooldown = MOVE_COOLDOWN
    end

    local time = state.time
    local record = state.record
    -- print("prev:", _previousRecording,  "timesence:", state.timeSince)
    
    if input.pressed "reset" then
      system.loadStage(require(currentStage)())
    end

    if time == "normal" then
      if state.record then
        state.timeSince = state.timeSince + dt
        _previousRecording = state.timeSince
        if state.timeSince >= RECORD_TOTAL then
          state.record = false
        end
      end
      if input.pressed "record" then
        if record then
          state.record = false
        else
          state.record = true
        end
      elseif input.pressed "rewind" then
        state.record = false
        state.time = "rewind"
      elseif input.pressed "play" then
        state.record = false
        state.time = "play"
      end

    end

    if time == "rewind" then
      if state.timeSince <= 0 then
        state.time = "normal"
        state.timeSince = 0
      else
        state.timeSince = state.timeSince - dt
      end
    elseif time == "play" then
      if state.timeSince >= _previousRecording then
        state.time = "normal"
      else
        state.timeSince = state.timeSince + dt
      end
    end
  end

  public.isSolid = function(x,y)
    if x <= _width and x >= 1 and y <= _height and y >= 1 then
      
      local obj = public.objects[y][x]
      if obj and obj.isSolid then
        return true
      end

      if _map[(y-1)*_width+x] > 0 then
        return true
      end
    end
    return false
  end

  public.objectAt = function(x,y)
    return public.objects[y][x]
  end

	return public
end