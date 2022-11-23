local BulletCountModule = require(game:GetService("Players").LocalPlayer.PlayerScripts.ProjectilesClient.WeaponScript.BulletCountModule)

hookfunction(BulletCountModule.CanFireBullet, function()
    return true
end)