--[[
   Copyright 2017 H8UL

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


--
-- class Cmwc
--
-- A pure lua Complimentary-Multiply-With-Carry random number generator
-- This is used in place of Lua's builtin math.random, which is platform-specific
--
-- A lag of 4 is used. While minimal by CMWC standards, the amount of random numbers
-- required is relatively small, so the periodicity is still excellent for our purposes.
--
-- Based on "Random Number Generators", by George Marsaglia
-- Journal of Modern Applied Statistical Methods May 2003, Vol. 2, No.1, 2-13
Cmwc = {
}

-- Multiplication behaves differently on Windows and Linux so we have to emulate 32-bit multiplication
local function mul32(a, b)
    a = bit32.band(a, 0xffffffff);
    b = bit32.band(b, 0xffffffff);
    local ah = bit32.rshift(a, 16);
    local bh = bit32.rshift(b, 16);
    local al = bit32.band(a, 0xffff);
    local bl = bit32.band(b, 0xffff);
    local high = bit32.band((ah * bl) + (al * bh), 0xffff);
    return bit32.band((high * 0x10000) + (al * bl), 0xffffffff);
end

local function lcg(s)
    return bit32.rshift(mul32(1664525,s)+1013904223, 0xffffffff)
end

local function rngFactory(seed1, seed2, seed3, seed4)
    local rng = {
        Q = {seed1, seed2, seed3, seed4},
        c = 123,
        i = 3,
    }

    -- discard enough values to do away with the seeds in Q
    Cmwc.randUint32(rng)
    Cmwc.randUint32(rng)
    Cmwc.randUint32(rng)
    Cmwc.randUint32(rng)

    return rng
end

-- CMWC supports a large seed space, but this method uses one numerical seed, for ease of input
-- this doesn't give access to the entire seed space, which would require a precise 128-bit integer
-- but it is does give 2^32 which is ample.
function Cmwc.withSeed(seed)
    -- use an LCG to populate the four seeds from one number in such a fashion that thee
    -- seeds are discontinuous

    -- discard the first LCG result, as a precaution
    local seedDiscarded = lcg(seed)

    local seed1 = lcg(seedDiscarded)
    local seed2 = lcg(seed1)
    local seed3 = lcg(seed2)
    local seed4 = lcg(seed3)

    return rngFactory(seed1, seed2, seed3, seed4)
end

-- Derive a new RNG seeded by this RNG, in such a way as to ensure that the derived RNG is
-- discontinuous; the derived RNG shouldn't repeat or be trivially related to the parent RNG's sequence
function Cmwc.deriveNew(rng)

    -- use some LCG-like transformations to ensure seed has non-trivial relationship to parent RNG
    -- we use four random values from the parent RNG rather than take just one seed, to give
    -- better sampling of the space of seeds Z in the derived RNGs
    local seed1 =lcg(lcg(Cmwc.randUint32(rng)))
    local seed2 =lcg(lcg(Cmwc.randUint32(rng)))
    local seed3 =lcg(lcg(Cmwc.randUint32(rng)))
    local seed4 =lcg(lcg(Cmwc.randUint32(rng)))

    return rngFactory(seed1, seed2, seed3, seed4)
end

-- Reserve the appropriate RNG calls, so it can be replaced with deriveNew later if desired without
-- affecting subsequence RNG
function Cmwc.reserved(rng)
    Cmwc.randUint32(rng)
    Cmwc.randUint32(rng)
    Cmwc.randUint32(rng)
    Cmwc.randUint32(rng)
end

-- Generate a random integer in the range [0, 2^32-1]
function Cmwc.randUint32(rng)
    rng.i = bit32.band(rng.i + 1, 3)
    local t = (mul32(987654978, rng.Q[rng.i+1])) + rng.c
    rng.c = bit32.rshift(t, 32)
    local x = bit32.band(t + rng.c, 0xffffffff)
    if x < rng.c then
        x = bit32.band(x + 1, 0xffffffff)
        rng.c = bit32.band(rng.c + 1, 0xffffffff)
    end
    local q = bit32.band(0xfffffffe - x, 0xffffffff)
    rng.Q[rng.i+1] = q
    return q
end

-- Generate a random fraction in the range [0, 1]
function Cmwc.randFraction(rng)
    return Cmwc.randUint32(rng) / 0xffffffff
end

-- Generate a random percentage in the range [0, 100]
function Cmwc.randPercentage(rng)
    return 100.0 * Cmwc.randUint32(rng) / 0xffffffff
end

-- Generate a random integer in the range [low, high]
function Cmwc.randRange(rng, low, high)
    return math.floor(Cmwc.randFraction(rng) * (1+high-low)) + low
end

function Cmwc.randFractionRange(rng, low, high)
    return low + ((high-low) * Cmwc.randFraction(rng))
end