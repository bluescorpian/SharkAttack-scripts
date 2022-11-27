-- local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/bluescorpian/missingPieceUtils/main/missingPieceUtils.lua"))()

local LocalPlayer = game:GetService("Players").LocalPlayer
local buoyScript = LocalPlayer.PlayerScripts:WaitForChild("GuiGameLoop"):WaitForChild("BuoySonarLocator")

local checkBouys = nil
local pingShark = nil

for _, v in pairs(getgc()) do
    if type(v) == "function" and getfenv(v).script == buoyScript then
        local info = debug.getinfo(v)
        if info.name == "" and info.currentline == 45 then
            checkBouys = v
        elseif info.name == "pingShark" then
            pingShark = v
        end
        if checkBouys and pingShark then break end
    end
end

if not (checkBouys and pingShark) then return error("Bouy functions not found, script prop updated") end

local sharks = workspace:WaitForChild("Sharks");

hookfunction(checkBouys, function() task.wait(1000) end)

while true do 
    task.wait(3)
    if game.Players.LocalPlayer.Team ~= game.Teams.Shark then
        for _, shark in pairs(sharks:GetChildren()) do
            pingShark(shark) 
        end
    end
end

-- hookfunction(checkBuoysFunc, function()
--     for _, shark in pairs(sharks:GetChildren()) do
--         pingSharkFunc(shark)
--     end
-- end)

-- local hook;
-- hook = hookfunction(checkBuoysFunc, function(...)
--     print('hook')
--     utils.print({...})
--     local a = hook(...)
--     utils.print(a)
--     return a
-- end)