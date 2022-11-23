-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local ammo = 0;
local u2 = require(script.Parent.WeaponUIModule);
local u3 = 0;
local u4 = {};
function v1.resetWeapons()
	u4 = {};
	u3 = 0;
	ammo = 0;
end;
local u5 = false;
local u6 = require(game.ReplicatedStorage.Projectiles.ProjectileStatsModule);
function v1.ChangeWeapon(p1)
	u5 = true;
	ammo = u4[p1.Name];
	u3 = u6.get()[p1.Name].MagSize;
	if not ammo then
		u4[p1.Name] = u3;
		ammo = u4[p1.Name];
	end;
	if ammo == math.huge then
		u2.setBulletText("");
		return;
	end;
	u2.setBulletText(tostring(ammo) .. " / " .. tostring(u3));
end;
local u7 = false;
function v1.CanFireBullet()
	local l__Character__2 = game.Players.LocalPlayer.Character;
	local l__Humanoid__3 = l__Character__2:FindFirstChild("Humanoid");
	if not l__Humanoid__3 then
		return false;
	end;
	local v4 = false;
	if ammo > 0 then
		v4 = not u7;
		if v4 then
			v4 = false;
			if l__Humanoid__3.Health > 0 then
				v4 = not l__Character__2:GetAttribute("InMouth");
			end;
		end;
	end;
	return v4;
end;
function v1.BulletFired(p2)
	if ammo < 1 then
		print("Bullet Count ERROR");
		return false;
	end;
	ammo = ammo - 1;
	u4[p2.Name] = ammo;
	if ammo == math.huge then
		u2.setBulletText("");
		return;
	end;
	u2.setBulletText(tostring(ammo) .. " / " .. tostring(u3));
end;
function v1.isReloading()
	return u7;
end;
local u8 = require(script.Parent.WeaponAnimations);
local u9 = nil;
function v1.Reload(p3)
	if u7 then
		return;
	end;
	u5 = false;
	u7 = true;
	game.SoundService.Reload:Play();
	local l__ReloadTime__5 = u6.get()[p3.Name].ReloadTime;
	u8.playReload(p3, l__ReloadTime__5);
	u2.hideReloadButton();
	local u10 = 0;
	u9 = game:GetService("RunService").Heartbeat:Connect(function(p4)
		u10 = u10 + p4;
		if u5 then
			u5 = false;
			u7 = false;
			game.SoundService.Reload:Stop();
			u9:Disconnect();
			u9 = nil;
			return;
		end;
		if not (l__ReloadTime__5 <= u10) then
			return;
		end;
		ammo = u3;
		u4[p3.Name] = ammo;
		u7 = false;
		if ammo == math.huge then
			u2.setBulletText("");
		else
			u2.setBulletText(tostring(ammo) .. " / " .. tostring(u3));
		end;
		u9:Disconnect();
		u9 = nil;
	end);
end;
return v1;
