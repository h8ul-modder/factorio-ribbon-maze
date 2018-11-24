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

data:extend{{
    type = "technology",
    name = "oil-scanning",
    icons = {
        {
            icon = "__base__/graphics/technology/oil-gathering.png",
            icon_size = 128
        },
        {
            icon = "__RibbonMaze__/graphics/technology/resource-scanning.png",
            icon_size = 128
        }
    },
    effects =
    {
        {
            type = "nothing"
        },
    },
    prerequisites = {"oil-processing"},
    unit =
    {
        count = 250,
        ingredients =
        {
            {"science-pack-1", 1},
            {"science-pack-2", 1},
        },
        time = 30
    },
    order = "d-e-f"
}
}