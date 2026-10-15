BUILD.md
Read GAME_MODE.md first. This file is only how to continue the build. It is not a second design.

Last session: 2026-10-15. Repo atongsa/luantidyssey, branch main.
The poem through Ithaca is playable. Do not add another story stop unless the owner asks.

--------------------------------------------------------------------------------
THIS PASS
--------------------------------------------------------------------------------

Way posts. Point at the marble post. The infotext names the place.
There is one by the spawn, and one at each stop.
Old worlds place them when voyage_ver is below 2. That runs on load. Restart Luanti after pulling.

Two suitor bands.
Wave 1 starts about 12 seconds after join. Three suitors and a lead. When they are gone, wave is 2.
The carrying ship, south-west, refuses until wave is 2. Then it starts wave 3: four suitors and a lead.
When that band is gone, wave is 4. The hall step works only then.
mods/ml_creeps/init.lua has ml.start_last_wave.
mods/ml_late/init.lua starts that band if a save already took the ship before this change.

--------------------------------------------------------------------------------
LEFT UNFINISHED
--------------------------------------------------------------------------------

The look is still tiles and node boxes, not carved statues.
ContentDB is not submitted.
Do not start those unless the owner asks.
