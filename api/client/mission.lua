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

Mission = {
    active = false,
    mission = nil,
    timeout = false,
    data = {}
}

function Mission:SetActive(active)
    self.active = active
end

function Mission:IsActive()
    return self.active
end

function Mission:GetData()
    return self.data
end

function Mission:CanStart()
    return not self.timeout and not self.active
end

function Mission:StartTimeout()
    self.timeout = true
    SetTimeout(Config.MissionTimeout, function()
        self.timeout = false
    end)
end

function Mission:Setup(mission, index)
    self.mission = mission
    self.data = Config.Missions[mission]?[index] or Config.Missions[mission]
    self:SetActive(true)

    ---@meta: global function from one of the files in client/missions/ will trigger
    _G[self.mission]:Start()
end

function Mission:Cancel()
    if not self.active then
        Visual.Notify("You are not on a mission")
        return
    end

    self:SetActive(false)
    self:StartTimeout()

    _G[self.mission]:Cancel()

    Scaleforms:MidsizeBanner("~r~Mission Cancelled", "You have cancelled the mission", 2, 3, true)
    Level:Remove(Config.MissionPenalty)

    self.mission = nil
    self.data = {}
end

function Mission:Complete()
    if not self.active then
        Visual.Notify("You are not on a mission")
        return
    end

    self:SetActive(false)
    self:StartTimeout()

    Scaleforms:MidsizeBanner("~g~Mission Completed", "You have completed the mission", 2, 5, true)
    Level:Add(self.data.xp)

    TriggerServerEvent("Trusted:Quests:CompleteMission", self.mission, self.data)

    self.mission = nil
    self.data = {}
end