-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = false;
local u2 = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("ProjectilesClient").WeaponScript.WeaponUIModule);
local u3 = {};
local l__UserInputService__4 = game:GetService("UserInputService");
local l__ContextActionService__5 = game:GetService("ContextActionService");
local u6 = {};
function v1.bindEvents()
	if u1 then
		return;
	end;
	u1 = true;
	u2.enableCorrectUIForSeat();
	game.Players.LocalPlayer.PlayerGui.DebugHelp.Frame.TurretCount.Text = "Turret # " .. #u3;
	if l__UserInputService__4.TouchEnabled then
		game.Players.LocalPlayer.PlayerGui.MobileTurretGui.Enabled = true;
	end;
	l__ContextActionService__5:BindActionAtPriority("FireTurret", function(p1, p2, p3)
		fireWeaponFunc(p1, p2);
	end, false, 50, Enum.UserInputType.MouseButton1);
	local l__ShootButton__2 = game.Players.LocalPlayer.PlayerGui.MobileTurretGui.BoatShootButtons.Buttons.ShootButton;
	u6 = { l__ShootButton__2.InputBegan:Connect(function()
			fireWeaponFunc(nil, Enum.UserInputState.Begin);
		end), (l__ShootButton__2.InputEnded:Connect(function()
			fireWeaponFunc(nil, Enum.UserInputState.End);
		end)) };
end;
function v1.unbindEvents()
	if not u1 then
		return;
	end;
	u1 = false;
	l__ContextActionService__5:UnbindAction("FireTurret");
	for v3, v4 in pairs(u6) do
		v4:Disconnect();
	end;
	u6 = {};
	u2.enableCorrectUIForSeat();
	game.Players.LocalPlayer.PlayerGui.MobileTurretGui.Enabled = false;
	game.Players.LocalPlayer.PlayerGui.DebugHelp.Frame.TurretCount.Text = "Turret # " .. #u3;
end;
function v1.addTurret(p4)
	local v5, v6, v7 = pairs(u3);
	while true do
		local v8, v9 = v5(v6, v7);
		if not v8 then
			local v10 = false;
			break;
		end;
		v7 = v8;
		if p4 == v9[1] then
			v10 = true;
			break;
		end;	
	end;
	if v10 then
		return;
	end;
	table.insert(u3, { p4, false });
end;
local u7 = require(script.Parent.HitScanFireTurret);
function v1.removeTurret(p5)
	for v11 = 1, #u3 do
		if u3[v11][1] == p5 then
			u7.turretRemoved(u3[v11][1]);
			table.remove(u3, v11);
			return;
		end;
	end;
end;
local u8 = require(game.ReplicatedStorage.Projectiles.TurretStatsModule);
local u9 = require(script.Parent.ProjectileFireTurret);
function fireWeaponFunc(p6, p7)
	game.Players.LocalPlayer.PlayerGui.DebugHelp.Frame.TurretCount.Text = "Turret # " .. #u3;
	local v12, v13, v14 = pairs(u3);
	while true do
		local v15, v16 = v12(v13, v14);
		if v15 then

		else
			break;
		end;
		v14 = v15;
		local v17 = v16[1];
		local v18 = v16[2];
		if u8.get()[v17.Name].Mode == 5 then
			if v18 == false then
				if p7 == Enum.UserInputState.Begin then
					if v18 == false then
						v16[2] = true;
						u9.fire(v17);
					end;
				end;
			elseif p7 == Enum.UserInputState.Begin then
				if v18 == false then
					v16[2] = true;
					u7.Fire(v17);
				elseif p7 == Enum.UserInputState.End then
					v16[2] = false;
					u7.Stop(v17);
				end;
			elseif p7 == Enum.UserInputState.End then
				v16[2] = false;
				u7.Stop(v17);
			end;
		elseif p7 == Enum.UserInputState.Begin then
			if v18 == false then
				v16[2] = true;
				u7.Fire(v17);
			elseif p7 == Enum.UserInputState.End then
				v16[2] = false;
				u7.Stop(v17);
			end;
		elseif p7 == Enum.UserInputState.End then
			v16[2] = false;
			u7.Stop(v17);
		end;	
	end;
end;
return v1;
