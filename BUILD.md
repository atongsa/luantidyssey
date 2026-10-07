BUILD.md
Read GAME_MODE.md first. This file is only how to continue the build. It is not a second design.

Last session: 2026-10-07. Repo atongsa/luantidyssey, branch main.
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
   The next story stop only: the cannibal shore. Do not jump ahead.
   Bag of winds, cyclops, and the Greek shore are in. Do not restart them unless the owner asks.
5. Same commit rules: message starts with "code from man_grok", then what, then the time.
6. New idea with no overlap: add it to GAME_MODE.md. Overlap: rewrite that old idea only.
7. Append CHANGES.log when the repo changes. Do not paste the chat into GAME_MODE.md.

--------------------------------------------------------------------------------
BAG OF WINDS
--------------------------------------------------------------------------------

mods/ml_winds/init.lua. Marble pad west of the path, around x=-10, z=14.
Needs the cyclops escape first.
Right-click the sealed bag: leave it shut. That finishes the stop.
Right-click the loose cord, or punch the bag: the winds blow you back to 0, 9, -8. The stop is not done. Lotus and cyclops stay done.
Storage: winds (1 = shut), winds_ver.
Win needs lotus + cyclops + winds + suitor wave cleared + hall above 0.
Restart Luanti after pulling so the new mod loads.

--------------------------------------------------------------------------------
CYCLOPS
--------------------------------------------------------------------------------

mods/ml_cyclops/init.lua. Cave east of the path, around x=10, z=18 to 24.
Wine, stake, mouth. The sword cannot kill him.

--------------------------------------------------------------------------------
LEFT UNFINISHED
--------------------------------------------------------------------------------

Poem stops after the bag of winds. Next one is the cannibal shore.
Carved statues and a mesh hero.
A real ContentDB upload.
