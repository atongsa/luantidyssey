# Game mode

This file is the idea and the coding direction. It is not a chat log. Do not paste conversations into it.

Keep every idea. Add a new idea as its own line or section when it does not overlap an old one. If a new idea overlaps an old one (same topic, a change, or a contradiction), update that old idea in place. Do not keep two versions of the same idea.

## Agents

Read this file before you code. Then read `BUILD.md` for where the code stopped. Code follows this file, not an older chat.

- Keep ideas that still stand.
- Overlap: rewrite the old idea. The new wording is the one to code.
- No overlap: add the idea. Do not delete unrelated ideas to "clean up."
- Do not record ideas here as chat. `CHANGES.log` is only for repo changes.
- If this file and another file disagree about the game, this file wins. If you are unsure what the current idea is, ask. Do not invent a direction.
- Do not write code until the owner says **grok code it**, unless that message already tells you to build.
- Commit messages start with `code from man_grok`, then what changed, then the date and time.

How to run or zip the game is `PACKAGING.log`.

## What this game is

A free 3D sandbox RPG that runs as a game inside [Luanti](https://www.luanti.org/). The name is **luantidyssey**. Install it on a laptop or a desktop and play it in Luanti's own 3D world. License is MIT.

The story is Homer's *Odyssey*. Odysseus is the hero. The look is Greek: stone, bronze, sea. Do not copy a film's costumes or another game's units.

The only borrow from Warcraft III is the hero: he levels, and he has four skills he spends points to learn and upgrade. Nothing else is taken from that game. No locked isometric camera. No real-time strategy port. No races, maps, UI, or unit names from it.

You walk the voyage in the 3D world, fight, finish the poem's tasks, and keep the hall at Ithaca standing. That is the RPG. Digging the ground is not how you win.

Not this:

- not a DotA game, and not a lane MOBA
- not a separate engine or a flat 2D game
- not a locked isometric camera, and not a project that tries to build one
- not a Warcraft III clone, and not a base-building strategy game
- not World of Warcraft
- not "win by digging the world away"
- not a new plot in place of the poem

## Story

Odysseus is trying to get home to Ithaca after the war. The hall must still be standing when he arrives.

Use the poem's order. Do not paste a copyrighted translation into the repo. The poem is ancient and public domain. A modern printed translation is not. Write our own short task text.

- The hero is Odysseus.
- Home is his hall on Ithaca.
- The opposing force is the suitors wearing the house down.
- Telemachus can exist as an ally already at the hall. Penelope is why the hall must not fall. Neither is a second player-hero in the first slice.

Tasks, in poem order:

1. Leave Troy's shore. The fleet is the start, not a base you keep.
2. The lotus-eaters. Refuse the easy stop and move on.
3. The cyclops. A camp fight, then escape, not a fair duel.
4. The bag of winds. You can fail by opening the wrong thing. Failure sends you back.
5. The cannibal shore. Do not land what you cannot hold.
6. Circe's island. Companions are turned aside until the hero undoes it.
7. The land of the dead. Speak to the dead and learn the way home. No new plot.
8. The sirens. Pass a point without stopping.
9. Scylla and Charybdis. The path costs something even if you play well.
10. The cattle of the sun. Do not touch them. Breaking the rule is a loss.
11. Calypso's island. A long hold. The task is to leave.
12. The Phaeacians. They carry him home. This unlocks Ithaca.
13. Ithaca. The hall is under siege by the suitors. Defend it, then end the journey in the hall.

The voyage is a chain of tasks in the 3D world. Later stops must follow this list. The first playable slice does not need all 13.

## Hero skills

Odysseus has four skills. No fifth. A skill point learns one or raises it. Highest rank is 3. One point per level, spent on a skill. This is the only Warcraft III pattern in the game.

You start with one point. Each level (10 experience) gives another point. Kills and finished tasks give experience.

| Slot | Skill | Ranks |
| --- | --- | --- |
| armor | Bronze voice | Stun lasts longer. Hits you take get smaller. |
| weapon | Brand | Punches hit harder, and the buff lasts longer. |
| fruit | Bitter fruit | Heals more, and pays a little more gold. |
| blood | Cut the vein | The cut is deeper, so a hurt enemy dies more easily. |

Open the journal and press Learn or Upgrade. Cast with Cast, or `/skill armor`, `/skill weapon`, `/skill fruit`, `/skill blood`. Names stay original.

## How a playthrough goes

- You are Odysseus in the Luanti world. Normal 3D movement. Third person is the player's own key (F7). Do not build a special camera.
- You gain experience, levels, and spend points on the four skills.
- The hall at Ithaca is home. Suitors pressure it. If it falls, the journey is lost.
- Tasks follow the story list. They pay gold or experience, or they open the next stop.
- The journey ends when the last task in the hall is done, or earlier if the hall falls.

Workers, a build menu, and towers are not the game. They are not scheduled. Gold stones stand in for gathering until something simpler is needed.

## Built now

- Greek shore: sea, sand, marble court, columns, bronze altar, offerings, olives, lotus stand
- the player is Odysseus, with a bronze sword, gold, experience, a text HUD, and the journal in slot 2
- four skills, each rank 0 to 3, one point to learn or upgrade
- one wave: three suitors plus one lead suitor
- cyclops cave east of the path. Wine, then the stake, then the mouth. The sword cannot kill him.
- bag of winds west of the path. Right-click the sealed bag and leave it shut. The loose cord, or a punch on the bag, blows you back to the shore.
- win if the lotus is refused, the cave is escaped, the bag stays shut, the suitors are dead, and the hall is above 0
- lose if the hall reaches 0
- `/ml` prints status. `/ml_reset` (server privilege) resets the slice and gives one skill point

The cannibal shore is next and is not built.

Not built: stops after the bag of winds, carved statues. Not wanted: a locked camera, a strategy base, a second player, a DotA match.

## Repository map

| Path | Role |
| --- | --- |
| `GAME_MODE.md` | All current ideas. Add new ones. Update an old one only when a new idea overlaps it. Not a chat log. |
| `BUILD.md` | Where the code stopped, and what to do next. |
| `CHANGES.log` | Repo changes only. Append. Not an idea diary. |
| `PACKAGING.log` | Local test and zip layout. |
| `LICENSE` | MIT. This game is open source. |
| `ml_core` | Hall life, gold, experience, levels, skill points, win and loss |
| `ml_journal` | The four skills and their ranks |
| `ml_camera` | A one-time look tilt. Not a special camera. Leave it. |
| `ml_map` | Greek shore |
| `ml_cyclops` | Cave, wine, stake, mouth, the giant |
| `ml_winds` | Sealed bag and the loose cord |
| `ml_creeps` | Three suitors and one lead suitor |
| `ml_heroes` | The player as Odysseus, plus a sword. `heroes/hero_example.lua` is not loaded |
| `ml_items` | One voyage token when the lotus is refused |
| `ml_ui` | Text HUD: gold, level, hall, task, skill ranks |

## One journey

1. The hero starts on the shore after the war. The hall on Ithaca already exists and is already under pressure.
2. One skill point is waiting. Spend it on one of the four skills.
3. The hero refuses the lotus, escapes the cyclops cave, then leaves the bag of winds shut. Later stops are not built.
4. Suitors walk an authored path toward the hall.
5. Each level gives one more skill point.
6. The journey ends when those stops are done and the hall still stands, or earlier if the hall falls.

Numbers that are not written here get decided when that system is built, then written into this file in place of this sentence.

## Content rules

- Invent building names and ability names. Do not reuse names from commercial games.
- Poem names stay poem names: Odysseus, Ithaca, Penelope, Telemachus, and the stops listed above.
- Each new task is data on the map: where, which poem beat, reward, next stop.
- The game is MIT so it can be published where Luanti requires a free license, and so it can be installed from a copy on a laptop or a desktop.
- The install folder and `game.conf` name are `luantidyssey`.

## Copyright and publishing

Code copyright (C) 2026 atongsa, under the MIT license. See `LICENSE` and `README.md`.

The story outline follows Homer's *Odyssey*, which is in the public domain. Do not copy a modern translation into this repository.

Luanti's own program is GNU LGPL v2.1. That is the engine, not this game.

Publishing on ContentDB is allowed only while this MIT grant stays in place. Local install is in `PACKAGING.log`: copy the folder into Luanti's `games` directory as `luantidyssey` and make a new world.
