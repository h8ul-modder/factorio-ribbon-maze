--[[
   Copyright 2018 H8UL

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
--]]

-- 001100
-- 011110
-- 111111
-- 111111
-- 011110
-- 001100

local circleTemplate = {{0, -2}, {0, 3}, {1, -2}, {1, 3}, {-2, 0}, {3, 0}, {-2, 1}, {3, 1}}
for tileX = -1,2 do
    for tileY = -1,2 do
        table.insert(circleTemplate, {tileX, tileY})
    end
end

local function terraformingEdge_(config, surface, tileX, tileY)
    local tileName = surface.get_tile(tileX, tileY).name
    return tileName ~= config.waterTile and tileName ~= config.mazeWallTile
end

local function terraformingEdge(config, surface, tileX, tileY)

    if not (surface.get_tile(tileX, tileY).name == config.waterTile and
            surface.get_tile(tileX+1, tileY).name == config.waterTile and
            surface.get_tile(tileX-1, tileY).name == config.waterTile and
            surface.get_tile(tileX, tileY+1).name == config.waterTile and
            surface.get_tile(tileX, tileY-1).name == config.waterTile) then
        return false
    end

    return  terraformingEdge_(config, surface, tileX-2, tileY) or
            terraformingEdge_(config, surface, tileX+2, tileY) or
            terraformingEdge_(config, surface, tileX, tileY-2) or
            terraformingEdge_(config, surface, tileX, tileY+2) or
            terraformingEdge_(config, surface, tileX-3, tileY) or
            terraformingEdge_(config, surface, tileX+3, tileY) or
            terraformingEdge_(config, surface, tileX, tileY-3) or
            terraformingEdge_(config, surface, tileX, tileY+3)
end

function mazeTerraformingResultHandler(event)

    local config = terraformingConfig()

    if event.entity.name == "maze-terraforming-result" then
        local surface = event.entity.surface
        local position = event.entity.position
        local updatedTiles = {}
        for _, templatePos in pairs(circleTemplate) do
            local tileX = position.x+templatePos[1]
            local tileY = position.y+templatePos[2]
            if surface.get_tile(tileX, tileY).name == config.mazeWallTile then
                table.insert(updatedTiles, {name = config.waterTile, position = {tileX, tileY}})
            end
        end

        surface.set_tiles(updatedTiles)

        local modSurfaceInfo = global.modSurfaceInfo[surface.name]
        for _, templatePos in pairs(circleTemplate) do
            local tileX = position.x+templatePos[1]
            local tileY = position.y+templatePos[2]
            if terraformingEdge(config, surface, tileX, tileY) then
                local randMangrove = Cmwc.randFraction(modSurfaceInfo.terraformingMangroveRng)
                if randMangrove > 0.9 then
                    surface.create_entity{name="mangrove-bruguiera", position={tileX,tileY}}
                elseif randMangrove > 0.5 then
                    surface.create_entity{name="mangrove-avicennia", position={tileX,tileY}}
                end
            end
        end

        -- entities should be destroyed while setting the tiles due to collisions, but ensure their removal:
        if event.entity.valid then
            event.entity.destroy()
        end
        local target = surface.find_entity("maze-terraforming-target", position)
        if target and target.valid then
            target.destroy()
        end
    end
end

function mazeTerraformingArtillerybuiltHandler(event)
    local entity = event.created_entity

    if entity.name == "maze-terraforming-artillery-turret" then
        entity.force = "maze-terraforming-artillery"
    end
end

