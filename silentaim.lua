local LocalPlayer = game:GetService("Players").LocalPlayer
local commonWeapon = require(LocalPlayer.PlayerScripts.ProjectilesClient.WeaponScript.CommonWeaponFunctions)
local sharks = workspace.Sharks

local lastSharkCheck
local closestShark
local function getClosestShark()
    if (not lastSharkCheck or not closestShark or not closestShark.Parent)
    or (tick() - lastSharkCheck) > 5  -- if it has not ran yet or shark dead
     then
    -- if (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart)
        -- or not lastSharkCheck or (tick() - lastSharkCheck > 5) or not closestShark or not closestShark.Parent then -- improve
        local closest = nil
        for _, shark in pairs(sharks:GetChildren()) do
            local distance = (shark:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if not closest or closest[1] < distance then
                closest = {distance, shark}
            end
        end
        lastSharkCheck = tick()
        if closest then 
            closestShark = closest[2]
            return closestShark
        end
    else
        return closestShark
    end
end

local oldRayCastFromWeapon
oldRayCastFromWeapon = hookfunction(commonWeapon.raycastFromWeapon, function(...)
    local shark = getClosestShark()
    if not shark then return oldRayCastFromWeapon(...) end
    local sharkMesh = shark.SharkMain.Mesh.Shark
    return sharkMesh, sharkMesh.Position
end)