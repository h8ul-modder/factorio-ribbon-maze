# Ribbon Maze

The maze itself is destined to be automated.

Ribbon Maze challenges you to explore a maze in search of rich resources. The maze is impassable, but new late game
technologies let you terraform the maze...

Mod portal page: https://mods.factorio.com/mod/RibbonMaze

## Key features

* **Perfect maze** - only one right path takes you deeper into a practically infinite maze. But...
* **Dead ends are rewarding!** - resources spawn at dead ends. Longer corridors hold the most valuable resources
* **Mixed ores near start** - mixed ores near the start of the maze provide an early game challenge, while
 making sure you can get your factory started
* **Great for trains** - resources are spread out so you'll soon want trains. The maze is "chunk aligned", ideal
for rail network blueprints
* **Mangroves** - the water at the start of the maze is lined with trees. Turn off normal trees in
 terrain generation if you wish. Mangroves offer wood as an infinite resource, like crude oil, but with new logistical
 challenges and opportunities
* **Terraforming** - Terraform the maze into canals using new recipes which provide a late-game need for
 wood and nuclear-generated steam. Automate the process with special artillery which will explore the maze for you.
 Decide: will you landfill your canals for more space, or exploit the new mangroves that grow along their banks?

## Soft modding

Ribbon Maze is designed to be "softmod" friendly. The core maze and resource generation logic can function
without the mangroves and terraforming prototypes. The mod's control.lua configures the settings, constants, and
events for the default mod experience, but all the logic is in separate scripts in the control directory. So
just providing a different control.lua should allow heavily customized setups, scenarios and soft mods.

## Credits

Terrain graphics for maze adapted from the MIT-license More Floors mod by Tone
(https://mods.factorio.com/mods/Tone/More_Floors).

Thanks also to Factorio staff and forum users for their help and support!