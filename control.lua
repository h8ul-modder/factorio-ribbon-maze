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

-----------------------------------
-- Functions to process settings --
-----------------------------------
require "control.settings-control"
require "control.config-control"

----------------------------------------------------
-- Require and register the maze control handlers --
----------------------------------------------------

require "control.maze-control"

script.on_init(ribbonMazeInitHandler)

script.on_event(defines.events.on_player_created, ribbonMazePlayerCreatedEventHander)
script.on_event(defines.events.on_chunk_generated, ribbonMazeChunkGeneratedEventHandler)
script.on_event(defines.events.on_research_finished, ribbonMazeResourceFinishedEventHandler)

------------------------------------------------------------
-- Require and register the terraforming control handlers --
------------------------------------------------------------

require "control.terraforming-control"

script.on_event(defines.events.on_built_entity, mazeTerraformingArtillerybuiltHandler)
script.on_event(defines.events.on_robot_built_entity, mazeTerraformingArtillerybuiltHandler)
script.on_event(defines.events.on_trigger_created_entity, mazeTerraformingResultHandler)

----------------------
-- Custom commands  --
----------------------

-- TODO commands are a work in progress
--commands.add_command("regenerateMaze", "Regenerate Maze", regenerateMaze)
--commands.add_command("unchart", "unchart", unchart)

------------------------------------------------------------------------------------------
-- control.lua runtime "migrations" i.e. ones not suited to builtin factorio migrations --
------------------------------------------------------------------------------------------

require "control.migration-control"

script.on_configuration_changed(ribbonMazeConfigurationChanged)
script.on_event(defines.events.on_runtime_mod_setting_changed, ribbonMazeModSettingChanged)


remote.add_interface("RibbonMaze",{
	["insert_mod_surface"]=function(surface_name)
		for _,surfaceName in pairs(global.ribbonMazeConfig.modSurfaces)do
			if(surfaceName==surface_name)then
				return false
			end 
		end
		return table.insert(global.ribbonMazeConfig.modSurfaces,surface_name)
	end,
	["remove_mod_surface"]=function(surface_name)
		for tableIndex,surfaceName in pairs(global.ribbonMazeConfig.modSurfaces)do
			if(surfaceName==surface_name)then
				return table.remove(global.ribbonMazeConfig.modSurfaces,tableIndex)
			end
		end
		return false
	end,
})
