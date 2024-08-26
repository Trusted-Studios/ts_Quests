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

Level = {
    Player = {
        level = 0,
        xp = 0,
    },
    ready = false
}

function Level:init()
    Async.Await(function()
        Callbacks:Trigger("Trusted:Quests:GetPlayerLevel", function(data)
            self.Player.level = data.level
            self.Player.xp = data.xp
        end)
    end)

    if Config.UseXNLRankBar then
        exports.XNLRankBar:Exp_XNL_SetInitialXPLevels(0, false, false)
        exports.XNLRankBar:Exp_XNL_SetInitialXPLevels(self.Player.xp, true, false)
    end

    self.ready = true
end

function Level:Add(amount)
    self.Player.xp = self.Player.xp + amount

    if Config.UseXNLRankBar then
        exports.XNLRankBar:Exp_XNL_AddPlayerXP(amount)
    end

    TriggerServerEvent("Trusted:Quests:SetPlayerLevel", self.Player.xp)
end

function Level:Remove(amount)
    self.Player.xp = self.Player.xp - amount

    if Config.UseXNLRankBar then
        exports.XNLRankBar:Exp_XNL_RemovePlayerXP(amount)
    end

    TriggerServerEvent("Trusted:Quests:SetPlayerLevel", self.Player.xp)
end

function Level:GetLevel()
    return self.Player.level
end

function Level:GetXP()
    return self.Player.xp
end

function Level:Ready()
    return self.ready
end


-------- exports --------

exports("AddLevel", function(amount)
    Level:Add(amount)
end)

exports("RemoveLevel", function(amount)
    Level:Remove(amount)
end)

exports("GetLevel", function()
    return Level:GetLevel()
end)

exports("GetXP", function()
    return Level:GetXP()
end)