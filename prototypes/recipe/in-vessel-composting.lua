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
    type = "recipe",
    name = "in-vessel-composting",
    category = "chemistry",
    energy_required = 60,
    enabled = false,
    always_show_made_in = true,
    ingredients =
    {
        {"composting-greens", 150},
        {"composting-browns", 100}
    },
    results = {
        {type="item", name="compost", amount=200},
        {type="fluid", name="water", amount=500, temperature=65},
    },
    subgroup = "intermediate-product",
    icons = {{
        icon = "__RibbonMaze018__/graphics/icons/compost.png",
        icon_size = 32,
    }},
    crafting_machine_tint =
    {
        primary = {r = 0.25, g = 0.1, b = 0.051, a = 0.000},
        secondary = {r = 0.812, g = 1.000, b = 0.000, a = 0.000}, -- #cfff0000
        tertiary = {r = 0.960, g = 0.806, b = 0.000, a = 0.000}, -- #f4cd0000
    },
    order = "terraforming-in-vessel-composting"
}}

