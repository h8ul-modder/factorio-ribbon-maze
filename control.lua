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

local cachedRibbonMazeConfig

--------------------------------------------------------
-- Configure fixed constants, and proxy any settings ---
--------------------------------------------------------

local function createRibbonMazeConfig()

    local WATER_TILE_REPLACEMENT = {}
    WATER_TILE_REPLACEMENT["water"] = "red-desert-0"
    WATER_TILE_REPLACEMENT["water-green"] = "red-desert-1"
    WATER_TILE_REPLACEMENT["deepwater"] = "red-desert-2"
    WATER_TILE_REPLACEMENT["deepwater-green"] = "red-desert-3"

    local RESOURCE_MATRIX = {}
    RESOURCE_MATRIX[2] = {
        "iron-ore",
        "copper-ore",
        "coal",
        "stone",
    }
    RESOURCE_MATRIX[4] = {
        "coal",
        "iron-ore",
    }
    RESOURCE_MATRIX[6] = {
        "copper-ore",
        "stone",
    }
    RESOURCE_MATRIX[8] = {
        "crude-oil",
    }
    RESOURCE_MATRIX[10] = {
        "uranium-ore",
        "crude-oil",
        "iron-ore",
    }
    local RESOURCE_MATRIX_MAX = 10

    -- idea here is to access the settings table just once per event, for performance
    local settingsGlobal = settings.global

    local resources = {}
    local mixedResources = {}
    local forcedMixedResources = {}

    if settingsGlobal["ribbon-maze-iron-ore"].value then
        resources["iron-ore"] = true
        table.insert(mixedResources, "iron-ore")
        table.insert(mixedResources, "iron-ore")
        table.insert(mixedResources, "iron-ore")
        table.insert(mixedResources, "iron-ore")
        table.insert(forcedMixedResources, "iron-ore")
    end
    if settingsGlobal["ribbon-maze-copper-ore"].value then
        resources["copper-ore"] = true
        table.insert(mixedResources, "copper-ore")
        table.insert(mixedResources, "copper-ore")
        table.insert(mixedResources, "copper-ore")
        table.insert(forcedMixedResources, "copper-ore")
    end
    if settingsGlobal["ribbon-maze-coal"].value then
        resources["coal"] = true
        table.insert(mixedResources, "coal")
        table.insert(mixedResources, "coal")
        table.insert(forcedMixedResources, "coal")
    end
    if settingsGlobal["ribbon-maze-stone"].value then
        resources["stone"] = true
        table.insert(mixedResources, "stone")
        table.insert(forcedMixedResources, "stone")
    end
    if settingsGlobal["ribbon-maze-crude-oil"].value then
        resources["crude-oil"] = true
    end
    if settingsGlobal["ribbon-maze-uranium-ore"].value then
        resources["uranium-ore"] = true
    end

    local ensureResources = {
        ["crude-oil"] = {
            fallbackY = 9,
            maxY = 32,
            reveal = settingsGlobal["ribbon-maze-chart-nearby-crude-oil"].value,
        },
        ["uranium-ore"] = {
            fallbackY = 17,
            maxY = 32,
            reveal = settingsGlobal["ribbon-maze-chart-nearby-uranium-ore"].value,
        },
    }

    local minMixedResourcesPatchworkSize =  settingsGlobal["ribbon-maze-mixed-patchwork-min"].value
    local maxMixedResourcesPatchworkSize =  settingsGlobal["ribbon-maze-mixed-patchwork-max"].value
    if maxMixedResourcesPatchworkSize < minMixedResourcesPatchworkSize then
        maxMixedResourcesPatchworkSize = minMixedResourcesPatchworkSize
    end

    local clearMazeStartChunks = settingsGlobal["ribbon-maze-clear-start"].value

    local config = {
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
        waterTileReplacement = WATER_TILE_REPLACEMENT,

        -- Maze dimensions are calculated from the narrowist finite map size or else use the default width
        -- This default is chosen to allow a be 3 radars in width, so one radar can't reveal it all, and provide some
        -- variability
        mazeDefaultWidthChunks = 21,

        -- Maximum is just some defensive programming; the maze algorithm should actually be very efficient
        mazeMaxWidthChunks = 70,

        -- Make sure resources like oil and uranium appear with in a tolerable distance, and optionally reveal their
        -- location so that people can assess if they are happy with the map
        ensureResources = ensureResources,

        -- The ores which are controlled by the mod. Only resources in this table will be added to dead ends and
        -- forcibly removed from other locations.
        resources = resources,

        -- Mixed ores near start are picked randomly from this array; duplicate entries increase a resource's
        -- odds of being picked.
        mixedResources = mixedResources,
        forcedMixedResources = forcedMixedResources,
        minMixedResourcesPatchworkSize = minMixedResourcesPatchworkSize,
        maxMixedResourcesPatchworkSize = maxMixedResourcesPatchworkSize,

        -- The resource matrix controls which resources can be picked at a given length of corridor (i.e. a length of
        -- maze with no junctions; bends are ok though). Only even numbers are possible. Corridor length calcuation is
        -- capped at RESOURCE_MATRIX_MAX.
        -- The first time a corridor of a given length is looked at, the first entry is picked. So the first resource
        -- created in a corridor of length 10 will always be uranium. After that, it is random. Resources are always
        -- calcuated in order rom bottom-left to top-right.
        resourceMatrix = RESOURCE_MATRIX,
        resourceMatrixMax = RESOURCE_MATRIX_MAX,

        -- Creates a clear maze of this many chunks
        clearMazeStartChunks = clearMazeStartChunks,
    }

    -- Update chached ribbon maze config here and return
    cachedRibbonMazeConfig = config
    return cachedRibbonMazeConfig
end

--------------------------------------------------------
-- Boilerplate for settings and configuration caching --
--------------------------------------------------------

function ribbonMazeConfig()
    if cachedRibbonMazeConfig then
        return cachedRibbonMazeConfig
    end
    return createRibbonMazeConfig()
end

local function clearCachedConfiguration()
    cachedRibbonMazeConfig = nil
end

script.on_configuration_changed(clearCachedConfiguration)
script.on_event(defines.events.on_runtime_mod_setting_changed, clearCachedConfiguration)

----------------------------------------------------
-- Require and register the maze control handlers --
----------------------------------------------------

require "control.maze-control"

script.on_init(initHandler)

script.on_event(defines.events.on_player_created, playerCreatedEventHander)
script.on_event(defines.events.on_chunk_generated, chunkGeneratedEventHandler)
script.on_event(defines.events.on_research_finished, resourceFinishedEventHandler)

------------------------------------------------------------
-- Require and register the terraforming control handlers --
------------------------------------------------------------

require "control.terraforming-control"

script.on_event(defines.events.on_built_entity, mazeTerraformingArtillerybuiltHandler)
script.on_event(defines.events.on_robot_built_entity, mazeTerraformingArtillerybuiltHandler)
script.on_event(defines.events.on_trigger_created_entity, mazeTerraformingResultHandler)