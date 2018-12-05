
-- https://github.com/h8ul-modder/factorio-ribbon-maze/issues/16
-- Removes mangroves that were not correctly colliding with landfill
for _,surface in pairs(game.surfaces) do

    for _, bruguiera in pairs(surface.find_entities_filtered{name="mangrove-bruguiera"}) do
        if bruguiera.valid then
            if surface.get_tile(bruguiera.position.x, bruguiera.position.y).name ~= "water" then
                bruguiera.destroy()
            end
        end
    end
end

