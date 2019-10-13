
local Level = require "objects.Level"
local Player = require "objects.Player"
local MoveBlock = require "objects.MoveBlock"
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
    1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
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
          mapObjects[4][4],
          mapObjects[5][5]
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

