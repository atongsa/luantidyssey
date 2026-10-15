# Install luantidyssey

This is a game for [Luanti](https://www.luanti.org/), not a program you double-click by itself. You install Luanti, put this folder in Luanti's `games` directory, and start a new world.

You need Luanti 5.6 or newer. The game is MIT. It is not on ContentDB yet, so use the zip or git below.

## 1. Install Luanti

Download it from [luanti.org](https://www.luanti.org/downloads/).

Open it once. Go to the **About** tab (older builds say **Credits**) and click **Open user data directory**. Leave that folder open. You will put the game inside `games` there.

If that button is missing, the folder is usually one of these:

| System | Folder |
| --- | --- |
| Linux | `~/.local/share/luanti/games` or `~/.minetest/games` |
| Windows | `%APPDATA%\Luanti\games` or `%APPDATA%\Minetest\games` |
| macOS | `~/Library/Application Support/luanti/games` or `~/Library/Application Support/minetest/games` |

Create `games` if it is not there.

## 2. Get the game

**Zip.** Download:

[https://github.com/atongsa/luantidyssey/archive/refs/heads/main.zip](https://github.com/atongsa/luantidyssey/archive/refs/heads/main.zip)

Unzip it. The folder inside is named `luantidyssey-main`. Rename that folder to `luantidyssey`.

**Git**, if you already use it. From inside the `games` folder:

```bash
git clone https://github.com/atongsa/luantidyssey.git luantidyssey
```

The result must look like this. `game.conf` is directly inside the game folder, not buried another level down:

```text
games/luantidyssey/game.conf
games/luantidyssey/mods/ml_core/init.lua
games/luantidyssey/mods/ml_voyage/init.lua
```

Wrong: `games/luantidyssey/luantidyssey/game.conf`.

If you still have an old folder named `luanti_dotA`, remove it or replace it. Worlds made under that name will not load this game. Make a new world.

## 3. Start a world

Close Luanti if it was open, then start it again so it sees the new folder.

1. **Start Game**, then **New**.
2. Game: **luantidyssey**. If it is not in the list, the folder is in the wrong place. Check step 2.
3. Any world name. Leave the mapgen dropdown alone. This game builds its own shore.
4. Create, then play.

Do not open a world from another game.

## 4. Check that it loaded

You stand on a marble court by the sea. A journal opens. Spend the one skill point.

A marble post stands near you. Point at it. The words name the next place. The line at the top of the screen is the current task. Type `/ml` if you want gold, hall life, and that task in chat.

Slot 1 is a sword. Slot 2 is the journal. Punch with the journal, or type `/journal`, to open it again. F7 twice is Luanti's own third-person key.

About 12 seconds in, the first suitors walk the path toward the hall. Clear them before you take the carrying ship later. That ship starts a last band. The hall step, south of the altar, ends the voyage only after that last band is gone and the hall is still standing.

If the ground is missing, or you fall, delete that world and make a new one with the game set to luantidyssey.

## Package it yourself

From the folder that contains `luantidyssey` (the parent, not inside the game):

```bash
zip -r luantidyssey.zip luantidyssey -x '*.git*'
```

The zip must open to one folder, with `game.conf` one level under it:

```text
luantidyssey/game.conf
luantidyssey/mods/ml_core/init.lua
```

Not `game.conf` alone at the top of the zip.

Give someone that zip, or the GitHub link in step 2. They follow this page. Luanti does not turn a game into its own `.exe`. The engine stays Luanti. This game stays a folder inside `games`.

ContentDB is the in-game browser at [content.luanti.org](https://content.luanti.org/). This game is not submitted there. The MIT license in `LICENSE` is what a later upload needs.
