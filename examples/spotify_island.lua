getgenv().KYRI_SPICY_KEY = getgenv().KYRI_SPICY_KEY or ""

local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()

local sp = kyri.spotify({
    tabs = false,
    commands = true,
    island_results = 6
})

local isl = sp.island

local function tell(s)
    print("[island] " .. s)
end

if not sp:authed() then
    tell("not signed in, tap the island and use the two rows")
else
    tell("signed in, tap the magnifier to search")
end

if getgenv().KYRI_SPICY_KEY == "" then
    tell("no spicy key set, falling back to lrc.red and lrclib")
    tell("get one at developers.spicylyrics.org, then set KYRI_SPICY_KEY at the top")
end

task.spawn(function()
    local was_track, was_auth = "", sp:authed()

    while task.wait(1.5) do
        local authed = sp:authed()

        if authed ~= was_auth then
            was_auth = authed
            tell(authed and "signed in" or "signed out")
            if authed then sp:sync() end
        end

        if not authed then continue end

        local name = sp.track and sp.track.name or ""
        if name ~= was_track then
            was_track = name
            if name == "" then
                tell("nothing playing")
            else
                tell(name .. "  by  " .. sp:artists())
                task.spawn(function()
                    local got = sp:lyrics()
                    if not got then
                        tell("  no lyrics anywhere")
                    elseif got.instrumental then
                        tell("  instrumental")
                    elseif got.synced then
                        local kind = got.words and "word synced" or "line synced"
                        tell("  " .. kind .. " from " .. tostring(got.provider))
                        tell("  " .. tostring(got.credit))
                        if got.drift and got.drift > 2 then
                            tell("  duration is off by " .. string.format("%.0f", got.drift)
                                .. "s, if the lines run early use: !sp sync 0.5")
                        end
                    elseif got.plain then
                        tell("  plain only from " .. tostring(got.provider) .. ", nothing to follow")
                    else
                        tell("  no lyrics")
                    end
                end)
            end
        end
    end
end)

task.delay(2, function()
    if not sp:authed() then return end

    local devs = sp:devices()
    print("[island] devices " .. #devs)
    for i, d in pairs(devs) do
        print("[island]   " .. i .. ". " .. d.name .. "  " .. d.type .. (d.is_active and "  active" or ""))
    end

    local mine = sp:playlists(5)
    print("[island] playlists " .. #mine)
    for i, pl in pairs(mine) do
        print("[island]   " .. i .. ". " .. pl.name .. "  " .. tostring(pl.tracks and pl.tracks.total or "?") .. " tracks")
    end

    local hits = sp:search("daft punk", 3, "track")
    print("[island] track search " .. #hits)

    local lists = sp:search("chill", 3, "playlist")
    print("[island] playlist search " .. #lists)

    if sp.last_error then print("[island] last error " .. sp.last_error) end
end)
