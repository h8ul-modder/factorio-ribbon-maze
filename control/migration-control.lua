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

local function fixes_0_6_7()
    local config = ribbonMazeConfig()

    for _,surface in pairs(game.surfaces) do
        local modSurfaceInfo = global.modSurfaceInfo[surface.name]
        if modSurfaceInfo then
            for chunkPosition in surface.get_chunks() do
                local chunkTilePosition = {x = chunkPosition.x*32, y=chunkPosition.y*32}

                local mazePosition = calculateMazePosition(config, modSurfaceInfo, chunkTilePosition)

                -- fix crude oil placement
                if config.resources["crude-oil"] then
                    local resource = resourceAt(config, surface, modSurfaceInfo, mazePosition)
                    if resource and resource.resourceName and resource.resourceName == "crude-oil" then
                        local chunkArea = {left_top = chunkTilePosition, right_bottom = {x = chunkTilePosition.x+31, y = chunkTilePosition.y+31}}
                        local resourcesToRemove = surface.find_entities_filtered{name="crude-oil", area=chunkArea}
                        for _, v in pairs(resourcesToRemove) do
                            v.destroy()
                        end
                        ribbonMazeGenerateResources(config, modSurfaceInfo, surface, chunkTilePosition, mazePosition)
                    end
                end

                -- fix terraforming targets
                if config.terraformingPrototypesEnabled and (not isOutOfMap(modSurfaceInfo, mazePosition)) and Maze.wallTileAt(modSurfaceInfo.maze, mazePosition.x, mazePosition.y) then
                    for tileX = chunkTilePosition.x+1, chunkTilePosition.x+29,4 do
                        for tileY = chunkTilePosition.y+1, chunkTilePosition.y+29,4 do
                            local tilePosition = {x=tileX,y=tileY}
                            if surface.get_tile(tilePosition).name == config.mazeWallTile then
                                local target = surface.find_entity("maze-terraforming-target", tilePosition)
                                if not target then
                                    target = surface.create_entity{name="maze-terraforming-target", position={tileX,tileY}, force="maze-terraforming-targets"}
                                    target.destructible = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Some migrations can only be run effectively once the config and global are available; we can do these here
-- Where possible however the factorio builtin mechanism should be preferred
local function runtimeControlMigrations(oldVersion)
    local migrations = {
        ["new"] = {},
        ["0.6.0"] = {fixes_0_6_7},
        ["0.6.1"] = {fixes_0_6_7},
        ["0.6.2"] = {fixes_0_6_7},
        ["0.6.3"] = {fixes_0_6_7},
        ["0.6.4"] = {fixes_0_6_7},
        ["0.6.5"] = {fixes_0_6_7},
        ["0.6.6"] = {fixes_0_6_7},
    }

    local versionMigrations = migrations[oldVersion or "new"]
    if versionMigrations then
        for _,migration in ipairs(versionMigrations) do
            migration()
        end
    end
end

-- register with script.on_configuration_changed(ribbonMazeConfigurationChanged):
function ribbonMazeConfigurationChanged(event)
    updateRibbonMazeConfig()
    if event and event.mod_changes and event.mod_changes["RibbonMaze"] then
        runtimeControlMigrations(event.mod_changes["RibbonMaze"].old_version)
    end
end


-- register with script.on_event(defines.events.on_runtime_mod_setting_changed, ribbonMazeModSettingChanged):
function ribbonMazeModSettingChanged()
    updateRibbonMazeConfig()
end

