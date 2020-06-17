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

data:extend {{
    type = "resource",
    name = "mangrove-avicennia",
    category = "mangrove",
    icon = "__base__/graphics/icons/tree-08.png",
    icon_size = 32,
    flags = {"placeable-neutral"},
    order="a-b-mangrove-avicennia",
    collision_mask = {"resource-layer", "ground-tile"},
    collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
    emissions_per_second = -0.0060,
    infinite = true,
    highlight = true,
    minimum = 100,
    normal = 100,
    infinite_depletion_amount = 0,
    resource_patch_search_radius = 1,
    tree_removal_probability = 0,
    tree_removal_max_distance = 1,
    minable = {
        mining_time = 10,
        result = "green-wood",
        count = 1,
        mining_particle = "wooden-particle",
        hardness = 0.5
    },
    stage_counts = {0},
    stages = {
        sheet = {
            filename = "__RibbonMaze018__/graphics/entity/green-coral-01.png",
            priority = "extra-high",
            width = 58,
            height = 69,
            frame_count = 1,
            variation_count = 1
        }
    },
    map_color = {r=0.1, g=0.4, b=0.3},
    map_grid = false,
} }

data:extend {{
    type = "resource",
    name = "mangrove-bruguiera",
    category = "mangrove",
    icon = "__base__/graphics/icons/tree-08.png",
    icon_size = 32,
    flags = {"placeable-neutral"},
    order="a-b-mangrove-bruguiera",
    collision_mask = {"resource-layer", "ground-tile"},
    collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
    emissions_per_second = -0.0060,
    infinite = true,
    highlight = true,
    minimum = 100,
    normal = 100,
    infinite_depletion_amount = 0,
    resource_patch_search_radius = 1,
    tree_removal_probability = 0,
    tree_removal_max_distance = 1,
    minable = {
        mining_time = 10,
        result = "wood",
        count = 1,
        mining_particle = "wooden-particle",
        hardness = 0.5
    },
    stage_counts = {0},
    stages = {
        sheet = {
            filename = "__RibbonMaze018__/graphics/entity/green-coral-06.png",
            priority = "extra-high",
            width = 67,
            height = 71,
            frame_count = 1,
            variation_count = 1
        }
    },
    map_color = {r=0.1, g=0.4, b=0.3},
    map_grid = false,
}}

