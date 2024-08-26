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

Bridge = {}

if IsDuplicityVersion() then
    function Bridge:GetPlayerLevel(source)
        return _G[Config.Framework]:GetPlayerLevel(source)
    end

    function Bridge:SetPlayerLevel(xp)
        _G[Config.Framework]:SetPlayerLevel(xp)
    end

    return
end