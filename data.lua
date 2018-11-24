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

-- maze scanning
require('prototypes.technology.oil-scanning')
require('prototypes.technology.uranium-scanning')

-- mangroves

require('prototypes.categories.mangrove')
require('prototypes.item.green-wood')
require('prototypes.recipe.wood-kiln-drying')
require('prototypes.technology.wood-kiln-drying')

require('prototypes.entity.mangrove-trees')
require('prototypes.resource.mangrove')

require('prototypes.entity.mangrove-harvester')
require('prototypes.item.mangrove-harvester')
require('prototypes.recipe.mangrove-harvester')

-- compost

require('prototypes.item.composting-browns')
require('prototypes.item.composting-greens')
require('prototypes.item.compost')
require('prototypes.recipe.composting-shredding')
require('prototypes.recipe.in-vessel-composting')
require('prototypes.technology.in-vessel-composting')

-- geocomposite

require('prototypes.item.geocomposite')
require('prototypes.recipe.geocomposite')

-- maze terraforming

require('prototypes.categories.maze-terraforming-artillery-shell')

require('prototypes.entity.maze-terraforming-projectile')
require('prototypes.entity.maze-terraforming-result')
require('prototypes.entity.maze-terraforming-target')
require('prototypes.entity.maze-terraforming-turret')


require('prototypes.item.maze-terraforming-artillery-cannon')
require('prototypes.item.maze-terraforming-artillery-shell')
require('prototypes.item.maze-terraforming-artillery-turret')

require('prototypes.recipe.maze-terraforming-artillery-shell')
require('prototypes.recipe.maze-terraforming-artillery-turret')

-- wagon does not fire (probably due to the loco's force), so disabling for now
--require('prototypes.entity.maze-terraforming-wagon')
--require('prototypes.item.maze-terraforming-artillery-wagon')
--require('prototypes.recipe.maze-terraforming-artillery-wagon')

require('prototypes.technology.maze-terraforming')

-- achievements

require('prototypes.achievements')