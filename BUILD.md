BUILD.md
Read GAME_MODE.md first. This file is only how to continue the build. It is not a second design.

Last session: 2026-10-13. Repo atongsa/luantidyssey, branch main.
The game id and the install folder are luantidyssey. It is not a DotA game.
Not run inside Luanti from the agent side. The owner tests on a laptop or desktop.

The poem through Ithaca is playable. Do not add another story stop unless the owner asks.
A daily job may look. If this file still says the poem is playable, that job should report progress and not change the repo.

--------------------------------------------------------------------------------
VOYAGE
--------------------------------------------------------------------------------

mods/ml_voyage/init.lua. Loads after the shore and replaces ml.task_line and ml.check_end.
You no longer win at the cannibal shore. You win only after the hall step, with the suitors dead and the hall above 0.

Order after the shore:
1. Circe, west of the hall. Herb, then both companions. The cup sends you back.
2. The dead, west of the spawn. One right-click.
3. Singers, east of the hall. Right-click the pass. The rock sends you back.
4. Cliff, east of the spawn. Costs 20 hall life. The whirlpool sends you back.
5. Cattle, north-west. Sail past. Touching them loses the voyage.
6. Long hold, north-east. Start it, wait about 25 seconds, then the raft.
7. Carriers, south-west. Their ship.
8. Hall step, south of the altar. Suitors must already be dead.

Restart Luanti after pulling so ml_voyage loads. /ml_reset must also clear the new flags. Those clears are in ml_core.

--------------------------------------------------------------------------------
LEFT UNFINISHED
--------------------------------------------------------------------------------

The look is still tiles and node boxes, not carved statues.
One suitor wave only.
ContentDB is not submitted.
Do not start those unless the owner asks.
