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

local terraformingArtilleryShell = table.deepcopy(data.raw.ammo["artillery-shell"])

terraformingArtilleryShell.name = "maze-terraforming-artillery-shell"
terraformingArtilleryShell.ammo_type.category = "maze-terraforming-artillery-shell"
terraformingArtilleryShell.ammo_type.action.action_delivery.projectile = "maze-terraforming-artillery-projectile"


terraformingArtilleryShell.icon = nil
terraformingArtilleryShell.icons = {{
    icon = "__base__/graphics/icons/artillery-shell.png",
    tint = {r=0.21, g=0.41, b=0.9, a=1.0},
}}

data:extend{terraformingArtilleryShell}
