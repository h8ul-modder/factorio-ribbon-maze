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
        type = "int-setting",
        name = "ribbon-maze-blocks",
        setting_type = "runtime-global",
        min_value = 1,
        max_value = 70,
        default_value = 21,
        order="rb-a",
    },
    {
        type = "int-setting",
        name = "ribbon-maze-block-size",
        setting_type = "runtime-global",
        default_value = 32,
        allowed_values = {32,64,96,128,192,256},
        order="rb-b",
    },
    {
        type = "int-setting",
        name = "ribbon-maze-clear-start",
        setting_type = "runtime-global",
        default_value = 0,
        order="rb-c",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-chart-nearby-crude-oil",
        setting_type = "runtime-global",
        default_value = false
        ,
        order="rb-d",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-chart-nearby-uranium-ore",
        setting_type = "runtime-global",
        default_value = false,
        order="rb-e",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-mixed-preferred",
        setting_type = "runtime-global",
        default_value = false,
        order="rb-f-a",
    },
    {
        type = "int-setting",
        name = "ribbon-maze-mixed-patchwork-min",
        setting_type = "runtime-global",
        default_value = 1,
        allowed_values = {1,2,3,5,6,10,15},
        order="rb-f-b",
    },
    {
        type = "int-setting",
        name = "ribbon-maze-mixed-patchwork-max",
        setting_type = "runtime-global",
        default_value = 15,
        allowed_values = {1,2,3,5,6,10,15},
        order="rb-f-c",
    },
    {
        type = "double-setting",
        name = "ribbon-maze-resource-stretch-factor",
        setting_type = "runtime-global",
        minimum_value = 0.01,
        maximum_value = 1000,
        default_value = 1,
        order="rb-resource-stretch-factor",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-stone",
        setting_type = "runtime-global",
        default_value = true,
        order="rb-h",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-coal",
        setting_type = "runtime-global",
        default_value = true,
        order="rb-i",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-copper-ore",
        setting_type = "runtime-global",
        default_value = true,
        order="rb-j",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-iron-ore",
        setting_type = "runtime-global",
        default_value = true,
        order="rb-k",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-uranium-ore",
        setting_type = "runtime-global",
        default_value = true,
        order="rb-lu",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-crude-oil",
        setting_type = "runtime-global",
        default_value = true,
        order="rb-lc",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-mod-resources",
        setting_type = "runtime-global",
        default_value = false,
        order="rb-m",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-separate-out-infinite-ores",
        setting_type = "runtime-global",
        default_value = false,
        order="rb-m-infinite",
    },
    {
        type = "double-setting",
        name = "ribbon-maze-infinite-ore-stretch-factor",
        setting_type = "runtime-global",
        minimum_value = 0.01,
        maximum_value = 1000,
        default_value = 8,
        order="rb-m-infinite-stretch-factor",
    },
    {
        type = "double-setting",
        name = "ribbon-maze-loop-chance",
        setting_type = "runtime-global",
        minimum_value = 0,
        maximum_value = 1,
        default_value = 0,
        order="rb-v-a",
    },
    {
        type = "bool-setting",
        name = "ribbon-maze-water-resource",
        setting_type = "runtime-global",
        default_value = false,
        order="rb-v-b",
    },
    {
        type = "double-setting",
        name = "ribbon-maze-clearing-chance",
        setting_type = "runtime-global",
        minimum_value = 0,
        maximum_value = 1,
        default_value = 0,
        order="rb-v-c-c",
    },
    {
        type = "int-setting",
        name = "ribbon-maze-clearing-size-max",
        setting_type = "runtime-global",
        default_value = 3,
        order="rb-v-c-m",
    },
}

