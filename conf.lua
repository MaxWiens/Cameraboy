local ini = require 'fileFormat.ini'
local Settings = require 'Settings'
local parsedSettings

if love.filesystem.getInfo(Settings.CONFIG_FILE_PATH) then
	parsedSettings = ini.parseIni(love.filesystem.read(Settings.CONFIG_FILE_PATH))
else
	parsedSettings = Settings.DEFAULT_SETTINGS()
	love.filesystem.write(Settings.CONFIG_FILE_PATH, ini.toIni(parsedSettings))
end


function love.conf(t)
	t.console = true

	t.version = "11.2"
	t.window.title = nil
	t.window.icon = nil
	t.window.fullscreen = false

	-- Graphics
	t.gammacorrect = parsedSettings.video.gamma_correction
	t.window.width = parsedSettings.video.window_width
	t.window.height = parsedSettings.video.window_height
	t.window.boarderless = parsedSettings.borderless
	t.window.vsync = parsedSettings.vsync
	t.window.display = parsedSettings.display
	t.window.highdpi = parsedSettings.highdpi
end
