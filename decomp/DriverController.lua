-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local boat = nil;
local u2 = false;
function v1.Start(p1, p2)
	boat = p1;
	u2 = true;
	drive(p2);
end;
function v1.End()
	u2 = false;
end;
local u3 = Vector2.new(0, 0);
function v1.UpdateMoveVector(p3)
	u3 = p3;
end;
local u4 = 0;
function v1.UpdateSubmarineMoveValue(p4)
	u4 = p4;
end;
local u5 = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("Misc").PIDController);
local u6 = require(script.Parent.UI);
local function getConfig()
	local l__Configuration__2 = boat.Configuration;
	local v3 = nil;
	if l__Configuration__2:FindFirstChild("UnderwaterConfigs") then
		v3 = {
			WeightPID = {
				P = l__Configuration__2.UnderwaterConfigs.PIDweight.P.Value, 
				I = l__Configuration__2.UnderwaterConfigs.PIDweight.I.Value, 
				D = l__Configuration__2.UnderwaterConfigs.PIDweight.D.Value, 
				I_MAX = l__Configuration__2.UnderwaterConfigs.PIDweight.I_MAX.Value
			}, 
			ForwardPID = {
				P = l__Configuration__2.UnderwaterConfigs.PIDforward.P.Value, 
				I = l__Configuration__2.UnderwaterConfigs.PIDforward.I.Value, 
				D = l__Configuration__2.UnderwaterConfigs.PIDforward.D.Value, 
				I_MAX = l__Configuration__2.UnderwaterConfigs.PIDforward.I_MAX.Value
			}, 
			SidewayPID = {
				P = l__Configuration__2.UnderwaterConfigs.PIDsideway.P.Value, 
				I = l__Configuration__2.UnderwaterConfigs.PIDsideway.I.Value, 
				D = l__Configuration__2.UnderwaterConfigs.PIDsideway.D.Value, 
				I_MAX = l__Configuration__2.UnderwaterConfigs.PIDsideway.I_MAX.Value
			}
		};
	end;
	return {
		ForwardPID = {
			P = l__Configuration__2.PIDforward.P.Value, 
			I = l__Configuration__2.PIDforward.I.Value, 
			D = l__Configuration__2.PIDforward.D.Value, 
			I_MAX = l__Configuration__2.PIDforward.I_MAX.Value
		}, 
		SidewayPID = {
			P = l__Configuration__2.PIDsideway.P.Value, 
			I = l__Configuration__2.PIDsideway.I.Value, 
			D = l__Configuration__2.PIDsideway.D.Value, 
			I_MAX = l__Configuration__2.PIDsideway.I_MAX.Value
		}
	}, v3;
end;
local u8 = nil;
local u9 = false;
local function u10(p5, p6, p7)
	local l__Value__4 = p5.EngineSound.MinSpeed.Value;
	local v5 = math.clamp(math.abs(p6) / p7, 0, 1);
	local v6 = nil;
	if p5.EngineSound:FindFirstChild("TargetVolume") then
		local l__Value__7 = p5.EngineSound.MinVolume.Value;
		v6 = (p5.EngineSound.MaxVolume.Value - l__Value__7) * v5 + l__Value__7;
	end;
	game.ReplicatedStorage.EventsFolder.Boat.ClientToServer.SetEnginePlaybackSpeed:FireServer(boat, p5.EngineSound, (p5.EngineSound.MaxSpeed.Value - l__Value__4) * v5 + l__Value__4, v6);
end;
local u11 = require(script.Parent.SteeringObjectVisuals);
function drive(p8)
	local l__Configuration__8 = boat.Configuration;
	local l__UnderwaterConfigs__9 = l__Configuration__8:FindFirstChild("UnderwaterConfigs");
	if l__UnderwaterConfigs__9 then
		u6.displayDiveMeter();
	else
		u6.hideDiveMeter();
	end;
	local u12 = u5.new(2000, 4000, 50, 280);
	local u13 = u5.new(1000, 2000, 10, 280);
	local u14 = u5.new(0, 0, 0, 0);
	local u15 = u5.new(0, 0, 0, 0);
	local u16 = u5.new(0, 0, 0, 0);
	local l__Value__17 = l__Configuration__8.Engine.EngineCutOutHeight.Value;
	local MaxSpeed = l__Configuration__8.Engine.MaxSpeed;
	local MaxRotVel = l__Configuration__8.Engine.MaxRotVel;
	coroutine.wrap(function()
		local l__Engines__10 = boat.Engines;
		while true do
			if u2 then

			else
				break;
			end;
			if not boat:IsDescendantOf(workspace) then
				u2 = false;
				return;
			end;
			local config, v12 = getConfig();
			u12:changePID(config.ForwardPID.P, config.ForwardPID.I, config.ForwardPID.D, config.ForwardPID.I_MAX);
			u13:changePID(config.SidewayPID.P, config.SidewayPID.I, config.SidewayPID.D, config.SidewayPID.I_MAX);
			if l__UnderwaterConfigs__9 then
				u14:changePID(v12.WeightPID.P, v12.WeightPID.I, v12.WeightPID.D, v12.WeightPID.I_MAX);
				u15:changePID(v12.ForwardPID.P, v12.ForwardPID.I, v12.ForwardPID.D, v12.ForwardPID.I_MAX);
				u16:changePID(v12.SidewayPID.P, v12.SidewayPID.I, v12.SidewayPID.D, v12.SidewayPID.I_MAX);
				local l__Engine__13 = l__Engines__10:FindFirstChild("Engine");
				if l__Engine__13 then
					local l__Y__14 = l__Engine__13.Position.Y;
					if u8 == nil then
						u8 = l__Y__14;
					end;
					u8 = math.clamp(u8 + u4, -260, 0);
					local v15 = math.max(0, u14:getOutput(u8, l__Y__14));
					u6.adjustSubDiveMeter(u8, l__Y__14);
					if not false then
						if u4 == 0 then
							boat.Body.Weights.SubmarineWeight.CustomPhysicalProperties = PhysicalProperties.new(0, 1, 1);
						else
							boat.Body.Weights.SubmarineWeight.CustomPhysicalProperties = PhysicalProperties.new(v15, 1, 1);
						end;
					else
						boat.Body.Weights.SubmarineWeight.CustomPhysicalProperties = PhysicalProperties.new(v15, 1, 1);
					end;
				end;
			end;
			if false then
				local v16 = u15;
				local v17 = u16;
				local l__Engine__18 = l__Engines__10:FindFirstChild("Engine");
				if l__Engine__18 then
					l__Engine__18.BodyGyro.MaxTorque = Vector3.new(80, 0, 80);
				end;
			else
				v16 = u12;
				v17 = u13;
				local l__Engine__19 = l__Engines__10:FindFirstChild("Engine");
				if l__Engine__19 then
					if l__Engine__19:FindFirstChild("BodyGyro") then
						l__Engine__19.BodyGyro.MaxTorque = Vector3.new(5, 0, 5);
					end;
				end;
			end;
			local v20, v21, v22 = pairs(l__Engines__10:GetChildren());
			while true do
				local v23, v24 = v20(v21, v22);
				if v23 then

				else
					break;
				end;
				local v25 = v24.CFrame:VectorToObjectSpace(v24.AssemblyAngularVelocity);
				local v26 = -v24.CFrame:VectorToObjectSpace(v24.Velocity).Z;
				local l__Y__27 = v25.Y;
				if v24.Position.Y < l__Value__17 then
					local v28 = MaxSpeed.Value * u3.Y;
					local v29 = v16:getOutput(v28, v26);
					u15:getOutput(v28, v26);
					u12:getOutput(v28, v26);
					if u3.Y ~= 0 then
						game.ReplicatedStorage.EventsFolder.Boat.ClientToServer.SprayRemote:FireServer(boat, true);
					else
						game.ReplicatedStorage.EventsFolder.Boat.ClientToServer.SprayRemote:FireServer(boat, false);
					end;
				else
					v16:getOutput(0, v26, true);
					v29 = 0;
				end;
				if v24.Position.Y < l__Value__17 then
					local v30 = math.clamp(MaxRotVel.Value, MaxRotVel.Value, 100) * u3.X;
					local v31 = v17:getOutput(v30, l__Y__27);
					u13:getOutput(v30, l__Y__27);
					u16:getOutput(v30, l__Y__27);
				else
					v17:getOutput(0, l__Y__27, true);
					v31 = 0;
				end;
				local l__VehicleSeat__32 = boat.Seats:FindFirstChild("VehicleSeat");
				if l__VehicleSeat__32 then
					local v33 = l__VehicleSeat__32:GetAttribute("NetworkOwnerName");
				else
					v33 = nil;
				end;
				if v33 == game.Players.LocalPlayer.Name then
					v24.ForwardForce.Force = Vector3.new(0, 0, v29);
					v24.Torque.Torque = Vector3.new(0, v31, 0);
					u9 = false;
				else
					local v34 = false;
					if not u9 then
						v34 = true;
					end;
					u9 = true;
					game.ReplicatedStorage.EventsFolder.Boat.Movement.BoatEnginesEvent:FireServer(v24, v29, v31, v34);
				end;
				u10(v24, v26, MaxSpeed.Value);
				u6.adjustSpeedo(v26, MaxSpeed.Value);
				u11.updateVisual(boat, l__Y__27);			
			end;
			wait();		
		end;
		u8 = nil;
		local v35, v36, v37 = pairs(l__Engines__10:GetChildren());
		while true do
			local v38, v39 = v35(v36, v37);
			if v38 then

			else
				break;
			end;
			v37 = v38;
			v39.ForwardForce.Force = Vector3.new(0, 0, 0);
			v39.Torque.Torque = Vector3.new(0, 0, 0);
			v39.EngineSound.TargetPlaybackSpeed.Value = 0;
			game.ReplicatedStorage.EventsFolder.Boat.Movement.BoatEnginesStopEvent:FireServer(v39);		
		end;
		if l__UnderwaterConfigs__9 then
			local l__Weights__40 = boat.Body:FindFirstChild("Weights");
			if l__Weights__40 then
				local l__SubmarineWeight__41 = l__Weights__40:FindFirstChild("SubmarineWeight");
				if l__SubmarineWeight__41 then
					game.ReplicatedStorage.EventsFolder.Boat.ClientToServer.SubmarineWeight:FireServer(boat, l__SubmarineWeight__41.CustomPhysicalProperties.Density);
				end;
			end;
		end;
	end)();
end;
return v1;
