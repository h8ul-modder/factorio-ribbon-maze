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

local terraformingArtilleryProjectile = table.deepcopy(data.raw["artillery-projectile"]["artillery-projectile"])

terraformingArtilleryProjectile.name = "maze-terraforming-artillery-projectile"
terraformingArtilleryProjectile.map_color = {r=0, g=0, b=1}
terraformingArtilleryProjectile.action = {
    type = "direct",
    action_delivery = {
        type = "instant",
        target_effects = {
            {
                type = "nested-result",
                action = {
                    type = "area",
                    radius = 1.0,
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "create-entity",
                                entity_name = "maze-terraforming-result",
                                trigger_created_entity = true
                            }
                        }
                    }
                }
            },
            {
                type = "create-trivial-smoke",
                smoke_name = "artillery-smoke",
                initial_height = 0,
                speed_from_center = 0.05,
                speed_from_center_deviation = 0.005,
                offset_deviation = {{-4, -4}, {4, 4}},
                max_radius = 3.5,
                repeat_count = 4 * 4 * 15
            },
            {
                type = "show-explosion-on-chart",
                scale = 8/32
            }
        }
    }
}

terraformingArtilleryProjectile.final_action = nil

data:extend{terraformingArtilleryProjectile}
