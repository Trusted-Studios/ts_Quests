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

---@diagnostic disable-next-line: missing-parameter
RMenu.Add("Trusted:Quests:Menu", "mainMenu", RageUI.CreateMenu("Quests", "~p~Created by Trusted-Studios", 0, 0))

Menu = {
    mainMenu = RMenu:Get("Trusted:Quests:Menu", "mainMenu"),
    mission = nil
}

function Menu:Open(mission)
    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
        Visual.Notify("Get out of the vehicle first!")
        return
    end
    if not Mission:CanStart() then
        Visual.Notify("Mission is already active")
        return
    end

    self.mission = mission
    RageUI.Visible(self.mainMenu, not RageUI.Visible(self.mainMenu))
end

function Menu:Main()
    if not RageUI.IsVisible(self.mainMenu) then
        Wait(500)
        return
    end

    RageUI.IsVisible(self.mainMenu, function()
        if self.mission == "warehouse" then
            ---@diagnostic disable-next-line: missing-parameter
            RageUI.Button("Start Warehouse Mission", "", {RightLabel = "→→→"}, true, {
                onSelected = function()
                    RageUI.CloseAll()
                    Mission:Setup(self.mission)
                end
            })
        end

        if self.mission == "postal" then
            for mission, data in pairs(Config.Missions.Postal) do
                ---@diagnostic disable-next-line: trailing-space, missing-parameter
                RageUI.Button("Start Postal Mission", "", {}, true, {
                    onSelected = function()
                        RageUI.CloseAll()

                        if Level:GetLevel() < data.Misc.rank then
                            Visual.Notify("Du must mindestens den Rang ~b~"..data.Misc.rank.."~w~ Besitzen um diesen Auftrag anzunehmen!")
                            return
                        end

                        Mission:Setup(self.mission, mission)
                    end
                })
            end
        end

        if self.mission == "drugs" then
            for mission, data in pairs(Config.Missions.Drugs) do
                ---@diagnostic disable-next-line: trailing-space, missing-parameter
                RageUI.Button("Start Drug Mission", "", {}, true, {
                    onSelected = function()
                        RageUI.CloseAll()

                        ---@todo: check if player is a cop or not (if enabled in config -> not able to start drug missions)

                        if Level:GetLevel() < data.Misc.rank then
                            Visual.Notify("Du must mindestens den Rang ~b~"..data.Misc.rank.."~w~ Besitzen um diesen Auftrag anzunehmen!")
                            return
                        end

                        Mission:Setup(self.mission, mission)
                    end
                })
            end
        end
    end)
end

CreateThread(function()
    while true do
        Wait(0)
        Menu:Main()
    end
end)