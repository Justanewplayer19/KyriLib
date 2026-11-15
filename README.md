# KyriLib

Modern UI library for Roblox executor scripts. Clean dark theme, smooth animations, built-in config system,
a dynamic island, and one-line Spotify control.

## Installation

```lua
local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()
```

## Quick Start

```lua
local w = kyri.new("my script", {
    GameName = "MyGame",
    AutoLoad = "default"
})

local main = w:tab("Main", "sword")

main:button("click me", function()
    w:notify("clicked", "button fired", 2)
end)

main:toggle("enable thing", false, function(state)
    print(state)
end, "thing_enabled")

main:slider("walkspeed", 0, 500, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end, "ws")
```

## Documentation

Full docs: [https://justanewplayer19.github.io/KyriLib](https://justanewplayer19.github.io/KyriLib)

## API Reference

### `kyri.new(title, options)`

**Options:**
| key | type | description |
|-----|------|-------------|
| `GameName` | string | used for config file storage |
| `AutoLoad` | string | config name to load on startup |
| `Theme` | table | override any theme colors at init |
| `KeySystem` | `"Once"` / `"Everytime"` | enable key gate before window loads |
| `KeySettings` | table | key system config (see below) |
| `Mode` | `"window"` / `"island"` | layout. defaults to `island` on touch devices, `window` otherwise |
| `Remember` | bool | `true`. persist position (and window size) to `KyriLib/window.json` |
| `Shadow` | bool | `true`. set `false` for no drop shadow at all |

### Window methods

```lua
w:tab(name, icon)               -- create a tab, returns tab object
w:notify(title, text, duration) -- send a notification (click to dismiss)
w:accent(color)                 -- change accent color live
w:apply_theme(overrides)        -- change any theme colors live (partial or full)
w:resetpos()                    -- forget the saved position/size
w:destroy()                     -- destroy the window
```

In island mode you also get `w.expand()`, `w.collapse()` and `w.expanded()`.

### Layout modes

```lua
local w = kyri.new("my hub", { Mode = "island" })
local main = w:tab("Main", "sword")
main:toggle("fly", false, function(s) end, "fly")
```

`window` is the classic layout: a 520x400 frame with a tab sidebar, resizable from the
bottom-right corner. `island` collapses to a pill at the top of the screen that expands into
a 370x430 panel when you click it, with the tabs as a horizontal strip instead of a sidebar.

Every `w:tab` and element call is identical in both — nothing in your script changes but the
one option. Touch devices default to the island because the sidebar leaves only ~190px of
usable width on a phone; pass `Mode = "window"` to opt back out.

Position is remembered between runs, as is the window's size. `w:resetpos()` clears it.

Both layouts have a close button in the topbar, which calls `w:destroy()`.

`kyri.presets` contains built-in themes: `kyri`, `midnight`, `rose`, `forest`, `slate`

```lua
w:apply_theme(kyri.presets["midnight"])
w:apply_theme({ accent = Color3.fromRGB(255, 80, 80) })  -- partial override
```

### Tab icons

Uses the [LucideBlox](https://github.com/frappedevs/lucideblox) icon pack, 1,000+ Lucide icons available by name, or pass a raw asset id:

```lua
w:tab("Main", "sword")                          -- lucide icon name
w:tab("Players", "users")
w:tab("Combat", "crosshair")
w:tab("Settings", "settings-2")
w:tab("Custom", "rbxassetid://7734053495")      -- raw asset id
```

Some useful names: `sword`, `axe`, `skull`, `flame`, `shield`, `crosshair`, `target`, `eye`, `ghost`, `users`, `user`, `user-plus`, `crown`, `star`, `heart`, `bolt`, `zap`, `settings`, `settings-2`, `sliders`, `wrench`, `key`, `lock`, `unlock`, `map-pin`, `compass`, `navigation`, `home`, `search`, `filter`, `list`, `grid`, `layout-dashboard`, `music`, `volume-2`, `mic`, `wifi`, `bluetooth`, `monitor`, `smartphone`, `camera`, `video`, `image`, `file`, `folder`, `download`, `upload`, `save`, `trash`, `edit`, `copy`, `share`, `send`, `mail`, `bell`, `clock`, `calendar`, `info`, `alert-triangle`, `check`, `x`, `plus`, `minus`, `arrow-right`, `chevron-down`

Full list at [lucide.dev/icons](https://lucide.dev/icons). Use the icon name as-is (e.g. `"arrow-up-right"`, `"battery-charging"`).

Icons are not bundled in `source.lua`. They live in [`icons.json`](icons.json) and are fetched on the
first icon lookup, then cached to `KyriLib/icons.json` so later runs read from disk.

```lua
getgenv().kyri_icon_source = "https://.../my-icons.json"   -- set BEFORE loading the lib
local kyri = loadstring(game:HttpGet(".../source.lua"))()

kyri.reload_icons()    -- drop the cache and re-fetch
```

The pack is loaded once while the library loads, not on first lookup: `HttpGet` yields, and yielding
inside an `__index` metamethod throws, so a lazy proxy cannot work here. If the fetch fails,
`kyri.icons` is empty and elements fall back to a default glyph instead of erroring.

### Elements

**Button**
```lua
tab:button(text, callback)
```

**Toggle**
```lua
tab:toggle(text, default, callback, flag)
```

**Slider**: drag the track, or click the value label to type a number directly
```lua
tab:slider(text, min, max, default, callback, flag, step)
-- step is optional (e.g. 0.1 for one decimal place)
```

**Input**
```lua
tab:input(text, placeholder, callback, flag)
```

**Dropdown**: searchable
```lua
tab:dropdown(text, options, default, callback, flag)
```

**Multiselect**
```lua
tab:multiselect(text, options, default, callback, flag)
```

**Color Picker**
```lua
tab:colorpicker(text, default, callback, flag)
```

**Keybind**
```lua
tab:keybind(text, default, hold_to_interact, callback, flag)
```

**Progress Bar**
```lua
local pb = tab:progressbar(text, max)
pb:set(value, animated)
```

**Image**
```lua
tab:image(asset_id, height)
```

**Layout helpers**
```lua
tab:section(text)
tab:label(text)
tab:paragraph(title, body)
tab:space(height)   -- height defaults to 8
tab:search(placeholder) -- filter box, hides elements on this tab that don't match
```

### Island

A floating pill at the top of the screen that expands into a panel — a dynamic island. It is
standalone: it works with or without a window.

```lua
local isl = kyri.island({
    title = "my script",
    subtitle = "idle",
    icon = "zap"
})

isl:button("play", function() print("hi") end)
isl:set({ title = "running", subtitle = "3 targets", progress = 0.5 })
isl:notify("saved", 2)
```

**Options:**
| key | type | default | description |
|-----|------|---------|-------------|
| `title` | string | `"kyri"` | collapsed + expanded title |
| `subtitle` | string | `""` | second line, expanded only |
| `icon` | string | `"music"` | fallback glyph when there is no `image` |
| `image` | string | `""` | asset id shown as artwork |
| `width` / `height` | number | `230` / `38` | collapsed pill size |
| `expanded_width` | number | `330` | width when open |
| `bars` | bool | `true` | animated EQ bars while `playing` |
| `seek` | bool | `true` | seek bar + elapsed/duration row |
| `volume` | bool | `true` | volume row |
| `draggable` | bool | `true` | drag to reposition (a tap under 6px still opens it) |
| `hover` | bool | `false` | expand on hover instead of only on tap |
| `y` | number | `10` | offset from the top |
| `position` | UDim2 | — | absolute position, overrides the top-center anchor |
| `on_seek` | function | — | `fn(pct)` where pct is 0-1 |
| `on_volume` | function | — | `fn(percent)` where percent is 0-100 |
| `on_toggle` | function | — | `fn(expanded)` |
| `remember` | bool | `true` | restore the position you last dragged it to |

**Methods:**
```lua
isl:set(data)                  -- title, subtitle, image, icon, progress, left, right, volume, playing
isl:button(icon, callback)     -- adds a round button to the transport row, returns {icon, tint, setcallback}
isl:row(text)                  -- adds a text row, returns {set}
isl:notify(text, duration)     -- morph the pill to show a message, then revert
isl:expand() / isl:collapse() / isl:toggle()
isl:relayout()                 -- re-measure after adding rows
isl:visible(bool)
isl:resetpos()                 -- forget the dragged position, back to top-center
isl:destroy()
```

`isl:set` ignores `progress` while the user is dragging the seek bar, so polling loops will not fight
the drag. From a window, `w:island(opts)` does the same thing and inherits the window title.

### Spotify

Control real Spotify playback. One call wires up the island, the tabs, the auth flow and the polling
loop — you do not write any of it:

```lua
kyri.spotify()
```

Or attach it to a window you already have:

```lua
local w = kyri.new("my hub")
local sp = w:spotify({ commands = true })
```

**Options:**
| key | type | default | description |
|-----|------|---------|-------------|
| `island` | bool | `true` | show the island with transport controls |
| `tabs` | bool | `true` | build Now Playing / Search / Auth tabs |
| `window` | window | — | build tabs on this window instead of creating one |
| `commands` | bool | `false` | enable `!sp` chat commands |
| `client_id` | string | built-in | use your own Spotify app |
| `on_track` | function | — | `fn(track)` when the track changes |
| `island_y`, `island_width`, `island_position`, `island_hover` | — | — | passed through to the island |

**Connecting** (once per machine — the refresh token is saved to `KyriLib/spotify/tokens.json`):

1. open the **Auth** tab, click *copy auth url*
2. paste it in a browser and approve
3. the callback page fails to load, which is expected
4. copy the whole url from the address bar
5. paste it in the input and hit submit

Auth uses the Authorization Code + PKCE flow, so there is no client secret in the script. The code
verifier is generated locally, SHA-256'd and sent as a challenge.

**Methods:**
```lua
sp:play() / sp:pause() / sp:toggle()
sp:next() / sp:prev()
sp:seek(pct)              -- 0-1
sp:volume(percent)        -- 0-100
sp:setshuffle(bool)
sp:setloop(mode)          -- "off" / "context" / "track", or nil to cycle; returns ok, mode
sp:like()                 -- save the current track
sp:search(query, limit)   -- returns a list of track objects
sp:playuri(uri) / sp:queue(uri)
sp:devices()
sp:sync()                 -- force a refresh now
sp:authed()
sp:artists()              -- current track artists as a string
sp:destroy()
```

Readable state: `sp.playing`, `sp.pos`, `sp.dur`, `sp.vol`, `sp.shuffle`, `sp.loop`, `sp.track`,
`sp.results`, `sp.island`, `sp.window`. `sp.request(method, endpoint, body)` hits any Web API endpoint
with auth and refresh already handled.

**Chat commands** (`commands = true`): `!sp play`, `pause`, `skip`, `back`, `current`, `like`,
`search [query]`, `pick [n]`, `volume [0-100]`, `loop [mode]`, `shuffle [on/off]`, `help`

Requires an executor with `request`/`http_request`, `writefile` and `getcustomasset` (for album art).

### Config

Elements with a `flag` string automatically participate in the config system. A Settings tab is auto-created with save/load UI and a full theme editor (preset dropdown + per-property color pickers).

```lua
-- read a value
local val = w.flags.ws

-- set a value programmatically
w.flags.ws_set(100, true)   -- second arg fires callback
```

### Key System

Gate your script behind a key. Set `KeySystem` on the window options:

```lua
local w = kyri.new("my script", {
    GameName = "MyGame",
    KeySystem = "Once",   -- "Once" or "Everytime"
    KeySettings = {
        Title    = "My Script",
        Subtitle = "Enter your key to continue",
        Note     = "Get a key from the discord",
        Creator  = "yourname",
        Key      = { "MY-KEY-ABC", "SECOND-KEY" },
        FileName = "MyScript"
    }
})

if not w then return end  -- user closed dialog without a valid key
```

**`KeySystem` modes:**
| value | behaviour |
|-------|-----------|
| `"Once"` | saves the accepted key to disk. dialog is skipped on future runs. if the owner changes the key list, the saved key becomes invalid and the dialog shows again |
| `"Everytime"` | always shows the dialog, never saves |

**`KeySettings` fields:**
| key | type | description |
|-----|------|-------------|
| `Title` | string | dialog title |
| `Subtitle` | string | dialog subtitle |
| `Note` | string | text shown on right side of dialog |
| `Creator` | string | shown on success splash as "by Creator" |
| `Key` | table | list of valid key strings |
| `FileName` | string | filename for saved key (`Once` mode) |

If the user closes the dialog without entering a valid key, `kyri.new` returns `nil`. Always guard your code:

```lua
if not w then return end
```

### Randomised names

Every ScreenGui the library creates gets a random name per run, as does the mobile toggle
action. Stale instances from a previous execute are found by a `kyri` attribute rather than a
fixed name, so nothing has to scan PlayerGui for `"Kyri"`.

### Toggle visibility

Press `RightControl` to show/hide the window.

## Example

```lua
local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()

local w = kyri.new("prison life", {
    GameName = "PrisonLife",
    AutoLoad = "default"
})

local main = w:tab("Main", "sword")

main:section("movement")

main:toggle("fly", false, function(state)
    w:notify("fly", state and "on" or "off", 2)
end, "fly")

main:slider("walkspeed", 16, 500, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end, "ws")

main:slider("jump power", 50, 500, 50, function(val)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
end, "jp")

main:dropdown("teleport", {"spawn", "prison", "criminal base"}, "spawn", function(val)
    w:notify("teleport", "going to " .. val, 2)
end)
```

## License

MIT
