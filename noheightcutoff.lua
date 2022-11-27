-- local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/bluescorpian/missingPieceUtils/main/missingPieceUtils.lua"))()
local startBoat = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Boats.BoatController).startBoat

local oldStartBoat
oldStartBoat = hookfunction(startBoat, function(boat, ...)
    -- utils.rconsoleprint(config)
    local config = boat.Configuration
    config.Engine.EngineCutOutHeight.Value = 500
    
    return oldStartBoat(boat, ...)
end)