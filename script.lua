-- Delta Script v4.0 - Blox Fruit Edition

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Compact Landscape
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 280)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Minimize button
local minimized = false
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 16
minimizeBtn.Parent = mainFrame
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 520, 0, 35)
        minimizeBtn.Text = "+"
        scrollFrame.Visible = false
        tabFrame.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 520, 0, 280)
        minimizeBtn.Text = "−"
        scrollFrame.Visible = true
        tabFrame.Visible = true
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Title dengan logo LANG SKIE STORE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 25)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "LANG SKIE STORE | Delta v4.0"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -70, 0, 15)
subtitle.Position = UDim2.new(0, 10, 0, 22)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Blox Fruit | Roblox"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = mainFrame

-- Tab buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 25)
tabFrame.Position = UDim2.new(0, 5, 0, 35)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local currentTab = "Main"

local function createTab(text, xPos)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 80, 0, 22)
    tab.Position = UDim2.new(0, xPos, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    tab.Text = text
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.TextSize = 12
    tab.Parent = tabFrame
    return tab
end

local tabMain = createTab("Main", 5)
local tabFarm = createTab("Farm", 90)
local tabCombat = createTab("Combat", 175)
local tabTeleport = createTab("Teleport", 260)

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 0, 190)
scrollFrame.Position = UDim2.new(0, 5, 0, 65)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
scrollFrame.Parent = mainFrame

local row = 0
local col = 0
local maxCol = 4

local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 115, 0, 30)
    btn.Position = UDim2.new(0, 5 + (col * 122), 0, 5 + (row * 35))
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(callback)
    
    col = col + 1
    if col >= maxCol then
        col = 0
        row = row + 1
    end
    return btn
end

local function resetGrid()
    row = 0
    col = 0
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- Variabel global untuk fitur
local espEnabled = false
local espObjects = {}
local flyEnabled = false
local flySpeed = 50
local flyBodyVelocity = nil
local speedEnabled = false
local speedAmount = 50
local jumpEnabled = false
local noclipEnabled = false
local farmEnabled = false
local farmTarget = nil
local godModeEnabled = false
local oneHitEnabled = false

local function showMainTab()
    resetGrid()
    
    createButton("ESP", Color3.fromRGB(40, 80, 200), function()
        espEnabled = not espEnabled
        if espEnabled then
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= player then
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local esp = Instance.new("BillboardGui")
                        esp.Size = UDim2.new(0, 150, 0, 40)
                        esp.AlwaysOnTop = true
                        esp.Parent = char.HumanoidRootPart
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = plr.Name
                        label.TextColor3 = Color3.fromRGB(255, 50, 50)
                        label.TextScaled = true
                        label.Parent = esp
                        table.insert(espObjects, esp)
                    end
                end
            end
        else
            for _, esp in ipairs(espObjects) do
                esp:Destroy()
            end
            espObjects = {}
        end
    end)
    
    createButton("Fly", Color3.fromRGB(40, 180, 200), function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            humanoid.PlatformStand = true
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.Parent = rootPart
        else
            humanoid.PlatformStand = false
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
        end
    end)
    
    createButton("Speed", Color3.fromRGB(40, 200, 80), function()
        speedEnabled = not speedEnabled
        if speedEnabled then
            humanoid.WalkSpeed = speedAmount
        else
            humanoid.WalkSpeed = 16
        end
    end)
    
    createButton("Jump", Color3.fromRGB(200, 200, 40), function()
        jumpEnabled = not jumpEnabled
    end)
    
    createButton("Noclip", Color3.fromRGB(200, 80, 40), function()
        noclipEnabled = not noclipEnabled
    end)
    
    createButton("Anti-AFK", Color3.fromRGB(100, 100, 200), function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end)
    
    if row > 0 then
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (row * 35) + 10)
    end
end

local function showFarmTab()
    resetGrid()
    
    createButton("Auto Farm", Color3.fromRGB(200, 120, 40), function()
        farmEnabled = not farmEnabled
        if farmEnabled then
            local nearest = nil
            local dist = math.huge
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                    local mag = (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        nearest = obj
                    end
                end
            end
            farmTarget = nearest
        else
            farmTarget = nil
        end
    end)
    
    createButton("Farm Boss", Color3.fromRGB(200, 50, 50), function()
        -- Cari boss terdekat
    end)
    
    createButton("Auto Fruit", Color3.fromRGB(200, 100, 200), function()
        -- Auto collect devil fruit
    end)
    
    createButton("Farm Mastery", Color3.fromRGB(100, 200, 100), function()
        -- Auto farm mastery
    end)
    
    createButton("Auto Raid", Color3.fromRGB(200, 150, 50), function()
        -- Auto raid
    end)
    
    if row > 0 then
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (row * 35) + 10)
    end
end

local function showCombatTab()
    resetGrid()
    
    createButton("Auto Attack", Color3.fromRGB(200, 50, 50), function()
        -- Auto attack nearest enemy
    end)
    
    createButton("Auto Dodge", Color3.fromRGB(50, 200, 200), function()
        -- Auto dodge
    end)
    
    createButton("Aimbot", Color3.fromRGB(200, 50, 200), function()
        -- Aimbot
    end)
    
    createButton("God Mode", Color3.fromRGB(200, 200, 50), function()
        godModeEnabled = not godModeEnabled
        if godModeEnabled then
            humanoid.Health = humanoid.MaxHealth
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end)
    
    createButton("One Hit", Color3.fromRGB(255, 0, 0), function()
        oneHitEnabled = not oneHitEnabled
    end)
    
    if row > 0 then
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (row * 35) + 10)
    end
end

local function showTeleportTab()
    resetGrid()
    
    createButton("Spawn", Color3.fromRGB(40, 80, 200), function()
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn then
            rootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        else
            rootPart.CFrame = CFrame.new(0, 10, 0)
        end
    end)
    
    createButton("Island", Color3.fromRGB(40, 200, 80), function()
        -- Teleport to nearest island
    end)
    
    createButton("NPC", Color3.fromRGB(200, 120, 40), function()
        -- Teleport to nearest NPC
    end)
    
    createButton("Fruit", Color3.fromRGB(200, 40, 200), function()
        -- Teleport to nearest fruit
    end)
    
    createButton("Chest", Color3.fromRGB(200, 200, 40), function()
        -- Teleport to nearest chest
    end)
    
    if row > 0 then
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (row * 35) + 10)
    end
end

-- Tab switching
tabMain.MouseButton1Click:Connect(function()
    currentTab = "Main"
    showMainTab()
end)

tabFarm.MouseButton1Click:Connect(function()
    currentTab = "Farm"
    showFarmTab()
end)

tabCombat.MouseButton1Click:Connect(function()
    currentTab = "Combat"
    showCombatTab()
end)

tabTeleport.MouseButton1Click:Connect(function()
    currentTab = "Teleport"
    showTeleportTab()
end)

-- Load default tab
showMainTab()

-- Loop untuk semua fitur
game:GetService("RunService").Heartbeat:Connect(function()
    -- Fly
    if flyEnabled and flyBodyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector * Vector3.new(1, 0, 1)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector * Vector3.new(1, 0, 1)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
        end
        flyBodyVelocity.Velocity = moveDir
    end
    
    -- Noclip
    if noclipEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
    end
    
    -- Auto Farm
    if farmEnabled and farmTarget and farmTarget:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = farmTarget.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        wait(0.1)
        farmTarget = nil
        farmEnabled = false
    end
    
    -- God Mode
    if godModeEnabled then
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    
    -- One Hit Kill
    if oneHitEnabled then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= character then
                if (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude < 20 then
                    obj.Humanoid.Health = 0
                end
            end
        end
    end
end)

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if jumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        return true
    end
end)

print("LANG SKIE STORE | Delta v4.0 Loaded!")
