local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()

local svc = {}
local gs = cloneref or function(o) return o end
local function call(n)
    return gs(game:GetService(n))
end

svc.plr = call("Players")

local w = kyri.new("spotify test", {GameName = "SpotifyTest"})
local sp = w:spotify({commands = true})
local isl = sp.island

local t = w:tab("Tests", "flask-conical")

t:section("state")

local out = t:label("press run all")
local log = {}

local function say(line)
    log[#log + 1] = line
    while #log > 8 do table.remove(log, 1) end
    out:set(table.concat(log, "\n"))
    print("[sp] " .. line)
end

local function mark(name, ok)
    say(string.format("%-14s %s%s", name, ok and "pass" or "FAIL",
        (not ok and sp.last_error) and ("  " .. sp.last_error) or ""))
    return ok
end

t:button("status", function()
    say("authed      " .. tostring(sp:authed()))
    say("ready       " .. tostring(sp.ready))
    say("playing     " .. tostring(sp.playing))
    say("track       " .. tostring(sp.track and sp.track.name or "none"))
    say("artists     " .. (sp:artists() ~= "" and sp:artists() or "none"))
    say("position    " .. tostring(sp.pos) .. " / " .. tostring(sp.dur))
    say("volume      " .. tostring(sp.vol))
    say("last error  " .. tostring(sp.last_error or "none"))
end, "activity")

t:button("force a sync", function()
    sp:sync()
    task.wait(0.4)
    say("after sync  " .. tostring(sp.track and sp.track.name or "nothing playing"))
end, "wifi")

t:section("transport")

t:button("play", function() mark("play", sp:play()) end, "play")
t:button("pause", function() mark("pause", sp:pause()) end, "pause")
t:button("next", function() mark("next", sp:next()) end, "skip-forward")
t:button("previous", function() mark("previous", sp:prev()) end, "skip-back")
t:button("like current", function() mark("like", sp:like()) end, "heart")

t:button("shuffle on then off", function()
    mark("shuffle on", sp:setshuffle(true))
    task.wait(0.5)
    mark("shuffle off", sp:setshuffle(false))
end, "shuffle")

t:button("cycle repeat", function()
    local ok, mode = sp:setloop()
    mark("repeat " .. tostring(mode), ok)
end, "repeat")

t:slider("volume", 0, 100, 60, function(v)
    sp:volume(v)
end, "sp_test_vol", 5)

t:slider("seek percent", 0, 100, 0, function(v)
    sp:seek(v / 100)
end, "sp_test_seek", 5)

t:section("search")

local last_uri

t:input("query", "bohemian rhapsody", function(q)
    local items = sp:search(q, 5)
    say("results     " .. #items)
    if #items == 0 then
        say("no results, or not authed")
        return
    end
    for i, tr in pairs(items) do
        local a = {}
        for j, v in pairs(tr.artists or {}) do a[#a + 1] = v.name end
        local cover = tr.album and tr.album.images and #tr.album.images > 0
        say(i .. ". " .. tr.name .. " - " .. table.concat(a, ", ") .. (cover and "  [art]" or "  [no art]"))
        last_uri = last_uri or tr.uri
    end
end, "sp_test_q")

t:button("play first result", function()
    if not last_uri then
        say("search something first")
        return
    end
    mark("playuri", sp:playuri(last_uri))
end, "play")

t:button("queue first result", function()
    if not last_uri then
        say("search something first")
        return
    end
    mark("queue", sp:queue(last_uri))
end, "list")

t:section("playlists and lyrics")

local last_ctx

t:button("my playlists", function()
    local mine = sp:playlists(10)
    say("playlists   " .. #mine)
    for i, pl in pairs(mine) do
        say(i .. ". " .. pl.name .. "  " .. tostring(pl.tracks and pl.tracks.total or "?") .. " tracks")
        last_ctx = last_ctx or pl.uri
    end
    if #mine == 0 then say("none, or not authed") end
end, "library")

t:button("search playlists", function()
    local lists = sp:search("chill", 5, "playlist")
    say("found       " .. #lists)
    for i, pl in pairs(lists) do
        local art = pl.images and #pl.images > 0
        say(i .. ". " .. pl.name .. (art and "  [art]" or "  [no art]"))
        last_ctx = last_ctx or pl.uri
    end
end, "search")

t:button("play first playlist", function()
    if not last_ctx then
        say("list playlists first")
        return
    end
    mark("playcontext", sp:playcontext(last_ctx))
end, "play")

t:button("lyrics for current", function()
    local got = sp:lyrics()
    if not got then
        say("lyrics      none on lrclib")
        return
    end
    if got.instrumental then say("lyrics      instrumental") end
    say("synced      " .. (got.synced and (#got.synced .. " lines") or "no"))
    say("plain       " .. (got.plain and "yes" or "no"))
    if got.synced then
        for i = 1, math.min(3, #got.synced) do
            local l = got.synced[i]
            say(string.format("  %6.2fs  %s", l.t, l.text))
        end
    end
end, "activity")

t:section("devices")

local devs = {}

t:button("list devices", function()
    devs = sp:devices()
    say("devices     " .. #devs)
    for i, d in pairs(devs) do
        say(i .. ". " .. d.name .. "  " .. d.type .. (d.is_active and "  active" or ""))
    end
    if #devs == 0 then say("open spotify somewhere first") end
end, "monitor")

t:button("move to another device", function()
    if #devs == 0 then
        say("list devices first")
        return
    end
    local target
    for i, d in pairs(devs) do
        if not d.is_active then target = d end
    end
    if not target then
        say("only one device, nothing to move to")
        return
    end
    mark("transfer", sp:transfer(target.id))
    say("moved to    " .. target.name)
end, "monitor")

t:section("island")

t:button("notify on the island", function()
    if not isl then
        say("no island, it was passed island = false")
        return
    end
    isl:notify("test message", 3)
    say("island notify sent")
end, "bell")

t:button("expand then collapse", function()
    if not isl then return end
    isl:expand()
    task.wait(1.2)
    isl:collapse()
    say("island toggled")
end, "monitor")

t:section("errors")

t:button("hit a bad endpoint", function()
    local r = sp.request("GET", "/me/player/does-not-exist")
    say("status      " .. tostring(r and r.StatusCode or "nil"))
    say("expect a 404 notification and last_error to be set")
end, "bug")

t:button("run all", function()
    log = {}
    say("running")
    say("authed      " .. tostring(sp:authed()))
    if not sp:authed() then
        say("not connected, use the Auth tab first")
        w:notify("spotify test", "connect on the auth tab, then run again", 5, "alert-triangle")
        return
    end

    sp:sync()
    task.wait(0.5)
    say("track       " .. tostring(sp.track and sp.track.name or "nothing playing"))

    devs = sp:devices()
    say("devices     " .. #devs)

    local items = sp:search("daft punk", 3)
    say("search      " .. #items .. " results")
    if items[1] then last_uri = items[1].uri end

    local mine = sp:playlists(5)
    say("playlists   " .. #mine)

    local got = sp:lyrics()
    say("lyrics      " .. (got and (got.synced and "synced" or (got.plain and "plain only" or "none")) or "none"))

    mark("play", sp:play())
    task.wait(0.6)
    mark("pause", sp:pause())

    say("done, check last error above")
end, "flask-conical")

w:notify("spotify test", sp:authed() and "connected, press run all" or "connect on the auth tab first", 6, "flask-conical")
