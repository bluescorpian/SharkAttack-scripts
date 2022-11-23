-- Decompiled with the Synapse X Luau decompiler.

local l__RunService__1 = game:GetService("RunService");
local v2 = require(script.Parent.WeaponUIModule);
local v3 = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("Misc"):WaitForChild("MouseModule"));
local u1 = require(script.Parent.CommonWeaponFunctions);
local u2 = nil;
local u3 = require(script.Parent.WeaponAnimations);
local u4 = require(script.Parent.BulletCountModule);
local function u5(p1)
	if p1.Name == "Shark" then
		local v4 = p1:FindFirstAncestorOfClass("Folder");
		if v4 and v4.Name == "SharkMain" then
			game:GetService("SoundService"):PlayLocalSound(game.SoundService.WeaponSounds.HitMarker.FleshImpact1);
			u1.displayHitMarker();
			u2:FireServer(v4.Parent);
		end;
	end;
end;
local u6 = require(game.ReplicatedStorage.Projectiles.RayProjectileRenderModule);
local targets = {};
local u8 = require(game.ReplicatedStorage.Projectiles.ProjectileStatsModule);
local u9 = require(script.Parent.RecoilModule);
task.spawn(function()
	u2 = game.ReplicatedStorage.Projectiles.Events.Weapons.WeaponParticle:InvokeServer();
end);
local u10 = 0;
local function u11(p2, p3)
	u3.playFire(p2);
	u1.muzzleEffects(p2);
	u4.BulletFired(p2);
	for v5 = 1, 10 do
		local v6, v7 = u1.raycastFromCamera(p3, p2);
		local v8, v9 = u1.raycastFromWeapon(p2, v7);
		if v9 then
			local v10 = nil;
			if v8 then
				u5(v8);
				v10 = v8.Color;
			end;
			u6.RenderBullet(p2.Handle.Barrel.WorldPosition, v9, v10, p2);
			table.insert(targets, v9);
			game.ReplicatedStorage.Projectiles.Events.Weapons.HitScanFire:FireServer(targets[v5]);
		end;
	end;
	u9.applyRecoil(u8.get()[p2.Name].Recoil);
end;
local function u12(p4, p5, p6, p7)
	u3.playFire(p5);
	u1.muzzleEffects(p5);
	u4.BulletFired(p5);
	local v11, v12 = u1.raycastFromCamera(p6, p5);
	if v12 then
		game.ReplicatedStorage.Projectiles.Events.Weapons.HitScanFire:FireServer(v12);
		u6.RenderBulletArc(p5.Handle.Barrel.WorldPosition, v12, p7.BulletSpeed or p7.ProjectileSpeed, true, p7.Gravity, p7.shouldThrowHigh, p5);
		u9.applyRecoil(u8.get()[p5.Name].Recoil);
	end;
end;
local function hitscan(p8, p9)
	u3.playFire(p8);
	u1.muzzleEffects(p8);
	u4.BulletFired(p8);
	local v13, v14 = u1.raycastFromCamera(p9, p8);
	local v15, v16 = u1.raycastFromWeapon(p8, v14);
	if v16 then
		local particleColor = nil;
		if v15 then
			u5(v15);
			particleColor = v15.Color;
		end;
		u6.RenderBullet(p8.Handle.Barrel.WorldPosition, v16, particleColor, p8);
		table.insert(targets, v16);
		u9.applyRecoil(u8.get()[p8.Name].Recoil);
	end;
end;
local u14 = nil;
local u15 = {
	Fire = function(p10, p11)
		targets = {};
		if not u4.CanFireBullet() then
			if not u4.isReloading() then
				v2.displayReloadButton();
			end;
			return;
		end;
		local l__Handle__18 = p10:FindFirstChild("Handle");
		if not l__Handle__18 or not p10:IsDescendantOf(workspace) then
			return;
		end;
		local projectileConfig = u8.get()[p10.Name];
		local l__FireRate__20 = projectileConfig.FireRate;
		local gunMode = projectileConfig.Mode;
		local v22 = tick();
		if v22 - u10 < 1 / l__FireRate__20 then
			return;
		end;
		u10 = v22;
		v2.displayBulletDelayTime(l__FireRate__20);
		if gunMode == 3 then
			u11(p10, p11);
		elseif gunMode == 4 then
			u12(targets, p10, p11, projectileConfig);
		else
			hitscan(p10, p11);
			if gunMode ~= 2 then
				game.ReplicatedStorage.Projectiles.Events.Weapons.HitScanFire:FireServer(targets[1]);
			end;
		end;
		if gunMode == 2 then
			game.ReplicatedStorage.Projectiles.Events.Weapons.HitScanStarted:FireServer(targets[1]);
			local u16 = 0;
			local u17 = 0;
			u14 = l__RunService__1.Heartbeat:Connect(function(p12)
				u16 = u16 + p12;
				u17 = u17 + p12;
				if not l__Handle__18 or not p10:IsDescendantOf(workspace) then
					u15.Stop();
					return;
				end;
				if 1 / l__FireRate__20 <= u16 then
					if not u4.CanFireBullet() then
						u15.Stop();
						v2.displayReloadButton();
						return;
					end;
					v2.displayBulletDelayTime(l__FireRate__20);
					hitscan(p10, p11);
					u16 = 0;
				end;
				if u17 >= 0.25 then
					game.ReplicatedStorage.Projectiles.Events.Weapons.HitScanContinued:FireServer(targets);
					targets = {};
					u17 = 0;
				end;
			end);
		end;
		targets = {};
	end, 
	Stop = function()
		if u14 then
			u14:Disconnect();
			u14 = nil;
		end;
		game.ReplicatedStorage.Projectiles.Events.Weapons.HitScanEnded:FireServer();
	end
};
return u15;
