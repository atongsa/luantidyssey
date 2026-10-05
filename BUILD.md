BUILD.md
Read GAME_MODE.md first. This file is only how to continue the build. It is not a second design.

Last session: 2026-10-05. Repo atongsa/luantidyssey, branch main.
The game id and the install folder are luantidyssey. It is not a DotA game.
Not run inside Luanti from the agent side. The owner tests on a laptop or desktop.

The game is a free MIT 3D sandbox RPG on Luanti. Story: Odyssey. The only Warcraft III borrow is the hero's levels and four upgradable skills. Do not build a locked camera. Do not build a strategy game.

--------------------------------------------------------------------------------
START HERE NEXT SESSION
--------------------------------------------------------------------------------

1. Read GAME_MODE.md. If the owner changed an idea, that file wins.
2. Read this file.
3. Do not rebuild the slice. It already runs.
4. Next unfinished work, unless GAME_MODE.md now says otherwise:
   The next story stop only: the bag of winds. Do not jump ahead in the poem list.
   Cyclops and the Greek shore are in. Do not restart them unless the owner asks.
5. Same commit rules: message starts with "code from man_grok", then what, then the time.
6. New idea with no overlap: add it to GAME_MODE.md. Overlap: rewrite that old idea only.
7. Append CHANGES.log when the repo changes. Do not paste the chat into GAME_MODE.md.

--------------------------------------------------------------------------------
CYCLOPS
--------------------------------------------------------------------------------

mods/ml_cyclops/init.lua. Cave east of the path, around x=10, z=18 to 24.
Order: refuse the lotus, right-click the wine bowl while he is near, right-click the stake, right-click the cave mouth.
He chases if awake. Wine dulls him. The stake blinds him. The mouth is the escape.
Punching cannot kill him. At 0 life he stays at 1 and the chat says to use the wine.
Storage: wine, blinded, cyclops (1 = escaped), cave_ver.
Win needs lotus + cyclops escaped + suitor wave cleared + hall above 0.
Restart Luanti after pulling so the new mod loads. The cave places itself when cave_ver is below 1.

--------------------------------------------------------------------------------
GREEK LOOK
--------------------------------------------------------------------------------

mods/ml_map/init.lua. Sea, sand, marble court, stone path, columns, lintels, bronze altar, offerings, olives, lotus.
Spawn is 0, 9, -8. look_ver 2.

--------------------------------------------------------------------------------
WHAT ALREADY RUNS
--------------------------------------------------------------------------------

Player is Odysseus. Slot 1 bronze sword. Slot 2 journal.
Punch the bronze offerings for +5. Right-click the lotus stand to refuse it.
About 12s later: 3 suitors plus 1 lead suitor walk toward the hall.
Commands: /ml  /journal  /skill armor|weapon|fruit|blood  /ml_reset (priv server).

--------------------------------------------------------------------------------
FOUR SKILLS
--------------------------------------------------------------------------------

mods/ml_journal/init.lua and ml.add_xp in mods/ml_core/init.lua.
Ranks 0 to 3. Meta: ml_points, ml_rank_armor, ml_rank_weapon, ml_rank_fruit, ml_rank_blood.
Blood and Bronze voice hit suitors, not the cyclops. That is on purpose.

--------------------------------------------------------------------------------
FILES
--------------------------------------------------------------------------------

mods/ml_core/init.lua       hall, gold, xp, tasks, win/lose
mods/ml_cyclops/init.lua    cave, wine, stake, mouth, the giant
mods/ml_map/init.lua        Greek shore
mods/ml_creeps/init.lua     suitors
mods/ml_journal/init.lua    four skills
mods/ml_heroes/init.lua     bronze sword, respawn at 0,9,-8

--------------------------------------------------------------------------------
LEFT UNFINISHED
--------------------------------------------------------------------------------

Poem stops after the cyclops. Next one is the bag of winds.
Carved statues and a mesh hero.
A real ContentDB upload.
