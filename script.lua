-- LANG SKIE STORE HUB - Safe Farm Edition

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local virtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")

-- GUI Mini LANG SKIE STORE
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = coreGui
screenGui.Name = "LSS_Gui"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 220)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
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
        mainFrame.Size = UDim2.new(0, 280, 0, 28)
        minimizeBtn.Text = "+"
        scrollFrame.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 280, 0, 220)
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
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
scrollFrame.Parent = mainFrame

-- ======================
-- FITUR SAFE FARM
-- ======================

-- Variabel
local espEnabled = false
local espObjects = {}
local flyEnabled = false
local flyBV = nil
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false
local godModeEnabled = false
local oneHitEnabled = false

-- VARIABEL SAFE FARM
local safeFarmEnabled = false
local farmTarget = nil
local safeDistance = 30 -- Jarak aman (diatur)
local attackCooldown = 0

-- Fungsi serang jarak jauh
local function attackTarget(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    -- Coba pake tool/weapon yang dipegang
    local tool = character:FindFirstChildWhichIsA("Tool")
    if tool then
        -- Aktifkan tool
        tool:Activate()
        wait(0.05)
        -- Coba panggil remote event untuk serang
        local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Activate")
        if remote then
            pcall(function()
                remote:FireServer(target.HumanoidRootPart.Position)
            end)
        end
    end
    
    -- Alternatif: pake ClickButton (attack default)
    virtualUser:ClickButton2(Vector2.new())
    
    -- Coba panggil semua remote yang mungkin
    for _, remote in ipairs(character:GetDescendants()) do
        if remote:IsA("RemoteEvent") and remote.Name:find("Attack") then
            pcall(function()
                remote:FireServer(target.HumanoidRootPart.Position)
            end)
        end
    end
end

-- Fungsi cari NPC terdekat (skip yang jauh)
local function findNearestNPC()
    local nearest = nil
    local dist = math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            -- Skip player dan diri sendiri
            if obj ~= character and not game:GetService("Players"):FindFirstChild(obj.Name) then
                if obj.Humanoid.Health > 0 then
                    local mag = (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    -- Cari yang dalam jarak aman (tapi gak terlalu dekat)
                    if mag < dist and mag > 5 and mag < 80 then
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
    btn.Size = UDim2.new(0, 82, 0, 30)
    btn.Position = UDim2.new(0, 5 + (col * 90), 0, 5 + (row * 36))
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

createBtn("ESP", Color3.fromRGB(40, 80, 200), function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
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

-- SAFE FARM (Jarak Aman + Auto Hit)
createBtn("Safe Farm", Color3.fromRGB(255, 150, 50), function()
    safeFarmEnabled = not safeFarmEnabled
    if safeFarmEnabled then
        farmTarget = findNearestNPC()
        if farmTarget then
            print("[Safe Farm] Target ditemukan: " .. farmTarget.Name)
        else
            print("[Safe Farm] Tidak ada NPC dalam jangkauan")
        end
    else
        farmTarget = nil
        print("[Safe Farm] Dimatikan")
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

-- Slider jarak aman (via input box sederhana)
local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(0, 80, 0, 20)
distLabel.Position = UDim2.new(0, 5, 0, 5 + (row * 36))
distLabel.BackgroundTransparency = 1
distLabel.Text = "Jarak: " .. safeDistance
distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distLabel.TextSize = 10
distLabel.Parent = scrollFrame

local distUp = Instance.new("TextButton")
distUp.Size = UDim2.new(0, 20, 0, 20)
distUp.Position = UDim2.new(0, 90, 0, 5 + (row * 36))
distUp.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
distUp.Text = "+"
distUp.TextColor3 = Color3.fromRGB(255, 255, 255)
distUp.TextSize = 12
distUp.Parent = scrollFrame
distUp.MouseButton1Click:Connect(function()
    safeDistance = math.min(safeDistance + 5, 80)
    distLabel.Text = "Jarak: " .. safeDistance
end)

local distDown = Instance.new("TextButton")
distDown.Size = UDim2.new(0, 20, 0, 20)
distDown.Position = UDim2.new(0, 115, 0, 5 + (row * 36))
distDown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
distDown.Text = "−"
distDown.TextColor3 = Color3.fromRGB(255, 255, 255)
distDown.TextSize = 12
distDown.Parent = scrollFrame
distDown.MouseButton1Click:Connect(function()
    safeDistance = math.max(safeDistance - 5, 10)
    distLabel.Text = "Jarak: " .. safeDistance
end)

row = row + 1
col = 0

-- ======================
-- LOOP UTAMA
-- ======================

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
    end
    
    -- OneHit
    if oneHitEnabled then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= character then
                if obj.Humanoid.Health > 0 and (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude < 20 then
                    obj.Humanoid.Health = 0
                end
            end
        end
    end
    
    -- ===== SAFE FARM =====
    if safeFarmEnabled then
        -- Cari target baru kalau target mati/ilang
        if not farmTarget or not farmTarget:FindFirstChild("Humanoid") or farmTarget.Humanoid.Health <= 0 then
            farmTarget = findNearestNPC()
            if farmTarget then
                print("[Safe Farm] Target baru: " .. farmTarget.Name)
            end
        end
        
        if farmTarget and farmTarget:FindFirstChild("HumanoidRootPart") then
            local targetPos = farmTarget.HumanoidRootPart.Position
            local myPos = rootPart.Position
            local distance = (targetPos - myPos).Magnitude
            
            -- Jika terlalu dekat, mundur ke jarak aman
            if distance < safeDistance - 3 then
                local retreatDir = (myPos - targetPos).Unit * safeDistance
                rootPart.CFrame = CFrame.new(targetPos + retreatDir) + Vector3.new(0, 3, 0)
            -- Jika terlalu jauh, mendekat ke jarak aman
            elseif distance > safeDistance + 3 then
                local approachDir = (targetPos - myPos).Unit * (safeDistance - 2)
                rootPart.CFrame = CFrame.new(targetPos - approachDir) + Vector3.new(0, 3, 0)
            end
            
            -- Serang dari jarak aman
            if distance <= safeDistance + 5 and distance >= safeDistance - 5 then
                attackCooldown = attackCooldown - 0.1
                if attackCooldown <= 0 then
                    attackTarget(farmTarget)
                    attackCooldown = 0.5 -- Cooldown biar gak spam
                end
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

-- Auto-attack saat tombol diklik (opsional)
mouse.Button1Down:Connect(function()
    if safeFarmEnabled and farmTarget then
        attackTarget(farmTarget)
    end
end)

print("LANG SKIE STORE HUB - Safe Farm Loaded!")
