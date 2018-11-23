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

data:extend {
    {
        type = "recipe",
        name = "raw-wood-shredding",
        energy_required = 0.2,
        enabled = false,
        always_show_made_in = true,
        ingredients =
        {
            {"raw-wood", 10},
        },
        results = {
            {type="item", name="composting-greens", amount=1},
            {type="item", name="composting-browns", amount=9},
        },
        main_product = "",
        subgroup = "intermediate-product",
        icons = {
            {
                icon = "__base__/graphics/icons/raw-wood.png",
                icon_size = 32,
            },
            {
                icon = "__RibbonMaze__/graphics/icons/compost-shredding.png",
                icon_size = 32,
            },
        },
        order = "terraforming-shredding-raw-wood"
    },

    {
        type = "recipe",
        name = "green-wood-shredding",
        energy_required = 0.2,
        enabled = false,
        always_show_made_in = true,
        ingredients =
        {
            {"green-wood", 10},
        },
        results = {
            {type="item", name="composting-greens", amount=9},
            {type="item", name="composting-browns", amount=1},
        },
        main_product = "",
        subgroup = "intermediate-product",
        icons = {
            {
                icon = "__base__/graphics/icons/raw-wood.png",
                icon_size = 32,
                tint = {r=0.41, g=0.8, b=0.41, a=1.0},
            },
            {
                icon = "__RibbonMaze__/graphics/icons/compost-shredding.png",
                icon_size = 32,
            },
        },
        order = "terraforming-shredding-green-wood"
    },

    {
        type = "recipe",
        name = "wood-shredding",
        energy_required = 0.2,
        enabled = false,
        always_show_made_in = true,
        ingredients =
        {
            {"wood", 2},
        },
        results = {
            {type="item", name="composting-browns", amount=1}
        },
        main_product = "",
        subgroup = "intermediate-product",
        icons = {
            {
                icon = "__base__/graphics/icons/wood.png",
                icon_size = 32,
            },
            {
                icon = "__RibbonMaze__/graphics/icons/compost-shredding.png",
                icon_size = 32,
            },
        },
        order = "terraforming-shredding-wood"
    },

    {
        type = "recipe",
        name = "wooden-chest-shredding",
        energy_required = 0.2,
        enabled = false,
        always_show_made_in = true,
        ingredients =
        {
            {"wooden-chest", 2},
        },
        results = {
            {type="item", name="composting-browns", amount=1}
        },
        main_product = "",
        subgroup = "intermediate-product",
        icons = {
            {
                icon = "__base__/graphics/icons/wooden-chest.png",
                icon_size = 32,
            },
            {
                icon = "__RibbonMaze__/graphics/icons/compost-shredding.png",
                icon_size = 32,
            },
        },
        order = "terraforming-shredding-wood"
    },

    {
        type = "recipe",
        name = "small-electric-pole-shredding",
        energy_required = 0.2,
        enabled = false,
        always_show_made_in = true,
        ingredients =
        {
            {"small-electric-pole", 2},
        },
        results = {
            {type="item", name="composting-browns", amount=1}
        },
        main_product = "",
        subgroup = "intermediate-product",
        icons = {
            {
                icon = "__base__/graphics/icons/small-electric-pole.png",
                icon_size = 32,
            },
            {
                icon = "__RibbonMaze__/graphics/icons/compost-shredding.png",
                icon_size = 32,
            },
        },
        order = "terraforming-shredding-wood"
    },

    {
        type = "recipe",
        name = "raw-fish-shredding",
        energy_required = 0.2,
        enabled = false,
        always_show_made_in = true,
        ingredients =
        {
            {"raw-fish", 1},
        },
        results = {
            {type="item", name="composting-greens", amount=1},
        },
        main_product = "",
        subgroup = "intermediate-product",
        icons = {
            {
                icon = "__base__/graphics/icons/fish.png",
                icon_size = 32,
            },
            {
                icon = "__RibbonMaze__/graphics/icons/compost-shredding.png",
                icon_size = 32,
            },
        },
        order = "terraforming-shredding-raw-fish"
    }
}