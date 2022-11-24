-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = require(game.ReplicatedStorage.Projectiles.TurretStatsModule);
local v3 = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("Misc"):WaitForChild("MouseModule"));
local l__RunService__4 = game:GetService("RunService");
local l__CurrentCamera__5 = game.Workspace.CurrentCamera;
local l__mouse__6 = game.Players.LocalPlayer:GetMouse();
local u1 = nil;
local u2 = require(script.Parent.Parent.WeaponScript.CommonWeaponFunctions);
local function u3(p1, p2)
	if p1.Name == "Shark" then
		local v7 = p1:FindFirstAncestorOfClass("Folder");
		if v7 and v7.Name == "SharkMain" then
			game:GetService("SoundService"):PlayLocalSound(game.SoundService.WeaponSounds.HitMarker.FleshImpact1);
			u1:FireServer(p2, v7.Parent);
		end;
	end;
end;
local u4 = require(game.ReplicatedStorage.Projectiles.RayProjectileRenderModule);
local u5 = {};
task.spawn(function()
	u1 = game.ReplicatedStorage.Projectiles.Events.Turrets.WeaponParticle:InvokeServer();
end);
local u6 = {};
local function u7(p3, p4, p5)
	u2.muzzleEffectsTurret(p4);
	local v8, v9 = u2.raycastFromCamera();
	local v10, v11 = u2.raycastFromTurret(p4, v9);
	local v12 = v9;
	if p5.Gravity == 1 then
		v12 = v11;
	end;
	if v12 then
		local v13 = p5.BulletSpeed or p5.ProjectileSpeed;
		local l__Gravity__14 = p5.Gravity;
		local l__shouldThrowHigh__15 = p5.shouldThrowHigh;
		for v16, v17 in pairs(p4.Cannons:GetChildren()) do
			game.ReplicatedStorage.Projectiles.Events.Turrets.HitScanFire:FireServer(p4, v12);
			u4.RenderBulletArc(v17.Barrel.WorldPosition, v12, v13, true, l__Gravity__14, l__shouldThrowHigh__15, p4);
		end;
	end;
end;
local function u8(p6)
	u2.muzzleEffectsTurret(p6);
	local v18, v19 = u2.raycastFromCamera();
	local v20, v21 = u2.raycastFromTurret(p6, v19);
	if v21 then
		local v22 = nil;
		if v20 then
			u3(v20, p6);
			v22 = v20.Color;
		end;
		for v23, v24 in pairs(p6.Cannons:GetChildren()) do
			u4.RenderBullet(v24.Barrel.WorldPosition, v21, v22, p6);
		end;
		table.insert(u5, v21);
	end;
end;
local u9 = {};
function v1.Fire(p7)
	u5 = {};
	local v25 = v2.get()[p7.Name];
	local l__FireRate__26 = v25.FireRate;
	local l__Mode__27 = v25.Mode;
	local l__ProjectileSpeed__28 = v25.ProjectileSpeed;
	local v29 = u6[p7];
	local v30 = tick();
	if v29 and v30 - v29 < 1 / l__FireRate__26 then
		return;
	end;
	u6[p7] = v30;
	if l__Mode__27 ~= 3 then
		if l__Mode__27 == 4 then
			u7(u5, p7, v25);
		else
			u8(p7);
			if l__Mode__27 ~= 2 then
				game.ReplicatedStorage.Projectiles.Events.Turrets.HitScanFire:FireServer(p7, u5[1]);
			end;
		end;
	end;
	if l__Mode__27 == 2 then
		game.ReplicatedStorage.Projectiles.Events.Turrets.HitScanStarted:FireServer(p7, u5[1]);
		local u10 = 0;
		local u11 = 0;
		table.insert(u9, (l__RunService__4.Heartbeat:Connect(function(p8)
			u10 = u10 + p8;
			u11 = u11 + p8;
			if 1 / l__FireRate__26 <= u10 then
				u8(p7);
				u10 = 0;
			end;
			if u11 >= 0.25 then
				game.ReplicatedStorage.Projectiles.Events.Turrets.HitScanContinued:FireServer(p7, u5);
				u5 = {};
				u11 = 0;
			end;
		end)));
	end;
end;
function v1.Stop(p9)
	for v31, v32 in pairs(u9) do
		v32:Disconnect();
	end;
	u9 = {};
	game.ReplicatedStorage.Projectiles.Events.Turrets.HitScanEnded:FireServer(p9);
end;
function v1.turretRemoved(p10)
	v1.Stop(p10);
	u6[p10] = nil;
end;
return v1;
