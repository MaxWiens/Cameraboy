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
  local _history = {}
  local _historyCount = 0
  public.isSolid = true
  local _playbackCount = 0

  public.update = function(dt,x,y)
    if public.on then
      if _level.objects[public.y][public.x] == public then
        _level.objects[public.y][public.x] = nil
      end
    else
      _level.objects[public.y][public.x] = public
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