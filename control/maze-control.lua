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

require("lib.cmwc")
require("lib.maze")

local function calculateMazePosition(modSurfaceInfo, coordinates)

    local topX
    local topY

    if modSurfaceInfo.mazeInfo.swapXY then
        topX = coordinates.y
        topY = -coordinates.x
    else
        topX = coordinates.x
        topY = coordinates.y
    end

    local mazeX = 1 + modSurfaceInfo.mapOffset + (topX / 32)
    local mazeY = 1 + (-topY / 32)

    return {x = mazeX, y = mazeY}
end

local function calculateChunkPositionFromMazeCoordinates(modSurfaceInfo, mazeCoordinates)

    local topX = (mazeCoordinates.x - (1 + modSurfaceInfo.mapOffset)) * 32
    local topY = -(mazeCoordinates.y - 1) * 32

    if modSurfaceInfo.mazeInfo.swapXY then
        return {x = topY, y = -topX}
    else
        return {x = topX, y = topY}
    end
end

local function isInClearMazeArea(config, modSurfaceInfo, x, y)
    if config.clearMazeStartChunks <= 0 then
        return false
    end

    local distanceFromOriginX
    if ((modSurfaceInfo.maze.numColumns - 1)/2) % 2 == 0 then
        distanceFromOriginX = x - ((modSurfaceInfo.maze.numColumns-1)/2)
    else
        distanceFromOriginX = x - ((modSurfaceInfo.maze.numColumns+1)/2)
    end
    if distanceFromOriginX < 0 then
        distanceFromOriginX = -distanceFromOriginX
    end
    return y <= config.clearMazeStartChunks+1 and distanceFromOriginX < config.clearMazeStartChunks+1
end

local function calculateResource(config, surface, modSurfaceInfo, x, y)

    if isInClearMazeArea(config, modSurfaceInfo, x, y) then
        return
    end

    local deadEnd = Maze.deadEnd(modSurfaceInfo.maze, x, y)
    if deadEnd.corridorLength == 0 then
        return
    end

    local isMazeStart = modSurfaceInfo.mazeStartCoordinates.x == x and modSurfaceInfo.mazeStartCoordinates.y == y

    local choice

    if isMazeStart then
        choice = "mixed_"
    else
        if y <= 7 and deadEnd.corridorLength == 2 then
            choice = "mixed_"
        elseif modSurfaceInfo.corridorStats[deadEnd.corridorLength] then
            local possibilities = config.resourceMatrix[deadEnd.corridorLength]
            local randomIndex = Cmwc.randRange(modSurfaceInfo.resourceGridRng, 1, #possibilities)
            choice = possibilities[randomIndex]
        else
            choice = config.resourceMatrix[deadEnd.corridorLength][1]
        end

        modSurfaceInfo.corridorStats[deadEnd.corridorLength] = modSurfaceInfo.corridorStats[deadEnd.corridorLength] + 1
    end

    if not choice then error("resource calcuation bug: no choice was made at " .. x .. ", " .. y) end

    local resource = {}

    if config.resources[choice] or choice == "mixed_" then
        resource.resourceName = choice
        resource.minRand = 1.0 - (1.0 / (1+deadEnd.corridorLength/2))
        resource.rng = Cmwc.deriveNew(modSurfaceInfo.resourceGridRng)
        if deadEnd.yHighest > 400 then
            resource.resourceAmount = 400 * 400 * 400
        elseif deadEnd.yHighest >= 7 then
            resource.resourceAmount = 4 * deadEnd.yHighest * deadEnd.yHighest * deadEnd.yHighest
        else
            resource.resourceAmount = 40 * deadEnd.yHighest * deadEnd.yHighest
        end
    end

    modSurfaceInfo.resourceGrid[y] = modSurfaceInfo.resourceGrid[y] or {}
    local row = modSurfaceInfo.resourceGrid[y]
    row[x] = resource
end

local function resourceAt(config, surface, modSurfaceInfo, coordinates)

    while coordinates.y > modSurfaceInfo.resourceGridCalculatedTo do
        for x = 1, modSurfaceInfo.maze.numColumns do
            calculateResource(config, surface, modSurfaceInfo, x, modSurfaceInfo.resourceGridCalculatedTo + 1)
        end
        modSurfaceInfo.resourceGridCalculatedTo = modSurfaceInfo.resourceGridCalculatedTo + 2
    end

    local row = modSurfaceInfo.resourceGrid[coordinates.y]
    if row then
        return row[coordinates.x]
    else
        return nil
    end
end

local function ensureResource(config, surface, modSurfaceInfo, chunksX, chunksY, fallbackY, desiredResource)
    for findY = 1, chunksY, 2 do
        for findX = 1, chunksX, 2 do
            local resource = resourceAt(config, surface, modSurfaceInfo, {x=findX, y=findY})
            if resource and resource.resourceName == desiredResource then
                modSurfaceInfo.firstResource[desiredResource] = {x=findX, y=findY}
                return
            end
        end
    end

    -- Couldn't find crude oil near enough, so replace another resource somewhere from row 7 onwards
    for findY = fallbackY, chunksY, 2 do
        for findX = 1, chunksX, 2 do
            local resource = resourceAt(config, surface, modSurfaceInfo, {x=findX, y=findY})
            if resource and resource.resourceName then
                modSurfaceInfo.firstResource[desiredResource] = {x=findX, y=findY}
                resource.resourceName = desiredResource
                return
            end
        end
    end
end

local function initModSurfaceInfo(config, surface, modSurfaceInfo)
    if modSurfaceInfo.initComplete then
        return
    end
    modSurfaceInfo.masterRng = modSurfaceInfo.masterRng or Cmwc.withSeed(surface.map_gen_settings.seed)

    modSurfaceInfo.mazeInfo = {}

    local width

    -- swap X/Y for the purposes of maze position calculation, depending upon which direction is larger
    if surface.map_gen_settings.height < surface.map_gen_settings.width then
        width = surface.map_gen_settings.height
        modSurfaceInfo.mazeInfo.swapXY = true
    else
        width = surface.map_gen_settings.width
        modSurfaceInfo.mazeInfo.swapXY = false
    end

    if width < 160 then
        error('Maze too narrow, please pick a width or height of at least 160')
    end

    if width <= 0 or width >= 2000000 then
        width = config.mazeDefaultWidthChunks * 32
    elseif width > config.mazeMaxWidthChunks * 32 then
        width = config.mazeMaxWidthChunks * 32
    else
        -- ignore a chunk either side on a finite map so that we don't get out-of-map in the maze
        width = width - 64
    end

    local chunks = (width - width % 32) / 32
    -- we need an odd number of chunks, to allow for walls e.g. |.W.W.W.|
    if chunks % 2 == 0 then
        chunks = chunks + 1
    end
    -- to start in the middle we need an odd number of chunks either side; if we don't have that then start off-centre
    if ((chunks - 1)/2) % 2 == 0 then
        modSurfaceInfo.mapOffset = (chunks-1) / 2
    else
        modSurfaceInfo.mapOffset = (chunks+1) / 2
    end

    local mazeRng = Cmwc.deriveNew(modSurfaceInfo.masterRng)

    modSurfaceInfo.maze = Maze.new(mazeRng, chunks, 0.5, config.resourceMatrixMax)

    modSurfaceInfo.resourceGrid = {}
    modSurfaceInfo.resourceGridCalculatedTo = 0
    modSurfaceInfo.resourceGridRng = Cmwc.deriveNew(modSurfaceInfo.masterRng)
    modSurfaceInfo.corridorStats = {}
    for c = 2,config.resourceMatrixMax,2 do
        modSurfaceInfo.corridorStats[c] = 0
    end

    modSurfaceInfo.mazeStartCoordinates = calculateMazePosition(modSurfaceInfo, {x = 0, y = 0})

    if config.terraformingPrototypesEnabled then
        local mangroveRng = Cmwc.deriveNew(modSurfaceInfo.masterRng)
        modSurfaceInfo.terraformingMangroveRng = Cmwc.deriveNew(mangroveRng)
        modSurfaceInfo.firstMazeRowMangroveRng = {}
        for i = 1,chunks do
            table.insert(modSurfaceInfo.firstMazeRowMangroveRng, Cmwc.deriveNew(mangroveRng))
        end
    end

    modSurfaceInfo.firstResource = {}

    for k,v in pairs(config.ensureResources) do
        ensureResource(config, surface, modSurfaceInfo, chunks, v.maxY, v.fallbackY, k)
    end

    modSurfaceInfo.initComplete = true
end

function chunkGeneratedEventHandler(event)

    local config = ribbonMazeConfig()

    local surface = event.surface
    local modSurfaceInfo = global.modSurfaceInfo[surface.name]
    -- if modSurfaceInfo is absent, this isn't a surface we are managing
    if not modSurfaceInfo then
        return
    end
    initModSurfaceInfo(config, surface, modSurfaceInfo)

    local chunkArea = event.area

    -- remove default generated resources
    local resourcesToRemove = surface.find_entities_filtered{type="resource", area=chunkArea}
    for _, v in pairs(resourcesToRemove) do
        if config.resources[v.name] then
            v.destroy()
        end
    end

    -- decide what we want this chunk to have; we use the same data for all tiles in the chunk
    local mazePosition = calculateMazePosition(modSurfaceInfo, chunkArea.left_top)

    local x = mazePosition.x
    local y = mazePosition.y

    if y < 0 or x < 0 or x > modSurfaceInfo.maze.numColumns+1 then
        local updatedTiles = {}
        for tileX = chunkArea.left_top.x, chunkArea.left_top.x+31 do
            for tileY = chunkArea.left_top.y, chunkArea.left_top.y+31 do
                table.insert(updatedTiles, {name = "out-of-map", position = {tileX, tileY}})
            end
        end
        surface.set_tiles(updatedTiles)
        return
    end

    local inClearMazeArea = isInClearMazeArea(config, modSurfaceInfo, x, y)
    local isWaterRow = y < 1

    if (isWaterRow or not inClearMazeArea) and Maze.wallTileAt(modSurfaceInfo.maze, x, y) then
        local updatedTiles = {}
        local tileName
        if isWaterRow and (inClearMazeArea or not Maze.wallTileAt(modSurfaceInfo.maze, x, y+1)) then
            tileName = config.waterTile
        else
            tileName = config.mazeWallTile
        end

        for tileX = chunkArea.left_top.x, chunkArea.left_top.x+31 do
            for tileY = chunkArea.left_top.y, chunkArea.left_top.y+31 do
                table.insert(updatedTiles, {name = tileName, position = {tileX, tileY}})
            end
        end
        surface.set_tiles(updatedTiles)

        if config.terraformingPrototypesEnabled and modSurfaceInfo.firstMazeRowMangroveRng[x] then
            if tileName == config.waterTile then
                if modSurfaceInfo.mazeInfo.swapXY then
                    for tileY = chunkArea.left_top.y+1, chunkArea.left_top.y+30 do
                        for tileX = chunkArea.left_top.x+32, chunkArea.left_top.x+33 do
                            local randMangrove = Cmwc.randFraction(modSurfaceInfo.firstMazeRowMangroveRng[x])
                            if randMangrove > 0.4 then
                                surface.create_entity{name="mangrove-rhizophora", position={tileX,tileY}}
                            end
                        end
                    end

                    for tileY = chunkArea.left_top.y+1, chunkArea.left_top.y+30 do
                        for tileX = chunkArea.left_top.x+30, chunkArea.left_top.x+31 do
                            local randMangrove = Cmwc.randFraction(modSurfaceInfo.firstMazeRowMangroveRng[x])
                            if randMangrove > 0.9 then
                                surface.create_entity{name="mangrove-bruguiera", position={tileX,tileY}}
                            elseif randMangrove > 0.5 then
                                surface.create_entity{name="mangrove-avicennia", position={tileX,tileY}}
                            end
                        end
                    end
                else
                    for tileX = chunkArea.left_top.x+1, chunkArea.left_top.x+30 do
                        for tileY = chunkArea.left_top.y-1, chunkArea.left_top.y do
                            local randMangrove = Cmwc.randFraction(modSurfaceInfo.firstMazeRowMangroveRng[x])
                            if randMangrove > 0.4 then
                                surface.create_entity{name="mangrove-rhizophora", position={tileX,tileY}}
                            end
                        end
                    end

                    for tileX = chunkArea.left_top.x+1, chunkArea.left_top.x+30 do
                        for tileY = chunkArea.left_top.y+1, chunkArea.left_top.y+2 do
                            local randMangrove = Cmwc.randFraction(modSurfaceInfo.firstMazeRowMangroveRng[x])
                            if randMangrove > 0.9 then
                                surface.create_entity{name="mangrove-bruguiera", position={tileX,tileY}}
                            elseif randMangrove > 0.5 then
                                surface.create_entity{name="mangrove-avicennia", position={tileX,tileY}}
                            end
                        end
                    end
                end
            elseif tileName == config.mazeWallTile then
                for tileX = chunkArea.left_top.x+1, chunkArea.left_top.x+29,4 do
                    for tileY = chunkArea.left_top.y+1, chunkArea.left_top.y+29,4 do
                        local target = surface.create_entity{name="maze-terraforming-target", position={tileX,tileY}, force="maze-terraforming-targets"}
                        target.destructible = false
                    end
                end
            end
        end

        return
    end

    local updatedTiles = {}

    for tileX = chunkArea.left_top.x, chunkArea.left_top.x+31 do
        for tileY = chunkArea.left_top.y, chunkArea.left_top.y+31 do
            local tile = surface.get_tile(tileX, tileY)
            local replacement = config.waterTileReplacement[tile.name]
            if replacement then
                table.insert(updatedTiles, {name = replacement, position = {tileX, tileY}})
            elseif tile.name == 'out-of-map' then
                table.insert(updatedTiles, {name = "red-desert-0", position = {tileX, tileY}})
            end
        end
    end

    surface.set_tiles(updatedTiles)

    if inClearMazeArea then
        return
    end

    local resource = resourceAt(config, surface, modSurfaceInfo, mazePosition)

    if resource and resource.resourceName then

        local resourceName = resource.resourceName

        local chunkRandomAdjustment = Cmwc.randFractionRange(modSurfaceInfo.resourceGridRng, resource.minRand, 1.0)

        local cumulativeOil = 0

        local mixedBag
        local patchworkSize
        if resourceName == "mixed_" then
            mixedBag = {table.unpack(config.forcedMixedResources) }
            if config.minMixedResourcesPatchworkSize ~= config.maxMixedResourcesPatchworkSize then

                local mixedResourcesPatchworkSizes = {}
                for p = config.minMixedResourcesPatchworkSize, config.maxMixedResourcesPatchworkSize do
                    if 30 % p == 0 then
                        table.insert(mixedResourcesPatchworkSizes, p)
                    end
                end

                local patchworkSizeIndex = Cmwc.randRange(modSurfaceInfo.resourceGridRng, 1, #mixedResourcesPatchworkSizes)
                patchworkSize = mixedResourcesPatchworkSizes[patchworkSizeIndex]
            else
                patchworkSize = config.minMixedResourcesPatchworkSize
            end
        end

        for tileY = chunkArea.left_top.y+1, chunkArea.left_top.y+30 do

            local crudeOilOffset = 0
            if resourceName == "crude-oil" and Cmwc.randFraction(modSurfaceInfo.resourceGridRng) > 0.5 then
                crudeOilOffset = 1
            end

            for tileX = chunkArea.left_top.x+1, chunkArea.left_top.x+30 do

                local resourceName = resource.resourceName

                if resourceName == "crude-oil" then

                    local tileRandomAdjustment = Cmwc.randFractionRange(modSurfaceInfo.resourceGridRng, resource.minRand, 1.0)
                    local amount = chunkRandomAdjustment * tileRandomAdjustment * resource.resourceAmount

                    local placementCoinToss = Cmwc.randFraction(modSurfaceInfo.resourceGridRng)

                    if tileX-chunkArea.left_top.x < 2 or (tileX+crudeOilOffset) % 2 == 0 or tileY % 2 == 0 or placementCoinToss < 0.75 then
                        amount = 0
                    end

                    cumulativeOil = cumulativeOil + amount

                    if amount >= 100 then
                        surface.create_entity{
                            name=resourceName,
                            amount=cumulativeOil*10,
                            initial_amount=cumulativeOil*10,
                            position={tileX, tileY},
                            enable_tree_removal=true,
                            enable_cliff_removal=true}
                        cumulativeOil = 0
                    end
                else
                    if resourceName == "mixed_" then

                        local moduloX = (tileX-(chunkArea.left_top.x+1)) % patchworkSize
                        local moduloY = (tileY-(chunkArea.left_top.y+1)) % patchworkSize
                        if (moduloX == 0 and moduloY == 0) then
                            local randomOre
                            if #mixedBag > 0 then
                                local randomOreIndex = Cmwc.randRange(resource.rng, 1, #mixedBag)
                                randomOre = mixedBag[randomOreIndex]
                                table.remove(mixedBag, randomOreIndex)
                            else
                                local randomOreIndex = Cmwc.randRange(resource.rng, 1, #config.mixedResources)
                                randomOre = config.mixedResources[randomOreIndex]
                            end

                            for randomOreX=tileX,tileX+patchworkSize-1 do
                                for randomOreY=tileY,tileY+patchworkSize-1 do

                                    local tileRandomAdjustment = Cmwc.randFractionRange(modSurfaceInfo.resourceGridRng, resource.minRand, 1.0)
                                    local amount = chunkRandomAdjustment * tileRandomAdjustment * resource.resourceAmount

                                    surface.create_entity{
                                        name=randomOre,
                                        amount=amount,
                                        initial_amount=amount,
                                        position={randomOreX, randomOreY},
                                        enable_tree_removal=true,
                                        enable_cliff_removal=true}
                                end
                            end
                        end
                    else
                        local tileRandomAdjustment = Cmwc.randFractionRange(modSurfaceInfo.resourceGridRng, resource.minRand, 1.0)
                        local amount = chunkRandomAdjustment * tileRandomAdjustment * resource.resourceAmount

                        if resourceName and amount >= 10 then

                            surface.create_entity{
                            name=resourceName,
                            amount=amount,
                            initial_amount=amount,
                            position={tileX, tileY},
                            enable_tree_removal=true,
                            enable_cliff_removal=true }
                        end
                    end
                end
            end
        end
    end

end

function playerCreatedEventHander(event)

    local config = ribbonMazeConfig()

    local player = game.players[event.player_index]
    local surface = player.surface
    local modSurfaceInfo = global.modSurfaceInfo[surface.name]
    -- if modSurfaceInfo is absent, this isn't a surface we are managing
    if not modSurfaceInfo then
        return
    end
    initModSurfaceInfo(config, surface, modSurfaceInfo)

    if config.clearMazeStartChunks <= 0 then

        local teleportPosition = surface.find_non_colliding_position("player", {x = 16, y = 16}, 16, 1)
        if teleportPosition then
            player.teleport(teleportPosition, surface)
        else
            player.teleport({x = 16, y = 16}, surface)
        end
    end

    for k,v in pairs(config.ensureResources) do
        if v.reveal and modSurfaceInfo.firstResource[k] then
            local firstResourcePos = calculateChunkPositionFromMazeCoordinates(modSurfaceInfo, modSurfaceInfo.firstResource[k])
            local firstResourceX = firstResourcePos.x
            local firstResourceY = firstResourcePos.y
            player.force.chart(surface, {{firstResourceX, firstResourceY}, {firstResourceX+31, firstResourceY+31}})
        end
    end
end

local function resourceScanning(research, resourceName)
    local config = ribbonMazeConfig()
    local maxY
    if config.ensureResources[resourceName] then
        maxY = config.ensureResources[resourceName].maxY
    else
        maxY = 32
    end

    local force = research.force
    for _,surfaceName in pairs(config.modSurfaces) do
        local surface = game.surfaces[surfaceName]
        if surface then
            local modSurfaceInfo = global.modSurfaceInfo[surfaceName]
            if modSurfaceInfo then
                for findY = 1, maxY, 2 do
                    for findX = 1, modSurfaceInfo.maze.numColumns, 2 do
                        local coordinates = {x=findX, y=findY}
                        local resource = resourceAt(config, surface, modSurfaceInfo, coordinates)
                        if resource and resource.resourceName == resourceName then
                            local resourcePos = calculateChunkPositionFromMazeCoordinates(modSurfaceInfo, coordinates)
                            local resourceX = resourcePos.x
                            local resourceY = resourcePos.y
                            force.chart(surface, {{resourceX, resourceY}, {resourceX+31, resourceY+31}})
                        end
                    end
                end
            end
        end
    end
end

function resourceFinishedEventHandler(event)
    local research = event.research
    if research and research.name == "oil-scanning" then
        resourceScanning(research, "crude-oil")
    elseif research and research.name == "uranium-scanning" then
        resourceScanning(research, "uranium-ore")
    end
end

function initHandler()

    local config = ribbonMazeConfig()

    if config.terraformingPrototypesEnabled then
        game.create_force("maze-terraforming-targets")
        game.create_force("maze-terraforming-artillery")

        game.forces["player"].set_friend("maze-terraforming-targets", true)
        game.forces["maze-terraforming-targets"].set_friend("player", true)

        game.forces["player"].set_friend("maze-terraforming-artillery", true)
        game.forces["maze-terraforming-artillery"].set_friend("player", true)

        game.forces["maze-terraforming-targets"].set_cease_fire("enemy", true)
        game.forces["enemy"].set_cease_fire("maze-terraforming-targets", true)

        game.forces["maze-terraforming-artillery"].set_cease_fire("maze-terraforming-targets", false)
    end

    global.modSurfaceInfo = global.modSurfaceInfo or {}
    for _, v in pairs(config.modSurfaces) do
        global.modSurfaceInfo[v] = global.modSurfaceInfo[v] or {}
    end
end