-- LANG SKIE STORE HUB - Auto Farm Fix (No Damage from NPC)

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
-- HITBOX MANIPULATION (Biarpun Kena Hit, Gak Damage)
-- ==========================================

local function protectFromDamage()
    -- Method 1: Force Health ke Max
    humanoid.Health = humanoid.MaxHealth
    
    -- Method 2: Disable dead state
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    
    -- Method 3: Pindahin hitbox ke atas (di atas NPC)
    rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 500, 0)
    wait(0.05)
    rootPart.CFrame = rootPart.CFrame - Vector3.new(0, 500, 0)
end

-- Loop buat protection tiap frame
runService.Heartbeat:Connect(function()
    if farmEnabled then
        -- Force health max
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
end)

-- ==========================================
-- GUI LANG SKIE STORE
-- ==========================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = coreGui
screenGui.Name = "LSS_Gui"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Background
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "https://i.imgur.com/your-image.jpg"
bg.ScaleType = Enum.ScaleType.Fit
bg.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BackgroundTransparency = 0.5
titleBar.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 20, 0, 20)
logo.Position = UDim2.new(0, 5, 0, 4)
logo.BackgroundTransparency = 1
logo.Image = "https://i.imgur.com/your-logo.png"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 28)
title.Position = UDim2.new(0, 28, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LANG SKIE STORE"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minimized = false
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
minimizeBtn.Position = UDim2.new(1, -52, 0, 3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Parent = titleBar
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 300, 0, 28)
        minimizeBtn.Text = "+"
        scrollFrame.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 300, 0, 220)
        minimizeBtn.Text = "−"
        scrollFrame.Visible = true
    end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -26, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 32)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
scrollFrame.Parent = mainFrame

-- ==========================================
-- AUTO FARM (Normal, Tanpa Jarak Jauh)
-- ==========================================

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

-- Fungsi cari NPC terdekat
local function findNearestNPC()
    local nearest = nil
    local dist = math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            if obj ~= character and not players:FindFirstChild(obj.Name) then
                if obj.Humanoid.Health > 0 then
                    local mag = (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if mag < dist and mag < 100 then
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
local row = 0
local col = 0
local maxCol = 3

local function createBtn(text, color, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 88, 0, 30)
    btn.Position = UDim2.new(0, 5 + (col * 93), 0, 5 + (row * 36))
    btn.BackgroundColor3 = color or Color3.fromRGB(55, 55, 75)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(cb)
    col = col + 1
    if col >= maxCol then
        col = 0
        row = row + 1
    end
    return btn
end

-- ====== AUTO FARM ======
createBtn("Auto Farm", Color3.fromRGB(255, 150, 50), function()
    farmEnabled = not farmEnabled
    if farmEnabled then
        farmTarget = findNearestNPC()
        -- Aktifkan protection
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        print("[Auto Farm] ON - Target: " .. (farmTarget and farmTarget.Name or "None"))
    else
        farmTarget = nil
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        print("[Auto Farm] OFF")
    end
end)

createBtn("Fly", Color3.fromRGB(40, 180, 200), function()
    if flyEnabled then
        flyEnabled = false
        humanoid.PlatformStand = false
        if flyBV then flyBV:Destroy() end
    else
        flyEnabled = true
        humanoid.PlatformStand = true
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = rootPart
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
-- FLY VARIABLE
-- ==========================================
local flyEnabled = false
local flyBV = nil
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false
local godModeEnabled = false
local oneHitEnabled = false

-- ==========================================
-- LOOP UTAMA
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
    
    -- ===== AUTO FARM (Normal) + Protection =====
    if farmEnabled then
        -- Protection: Health selalu max
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        -- Cari target baru
        if not farmTarget or not farmTarget:FindFirstChild("Humanoid") or farmTarget.Humanoid.Health <= 0 then
            farmTarget = findNearestNPC()
        end
        
        if farmTarget and farmTarget:FindFirstChild("HumanoidRootPart") then
            local targetPos = farmTarget.HumanoidRootPart.Position
            local myPos = rootPart.Position
            local distance = (targetPos - myPos).Magnitude
            
            -- Teleport ke target (di atas)
            if distance > 5 then
                rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
            end
            
            -- Serang
            attackCooldown = attackCooldown - 0.05
            if attackCooldown <= 0 then
                doAttack(farmTarget)
                attackCooldown = 0.2
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

print("LANG SKIE STORE HUB - Auto Farm Fix (No Damage) Loaded!")
