local Level = require "objects.Level"
local Player = require "objects.Player"
local MoveBlock = require "objects.MoveBlock"
local Lever = require "objects.Lever"
local Door = require "objects.Door"
local Exit = require "objects.Exit"
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
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,5,2,2,2,2,2,2,6,0,0,0,0,
    0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,
    0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,
    0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,
    0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,
    0,0,0,0,3,2,2,2,2,2,2,4,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
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
    objects = mapObjects,
	currentStage = "Stages.Stage5"
  })

  local playerx = 7
  local playery = 7
  local player = Player(
    playerx,playery,{
      level = level,
      looking = "down"
  })
  
  
  -- Add Objects
  mapObjects[playery][playerx] = player
  mapObjects[3][8] = MoveBlock(8,3, {
    level = level
  })

  mapObjects[4][7] = MoveBlock(7,4, {
    level = level
  })

  mapObjects[4][9] = MoveBlock(9,4, {
    level = level
  })

  mapObjects[5][6] = MoveBlock(6,5, {
    level = level
  })

  mapObjects[5][10] = MoveBlock(10,5, {
    level = level
  })
 
  mapObjects[5][8] = MoveBlock(8,5, {
    level = level
  })


  mapObjects[6][7] = MoveBlock(7,6, {
    level = level
  })

 
  mapObjects[6][9] = MoveBlock(9,6, {
    level = level
  })

  mapObjects[7][8] = MoveBlock(8,7, {
    level = level
  })

  mapObjects[3][12] = Door(12,3, {
    level = level,
    on = false,
    horizontal = false
  })

  mapObjects[3][6] = Lever(6,3, {
    level = level,
    links = {mapObjects[3][12]}
  })
  mapObjects[3][11] = Door(11,3, {
    level = level,
    on = false,
    horizontal = false
  })
  mapObjects[7][11] = Lever(11,7, {
    level = level,
    links = {mapObjects[3][12]}
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
		  Exit(12, 3, {
			level = level,
			looking = "up",
			nextStage = "Stages.TitleStage"
						}),
		  mapObjects[3][8],mapObjects[4][7],mapObjects[4][9],mapObjects[5][6],mapObjects[5][10],mapObjects[5][8],mapObjects[6][7],mapObjects[6][9],mapObjects[7][8]
,		  mapObjects[3][12],
      mapObjects[3][6],
      mapObjects[7][11]
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

