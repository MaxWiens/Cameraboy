local C = require "Constants"
local VIEW_WIDTH = C.VIEW_WIDTH
local VIEW_HEIGHT = C.VIEW_HEIGHT
local camera = require"Camera"(VIEW_WIDTH, VIEW_HEIGHT)
system = require"System"(camera)
local systemUpdate = system.update
local systemDraw = system.draw
input = require"Input"()
local inputUpdate = input.update
local aspectRatio = VIEW_WIDTH/VIEW_HEIGHT

love.graphics.setDefaultFilter("nearest", "nearest", 0)
local canvas = love.graphics.newCanvas(camera.getDimensions())

local setCanvas = love.graphics.setCanvas
local clear = love.graphics.clear
local loveDraw = love.graphics.draw

local music = love.audio.newSource("assets/sound/Wobbly Weeble.mp3", "stream")
music:setLooping(true)
function love.load()
	Settings:setAudio()
	love.resize(love.window.getMode())
	-- Initial Loading --
	system.loadStage(require("Stages.TitleStage")())	
	system.state = {time="normal", record = false, timeSince = 0}
	-- End Initial Loading --
	music:play()
end

function love.update(dt)
	camera.update()
	inputUpdate()
	systemUpdate(dt)
	-- Debug Update --
	
	-- End Debug Update --
end

function love.draw()
	setCanvas(canvas)
	clear()
	systemDraw()
	-- Scaled Debug Drawing --

	-- End Scaled Debug Drawing --
	setCanvas()
	loveDraw(canvas, viewx, viewy, 0, scale, scale)
	-- Debug Drawing --

	-- End Debug Drawing --
end

function love.resize(w,h)
	if w > h and aspectRatio*h < w then
		scale = h/VIEW_HEIGHT
		viewx = (w-VIEW_WIDTH*scale)/2
		viewy = 0
	else
		scale = w/VIEW_WIDTH
		viewx = 0
		viewy = (h-VIEW_HEIGHT*scale)/2
	end
end