
local Level = require "objects.Level"
local Player = require "objects.Player"
local MoveBlock = require "objects.MoveBlock"
local Lever = require "objects.Lever"
local Door = require "objects.Door"
local Belt = require "objects.Belt"
local Title = require "objects.Title"
local Camera = require "objects.Camera"
local CTileGraphic = require "graphics.CTileGraphic"
local newArrayImage = love.graphics.newArrayImage

return function()

	return {
		unlayered = {
      level
		},
		layers = {
			[1] = {
				xParalax = 0,
				yParalax = 0,

				objects = {
          Title(0,0)
        }
			},
			[2] = {
				xParalax = 0,
				yParalax = 0,

				objects = {
				}
      },
      [3] = {
        xParalax = 0,
        yParalax = 0,

        objects = {
        }
      }
		}
	}
end

