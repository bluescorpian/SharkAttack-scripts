-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = {};
v2.__index = v2;
function v1.new(p1)
	local v3 = setmetatable({}, v2);
	v3.Enabled = false;
	v3.Turret = p1;
	local l__Base__4 = p1:FindFirstChild("Base");
	local l__Yaw__5 = p1:FindFirstChild("Yaw");
	local l__Pitch__6 = p1:FindFirstChild("Pitch");
	v3.YawDiff = nil;
	if l__Yaw__5 and l__Base__4 then
		v3.YawDiff = l__Base__4.CFrame:PointToObjectSpace(l__Yaw__5.Position);
	end;
	v3.PitchDiff = nil;
	if l__Pitch__6 and l__Yaw__5 then
		v3.PitchDiff = l__Pitch__6.CFrame:PointToObjectSpace(l__Yaw__5.Position);
	end;
	v3.YawLastUpdate = 0;
	v3.PitchLastUpdate = 0;
	v3.minUpdateLen = 0.17453292519943295;
	if not p1:GetAttribute("YawDiff") then
		p1:SetAttribute("YawDiff", v3.YawDiff);
		p1:SetAttribute("PitchDiff", v3.PitchDiff);
	end;
	return v3;
end;
local u1 = require(game.Players.LocalPlayer.PlayerScripts.ProjectilesClient.Turrets.TurretInputModule);
function v2.enable(p2)
	if p2.Enabled then
		return;
	end;
	p2.Enabled = true;
	u1.addTurret(p2.Turret);
end;
function v2.disable(p3)
	if not p3.Enabled then
		return;
	end;
	p3.Enabled = false;
	u1.removeTurret(p3.Turret);
end;
local function u2(p4, p5)
	return math.sqrt(p4 * p4 + p5 * p5);
end;
function v2.aim(self, p7)
	if self.Turret.PrimaryPart == nil then
		return;
	end;
	if not self.Turret.Cannons:FindFirstChild("Cannon") then
		return;
	end;
	local v7 = self.Turret.PrimaryPart.CFrame:VectorToObjectSpace(p7 - self.Turret.Cannons.Cannon.Position);
	local v8 = math.atan2(v7.Y, u2(v7.X, v7.Z));
	local v9 = math.atan2(v7.X, v7.Z);
	local v10 = self.Turret:GetAttribute("PitchMin");
	if v10 then
		v8 = math.max(v8, math.rad(v10));
	end;
	local v11 = TweenInfo.new(0.15);
	local v12 = CFrame.new();
	local v13 = CFrame.new();
	local l__Yaw__14 = self.Turret:FindFirstChild("Yaw");
	if l__Yaw__14 and l__Yaw__14:FindFirstChild("Motor6D") then
		v12 = CFrame.new(self.Turret:GetAttribute("YawDiff")) * CFrame.Angles(0, v9 + math.pi, 0);
		game:GetService("TweenService"):Create(l__Yaw__14.Motor6D, v11, {
			C0 = v12
		}):Play();
	end;
	local l__Pitch__15 = self.Turret:FindFirstChild("Pitch");
	if l__Pitch__15 and l__Pitch__15:FindFirstChild("Motor6D") then
		v13 = CFrame.new(self.Turret:GetAttribute("PitchDiff")) * CFrame.Angles(-v8, 0, 0);
		game:GetService("TweenService"):Create(l__Pitch__15.Motor6D, v11, {
			C0 = v13
		}):Play();
	end;
	if self.minUpdateLen <= math.abs(v9 - self.YawLastUpdate) or self.minUpdateLen / 2 <= math.abs(v8 - self.PitchLastUpdate) then
		game.ReplicatedStorage.EventsFolder.Boat.ClientToServer.TurretRotation:FireServer(self.Turret, v12, v13);
		self.YawLastUpdate = v9;
		self.PitchLastUpdate = v8;
	end;
end;
return v1;
