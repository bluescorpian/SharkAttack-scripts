-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__CollectionService__1 = game:GetService("CollectionService");
local l__UserInputService__2 = game:GetService("UserInputService");
local u3 = require(script.Parent.WeaponUIModule);
local l__mouse__4 = game.Players.LocalPlayer:GetMouse();
local l__CurrentCamera__5 = game.Workspace.CurrentCamera;
local function u6()
	local v2 = { game.Players.LocalPlayer.Character };
	for v3, v4 in pairs(l__CollectionService__1:GetTagged("BulletsIgnore")) do
		table.insert(v2, v4);
	end;
	local v5 = RaycastParams.new();
	v5.FilterDescendantsInstances = v2;
	v5.FilterType = Enum.RaycastFilterType.Blacklist;
	v5.IgnoreWater = false;
	v5.CollisionGroup = "Projectiles";
	return v5;
end;
local function u7()
	local l__Character__6 = game.Players.LocalPlayer.Character;
	if not l__Character__6 then
		local v7 = nil;
	else
		local l__Humanoid__8 = l__Character__6:FindFirstChild("Humanoid");
		if not l__Humanoid__8 then
			v7 = nil;
		else
			local l__SeatPart__9 = l__Humanoid__8.SeatPart;
			if l__SeatPart__9 then
				v7 = l__SeatPart__9.Parent.Parent;
			else
				v7 = nil;
			end;
		end;
	end;
	local v10 = { game.Players.LocalPlayer.Character, v7 };
	for v11, v12 in pairs(l__CollectionService__1:GetTagged("BulletsIgnore")) do
		table.insert(v10, v12);
	end;
	local v13 = RaycastParams.new();
	v13.FilterDescendantsInstances = v10;
	v13.FilterType = Enum.RaycastFilterType.Blacklist;
	v13.IgnoreWater = true;
	v13.CollisionGroup = "Projectiles";
	return v13;
end;
function v1.raycastFromCamera(p1)
	if l__UserInputService__2.TouchEnabled then
		local v14 = u3.getMobileTarget();
		local l__AbsolutePosition__15 = v14.AbsolutePosition;
		local l__AbsoluteSize__16 = v14.AbsoluteSize;
		local v17 = Vector2.new(l__AbsolutePosition__15.X + l__AbsoluteSize__16.X / 2, l__AbsolutePosition__15.Y + l__AbsoluteSize__16.Y / 2);
	else
		v17 = Vector2.new(l__mouse__4.X, l__mouse__4.Y);
	end;
	local v18 = l__CurrentCamera__5:ScreenPointToRay(v17.X, v17.Y);
	if p1 then
		local v19 = u6();
	else
		v19 = u7();
	end;
	local v20 = game.Workspace:Raycast(v18.Origin, v18.Direction * 500, v19);
	if v20 then
		return v20.Instance, v20.Position, v20.Normal;
	end;
	return nil, v18.Origin + v18.Direction * 500;
end;
local u8 = require(game.ReplicatedStorage.Projectiles.ProjectileStatsModule);
function v1.raycastFromWeapon(gun, pos)
	local gunPossition = gun.Handle.Barrel.WorldPosition;
	local l__Spread__22 = u8.get()[gun.Name].Spread;
	local l__Range__23 = u8.get()[gun.Name].Range;
	local v24 = Random.new();
	local v25 = (pos - gunPossition).Unit + Vector3.new((v24:NextNumber() - v24:NextNumber()) * l__Spread__22, (v24:NextNumber() - v24:NextNumber()) * l__Spread__22, (v24:NextNumber() - v24:NextNumber()) * l__Spread__22);
	local v26 = workspace:Raycast(gunPossition, v25 * l__Range__23, (u7()));
	if not v26 then
		return nil, gunPossition + v25 * l__Range__23;
	end;
	return v26.Instance, v26.Position;
end;
local u9 = require(game.ReplicatedStorage.Projectiles.TurretStatsModule);
local function u10(p4)
	local v27 = { game.Players.LocalPlayer.Character, p4 };
	for v28, v29 in pairs(l__CollectionService__1:GetTagged("BulletsIgnore")) do
		table.insert(v27, v29);
	end;
	local v30 = RaycastParams.new();
	v30.FilterDescendantsInstances = v27;
	v30.FilterType = Enum.RaycastFilterType.Blacklist;
	v30.IgnoreWater = true;
	v30.CollisionGroup = "Projectiles";
	return v30;
end;
function v1.raycastFromTurret(p5, p6)
	local l__Cannon__31 = p5.Cannons:FindFirstChild("Cannon");
	if not l__Cannon__31 then
		return;
	end;
	local l__Position__32 = l__Cannon__31.Position;
	local l__Spread__33 = u9.get()[p5.Name].Spread;
	local l__Range__34 = u9.get()[p5.Name].Range;
	local v35 = Random.new();
	local v36 = l__Cannon__31.CFrame.LookVector + Vector3.new((v35:NextNumber() - v35:NextNumber()) * l__Spread__33, (v35:NextNumber() - v35:NextNumber()) * l__Spread__33, (v35:NextNumber() - v35:NextNumber()) * l__Spread__33);
	local v37 = workspace:Raycast(l__Position__32, v36 * l__Range__34, (u10(p5)));
	if not v37 then
		return nil, l__Position__32 + v36 * l__Range__34;
	end;
	return v37.Instance, v37.Position;
end;
local l__RunService__11 = game:GetService("RunService");
function v1.muzzleEffectsTurret(p7)
	local function v38(p8)
		local v39 = p8:GetAttribute("FlashPeriod") and 0.07;
		local v40 = tick();
		for v41, v42 in pairs(p8:GetChildren()) do
			if v42.Name == "Muzzle" then
				v42.Enabled = true;
			end;
		end;
		while true do
			l__RunService__11.Stepped:Wait();
			if v39 <= tick() - v40 then
				break;
			end;		
		end;
		for v43, v44 in pairs(p8:GetChildren()) do
			if v44.Name == "Muzzle" then
				v44.Enabled = false;
			end;
		end;
	end;
	for v45, v46 in pairs((p7.Cannons:GetChildren())) do
		for v47, v48 in pairs(v46:GetChildren()) do
			if v48.Name == "Barrel" then
				task.spawn(function()
					v38(v48);
				end);
			end;
		end;
	end;
end;
function v1.muzzleEffects(p9)
	local function v49(p10)
		local v50 = p10:GetAttribute("FlashPeriod") and 0.07;
		local v51 = tick();
		for v52, v53 in pairs(p10:GetChildren()) do
			if v53.Name == "Muzzle" then
				v53.Enabled = true;
			end;
		end;
		while true do
			l__RunService__11.Stepped:Wait();
			if v50 <= tick() - v51 then
				break;
			end;		
		end;
		for v54, v55 in pairs(p10:GetChildren()) do
			if v55.Name == "Muzzle" then
				v55.Enabled = false;
			end;
		end;
	end;
	local l__Handle__56 = p9:FindFirstChild("Handle");
	if l__Handle__56 then
		for v57, v58 in pairs(l__Handle__56:GetChildren()) do
			if v58.ClassName == "Attachment" then
				coroutine.wrap(v49)(v58);
			end;
		end;
	end;
end;
function v1.updateAimMarker()
	local v59 = workspace.Miscellaneous:FindFirstChild("AimPart");
	local v60, v61, v62 = v1.raycastFromCamera(true);
	if not v60 then
		if v59 then
			v59:Destroy();
		end;
		return;
	end;
	if not v59 then
		v59 = game.ReplicatedStorage.Projectiles.AimPart:Clone();
		v59.Parent = workspace.Miscellaneous;
	end;
	v59.CFrame = CFrame.new(v61, v61 + v62) * CFrame.Angles(-math.pi / 2, 0, 0);
end;
local u12 = 0;
function v1.displayHitMarker()
	u12 = u12 + 1;
	task.spawn(function()
		l__UserInputService__2.MouseIconEnabled = true;
		game.Players.LocalPlayer:GetMouse().Icon = "rbxassetid://11306021918";
		task.wait(0.1);
		if u12 == u12 and game.Players.LocalPlayer:GetMouse().Icon == "rbxassetid://11306021918" then
			game.Players.LocalPlayer:GetMouse().Icon = "rbxassetid://11306021749";
		end;
	end);
end;
function v1.setCursorIcon()
	l__UserInputService__2.MouseIconEnabled = true;
	game.Players.LocalPlayer:GetMouse().Icon = "rbxassetid://11306021749";
end;
return v1;
