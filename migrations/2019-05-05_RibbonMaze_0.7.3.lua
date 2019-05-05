
-- Backport fix that in 0.17, the maze chasm has to be immune to all damage types rather than indestructible to be
-- targeted by artillery

for _,surface in pairs(game.surfaces) do

    for _, chasm in pairs(surface.find_entities_filtered{name="maze-terraforming-target"}) do
        chasm.destructible = true
    end
end

