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

local frame_count = 64
local animation_speed = 0.2
local run_mode = "forward-then-backward"
local scale = 0.4
local tint = {r=1.0, g=1.0, b=0.5, a=1.0}
local shift = {0.0, 0.5}

local mangroveHarvester = table.deepcopy(data.raw["mining-drill"]["burner-mining-drill"])

local mangroveHarvesterLayers = {
    table.deepcopy(data.raw.car["tank"].animation.layers[1])
}

mangroveHarvester.name = "mangrove-harvester"
mangroveHarvester.minable = {mining_time = 1, result = "mangrove-harvester"}
mangroveHarvester.collision_mask = {"object-layer" }
mangroveHarvester.resource_categories = {"mangrove"}
mangroveHarvester.energy_usage = "330kW"
mangroveHarvester.mining_power = 2.5
mangroveHarvester.mining_speed = 0.5
mangroveHarvester.max_health = 2000

mangroveHarvester.collision_box = {{ -1.4, -1.4}, {1.4, 1.4}}
mangroveHarvester.selection_box = {{ -1.5, -1.5}, {1.5, 1.5}}
mangroveHarvester.resource_searching_radius = 1.49
mangroveHarvester.vector_to_place_result = {0, -1.85}

mangroveHarvester.radius_visualisation_picture =
{
    filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
    width = 12,
    height = 12
}

mangroveHarvesterLayers[1].line_length = nil
mangroveHarvesterLayers[1].hr_version.line_length = nil

mangroveHarvesterLayers[1].frame_count = frame_count
mangroveHarvesterLayers[1].hr_version.frame_count = frame_count

mangroveHarvesterLayers[1].animation_speed = animation_speed
mangroveHarvesterLayers[1].hr_version.animation_speed = animation_speed

mangroveHarvesterLayers[1].run_mode = run_mode
mangroveHarvesterLayers[1].hr_version.run_mode = run_mode

mangroveHarvesterLayers[1].scale = scale
mangroveHarvesterLayers[1].hr_version.scale = scale

mangroveHarvesterLayers[1].tint = tint
mangroveHarvesterLayers[1].hr_version.tint = tint

mangroveHarvesterLayers[1].shift = shift
mangroveHarvesterLayers[1].hr_version.shift = shift

mangroveHarvester.animations.north.layers = mangroveHarvesterLayers
mangroveHarvester.animations.south.layers = mangroveHarvesterLayers
mangroveHarvester.animations.east.layers = mangroveHarvesterLayers
mangroveHarvester.animations.west.layers = mangroveHarvesterLayers

data:extend{mangroveHarvester}
