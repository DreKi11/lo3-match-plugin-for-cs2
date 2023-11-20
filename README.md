# lo3-match-plugin-for-cs2
5vs5 competitive match plugin written in Lua VScript for Counter-Strike 2.

## How to Install
- Install [Metamod](https://www.sourcemm.net/downloads.php?branch=dev)
- Install [LuaUnlocker](https://github.com/Source2ZE/LuaUnlocker)
- Extract the package contents into `game/csgo` on your server
- Add `exec lo3_matchplugin` to your servers gamemode cfg (e.g. `gamemode_competitive.cfg`)

## How it works
### Warmup phase
- `.lo3` Start a match
- `.pracc` Start a pracc
- `.scramble` Player scramble 3 times
- `.help` Show command help

### Match phase
- `.pause` Pause match
- `.unpause` Unpause match
- `.restart` Restart match (Score to 0)
- `.forceend` Cancel a match

### Pracc phase
- `.restart` Restart pracc (Score to 0)
- `.forceend` Cancel a match

## Credit
[@execut1ve](https://twitter.com/execut1ve)
