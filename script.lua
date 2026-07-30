-- LANG SKIE STORE HUB - Textdraw Edition

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local virtualUser = game:GetService("VirtualUser")
local players = game:GetService("Players")

-- ==========================================
-- TEXTDRAW UI (Ringan)
-- ==========================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = coreGui
screenGui.Name = "LSS_Gui"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 280)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.Text = "LANG SKIE STORE"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 14
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -25, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

-- Tombol kecil
local row = 0
local col = 0
local maxCol = 2

local function createBtn(text, color, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 0, 28)
    btn.Position = UDim2.new(0, 5 + (col * 90), 0, 5 + (row * 34))
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(cb)
    col = col + 1
    if col >= maxCol then
        col = 0
        row = row + 1
    end
    return btn
end

-- Variabel fitur
local espEnabled = false
local espObjects = {}
local flyEnabled = false
local flyBV = nil
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false
local godModeEnabled = false
local oneHitEnabled = false
local farmEnabled = false
local farmTarget = nil
local attackCooldown = 0

-- Fungsi serang
local function doAttack(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    virtualUser:ClickButton2(Vector2.new())
    local tool = character:FindFirstChildWhichIsA("Tool")
    if tool then
        tool:Activate()
        local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Activate")
        if remote and remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer(target.HumanoidRootPart.Position) end)
        end
    end
    for _, remote in ipairs(character:GetDescendants()) do
        if remote:IsA("RemoteEvent") and remote.Name:lower():find("attack") then
            pcall(function() remote:FireServer(target.HumanoidRootPart.Position) end)
        end
    end
end

-- Fungsi cari NPC
local function findNearestNPC()
    local nearest = nil
    local dist = math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            if obj ~= character and not players:FindFirstChild(obj.Name) then
                if obj.Humanoid.Health > 0 then
                    local mag = (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if mag < dist and mag < 150 then
                        dist = mag
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest
end

-- Tombol
createBtn("ESP", Color3.fromRGB(40, 80, 200), function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in ipairs(players:GetPlayers()) do
            if plr ~= player then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local esp = Instance.new("BillboardGui")
                    esp.Size = UDim2.new(0, 120, 0, 30)
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

createBtn("Fly", Color3.fromRGB(40, 180, 200), function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        humanoid.PlatformStand = true
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = rootPart
    else
        humanoid.PlatformStand = false
        if flyBV then flyBV:Destroy() end
    end
end)

createBtn("Speed", Color3.fromRGB(40, 200, 80), function()
    speedEnabled = not speedEnabled
    humanoid.WalkSpeed = speedEnabled and 50 or 16
end)

createBtn("Jump", Color3.fromRGB(200, 200, 40), function()
    jumpEnabled = not jumpEnabled
end)

createBtn("Noclip", Color3.fromRGB(200, 80, 40), function()
    noclipEnabled = not noclipEnabled
end)

createBtn("Farm", Color3.fromRGB(255, 150, 50), function()
    farmEnabled = not farmEnabled
    if farmEnabled then
        farmTarget = findNearestNPC()
        godModeEnabled = true
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    else
        farmTarget = nil
        godModeEnabled = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
    end
end)

createBtn("GodMode", Color3.fromRGB(200, 200, 50), function()
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
    end
end)

createBtn("OneHit", Color3.fromRGB(255, 0, 0), function()
    oneHitEnabled = not oneHitEnabled
end)

createBtn("Teleport", Color3.fromRGB(40, 80, 200), function()
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if spawn then
        rootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
    end
end)

-- ==========================================
-- LOOP
-- ==========================================

runService.Heartbeat:Connect(function()
    -- Fly
    if flyEnabled and flyBV then
        local moveDir = Vector3.new(0, 0, 0)
        local cam = workspace.CurrentCamera
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * 50
        end
        flyBV.Velocity = moveDir
    end
    
    -- Noclip
    if noclipEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
    end
    
    -- GodMode
    if godModeEnabled then
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    
    -- OneHit
    if oneHitEnabled then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= character then
                if obj.Humanoid.Health > 0 and (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude < 30 then
                    obj.Humanoid.Health = 0
                end
            end
        end
    end
    
    -- Farm
    if farmEnabled then
        humanoid.Health = humanoid.MaxHealth
        if not farmTarget or not farmTarget:FindFirstChild("Humanoid") or farmTarget.Humanoid.Health <= 0 then
            farmTarget = findNearestNPC()
        end
        if farmTarget and farmTarget:FindFirstChild("HumanoidRootPart") then
            local targetPos = farmTarget.HumanoidRootPart.Position
            local distance = (targetPos - rootPart.Position).Magnitude
            if distance > 5 then
                rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 4, 0))
            end
            attackCooldown = attackCooldown - 0.05
            if attackCooldown <= 0 then
                doAttack(farmTarget)
                attackCooldown = 0.15
            end
        end
    end
end)

-- Jump
userInputService.JumpRequest:Connect(function()
    if jumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        return true
    end
end)

-- Anti-AFK
player.Idled:Connect(function()
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new())
end)

print("LANG SKIE STORE HUB - Textdraw Edition Loaded!")
