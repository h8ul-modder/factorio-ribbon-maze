--[[
   Copyright 2018 H8UL
   Modifications Copyright 2019 Illiander

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

-- Eller's maze generation algorithm

Maze = {
}

function Maze.new(cmwcRng, numColumns, pRightWall, maxCorridorCheckDepth, loopChance, clearingChance, maxClearingSize)

    local numNonWallColumns = (numColumns + 1) / 2

    local o = {
        heightSoFar = 0,
        rng = cmwcRng,
        numNonWallColumns = numNonWallColumns,
        numColumns = numColumns,
        pRightWall = pRightWall,
        maxCorridorCheckDepth = maxCorridorCheckDepth,
        line = {},
        walls = {},
    }

    if loopChance > 0 then
        o.loopChance = loopChance
    end

    if clearingChance > 0 then
        o.clearingChance = clearingChance
        o.maxClearingSize = maxClearingSize
    end

    for pos = 1, numNonWallColumns do
        local set = {}
        set[pos] = true
        o.line[pos] = set
    end

    return o
end

function Maze.shrink(maze, newHeight)

    if newHeight >= maze.heightSoFar then
        return
    end

    for pos = 1, maze.numNonWallColumns do
        local set = {}
        set[pos] = true
        maze.line[pos] = set
    end

    for y = newHeight + 3, maze.heightSoFar do
        maze.walls[y] = nil
    end
    maze.heightSoFar = newHeight
--
--    for y = 0, maze.heightSoFar do
--        Maze.regenerateMazeRow_(maze, y)
--    end

end

function Maze.wallTileAt(maze, x, y)

    if y < 1 or x < 1 or x > maze.numColumns then
        return true
    end

    while y > maze.heightSoFar do
        Maze.generateMazeRow_(maze)
    end

    if maze.clearings then
        for _,c in pairs(maze.clearings) do
            if x > c.pos.x and x < c.pos.x+c.size and
                y > c.pos.y and y < c.pos.y+c.size then
            return false
            end
        end
    end

    if x % 2 == 0 and y % 2 == 0 then
        return true
    end

    local row = maze.walls[y]

    if row and row[x] then
        return true
    else
        return nil
    end
end

local NORTH = "N"
local SOUTH = "S"
local EAST = "E"
local WEST = "W"

function Maze.deadEnd(maze, x, y)
    local neighbouringWallTiles = 0;
    local direction;

    if Maze.wallTileAt(maze, x, y+1) then
        neighbouringWallTiles = neighbouringWallTiles + 1
    else
        direction = NORTH
    end
    if Maze.wallTileAt(maze, x, y-1) then
        neighbouringWallTiles = neighbouringWallTiles + 1
    else
        direction = SOUTH
    end
    if Maze.wallTileAt(maze, x+1, y) then
        neighbouringWallTiles = neighbouringWallTiles + 1
    else
        direction = EAST
    end
    if Maze.wallTileAt(maze, x-1, y) then
        neighbouringWallTiles = neighbouringWallTiles + 1
    else
        direction = WEST
    end

    if neighbouringWallTiles == 4 then
        error("maze algorithm bug: 4 neighbouring wall tiles at " .. x .. "," .. y)
    end

    if neighbouringWallTiles == 3 then
        return Maze.checkCorridor_(maze, x, y, direction, y, 2)
    else
        return {corridorLength = 0, yHighest = y}
    end
end

function Maze.checkCorridor_(maze, xIn, yIn, directionIn, yHighestIn, corridorLength)

    if not directionIn then
        error("maze algorithm bug: directionIn is nil")
    end

    if corridorLength >= maze.maxCorridorCheckDepth then
        return {corridorLength = corridorLength, yHighest = yHighestIn}
    end

    local x
    local y
    local yHighest = yHighestIn

    local neighbouringWallTiles = 0;
    local direction;

    if directionIn == NORTH then
        x = xIn
        y = yIn + 2
        if y > yHighest then
            yHighest = y
        end
        if Maze.wallTileAt(maze, x, y+1) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = NORTH
        end
        if Maze.wallTileAt(maze, x+1, y) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = EAST
        end
        if Maze.wallTileAt(maze, x-1, y) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = WEST
        end
    elseif directionIn == SOUTH then
        x = xIn
        y = yIn - 2
        if Maze.wallTileAt(maze, x, y-1) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = SOUTH
        end
        if Maze.wallTileAt(maze, x+1, y) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = EAST
        end
        if Maze.wallTileAt(maze, x-1, y) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = WEST
        end
    elseif directionIn == EAST then
        x = xIn + 2
        y = yIn
        if Maze.wallTileAt(maze, x, y+1) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = NORTH
        end
        if Maze.wallTileAt(maze, x, y-1) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = SOUTH
        end
        if Maze.wallTileAt(maze, x+1, y) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = EAST
        end
    elseif directionIn == WEST then
        x = xIn - 2
        y = yIn
        if Maze.wallTileAt(maze, x, y+1) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = NORTH
        end
        if Maze.wallTileAt(maze, x, y-1) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = SOUTH
        end
        if Maze.wallTileAt(maze, x-1, y) then
            neighbouringWallTiles = neighbouringWallTiles + 1
        else
            direction = WEST
        end
    end

    if neighbouringWallTiles == 4 then
        error("maze algorithm bug: 3 neighbouring wall tiles in corridor " .. x .. "," .. y)
    end

    if neighbouringWallTiles == 2 then
        return Maze.checkCorridor_(maze, x, y, direction, yHighest, corridorLength+2)
    else
        return {corridorLength = corridorLength, yHighest = yHighest}
    end
end


local function calculateSetSize_(set)
    local setSize = 0
    for _,v in pairs(set) do
        if v then
            setSize = setSize + 1
        end
    end
    return setSize
end

function Maze.calculateSampleSize_(maze, setSize)
    if setSize == 0 then
        error("maze algorithm bug: unexpected empty set during sampling")
    elseif setSize == 1 then
        -- never put a top wall on a lone set
        return 0
    end

    -- always leave 1 remaining to prevent isolates:
    return Cmwc.randRange(maze.rng, 0, setSize-1)
end

local function sample_(set, sampleAt)
    local pos = 0
    for k,v in pairs(set) do
        if v then
            pos = pos + 1
        end
        if pos == sampleAt then
            return k
        end
    end
    error("maze algorithm bug: attempted to sample at position " .. sampleAt .. " .. but the final position in the set was " .. pos)
end

function Maze.generateMazeRow_(maze)

    local rightWalls = {}
    local topWalls = {}

    for column = 1, (maze.numNonWallColumns-1) do
        local neighbour = column + 1

        if not maze.loopChance or Cmwc.randFraction(maze.rng) >= maze.loopChance then
            if maze.line[column] == maze.line[neighbour] then
                -- add loop breaking right wall
                rightWalls[column*2] = true
            elseif Cmwc.randFraction(maze.rng) >= maze.pRightWall then
                -- add right wall
                rightWalls[column*2] = true
            else
                -- not adding a wall so union the sets
                local fromCell = maze.line[neighbour]
                local toCell = maze.line[column]

                for k,present in pairs(fromCell) do
                    if present then
                        toCell[k] = true
                        maze.line[k] = toCell
                    end
                end
            end
        end
    end

    local setsToVisit = {}

    for column = 1, maze.numNonWallColumns do
        setsToVisit[maze.line[column]] = true
    end

    for set,_ in pairs(setsToVisit) do
        local setSize = calculateSetSize_(set)
        local sampleSize = Maze.calculateSampleSize_(maze, setSize)

        while (sampleSize > 0) do
            local sampleAt = Cmwc.randRange(maze.rng, 1, setSize)
            local sample = sample_(set, sampleAt)

            set[sample] = nil
            topWalls[sample*2 - 1] = true

            local newSet = {}
            newSet[sample] = true
            maze.line[sample] = newSet

            sampleSize = sampleSize - 1
            setSize = setSize - 1
        end
    end

    if maze.clearingChance and Cmwc.randFraction(maze.rng) <= maze.clearingChance then
        local size = math.floor(Cmwc.randRange(maze.rng, 2, maze.maxClearingSize))*2
        local pos = Cmwc.randRange(maze.rng, 1, maze.numNonWallColumns)*2
        local clearing = {
                size = size,
                pos = {y=maze.heightSoFar+2,x = pos}
        }
        maze.clearings = maze.clearings or {}
        table.insert(maze.clearings, clearing)
    end

    maze.walls[maze.heightSoFar+1] = rightWalls
    maze.walls[maze.heightSoFar+2] = topWalls
    maze.heightSoFar = maze.heightSoFar + 2
end

function Maze.regenerateMazeRow_(maze, row)

    local rightWalls = maze.walls[row+1]
    local topWalls = maze.walls[row+2]

    for column = 1, (maze.numNonWallColumns-1) do
        local neighbour = column + 1

        if not rightWalls[column*2] then
            -- no wall so union the sets
            local fromCell = maze.line[neighbour]
            local toCell = maze.line[column]

            for k,present in pairs(fromCell) do
                if present then
                    toCell[k] = true
                    maze.line[k] = toCell
                end
            end
        end
    end

    for column = 1, (maze.numNonWallColumns-1) do
        if topWalls[column*2] then
            -- wall above so start new set
            local newSet = {}
            newSet[column] = true
            maze.line[column] = newSet
        end
    end
end