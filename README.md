# KyriLib

Modern UI library for Roblox executor scripts. Clean dark theme, smooth animations, built-in config system,
a dynamic island, and one-line Spotify control.

## Installation

```lua
local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()
```

## Roblox Studio

Studio needs a different entry point, not a different call. `loadstring` is off in LocalScripts
and `game:HttpGet` is an executor function, so there is no one-liner that can work there.

Use `studiosource.lua` instead. Paste it into a ModuleScript (ReplicatedStorage is the usual
spot, name it `KyriLib`) and require it:

```lua
local kyri = require(game.ReplicatedStorage.KyriLib)

local w = kyri.new("my hub")
w:tab("Main", "sword"):toggle("fly", false, function(s) end, "fly")
```

Everything past that line is the same. `kyri.studio` is `true` so you can branch if you need to.

[`examples/studio_demo.lua`](examples/studio_demo.lua) is a working demo you can drop into a
LocalScript: real fly, walkspeed and jump, plus one of every element. Teleport destinations are
placeholders, since an empty baseplate has nowhere to go.

### Where everything goes

Three places in the explorer. Only the first is required.

```
ReplicatedStorage
  KyriLib                  ModuleScript   <- paste studiosource.lua in here
ServerScriptService
  KyriStoreServer          Script         <- only for saving, see below
StarterPlayer
  StarterPlayerScripts
    MyHub                  LocalScript    <- your code goes here
```

The ModuleScript has to be somewhere the client can see, which is why it is in
ReplicatedStorage. The LocalScript can live in StarterPlayerScripts or StarterGui, either works.

### Saving, step by step

Nothing persists until you set this up. Skip it and configs still work, they just die when you
stop the playtest.

**1. Turn DataStores on.** Studio cannot touch them otherwise.
**Game Settings > Security > Enable Studio Access to API Services**, then save and restart the
playtest. It is a published-place setting, so the place has to be published first.

**2. Add the bridge.** `DataStoreService` only answers the server and KyriLib runs on the
client, so the two need something in between. Make a **Script** (not a LocalScript, not a
ModuleScript) in ServerScriptService called `KyriStoreServer` and paste
[examples/KyriStoreServer.lua](examples/KyriStoreServer.lua) into it.

It creates a `KyriStore` RemoteFunction and does the reads and writes server side. It checks
what the client sends, since any client can reach a RemoteFunction: strings only, 64 keys,
200KB a value.

**3. Name your store.** Pick anything. Two scripts with different names never see each other's
saves.

```lua
local kyri = require(game.ReplicatedStorage.KyriLib)

local ok, why = kyri.persist("MyHubSaves")
if not ok then warn(why) end
```

Configs, window position and island position load from it on startup, then batch back every 7
seconds and on `BindToClose`. `kyri.flush()` forces a write now.

If a step is missing, `kyri.persist` returns `false` and tells you which one:

| what comes back | what to do |
|-----------------|------------|
| `datastores are off, tick Studio Access to API Services...` | step 1 |
| `no KyriStore RemoteFunction, add examples/KyriStoreServer.lua...` | step 2 |

Running from a server Script instead? Then it talks to `DataStoreService` directly and step 2 is
unnecessary. `kyri.new` is client only though, so that is rare.

### The splash

It tries four things in order and uses the first that actually renders:

1. `Logo`, if you passed one
2. the PNG cached on disk through `getcustomasset`, which only executors have
3. `rbxassetid://88259917092947`, the logo uploaded to Roblox, which works anywhere
4. the KyriLib wordmark drawn as text in Merriweather

Each step checks the image really loaded rather than assuming, so a pending, moderated or deleted
asset falls through instead of leaving a blank frame on screen.

The check uses a 1x1 probe rather than the logo itself, because Roblox does not fetch an image
that is fully transparent, and the logo starts at `ImageTransparency = 1` so it can fade in. Read
`IsLoaded` on the logo directly and it is always `false`, no matter how long you wait.

### What else differs

| | executor | studio |
|-|----------|--------|
| spotify | works | not in the build at all, 735 lines cut |
| tab icons | fetched once, cached | needs `HttpService`, which only answers on the server |
| clipboard | `setclipboard` | `kyri.copybox` shows a selectable box to copy by hand |

Spotify needs `request()`, which no Studio script has, so it is stripped rather than shipped
broken. `kyri.spotify()` still returns a no-op stub and `w:spotify()` says so in a notification,
which means a script written for the executor still runs here without erroring.

Nothing throws. Each of those checks for the function it needs and skips if it is missing.

`studiosource.lua` is generated from `source.lua`, which is the only file anyone edits. A build
step prepends the compatibility shim and inlines the icon pack; the library body is byte-identical
in both, so the two cannot drift apart. Nothing in the Lua sources carries a comment, so the
generated file has no header saying it is generated: treat `studiosource.lua` as output and never
edit it directly.

A Settings tab is built for you about 0.1s after `kyri.new`. `w:create_settings()` returns that
same tab rather than adding a second one, so calling it yourself is safe.

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
| `Island` | bool | `true` is the same as `Mode = "island"` |
| `Remember` | bool | `true`. persist position (and window size) to `KyriLib/window.json` |
| `Shadow` | bool | `false`. set `true` for a drop shadow under the frame |
| `Splash` | bool | `true`. the logo screen |
| `SplashTime` | number | `1.5`. seconds the logo holds before fading |
| `Logo` | string | your own asset id for the splash, tried before the built-in one |

### Window methods

```lua
w:tab(name, icon)               -- create a tab, returns tab object
w:notify(title, text, duration, icon) -- send a notification (click to dismiss)
w:accent(color)                 -- change accent color live
w:apply_theme(overrides)        -- change any theme colors live (partial or full)
w:resetpos()                    -- forget the saved position/size
w:destroy()                     -- destroy the window
```

`kyri.copybox(text, title)` puts text in a focused, pre-selected TextBox so it can be copied by
hand. The Spotify auth tab falls back to it when `setclipboard` is missing.

In island mode you also get `w.expand()`, `w.collapse()` and `w.expanded()`.

The chrome buttons carry tooltips: minimise, close, collapse. Island transport buttons made with
`isl:button(icon, cb, name)` use their `name` as the tooltip, so passing one is worth it.

### Layout modes

```lua
local w = kyri.new("my hub", { Mode = "island" })
local main = w:tab("Main", "sword")
main:toggle("fly", false, function(s) end, "fly")
```

`{ Island = true }` is the same thing if you prefer it.

`window` is the classic layout: a 520x400 frame with a tab sidebar, resizable from the
bottom-right corner. `island` is a `kyri.island`, the same pill the Spotify integration uses,
with the tab strip and pages living in its body, so it collapses to a 230x38 pill and expands
into a 370x430 panel.

Every `w:tab` and element call is identical in both - nothing in your script changes but the
one option. Touch devices default to the island because the sidebar leaves only ~190px of
usable width on a phone; pass `Mode = "window"` to opt back out.

Because island mode *is* an island, `w:spotify()` shares it rather than adding a second pill:

```lua
local w = kyri.new("my hub", { Mode = "island" })
w:tab("Main", "sword"):toggle("fly", false, function(s) end, "fly")
w:spotify()
```

That gives you one pill holding the track, the transport buttons, the seek and volume rows and
your own tabs. The panel grows to fit the extra rows.

### Keeping them separate

All four combinations work. Pick by layout mode and the `island` flag:

```lua
-- window + its own spotify pill, kept apart (the default)
local w = kyri.new("my hub")
w:spotify()

-- window, no pill at all, spotify lives in the tabs
local w = kyri.new("my hub")
w:spotify({ island = false })

-- one pill holding spotify and your tabs
local w = kyri.new("my hub", { Mode = "island" })
w:spotify()

-- a pill for your tabs and a second pill for spotify
local w = kyri.new("my hub", { Mode = "island" })
w:spotify({ island = true })
```

Islands created in the same run stack instead of replacing each other, so the second pill steps
down a row rather than landing on the first. Each remembers its own position - `island.json` is
keyed by `id`, with `"hub"` and `"spotify"` for the two built-in ones.

In island mode `w:resetpos()` clears the island's saved position; in window mode it clears the
window's position and size. Window mode has a close button in the topbar, island mode has one
beside the collapse X - both call `w:destroy()`.

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

A floating pill at the top of the screen that expands into a panel - a dynamic island. It is
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
| `position` | UDim2 | none | absolute position, overrides the top-center anchor |
| `on_seek` | function | none | `fn(pct)` where pct is 0-1 |
| `on_volume` | function | none | `fn(percent)` where percent is 0-100 |
| `on_toggle` | function | none | `fn(expanded)` |
| `remember` | bool | `true` | restore the position you last dragged it to |
| `body_height` | number | none | adds `isl.body`, a fixed-height frame you fill yourself |
| `total_height` | number | none | sizes `isl.body` so the whole open island lands on this height |
| `on_close` | function | none | adds a quit button beside the collapse X |
| `id` | string | `"main"` | which slot in `island.json` holds this island's position |
| `letter` | string | first letter of `title` | shown in the artwork tile when no `icon` or `image` resolves |

**Methods:**
```lua
isl:set(data)                  -- title, subtitle, image, icon, progress, left, right, volume, playing
isl:button(icon, callback)     -- adds a round button to the transport row, returns {icon, tint, setcallback}
isl:row(text)                  -- adds a text row, returns {set}
isl:input(placeholder, cb)     -- search field with songs/lists toggle, returns {show, visible, get, set, focus}
isl:list(max)                  -- replaceable rows of clickable results, returns {set, clear, count}
isl:lyrics()                   -- synced lyric line, returns {line, set, credit, show, visible}
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

The three tabs it builds cover the lot:

- **Now Playing** has artwork, seek, transport, volume, shuffle, repeat, like, and a device list.
  `find devices` lists everything your account has open and clicking one moves playback to it.
- **Search** returns tracks with their album art as the row icon. A `queue instead of play` toggle
  switches what clicking a result does.
- **Auth** is the PKCE flow.

Failures are reported rather than swallowed. A missing device, an expired session, a non-premium
account or a rate limit each produce a readable notification, deduplicated so a stuck control
cannot spam you. The last one is on `sp.last_error`.

### On the island

The island is a full client on its own, not just transport buttons.

- **Search.** The magnifier opens a field with a `songs` / `lists` toggle. Songs show their album
  art and play on click; lists show playlists and play the whole context. Submitting an empty
  query in `lists` mode shows your own playlists.
- **Two windows.** The island carries a button that opens `sp:desktop()`, a client in
  Spotify's own three column shape: a library sidebar that collapses to a rail of covers, a
  centre pane that switches between home, playlist, album, artist and search, a now playing
  panel with an about-the-artist card, and a player bar with seek, volume, shuffle, repeat and
  a device picker. Its player bar carries the lyric button, `sp:cinema()`: the cover with its transport
  laid over it, a vertical volume slider down its edge, and the lyrics beside it at reading
  size. Its toolbar toggles compact mode, swaps the card to the other side, switches to cinema
  view, and opens the queue and the lyric settings. Pass `desktop = false` or `cinema = false`
  to leave either off.

  Each line is laid out one syllable at a time, measured with `TextService:GetTextSize` and
  wrapped by hand, so the highlight sweeps word by word and keeps sweeping correctly across a
  wrapped line rather than restarting. The credits sit after the last line and scroll up with
  it.

  Panels with no Web API behind them are not invented. Featured playlists and the Made For You
  rows were deprecated for new apps in November 2024, so home shows recently played, top tracks
  and top artists instead, and the artist card shows followers and genres, because monthly
  listeners is not exposed.

- **Lyrics.** Three providers are tried in order, and the first one that answers with timings
  wins. An answer without timings is kept aside and only used if nobody else has a synced one.

  | Provider | Key | Sync |
  | --- | --- | --- |
  | [Spicy Lyrics](https://developers.spicylyrics.org) | yes | syllable |
  | [lrc.red](https://lrc.red) | no | syllable |
  | [lrclib.net](https://lrclib.net) | no | line |

  The first two are community run and carry per syllable timing, so the highlight sweeps word by
  word instead of gliding evenly across the whole line. The position is measured with
  `TextService:GetTextSize`, so it lands on real letter boundaries. A line too wide for the pill
  scrolls sideways to keep the syllable being sung about 40 percent across, rather than shrinking
  to nothing. Pass `lyrics = false` to turn the whole thing off.

  Spicy Lyrics needs a key. Create an application at
  [developers.spicylyrics.org](https://developers.spicylyrics.org), then give it to KyriLib
  without putting it in a script you share:

  ```lua
  getgenv().KYRI_SPICY_KEY = "sl_sk_..."
  -- or
  kyri.spotify({spicy_key = "sl_sk_..."})
  ```

  Their terms require attribution, so the island shows it under the line: the provider always,
  plus the uploader and the maker when the sync is a community one. That is read from each
  response rather than hardcoded, because a track answered by a community sync today can be
  answered by Apple Music tomorrow. Click the credit to copy the profile links. Responses are
  held in memory for the session only, which keeps the 30 day cache limit.

  Without a key it falls through to lrc.red, which needs nothing but a User-Agent and still
  gives syllable timing, and then to lrclib, which gives whole lines.

  Timings are sometimes cut against a different master, which reads as the line landing seconds
  early. The lrclib lookup falls back to `/api/search` and takes the closest candidate whose
  duration is within 6 seconds of the track. If one is still off, nudge it:

  ```lua
  sp:nudge(0.5)       -- line was half a second early
  sp.lyric_offset     -- read or set directly, clamped to 15s
  ```

  With `commands = true`, `!sp sync 0.5` does the same from chat and `!sp sync` reports the
  current offset.

  When lrclib has several matches, `!sp lyrics` lists the synced ones with how far each one's
  duration sits from the track, and `!sp lyrics 2` switches to that match. `sp:lyricsalts()` and
  `sp:uselyrics(n)` are the same thing in code.
- **Devices.** A third chip, `on`, lists everything your account has open and moves playback when
  you click one. The window's Now Playing tab has the same list under `find devices`.
- **Autoplay.** Playing a bare track uri gives Spotify no context, so it stops when the track
  ends. Picking a search result now anchors it inside its album, so playback carries on. Set
  `autoplay = false` on `sp` to go back to single tracks.
- `island_results` sets how many rows a search shows, default 5.
- `font` and `font_bold` set the face used for the track name and the lyric lines. Either an
  `Enum.Font` or a `Font` object from `Font.fromName`.

On the typeface: Roblox has no Circular, and Spotify Mix is licensed so it cannot be shipped.
The closest thing Roblox has is Montserrat, which is what the island already draws. `Enum.Font.Gotham*`
resolves to `GothamSSm.json` but renders with Montserrat's exact metrics, identical to the pixel at
14, 24 and 48. The only genuinely different sans worth trying is BuilderSans, which is narrower:

```lua
kyri.spotify({
    font = Font.fromName("BuilderSans", Enum.FontWeight.Medium),
    font_bold = Font.fromName("BuilderSans", Enum.FontWeight.Bold)
})
```

### Island only

Skip the window entirely:

```lua
local sp = kyri.spotify({ tabs = false })
```

There is no Auth tab in that mode, so the island grows its own sign in: two rows that copy the
PKCE url and let you paste the redirect back into the search field. Everything else, search,
playlists, lyrics, devices and transport, works the same.

[`examples/spotify_island.lua`](examples/spotify_island.lua) is the island on its own, two lines of
setup plus a status row, and prints devices, playlists and search counts to the console.

[`examples/spotify_test.lua`](examples/spotify_test.lua) exercises the whole surface: status,
transport, search with artwork, devices and transfer, the island, and a deliberate bad request to
check the error path. `run all` does a pass and prints the results into the tab and the console.

Control real Spotify playback. One call wires up the island, the tabs, the auth flow and the polling
loop - you do not write any of it:

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
| `window` | window | none | build tabs on this window instead of creating one |
| `commands` | bool | `false` | enable `!sp` chat commands |
| `client_id` | string | built-in | use your own Spotify app |
| `on_track` | function | none | `fn(track)` when the track changes |
| `island_y`, `island_width`, `island_position`, `island_hover` | none | - | passed through to the island |

**Connecting** (once per machine - the refresh token is saved to `KyriLib/spotify/tokens.json`):

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
sp:devices()                   -- list of connected devices
sp:transfer(id, play)          -- move playback to a device id
sp:playlists(limit)            -- your playlists
sp:playcontext(uri)            -- play a playlist or album uri
sp:features()                  -- audio features, sets sp.bpm when spotify allows it
sp:desktop()                   -- the full client window, returns {show, hide, toggle, refresh, destroy}
sp:cinema()                    -- the lyric view, returns {show, hide, toggle, mode, side, compact, destroy}
sp:now()                       -- playback position in seconds, interpolated between syncs
sp.stale_scopes                -- true when the saved sign in predates the current scope list
sp.lyric_source                -- pin one provider: "spicy", "lrc.red" or "lrclib"
sp:lyricsalts()                -- other synced lrclib matches, sorted by duration gap
sp:uselyrics(n)                -- switch to one of them
sp.device_id                   -- the device plays are sent to, learned from sync
sp:lyrics()                    -- best of spicy, lrc.red, lrclib
                               -- {synced, plain, provider, credit, words, instrumental} or nil
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
| `Key` | table or string | valid key(s). a single key can be a plain string |
| `Link` | string | adds a `get key` button that copies this link |
| `FileName` | string | filename for saved key (`Once` mode) |

The key box submits on Enter as well as the button, the key is trimmed before comparing, and a
correct key turns the button green for a moment so you can see it took.

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
