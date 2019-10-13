local Level = require "objects.Level"
local Player = require "objects.Player"
local MoveBlock = require "objects.MoveBlock"
local Lever = require "objects.Lever"
local Door = require "objects.Door"
local CTileGraphic = require "graphics.CTileGraphic"
local newArrayImage = love.graphics.newArrayImage

local tilePaths = {
  "assets/tiles/wallV.png",
  "assets/tiles/wallH.png",
  "assets/tiles/cornerBL.png",
  "assets/tiles/cornerBR.png",
  "assets/tiles/cornerTL.png",
  "assets/tiles/cornerTR.png",
  "assets/tiles/wallM.png",
  "assets/tiles/floor.png",
}
local tileArrayImage = newArrayImage(tilePaths)

return function()

  local tileMap = {
    5,2,2,2,2,2,2,2,2,2,2,2,6,
    1,0,0,0,0,0,0,0,0,0,0,0,1,
    3,2,6,0,0,0,0,0,0,0,0,0,1,
    0,0,0,0,0,0,0,0,0,0,0,0,1,
    5,2,4,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,1,
    3,2,2,2,2,2,2,2,2,2,2,2,4,
  }
  local mapWidth = 13
  local mapHeight = 7

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
  
  mapObjects[4][3] = Door(3,4, {
    level = level,
    on = false,
    horizontal = false
  })

  mapObjects[4][1] = Door(1,4, {
    level = level,
    on = true,
    horizontal = false
  })

  mapObjects[2][8] = Lever(8,2, {
    level = level,
    links = {mapObjects[4][3], mapObjects[4][1]}
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
				}
			},
			[2] = {
				xParalax = 0,
				yParalax = 0,

				objects = {
          player,
          mapObjects[4][3],
          mapObjects[4][1],
          mapObjects[2][8]
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

