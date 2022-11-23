-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = false;
local l__ContextActionService__2 = game:GetService("ContextActionService");
local u3 = require(script.Parent.WeaponUIModule);
local u4 = {};
function v1.bindEvents(p1)
	if u1 then
		return;
	end;
	u1 = true;
	l__ContextActionService__2:BindActionAtPriority("FireWeapon", function(p2, p3, p4)
		fireWeaponFunc(p1, p2, p3, p4);
	end, false, 49, Enum.UserInputType.MouseButton1);
	l__ContextActionService__2:BindAction("ReloadWeapon", function(p5, p6, p7)
		reloadWeaponFunc(p1, p5, p6, p7);
	end, false, Enum.KeyCode.R);
	local v2, v3 = u3.getReloadButton();
	local v4, v5 = u3.getShootButton();
	u4 = { v2.Activated:Connect(function()
			reloadWeaponFunc(p1, nil, Enum.UserInputState.Begin, nil);
		end), v4.MouseButton1Down:Connect(function()
			fireWeaponFunc(p1, nil, Enum.UserInputState.Begin, Enum.UserInputType.Touch);
		end), v4.MouseButton1Up:Connect(function()
			fireWeaponFunc(p1, nil, Enum.UserInputState.End, Enum.UserInputType.Touch);
		end), v3.Activated:Connect(function()
			reloadWeaponFunc(p1, nil, Enum.UserInputState.Begin, nil);
		end), v5.MouseButton1Down:Connect(function()
			fireWeaponFunc(p1, nil, Enum.UserInputState.Begin, Enum.UserInputType.Touch);
		end), (v5.MouseButton1Up:Connect(function()
			fireWeaponFunc(p1, nil, Enum.UserInputState.End, Enum.UserInputType.Touch);
		end)) };
	displayAimMarker(p1);
end;
local l__RunService__5 = game:GetService("RunService");
function v1.unbindEvents()
	u1 = false;
	l__ContextActionService__2:UnbindAction("FireWeapon");
	l__ContextActionService__2:UnbindAction("ReloadWeapon");
	for v6, v7 in pairs(u4) do
		v7:Disconnect();
	end;
	l__RunService__5:UnbindFromRenderStep("DisplayAimMarker");
end;
local projectileStats = require(game.ReplicatedStorage.Projectiles.ProjectileStatsModule);
local u7 = false;
local projectileFire = require(script.Parent.ProjectileFire);
local hitscanFire = require(script.Parent.HitScanFire);
function fireWeaponFunc(gun, p9, p10, p11)
	local l__Character__8 = game.Players.LocalPlayer.Character;
	if l__Character__8 then
		if 0 < l__Character__8:FindFirstChild("Humanoid").Health then
			local v9 = not l__Character__8:GetAttribute("InMouth");
		else
			v9 = false;
		end;
	else
		v9 = false;
	end;
	if not v9 then
		return;
	end;
	local gunMode = projectileStats.get()[gun.Name].Mode;
	if gunMode == 5 then
		if u7 == false then
			if p10 == Enum.UserInputState.Begin then
				if u7 == false then
					u7 = true;
					projectileFire.fire(gun, p11);
					return;
				end;
			end;
		elseif gunMode == 101 then
			if u7 == false then
				if p10 == Enum.UserInputState.Begin then
					if u7 == false then
						u7 = true;
						projectileFire.fireFlare(gun);
						return;
					end;
				end;
			else
				if p10 == Enum.UserInputState.Begin then
					if u7 == false then
						u7 = true;
						hitscanFire.Fire(gun, p11);
						return;
					end;
				end;
				if p10 == Enum.UserInputState.End then
					u7 = false;
					hitscanFire.Stop();
				end;
			end;
		else
			if p10 == Enum.UserInputState.Begin then
				if u7 == false then
					u7 = true;
					hitscanFire.Fire(gun, p11);
					return;
				end;
			end;
			if p10 == Enum.UserInputState.End then
				u7 = false;
				hitscanFire.Stop();
			end;
		end;
	elseif gunMode == 101 then
		if u7 == false then
			if p10 == Enum.UserInputState.Begin then
				if u7 == false then
					u7 = true;
					projectileFire.fireFlare(gun);
					return;
				end;
			end;
		else
			if p10 == Enum.UserInputState.Begin then
				if u7 == false then
					u7 = true;
					hitscanFire.Fire(gun, p11);
					return;
				end;
			end;
			if p10 == Enum.UserInputState.End then
				u7 = false;
				hitscanFire.Stop();
			end;
		end;
	else
		if p10 == Enum.UserInputState.Begin then
			if u7 == false then
				u7 = true;
				hitscanFire.Fire(gun, p11);
				return;
			end;
		end;
		if p10 == Enum.UserInputState.End then
			u7 = false;
			hitscanFire.Stop();
		end;
	end;
end;
local u10 = require(script.Parent.CommonWeaponFunctions);
function displayAimMarker(p12)
	local l__Mode__11 = projectileStats.get()[p12.Name].Mode;
	if l__Mode__11 ~= 5 then
		if l__Mode__11 == 4 then
			l__RunService__5:BindToRenderStep("DisplayAimMarker", Enum.RenderPriority.Last.Value, function()
				u10.updateAimMarker();
			end);
		end;
	else
		l__RunService__5:BindToRenderStep("DisplayAimMarker", Enum.RenderPriority.Last.Value, function()
			u10.updateAimMarker();
		end);
	end;
end;
local u11 = require(script.Parent.BulletCountModule);
function reloadWeaponFunc(p13, p14, p15, p16)
	if p15 == Enum.UserInputState.Begin then
		u11.Reload(p13);
	end;
end;
return v1;
