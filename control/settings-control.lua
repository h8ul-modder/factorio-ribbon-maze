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

--------------------------------------------------------
-- Configure fixed constants, and proxy any settings ---
--------------------------------------------------------

local INFINITE_PREFIX = "infinite-"

local function infiniteOre(entityPrototype)
    if entityPrototype.type == "resource" and
            entityPrototype.name and
            entityPrototype.name:sub(1, #INFINITE_PREFIX) == INFINITE_PREFIX then
        local infiniteOf = entityPrototype.name:sub(#INFINITE_PREFIX + 1, #(entityPrototype.name))
        return infiniteOf
    end
end

local function deadEndEnabled(settingsGlobal, resource)

    local entityPrototype = game.entity_prototypes[resource]
    if not entityPrototype then
        return false
    end
    if entityPrototype.type ~= "resource" then
        return false
    end

    if infiniteOre(entityPrototype) then
        -- infinite ores may or may not have an autoplace specification depending upon whether RSO is installed; to
        -- avoid confusion we have a specific setting to decide how to treat infinite resources
        return settingsGlobal["ribbon-maze-mod-resources"].value and
                settingsGlobal["ribbon-maze-separate-out-infinite-ores"].value
    end

    if not entityPrototype.autoplace_specification then
        return false
    end

    if resource == "iron-ore" then
        return settingsGlobal["ribbon-maze-iron-ore"].value
    end

    if resource == "copper-ore" then
        return settingsGlobal["ribbon-maze-copper-ore"].value
    end

    if resource == "coal" then
        return settingsGlobal["ribbon-maze-coal"].value
    end

    if resource == "stone" then
        return settingsGlobal["ribbon-maze-stone"].value
    end

    if resource == "crude-oil" then
        return settingsGlobal["ribbon-maze-crude-oil"].value
    end

    if resource == "uranium-ore" then
        return settingsGlobal["ribbon-maze-uranium-ore"].value
    end

    return settingsGlobal["ribbon-maze-mod-resources"].value
end

local function guessAvoidStartingArea(resource)
    local prototype = game.entity_prototypes[resource]
    if prototype and prototype.autoplace_specification and prototype.autoplace_specification.peaks then
        -- look for a peak that reduces the influence in the starting area (as done with uranium, and certain angel's ores):
        for _,v in ipairs(prototype.autoplace_specification.peaks) do
            if v.influence and v.starting_area_weight_optimal and v.influence <= -1 and v.starting_area_weight_optimal == 1 then
                return true
            end
        end
    end
    return false
end

local function guessMixedOreStrength(resource)
    local prototype = game.entity_prototypes[resource]

    if guessAvoidStartingArea(resource) then
        return 0
    end

    if prototype.resource_category == "basic-solid" and
            prototype.mineable_properties and not
            prototype.mineable_properties.required_fluid and not
            prototype.infinite_resource then
        return 1
    else
        return 0
    end
end

-- AutoplaceSpecification information is limited at runtime so we build up some static information for both vanilla
-- and mods heere

local mixedOreStrengths = {}
-- vanilla
mixedOreStrengths["iron-ore"] = 4
mixedOreStrengths["copper-ore"] = 3
mixedOreStrengths["coal"] = 2
mixedOreStrengths["stone"] = 1
mixedOreStrengths["uranium-ore"] = 0
mixedOreStrengths["crude-oil"] = 0
-- bob's ores:
mixedOreStrengths["bauxite-ore"] = 0
mixedOreStrengths["cobalt-ore"] = 0
mixedOreStrengths["gem-ore"] = 0
mixedOreStrengths["gold-ore"] = 0
mixedOreStrengths["lead-ore"] = 1
mixedOreStrengths["nickel-ore"] = 0
mixedOreStrengths["quartz"] = 1
mixedOreStrengths["rutile-ore"] = 0
mixedOreStrengths["silver-ore"] = 0
mixedOreStrengths["sulfur"] = 0
mixedOreStrengths["thorium-ore"] = 0
mixedOreStrengths["tin"] = 1
mixedOreStrengths["tungsten-ore"] = 0
mixedOreStrengths["zinc-ore"] = 0
mixedOreStrengths["ground-water"] = 0
mixedOreStrengths["lithia_water"] = 0
-- angel's refining:
mixedOreStrengths["angels-ore1"] = 2
mixedOreStrengths["angels-ore2"] = 0
mixedOreStrengths["angels-ore3"] = 2
mixedOreStrengths["angels-ore4"] = 0
mixedOreStrengths["angels-ore5"] = 2
mixedOreStrengths["angels-ore6"] = 2
-- yuoki industries:
mixedOreStrengths["y-res1"] = 1
mixedOreStrengths["y-res2"] = 1
-- dark matter replicators:
mixedOreStrengths["tenemut"] = 1
-- mad clown's ores (use automatic guessing)

-- The depths at which to add certain ores to the resource matrix (excluding some hard-coded values below to ensure
-- critical vanilla resources spawn in the first available corridor of the given depth)
local resourceCorridorDepths = {}
-- vanilla
resourceCorridorDepths["iron-ore"] = {4,10} -- 2 hardcoded below
resourceCorridorDepths["coal"] = {2} -- 4 hardcoded below
resourceCorridorDepths["copper-ore"] = {2} -- 6 hardcoded below
resourceCorridorDepths["stone"] = {2,6}
resourceCorridorDepths["crude-oil"] = {10} -- 8 hardcoded below
resourceCorridorDepths["uranium-ore"] = {} -- 10 hardcoded below
-- bob's ores:
resourceCorridorDepths["bauxite-ore"] = {6,8}
resourceCorridorDepths["cobalt-ore"] = {8,10}
resourceCorridorDepths["gem-ore"] = {10}
resourceCorridorDepths["gold-ore"] = {4,6}
resourceCorridorDepths["lead-ore"] = {2,4,6}
resourceCorridorDepths["nickel-ore"] = {6,8}
resourceCorridorDepths["quartz"] = {2,4}
resourceCorridorDepths["rutile-ore"] = {6,8}
resourceCorridorDepths["silver-ore"] = {4,6}
resourceCorridorDepths["sulfur"] = {4,6}
resourceCorridorDepths["thorium-ore"] = {8}
resourceCorridorDepths["tin"] = {2,4,6}
resourceCorridorDepths["tungsten-ore"] = {6,8}
resourceCorridorDepths["zinc-ore"] = {4,6}
resourceCorridorDepths["ground-water"] = {6,8}
resourceCorridorDepths["lithia_water"] = {6,8}
-- angel's refining:
resourceCorridorDepths["angels-ore1"] = {2,4,6,8,10}
resourceCorridorDepths["angels-ore2"] = {6,8,10}
resourceCorridorDepths["angels-ore3"] = {2,4,6,8,10}
resourceCorridorDepths["angels-ore4"] = {6,8,10}
resourceCorridorDepths["angels-ore5"] = {2,4,6,8,10}
resourceCorridorDepths["angels-ore6"] = {2,4,6,8,10}
-- yuoki industries:
resourceCorridorDepths["y-res1"] = {2,4,6,8,10}
resourceCorridorDepths["y-res2"] = {2,4,6,8,10}
-- dark matter replicators:
resourceCorridorDepths["tenemut"] = {2,4,6,8,10}
-- mad clown's ores (use automatic guessing)

local function guessResourceCorridorDepths(resource)
    local prototype = game.entity_prototypes[resource]
    if prototype and prototype.infinite_resource then
        return {8,10}
    elseif guessAvoidStartingArea(resource) then
        return {6,8,10}
    else
        return {2,4,6,8,10}
    end
end

local function fitDivisor30(startSize)
    for i = startSize,30,1 do
        if 30 % i == 0 then
            return i
        end
    end
    return startSize
end

local function resourceAlignment(resource)
    local prototype = game.entity_prototypes[resource]
    local collisionBox = prototype.collision_box
    local sizeX = math.ceil(collisionBox.right_bottom.x - collisionBox.left_top.x)
    local sizeY = math.ceil(collisionBox.right_bottom.y - collisionBox.left_top.y)
    -- don't both if it can fit in a single tile
    if sizeX <= 1 and sizeY <= 1 then
        return nil
    end

    -- room for pipes (most large resources need them)
    sizeX = sizeX + 1
    sizeY = sizeY + 1

    -- fit equally in the 30x30 tile:
    sizeX = fitDivisor30(sizeX)
    sizeY = fitDivisor30(sizeY)

    local offsetX = math.ceil(-collisionBox.left_top.x)
    local offsetY = math.ceil(-collisionBox.left_top.y)

    local xPositions = {}
    local yPositions = {}

    for x = 0,(30-sizeX),sizeX do
        xPositions[x+offsetX] = true
    end
    for y = 0,(30-sizeY),sizeY do
        yPositions[y+offsetY] = true
    end

    return {xPositions = xPositions, yPositions = yPositions}
end

-- This function must be called createRibbonMazeConfig(). It is recommended to use only settings, but global/game are
-- also available. It can be relatively expensive because it is only run on settings/configuration change.
function createRibbonMazeConfig()

    -- idea here is to access the settings table just once per event, for performance
    local settingsGlobal = settings.global

    local waterTileReplacement = {}
    waterTileReplacement["water"] = "red-desert-0"
    waterTileReplacement["water-green"] = "red-desert-1"
    waterTileReplacement["deepwater"] = "red-desert-2"
    waterTileReplacement["deepwater-green"] = "red-desert-3"

    local resourceMatrix = {}
    resourceMatrix[2] = {}
    resourceMatrix[4] = {}
    resourceMatrix[6] = {}
    resourceMatrix[8] = {}
    resourceMatrix[10] = {}

    -- initial resources, hardcoded to ensure they take the first available corridor of the given depth:
    if deadEndEnabled(settingsGlobal, "iron-ore") then
        table.insert(resourceMatrix[2], "iron-ore")
    end

    if deadEndEnabled(settingsGlobal, "coal") then
        table.insert(resourceMatrix[4], "coal")
    end

    if deadEndEnabled(settingsGlobal, "copper-ore") then
        table.insert(resourceMatrix[6], "copper-ore")
    end

    if deadEndEnabled(settingsGlobal, "crude-oil") then
        table.insert(resourceMatrix[8], "crude-oil")
    end

    if deadEndEnabled(settingsGlobal, "uranium-ore") then
        table.insert(resourceMatrix[10], "uranium-ore")
    end

    local resources = {}
    local mixedResources = {}
    local forcedMixedResources = {}

    local infiniteOres
    if not settingsGlobal["ribbon-maze-separate-out-infinite-ores"].value then
        infiniteOres = {}
    else
        infiniteOres = nil
    end

    for name,prototype in pairs(game.entity_prototypes) do
        if deadEndEnabled(settingsGlobal, name) then
            resources[name] = true
            local resourceCorridorDepth = resourceCorridorDepths[name] or guessResourceCorridorDepths(name)
            for _,depth in pairs(resourceCorridorDepth) do
                if not resourceMatrix[depth] then
                    resourceMatrix[depth] = {}
                end
                table.insert(resourceMatrix[depth], name)
            end
            local mixedOreStrength = mixedOreStrengths[name] or guessMixedOreStrength(name)
            for i=1,mixedOreStrength do
                table.insert(mixedResources, name)
            end
            if mixedOreStrength > 0 then
                table.insert(forcedMixedResources, name)
            end
        elseif infiniteOres then
            local finiteOre = infiniteOre(prototype)
            if finiteOre and deadEndEnabled(settingsGlobal, finiteOre) then
                infiniteOres[finiteOre] = name
                resources[name] = true
            end
        end
    end

    local ensureResources = {}

    if deadEndEnabled(settingsGlobal, "crude-oil") then
        ensureResources["crude-oil"] = {
            fallbackY = 9,
            maxY = 32,
            reveal = settingsGlobal["ribbon-maze-chart-nearby-crude-oil"].value,
        }
    end

    if deadEndEnabled(settingsGlobal, "uranium-ore") then
        ensureResources["uranium-ore"] = {
            fallbackY = 17,
            maxY = 32,
            reveal = settingsGlobal["ribbon-maze-chart-nearby-uranium-ore"].value,
        }
    end

    local minMixedResourcesPatchworkSize =  settingsGlobal["ribbon-maze-mixed-patchwork-min"].value
    local maxMixedResourcesPatchworkSize =  settingsGlobal["ribbon-maze-mixed-patchwork-max"].value
    if maxMixedResourcesPatchworkSize < minMixedResourcesPatchworkSize then
        maxMixedResourcesPatchworkSize = minMixedResourcesPatchworkSize
    end

    local clearMazeStartChunks = settingsGlobal["ribbon-maze-clear-start"].value

    local resourceAlignments = {}
    for r,_ in pairs(resources) do
        local alignment = resourceAlignment(r)
        if alignment then
            resourceAlignments[r] = alignment
        end
    end

    return {
        -- True if terraforming prototypes are available, in which case entities and forces will be created to allow
        -- automated terraforming with artillery
        terraformingPrototypesEnabled = true,

        -- Surfaces for the mod to manage; by default only nauvis to avoid conflict with other mods
        modSurfaces = {"nauvis"},

        -- Tile to use for water placed at the start of the maze ("row zero").
        waterTile = "water",

        -- By default, water-green is reused as a maze wall and its prototype modified, rather than using the out-of-map
        -- tile. This means we can reuse the transitions set up by the base mod with no extra effort.
        mazeWallTile = "water-green",

        -- Replace water tiles so that water doesn't block exploration
        waterTileReplacement = waterTileReplacement,

        -- Maze dimensions are calculated from the narrowist finite map size or else use the default width
        -- This default is chosen to allow a be 3 radars in width, so one radar can't reveal it all, and provide some
        -- variability
        mazeDefaultWidthChunks = 21,

        -- Maximum is just some defensive programming; the maze algorithm should actually be very efficient
        mazeMaxWidthChunks = 70,

        mazeBlockSize = settingsGlobal["ribbon-maze-block-size"].value,

        -- Make sure resources like oil and uranium appear with in a tolerable distance, and optionally reveal their
        -- location so that people can assess if they are happy with the map
        ensureResources = ensureResources,

        -- The ores which are controlled by the mod. Only resources in this table will be added to dead ends and
        -- forcibly removed from other locations.
        resources = resources,
        resourceAlignments = resourceAlignments,
        resourceStretchFactor = settingsGlobal["ribbon-maze-resource-stretch-factor"].value,

        -- Infinite equivalents of ores, to place them at the centre of resource patches
        infiniteOres = infiniteOres,
        infiniteOreStretchFactor = settingsGlobal["ribbon-maze-infinite-ore-stretch-factor"].value,

        -- Mixed ores near start are picked randomly from this array; duplicate entries increase a resource's
        -- odds of being picked.
        mixedResources = mixedResources,
        -- There will be at least one of any forced mixed resources in a patch, space permitting:
        forcedMixedResources = forcedMixedResources,
        minMixedResourcesPatchworkSize = minMixedResourcesPatchworkSize,
        maxMixedResourcesPatchworkSize = maxMixedResourcesPatchworkSize,
        mixedResourcesMultiplier = (#forcedMixedResources / 4) or 1,

        -- The resource matrix controls which resources can be picked at a given length of corridor (i.e. a length of
        -- maze with no junctions; bends are ok though). Only even numbers are possible. Corridor length calculation is
        -- capped at the highest index given in the table.
        -- The first time a corridor of a given length is looked at, the first entry is picked. So the first resource
        -- created in a corridor of length 10 will always be uranium. After that, it is random. Resources are always
        -- calcuated in order rom bottom-left to top-right.
        resourceMatrix = resourceMatrix,

        -- Creates a clear maze of this many chunks
        clearMazeStartChunks = clearMazeStartChunks,
    }
end
