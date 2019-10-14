

local draw = love.graphics.draw
local newImage = love.graphics.newImage
local require = require
local system = system
local input = input

module("objects.Title")

local image = newImage("assets/NewsPaper.png")

return function(x, y, properties)
	local public = {}
	-- Object Body --

  local _timer = 0
  local TIME = .5

  local _r = 0
  local rRate = 50.265482

  local _s = 0
  local sRate = 0.5
  
  public.update = function(dt,x,y)
    if _timer < TIME then
      _timer = _timer + dt
      _r = _r + rRate*dt
      _s = _s + sRate*dt
    else
      _r = 0
      _s = 1
      if input.pressed "action" then
        system.loadStage(require("Stages/Stage2")())
      end
    end
  end

  public.draw = function(x,y)
    draw(image, x+128, y+72, _r, _s, _s, 128, 72)
  end

	return public
end