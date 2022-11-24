-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__mouse__2 = game.Players.LocalPlayer:GetMouse();
local l__CollectionService__1 = game:GetService("CollectionService");
local u2 = false;
local Turret = require(script.Turret);
local u4 = require(game.Players.LocalPlayer.PlayerScripts.ProjectilesClient.Turrets.TurretInputModule);
local l__UserInputService__5 = game:GetService("UserInputService");
local function u6(p1)
	local v3 = { p1, game.Players.LocalPlayer.Character };
	for v4, v5 in pairs(l__CollectionService__1:GetTagged("BulletsIgnore")) do
		table.insert(v3, v5);
	end;
	return v3;
end;
local u7 = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("Misc"):WaitForChild("MouseModule"));
function v1.Start(p2)
	u2 = false;
	local l__TouchGui__6 = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui");
	if l__TouchGui__6 then
		local l__DynamicThumbstickFrame__7 = l__TouchGui__6.TouchControlFrame:FindFirstChild("DynamicThumbstickFrame");
		if l__DynamicThumbstickFrame__7 then
			l__DynamicThumbstickFrame__7.Visible = false;
		end;
	end;
	local v8 = false;
	local turrets = {};
	for v10, v11 in pairs((p2.AddOns.Turrets.Small:GetChildren())) do
		local turret = Turret.new(v11);
		turret:enable();
		table.insert(turrets, turret);
		v8 = true;
	end;
	for v13, v14 in pairs((p2.AddOns.Turrets.Medium:GetChildren())) do
		local v15 = Turret.new(v14);
		v15:enable();
		table.insert(turrets, v15);
		v8 = true;
	end;
	if v8 then
		u4.bindEvents();
	end;
	while not u2 do
		if l__UserInputService__5.TouchEnabled then
			local l__MobileTarget__16 = game.Players.LocalPlayer.PlayerGui.MobileTurretGui.MobileTarget;
			local l__AbsolutePosition__17 = l__MobileTarget__16.AbsolutePosition;
			local l__AbsoluteSize__18 = l__MobileTarget__16.AbsoluteSize;
			local v19 = Vector2.new(l__AbsolutePosition__17.X + l__AbsoluteSize__18.X / 2, l__AbsolutePosition__17.Y + l__AbsoluteSize__18.Y / 2);
			local v20 = workspace.CurrentCamera:ScreenPointToRay(v19.X, v19.Y);
			local v21 = RaycastParams.new();
			v21.FilterType = Enum.RaycastFilterType.Blacklist;
			v21.FilterDescendantsInstances = u6(p2);
			v21.IgnoreWater = false;
			local v22 = workspace:Raycast(v20.Origin, v20.Direction * 1500, v21);
			if v22 then
				local v23 = v22.Position;
			else
				v23 = v20.Origin + v20.Direction * 1500;
			end;
		else
			local v24, v25 = u7:CastWithIgnoreList(u6(p2), true, false);
			_ = v24;
			v23 = v25;
		end;
		local v26 = #turrets;
		local v27, v28, v29 = pairs(turrets);
		while true do
			local v30, v31 = v27(v28, v29);
			if not v30 then
				break;
			end;
			if not v31.Turret then
				v26 = v26 - 1;
				v31:disable();
				u2 = true;
				break;
			end;
			if not v31.Turret:IsDescendantOf(workspace) then
				v26 = v26 - 1;
				v31:disable();
				u2 = true;
				break;
			end;
			local l__Seat__32 = v31.Turret:FindFirstChild("Seat");
			if l__Seat__32 then
				local l__SeatWeld__33 = l__Seat__32:FindFirstChild("SeatWeld");
				if l__SeatWeld__33 then
					local v34 = game.Players:FindFirstChild(l__SeatWeld__33.Part1.Parent.Name);
				else
					v34 = false;
				end;
			else
				v34 = false;
			end;
			if v34 then
				v26 = v26 - 1;
				v31:disable();
			else
				v31:enable();
				v31:aim(v23);
			end;		
		end;
		if v8 and v26 <= 0 then
			u4.unbindEvents();
		elseif v8 then
			u4.bindEvents();
		end;
		task.wait();	
	end;
	for v35, v36 in pairs(turrets) do
		v36:disable();
	end;
	u4.unbindEvents();
	u2 = false;
end;
function v1.StartIndividualTurret(p3)
	u2 = false;
	u4.bindEvents();
	local l__Parent__37 = p3.Parent.Parent.Parent.Parent;
	local v38 = Turret.new(p3);
	v38:enable();
	while not u2 do
		if l__UserInputService__5.TouchEnabled then
			local l__MobileTarget__39 = game.Players.LocalPlayer.PlayerGui.MobileTurretGui.MobileTarget;
			local l__AbsolutePosition__40 = l__MobileTarget__39.AbsolutePosition;
			local l__AbsoluteSize__41 = l__MobileTarget__39.AbsoluteSize;
			local v42 = Vector2.new(l__AbsolutePosition__40.X + l__AbsoluteSize__41.X / 2, l__AbsolutePosition__40.Y + l__AbsoluteSize__41.Y / 2);
			local v43 = workspace.CurrentCamera:ScreenPointToRay(v42.X, v42.Y);
			local v44 = RaycastParams.new();
			v44.FilterType = Enum.RaycastFilterType.Blacklist;
			v44.FilterDescendantsInstances = u6(l__Parent__37);
			v44.IgnoreWater = false;
			local v45 = workspace:Raycast(v43.Origin, v43.Direction * 1500, v44);
			if v45 then
				local v46 = v45.Position;
			else
				v46 = v43.Origin + v43.Direction * 1500;
			end;
		else
			local v47, v48 = u7:CastWithIgnoreList(u6(l__Parent__37), true, false);
			_ = v47;
			v46 = v48;
		end;
		if v46 then
			v38:aim(v46);
		else
			print("no target pos");
		end;
		wait();	
	end;
	v38:disable();
	u4.unbindEvents();
	u2 = false;
end;
function v1.End()
	local l__TouchGui__49 = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui");
	if l__TouchGui__49 then
		local l__DynamicThumbstickFrame__50 = l__TouchGui__49.TouchControlFrame:FindFirstChild("DynamicThumbstickFrame");
		if l__DynamicThumbstickFrame__50 then
			l__DynamicThumbstickFrame__50.Visible = true;
		end;
	end;
	u2 = true;
end;
game.ReplicatedStorage.EventsFolder.Boat.SeatedTurretEvent.OnClientEvent:Connect(function(p4, p5)
	if not p5 then
		v1.End();
		return;
	end;
	v1.StartIndividualTurret(p4);
end);
return v1;
