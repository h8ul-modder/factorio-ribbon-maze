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
    type = "item",
    name = "mangrove-harvester",
    icons = {
        {
            icon = "__base__/graphics/icons/tank.png",
            shift = {-3, -3},
            icon_size = 32,
        },
        {
            icon = "__base__/graphics/icons/raw-wood.png",
            shift = {3, 3},
            icon_size = 32,
            tint = {r=0.41, g=0.8, b=0.41, a=0.5},
        }
    },
    flags = {"goes-to-quickbar"},
    subgroup = "extraction-machine",
    order = "a[items]-b[mangrove-harvester]",
    place_result = "mangrove-harvester",
    stack_size = 50
}}
