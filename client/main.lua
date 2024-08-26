-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

local filename = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end
print("^6[CLIENT - DEBUG] ^0: "..filename()..".lua started");

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Quests = {}

function Quests:init()
    ---@todo: add locations for each mission type
end

function Quests:UpdatePlayerLevel()
    if not Config.PlayTimeXPReward.enable then
        return
    end

    CreateThread(function()
        while true do
            Wait(Config.PlayTimeXPReward.interval * 60000)
            Level:Add(Config.PlayTimeXPReward.amount)
        end
    end)
end

function Quests:OnReady(func)
    repeat Wait(10) until Level:Ready()

    if not func or type(func) ~= "function" then
        return
    end

    func()
end

CreateThread(function()
    Quests:UpdatePlayerLevel()
end)