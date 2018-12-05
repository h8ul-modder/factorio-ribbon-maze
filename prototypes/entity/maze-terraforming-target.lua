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
        type = "simple-entity-with-force",
        name = "maze-terraforming-target",
        icon = "__base__/graphics/icons/stone-wall.png",
        picture = {
            filename = "__base__/graphics/entity/pipe/hr-pipe-cross.png",
            priority = "extra-high",
            width = 0,
            height = 0,
        },
        icon_size = 32,
        collision_mask = {"object-layer"},
        collision_box = {{-0, -0}, {0, 0}},
        selection_box = {{-1, -1}, {2.9, 2.9}},
        shooting_cursor_size = 2,
        flags = {"not-flammable", "not-repairable", "not-on-map", "not-blueprintable", "not-deconstructable", "not-rotatable"},
        allow_copy_paste = false,
        minable = nil,
        max_health = 1000,
        corpse = nil,
    },
}
