# -*- coding: utf-8 -*-
"""Builds studiosource.lua from source.lua.

source.lua is the only file anyone edits. This prepends a compatibility shim,
cuts the Spotify code (it needs request(), which no Studio script has) and
writes studiosource.lua, so the rest of the library body is identical in both
builds and cannot drift.

The cuts are anchored to code, not to marker comments, because the Lua sources
carry no comments at all.

    python tools/build_studio.py
"""

import io
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

SRC = os.path.join(ROOT, 'source.lua')
OUT = os.path.join(ROOT, 'studiosource.lua')

def icon_table():
    """icons.json inlined: a Studio client cannot reach HttpService at all,
    so the pack has to ship inside the build or every icon falls back."""
    import json
    path = os.path.join(ROOT, 'icons.json')
    with io.open(path, encoding='utf8') as fh:
        data = json.load(fh)
    rows = []
    for k in sorted(data):
        v = data[k]
        if '"' in k or '"' in v or chr(92) in k or chr(92) in v:
            continue
        rows.append('["%s"]="%s"' % (k, v))
    out, line = [], []
    for r in rows:
        line.append(r)
        if len(line) >= 6:
            out.append(','.join(line))
            line = []
    if line:
        out.append(','.join(line))
    nl = chr(10)
    return 'KYRI_ICONS = {' + nl + (',' + nl).join(out) + nl + '}' + nl + nl


SHIM = '''KYRI_STUDIO = true

do
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local files, folders = {}, {}
    local store_name, ds, remote
    local dirty, flushing = false, false

    local function persisted(p)
        return p:sub(-5) == ".json" and p ~= "KyriLib/icons.json"
    end

    local function mark_folders(p)
        local dir = p:match("^(.*)/[^/]+$")
        while dir do
            folders[dir] = true
            dir = dir:match("^(.*)/[^/]+$")
        end
    end

    if not isfile then
        isfile = function(p) return files[p] ~= nil end
        readfile = function(p) return files[p] end
        delfile = function(p)
            files[p] = nil
            if persisted(p) then dirty = true end
        end
        isfolder = function(p) return folders[p] == true end
        makefolder = function(p) folders[p] = true end
        listfiles = function(p)
            local out = {}
            for k in pairs(files) do
                if k:sub(1, #p + 1) == p .. "/" then out[#out + 1] = k end
            end
            return out
        end
        writefile = function(p, d)
            files[p] = d
            mark_folders(p)
            if persisted(p) then dirty = true end
        end
    end

    if not getgenv then
        getgenv = function() return shared end
    end

    local function snapshot()
        local out = {}
        for k, v in pairs(files) do
            if persisted(k) then out[k] = v end
        end
        return out
    end

    local function push()
        local snap = snapshot()
        if ds then
            return pcall(function() ds:SetAsync("kyrilib", snap) end)
        elseif remote then
            return pcall(function() return remote:InvokeServer("set", store_name, snap) end)
        end
        return false
    end

    local function pull()
        local data
        if ds then
            local ok, got = pcall(function() return ds:GetAsync("kyrilib") end)
            if ok then data = got end
        elseif remote then
            local ok, got = pcall(function() return remote:InvokeServer("get", store_name) end)
            if ok then data = got end
        end
        if type(data) ~= "table" then return end
        for k,v in pairs(data) do
            if type(k) == "string" and type(v) == "string" then
                files[k] = v
                mark_folders(k)
            end
        end
    end

    KYRI_SET_STORE = function(name)
        store_name = name or "KyriLib"
        ds, remote = nil, nil

        if RunService:IsServer() then
            local ok, got = pcall(function()
                return game:GetService("DataStoreService"):GetDataStore(store_name)
            end)
            if not ok then
                return false, "datastores are off, tick Studio Access to API Services in Game Settings"
            end
            local okp = pcall(function() return got:GetAsync("kyrilib") end)
            if not okp then
                return false, "datastores are off, tick Studio Access to API Services in Game Settings"
            end
            ds = got
        else
            remote = ReplicatedStorage:FindFirstChild("KyriStore")
            if not remote then
                return false, "no KyriStore RemoteFunction, add tools/KyriStoreServer.lua to ServerScriptService"
            end
            local okp, alive = pcall(function() return remote:InvokeServer("ping", store_name) end)
            if not okp or alive ~= true then
                remote = nil
                return false, "the KyriStore bridge cannot reach datastores, tick Studio Access to API Services in Game Settings"
            end
        end

        pull()

        if not flushing then
            flushing = true
            task.spawn(function()
                while task.wait(7) do
                    if dirty then
                        dirty = false
                        push()
                    end
                end
            end)
            if RunService:IsServer() then
                game:BindToClose(function()
                    if dirty then push() end
                end)
            end
        end

        return true
    end

    KYRI_FLUSH_STORE = function()
        if not (ds or remote) then return false, "call kyri.persist(name) first" end
        dirty = false
        return push()
    end
end

'''

STUB_SPOTIFY = '''function kyri.spotify()
    local sp = {ready = false, playing = false, studio = true}
    return setmetatable(sp, {__index = function() return function() return false end end})
end

'''

STUB_W_SPOTIFY = '''    function w:spotify()
        w:notify("spotify", "spotify needs an executor, it is not in the studio build", 4)
        return kyri.spotify()
    end

'''


def cut(body, start, end, replacement, label):
    """Replace everything from `start` up to (not including) `end`."""
    i = body.find(start)
    if i < 0:
        print('build anchor missing (%s start): %r' % (label, start))
        sys.exit(1)
    j = body.find(end, i)
    if j < 0:
        print('build anchor missing (%s end): %r' % (label, end))
        sys.exit(1)
    return body[:i] + replacement + body[j:]


def main():
    if not os.path.isfile(SRC):
        print('missing %s' % SRC)
        return 1

    raw = open(SRC, 'rb').read().decode('utf8')
    nl = '\r\n' if raw.count('\r\n') else '\n'
    body = raw.replace('\r\n', '\n')
    before = body.count('\n')

    if 'KYRI_STUDIO' not in body:
        print('source.lua no longer checks KYRI_STUDIO, the shim marker is dead')
        return 1

    body = cut(body, 'local sha_k = {', 'function kyri.new(title, options)',
               STUB_SPOTIFY, 'spotify')
    body = cut(body, '    function w:spotify(opts)', '    function w:destroy()',
               STUB_W_SPOTIFY, 'w:spotify')

    if 'sha256' in body or 'kyri.spotify(opts)' in body:
        print('spotify code survived the cut')
        return 1

    if not body.rstrip('\n').endswith('return kyri'):
        print('source.lua does not end in "return kyri"')
        return 1

    body = body.rstrip('\n')
    body = body[:body.rindex('return kyri')] + (
        'kyri.persist = KYRI_SET_STORE\n'
        'kyri.flush = KYRI_FLUSH_STORE\n'
        '\n'
        'return kyri\n'
    )

    out = icon_table() + SHIM + body
    open(OUT, 'wb').write(out.replace('\n', nl).encode('utf8'))

    print('wrote %s (%d lines, %d cut from source)'
          % (os.path.basename(OUT), out.count('\n') + 1, before - body.count('\n')))
    return 0


if __name__ == '__main__':
    sys.exit(main())
