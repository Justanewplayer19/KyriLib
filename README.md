# KyriLib

Modern UI library for Roblox scripts with a clean interface, smooth animations, and built-in config system.

## Features

- Modern, clean interface with smooth animations
- Built-in save/load config system
- Custom notifications with fade animations
- Rich elements: buttons, toggles, sliders, inputs, dropdowns
- Customizable themes
- Optional Lucide icons for tabs
- Draggable and resizable windows

## Installation

```lua
local KyriLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()
```

## Quick Start

```lua
-- Create window
local window = KyriLib.new("My Script", {
    GameName = "MyGame"
})

-- Create tab
local main = window:tab("Main")

-- Add elements
main:button("Click Me", function()
    print("clicked!")
end)

main:toggle("Enable Feature", false, function(state)
    print("toggled:", state)
end, "feature_flag")

main:slider("Speed", 16, 200, 16, function(value)
    print("speed:", value)
end, "speed_flag")

-- Send notification
window:notify("Title", "Message", 3)
```

## Documentation

Full documentation available at: [https://justanewplayer19.github.io/KyriLib](https://justanewplayer19.github.io/KyriLib)

## API Reference

### Window

```lua
KyriLib.new(title, options)
```

**Options:**
- `GameName` - Name for config storage
- `Theme` - Custom color theme

**Example with custom theme:**
```lua
local window = KyriLib.new("My Script", {
    GameName = "MyGame",
    Theme = {
        bg = Color3.fromRGB(10, 10, 15),
        accent = Color3.fromRGB(255, 100, 100)
    }
})
```

### Tabs

```lua
window:tab(name, icon)
```

**Example:**
```lua
local main = window:tab("Main", "home")
local settings = window:tab("Settings", "settings")
```

### Elements

**Button**
```lua
tab:button(text, callback)
```

**Toggle**
```lua
tab:toggle(text, default, callback, flag)
```

**Slider**
```lua
tab:slider(text, min, max, default, callback, flag)
```

**Input**
```lua
tab:input(text, placeholder, callback, flag)
```

**Dropdown**
```lua
tab:dropdown(text, options, default, callback)
```

**Label**
```lua
tab:label(text)
```

### Notifications

```lua
window:notify(title, text, duration)
```

### Config System

Settings with flags automatically save. Access them:

```lua
-- Get value
local speed = window.flags.speed_flag

-- Set value
window.flags.feature_flag_set(true, true)
```

## Example Script

```lua
local KyriLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()

local window = KyriLib.new("prison life", {
    GameName = "PrisonLife"
})

local main = window:tab("Main", "home")

main:label("movement")

main:toggle("fly", false, function(state)
    if state then
        window:notify("Movement", "Fly enabled", 2)
    else
        window:notify("Movement", "Fly disabled", 2)
    end
end, "fly_toggle")

main:slider("walkspeed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end, "walkspeed")

main:dropdown("teleport to", {"spawn", "prison", "criminal base"}, "spawn", function(value)
    window:notify("Teleport", "Teleported to " .. value, 2)
end)

window:accent(Color3.fromRGB(138, 116, 249))
```

## License

MIT License - feel free to use in your projects

## Credits

Made with ❤️ for the Roblox scripting community
