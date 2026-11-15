
local svc = {}
local function call(n)
    return game:GetService(n)
end

svc.rep = call("ReplicatedStorage")
svc.ds = call("DataStoreService")

local KEY = "kyrilib"

local f = Instance.new("RemoteFunction")
f.Name = "KyriStore"
f.Parent = svc.rep

local function store(name)
    if type(name) ~= "string" or name == "" then return nil end
    local ok, s = pcall(function() return svc.ds:GetDataStore(name) end)
    if ok then return s end
    return nil
end

f.OnServerInvoke = function(plr, action, name, data)
    local s = store(name)
    if not s then return nil end

    if action == "ping" then
        local ok = pcall(function() return s:GetAsync(KEY) end)
        return ok

    elseif action == "get" then
        local ok, got = pcall(function() return s:GetAsync(KEY) end)
        if ok then return got end
        return nil

    elseif action == "set" then
        if type(data) ~= "table" then return false end

        local n = 0
        for k,v in pairs(data) do
            if type(k) ~= "string" or type(v) ~= "string" then return false end
            if #v > 200000 then return false end
            n = n + 1
            if n > 64 then return false end
        end

        local ok = pcall(function() s:SetAsync(KEY, data) end)
        return ok
    end

    return nil
end
