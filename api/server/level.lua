-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

local filename = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end
print("^6[SERVER - DEBUG] ^0: "..filename()..".lua started");

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Callback:Register("Trusted:Quests:GetPlayerLevel", function(source, callback)
    local playerLevel = Bridge:GetPlayerLevel(source)

    callback(playerLevel)
end)

RegisterNetEvent("Trusted:Quests:SetPlayerLevel", function(xp)
    ---@todo: add more checks to prevent cheating

    Bridge:SetPlayerLevel(xp)
end)