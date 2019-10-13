local C = require "Constants"
local TILE_SIZE = C.TILE_SIZE
local REVERSE = C.REVERSE
local state = system.state
local newImage = love.graphics.newImage
local pairs = pairs
local draw = love.graphics.draw

local print = print
local input = input
module("objects.Lever")
local image = newImage("assets/objects/lever (2).png")
return function(x, y, properties)
	local public = {}
	-- Object Body --

  public.x = x or 0
  public.y = y or 0
  local _level = properties.level
  local _horizontal = properties.horizontal or true
  local _history = {}
  local _historyCount = 0
  local _playbackCount = 0
  local _links = properties.links
  public.isSolid = true
  local _on = false

  public.update = function(dt,x,y)
    if input.pressed "delete" then
      _history = {}
      _historyCount = 0
      _playbackCount = 0
    end
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
  end

  public.draw = function(x, y)
    local sx = 1
    if _on then
      sx = -1
    end
    draw(image, x+(public.x-1)*TILE_SIZE+TILE_SIZE/2, y+(public.y-1)*TILE_SIZE+TILE_SIZE/2, 0, sx, 1, TILE_SIZE/2, TILE_SIZE/2)
  end

  -------------
  -- ACTIONS --
  -------------
  public.toggle = function()
    if state.record then
      _historyCount = _historyCount + 1
      _history[_historyCount] = {state.timeSince, public.toggle, val}
    end
    if _on then
      _on = false
    else
      _on = true
    end

    for _,v in pairs(_links) do
      if v.on then
        v.on = false
      else
        v.on = true
      end
    end
  end

	return public
end