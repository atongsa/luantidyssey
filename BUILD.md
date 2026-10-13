BUILD.md
Read GAME_MODE.md first. This file is only how to continue the build. It is not a second design.

Last session: 2026-10-13. Repo atongsa/luantidyssey, branch main.
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
   The next story stop only: Circe's island. Do not jump ahead.
   The cannibal shore, the bag of winds, the cyclops, and the Greek shore are in. Do not restart them unless the owner asks.
5. Same commit rules: message starts with "code from man_grok", then what, then the time.
6. New idea with no overlap: add it to GAME_MODE.md. Overlap: rewrite that old idea only.
7. Append CHANGES.log when the repo changes. Do not paste the chat into GAME_MODE.md.

--------------------------------------------------------------------------------
CANNIBAL SHORE
--------------------------------------------------------------------------------

mods/ml_shore/init.lua. A quay north of the island, east of the path, around x=6, z=40.
Needs the bag left shut first.
Right-click the outer hull (bronze, further north): hold that ship off. That finishes the stop.
Right-click either beach landing: that ship is smashed and you are sent back to 0, 9, -8. Earlier stops stay done.
Storage: shore (1 = held off), shore_ver.
Win needs lotus + cyclops + winds + shore + suitor wave cleared + hall above 0.
Restart Luanti after pulling so the new mod loads.

--------------------------------------------------------------------------------
LEFT UNFINISHED
--------------------------------------------------------------------------------

Poem stops after the cannibal shore. Next one is Circe's island.
Carved statues and a mesh hero.
A real ContentDB upload.
