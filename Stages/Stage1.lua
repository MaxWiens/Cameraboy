
local Level = require "objects.Level"
local Player = require "objects.Player"
local MoveBlock = require "objects.MoveBlock"
local Lever = require "objects.Lever"
local Door = require "objects.Door"
local Belt = require "objects.Belt"
local Camera = require "objects.Camera"
local CTileGraphic = require "graphics.CTileGraphic"
local newArrayImage = love.graphics.newArrayImage

local tilePaths = {
  "assets/tiles/wallStraight.png",
  "assets/tiles/wallCorner.png",
}
local tileArrayImage = newArrayImage(tilePaths)

return function()

  local tileMap = {
    2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,
  }
  local mapWidth = 16
  local mapHeight = 9

  local mapObjects = {}
  for i=0,mapHeight do mapObjects[i] = {} end

  local level = Level(
    0,0, {
    map = tileMap,
    width = mapWidth,
    height = mapHeight,
    player = player,
    objects = mapObjects
  })

  local playerx = 3
  local playery = 2
  local player = Player(
    playerx,playery,{
      level = level,
      looking = "down"
  })
  
  
  -- Add Objects
  mapObjects[playery][playerx] = player
  mapObjects[4][4] = MoveBlock(4,4, {
    level = level
  })

  mapObjects[5][5] = MoveBlock(5,5, {
    level = level
  })

  mapObjects[5][7] = Door(7,5, {
    level = level,
    on = false,
    horizontal = false
  })

  mapObjects[5][10] = Door(10,5, {
    level = level,
    on = true,
    horizontal = false
  })

  mapObjects[7][5] = Lever(5,7, {
    level = level,
    links = {mapObjects[5][7], mapObjects[5][10]}
  })
  

	return {
		unlayered = {
      level
		},
		layers = {
			[1] = {
				xParalax = 0,
				yParalax = 0,

				objects = {
          CTileGraphic(tileArrayImage, tileMap, mapWidth, mapHeight),
          Belt(2,4, {
            level = level,
            on = true,
            looking = "down"
          }),
          Belt(2,5, {
            level = level,
            on = true,
            looking = "down"
          }),
          Belt(2,6, {
            level = level,
            on = true,
            looking = "right"
          }),
          Belt(3,6, {
            level = level,
            on = true,
            looking = "up"
          }),
          Belt(3,5, {
            level = level,
            on = true,
            looking = "up"
          }),
          Belt(3,4, {
            level = level,
            on = true,
            looking = "left"
          }),
        }
			},
			[2] = {
				xParalax = 0,
				yParalax = 0,

				objects = {
          player,
          mapObjects[4][4],
          mapObjects[5][5],
          mapObjects[7][5],
          mapObjects[5][7],
          mapObjects[5][10]
				}
      },
      [3] = {
        xParalax = 0,
        yParalax = 0,

        objects = {
          Camera(0,0,{})
        }
      }
		}
	}
end

