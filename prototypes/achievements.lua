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

data:extend{
    {
        type = "produce-achievement",
        name = "terraforming-maze",
        order = "aa[production]-a[terraforming-maze]",
        amount = 5000,
        item_product = "maze-terraforming-artillery-shell",
        icons = {
            {
                icon = "__base__/graphics/achievement/trans-factorio-express.png",
                icon_size = 128,
                tint = {r=0, b=1, g=0, a=0.8}
            },
            {
                icon = "__RibbonMaze__/graphics/achievements/terraforming.png",
                icon_size = 128,
            },
        },
        limited_to_one_game = true
    },
    {
        type = "produce-per-hour-achievement",
        name = "feller-buncher",
        order = "aa[production]-b[feller-buncher]",
        item_product = "wood",
        amount = 1000,
        icons = {
            {
                icon = "__RibbonMaze__/graphics/achievements/waterworld.png",
                icon_size = 128,
            },
            {
                icon = "__base__/graphics/achievement/run-forrest-run.png",
                icon_size = 128,
            },
        },
        limited_to_one_game = false
    }
}