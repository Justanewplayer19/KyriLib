# KyriLib

Modern UI library for Roblox executor scripts. Clean dark theme, smooth animations, built-in config system.

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

### Window methods

```lua
w:tab(name, icon)               -- create a tab, returns tab object
w:notify(title, text, duration) -- send a notification (click to dismiss)
w:accent(color)                 -- change accent color live
w:apply_theme(overrides)        -- change any theme colors live (partial or full)
w:destroy()                     -- destroy the window
```

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
```

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
