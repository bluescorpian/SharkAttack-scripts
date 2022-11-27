
-- Decompiled with the Synapse X Luau decompiler.

local l__Buoys__1 = workspace.BuoyContainer.Buoys;
local l__Sharks__2 = workspace.Sharks;
local l__SharkSonarBillboard__1 = game.Players.LocalPlayer.PlayerGui:WaitForChild("SharkSonarBillboard");
local l__TweenService__2 = game:GetService("TweenService");
local u3 = TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
local u4 = {
	Scale = 1
};
local u5 = TweenInfo.new(3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In);
local u6 = {
	ImageTransparency = 1
};
local function pingShark(p1)
	local v4 = Instance.new("Attachment");
	v4.Parent = workspace.Terrain;
	v4.WorldPosition = p1.PrimaryPart.Position;
	local v5 = l__SharkSonarBillboard__1:Clone();
	v5.Enabled = true;
	v5.Adornee = v4;
	v5.Parent = game.Players.LocalPlayer.PlayerGui;
	local v6 = l__TweenService__2:Create(v5.Frame.SonarCircle.UIScale, u3, u4);
	local v7 = l__TweenService__2:Create(v5.Frame.SonarCircle, u5, u6);
	local v8 = l__TweenService__2:Create(v5.Frame.SharkFin, u5, u6);
	v6:Play();
	v7:Play();
	v8:Play();
	v6.Completed:Connect(function()
		if v5 then
			v5:Destroy();
			v4:Destroy();
		end;
	end);
end;
while true do
	task.wait(4);
	if game.Players.LocalPlayer.Team ~= game.Teams.Shark then -- disablable
		local success, v10 = pcall(function() -- checkBuoysFunc
			for v11, buoy in pairs(l__Buoys__1:GetChildren()) do
				local bouyLight = buoy:FindFirstChild("Light");
				if bouyLight and buoy.HasExploded.Value ~= true then
					for v14, v15 in pairs(l__Sharks__2:GetChildren()) do
						local l__PrimaryPart__16 = v15.PrimaryPart;
						if l__PrimaryPart__16 and l__PrimaryPart__16:IsDescendantOf(workspace.Sharks) and (bouyLight.Position - l__PrimaryPart__16.Position).Magnitude < 500 then
							pingShark(v15);
						end;
					end;
				end;
			end;
		end);
		if not success then
			print(v10);
		end;
	end;
end;

