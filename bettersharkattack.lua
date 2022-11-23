local CoreGui = game:GetService("StarterGui")

local exploits = {
{"Silent Aim", "https://raw.githubusercontent.com/bluescorpian/SharkAttack-scripts/main/silentaim.lua"},
{"No Recoil", "https://raw.githubusercontent.com/bluescorpian/SharkAttack-scripts/main/norecoil.lua"},
{"Always Can Fire", "https://raw.githubusercontent.com/bluescorpian/SharkAttack-scripts/main/alwayscanfire.lua"},
{"No Barriers", "https://raw.githubusercontent.com/bluescorpian/SharkAttack-scripts/main/nobarriers.lua"}
}

for _, exploit in pairs(exploits) do
    loadstring(game:HttpGet(exploit[2]))()
    CoreGui:SetCore("SendNotification", {
        Title = "Exploit Loaded",
        Text = exploit[1]
    })
end