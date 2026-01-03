local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local savedCFrame = nil
local tpEnabled = false
local godModeEnabled = false

local function antiKick()
    local getconnections = getconnections or function() return {} end
    for _,v in pairs(getconnections(LocalPlayer.Idled)) do
        v:Disable()
    end
    game:GetService("ScriptContext").Error:Connect(function() return end)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" or method == "Kicked" or method == "kicked" then
            return nil
        end
        return old(self, ...)
    end)
end
antiKick()

local function activateGodMode()
    local getconnections = getconnections
    local godConnections = {}
    local godHeartbeat

    local function apply(character)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        humanoid.BreakJointsOnDeath = false
        humanoid.RequiresNeck = false
        if getconnections then
            for _, connection in ipairs(getconnections(humanoid.Died)) do
                connection:Disable()
                table.insert(godConnections, connection)
            end
        end
        table.insert(godConnections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end))
        godHeartbeat = RunService.Heartbeat:Connect(function()
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    apply(char)
    table.insert(godConnections, LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        apply(character)
    end))
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NorrysHud"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui) 
    ScreenGui.Parent = CoreGui 
elseif gethui then 
    ScreenGui.Parent = gethui() 
else 
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
end

local Colors = {
    MainBg = Color3.fromRGB(20, 20, 25),
    Stroke = Color3.fromRGB(50, 50, 60),
    Accent = Color3.fromRGB(60, 140, 220),
    Red = Color3.fromRGB(220, 60, 60),
    CloseRed = Color3.fromRGB(200, 40, 40),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 160)
}

local ShadowImage = "rbxassetid://6015897843"

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.MainBg
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -130)
MainFrame.Size = UDim2.new(0, 260, 0, 260)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 3

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Colors.Stroke
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 2
Shadow.Image = ShadowImage
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.4
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 40)
Header.ZIndex = 3

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Text = "INSTANT STEAL"
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Colors.Text
Title.TextSize = 15
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Colors.CloseRed
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -12)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 18
CloseBtn.AutoButtonColor = true
CloseBtn.ZIndex = 3
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = Header
MinBtn.BackgroundColor3 = Colors.Stroke
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -64, 0.5, -12)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.TextSize = 18
MinBtn.AutoButtonColor = true
MinBtn.ZIndex = 1
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local Container = Instance.new("Frame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 16, 0, 45)
Container.Size = UDim2.new(1, -32, 1, -50)
Container.ZIndex = 3

local StatsFrame = Instance.new("Frame")
StatsFrame.Parent = Container
StatsFrame.BackgroundTransparency = 1
StatsFrame.Size = UDim2.new(1, 0, 0, 20)
StatsFrame.ZIndex = 3

local PingLbl = Instance.new("TextLabel")
PingLbl.Parent = StatsFrame
PingLbl.BackgroundTransparency = 1
PingLbl.Size = UDim2.new(0.5, 0, 1, 0)
PingLbl.Font = Enum.Font.GothamBold
PingLbl.TextColor3 = Colors.TextDim
PingLbl.TextSize = 11
PingLbl.TextXAlignment = Enum.TextXAlignment.Left
PingLbl.Text = "PING: 0ms"
PingLbl.ZIndex = 3

local FPSLbl = Instance.new("TextLabel")
FPSLbl.Parent = StatsFrame
FPSLbl.BackgroundTransparency = 1
FPSLbl.Position = UDim2.new(0.5, 0, 0, 0)
FPSLbl.Size = UDim2.new(0.5, 0, 1, 0)
FPSLbl.Font = Enum.Font.GothamBold
FPSLbl.TextColor3 = Colors.TextDim
FPSLbl.TextSize = 11
FPSLbl.TextXAlignment = Enum.TextXAlignment.Right
FPSLbl.Text = "FPS: 0"
FPSLbl.ZIndex = 3

local Divider = Instance.new("Frame")
Divider.Parent = Container
Divider.BackgroundColor3 = Colors.Stroke
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 0, 0, 25)
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.ZIndex = 3

local ButtonList = Instance.new("Frame")
ButtonList.Parent = Container
ButtonList.BackgroundTransparency = 1
ButtonList.Position = UDim2.new(0, 0, 0, 36)
ButtonList.Size = UDim2.new(1, 0, 1, -55)
ButtonList.ZIndex = 3

local UIList = Instance.new("UIListLayout")
UIList.Parent = ButtonList
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

local function CreateBtn(text, color, order)
    local btn = Instance.new("TextButton")
    btn.Parent = ButtonList
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.new(1,1,1)
    s.Transparency = 0.9
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    
    return btn
end

local SetBtn = CreateBtn("Set Checkpoint", Color3.fromRGB(50, 50, 55), 1)
local TpBtn = CreateBtn("TP: OFF", Color3.fromRGB(70, 70, 75), 2)
local DesyncBtn = CreateBtn("Desync", Colors.Red, 3)

local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Font = Enum.Font.GothamMedium
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.TextSize = 10
Footer.Text = "Requires: Flying Carpet / Witch Broom / Santa Sleigh"
Footer.ZIndex = 3

local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local minimized = false
local normalSize = UDim2.new(0, 260, 0, 260)
local miniSize = UDim2.new(0, 260, 0, 40)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        Container.Visible = false
        Footer.Visible = false

        TweenService:Create(
            MainFrame,
            TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Size = miniSize }
        ):Play()
    else
        Container.Visible = true
        Footer.Visible = true

        TweenService:Create(
            MainFrame,
            TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Size = normalSize }
        ):Play()
    end
end)

RunService.RenderStepped:Connect(function(dt)
    FPSLbl.Text = "FPS: " .. math.floor(1/dt)
    local ping = 0
    pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    PingLbl.Text = "PING: " .. ping .. "ms"
end)

SetBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        savedCFrame = char:GetPivot()
        SetBtn.Text = "Set Checkpoint"
        SetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        task.wait(0.1)
        SetBtn.Text = "Set Checkpoint"
        SetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end
end)

TpBtn.MouseButton1Click:Connect(function()
    tpEnabled = not tpEnabled
    if tpEnabled then
        TpBtn.Text = "TP: ON"
        TpBtn.BackgroundColor3 = Colors.Accent
    else
        TpBtn.Text = "TP: OFF"
        TpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end
end)

DesyncBtn.MouseButton1Click:Connect(function()
    local flags = {
        {"GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000"},
        {"LargeReplicatorWrite5", "true"},
        {"LargeReplicatorEnabled9", "true"},
        {"AngularVelociryLimit", "360"},
        {"TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646"},
        {"S2PhysicsSenderRate", "15000"},
        {"DisableDPIScale", "true"},
        {"MaxDataPacketPerSend", "2147483647"},
        {"ServerMaxBandwith", "52"},
        {"PhysicsSenderMaxBandwidthBps", "20000"},
        {"MaxTimestepMultiplierBuoyancy", "2147483647"},
        {"SimOwnedNOUCountThresholdMillionth", "2147483647"},
        {"MaxMissedWorldStepsRemembered", "-2147483648"},
        {"CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "1"},
        {"StreamJobNOUVolumeLengthCap", "2147483647"},
        {"DebugSendDistInSteps", "-2147483648"},
        {"MaxTimestepMultiplierAcceleration", "2147483647"},
        {"LargeReplicatorRead5", "true"},
        {"SimExplicitlyCappedTimestepMultiplier", "2147483646"},
        {"GameNetDontSendRedundantNumTimes", "1"},
        {"CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1"},
        {"CheckPVCachedRotVelThresholdPercent", "10"},
        {"LargeReplicatorSerializeRead3", "true"},
        {"ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "2147483647"},
        {"NextGenReplicatorEnabledWrite4", "true"},
        {"CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "1"},
        {"GameNetDontSendRedundantDeltaPositionMillionth", "1"},
        {"InterpolationFrameVelocityThresholdMillionth", "5"},
        {"StreamJobNOUVolumeCap", "2147483647"},
        {"InterpolationFrameRotVelocityThresholdMillionth", "5"},
        {"WorldStepMax", "30"},
        {"TimestepArbiterHumanoidLinearVelThreshold", "1"},
        {"InterpolationFramePositionThresholdMillionth", "5"},
        {"TimestepArbiterHumanoidTurningVelThreshold", "1"},
        {"MaxTimestepMultiplierContstraint", "2147483647"},
        {"GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000"},
        {"CheckPVCachedVelThresholdPercent", "10"},
        {"TimestepArbiterOmegaThou", "1073741823"},
        {"MaxAcceptableUpdateDelay", "1"},
        {"LargeReplicatorSerializeWrite4", "true"},
    }

    DesyncBtn.Text = "Desyinc..."
    for _, data in ipairs(flags) do
        pcall(function()
            if setfflag then setfflag(data[1], data[2]) end
        end)
    end

    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Dead) end
        char:ClearAllChildren()
        local fakeModel = Instance.new("Model", workspace)
        LocalPlayer.Character = fakeModel
        task.wait()
        LocalPlayer.Character = char
        fakeModel:Destroy()
    end
    
    task.wait(2)
    DesyncBtn.Text = "Desync"
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, who)
    if who ~= LocalPlayer then return end
    if not tpEnabled or not savedCFrame then return end

    if prompt.Name == "Steal" or prompt.ActionText == "Steal" then
        local char = LocalPlayer.Character
        if char then
            char:PivotTo(savedCFrame)
            if char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                char.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
            end
            if not godModeEnabled then
                godModeEnabled = true
                activateGodMode()
                local originalColor = MainFrame.BackgroundColor3
                TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(40, 80, 40)}):Play()
                task.wait(0.5)
                TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundColor3 = originalColor}):Play()
            end
        end
    end
end)
