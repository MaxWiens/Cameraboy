

local state = system.state
local newImage = love.graphics.newImage
local draw = love.graphics.draw

module("objects.Camera")

local pauseImage = newImage("assets/camera/pauseSprite.png")
local rewindImage = newImage("assets/camera/rewind.png")
local playImage = newImage("assets/camera/playSprite.png")
local receordImage = newImage("assets/camera/RecCircle.png")


return function(x, y, properties)
	local public = {}
	-- Object Body --

  
  public.draw = function(x,y)
    local time = state.time
    local record = state.record
    local icon = nil
    if record then
      icon = receordImage
    elseif time == "rewind" then
      icon = rewindImage
    elseif time == "play" then
      icon = playImage
    else
      icon = pauseImage
    end

    draw(icon, 248, 136, 0, 0.25, 0.25)
  end
	return public
end