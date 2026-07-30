-- sc-delta/script.lua
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Delta Script v2.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

local function createButton(text, callback, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local yPos = 5

-- ESP
local espEnabled = false
local espObjects = {}

createButton("Toggle ESP", function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= player then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local esp = Instance.new("BillboardGui")
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.AlwaysOnTop = true
                    esp.Parent = char.HumanoidRootPart
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = plr.Name
                    label.TextColor3 = Color3.fromRGB(255, 0, 0)
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
end, yPos)
yPos = yPos + 35

-- Auto Farm
local farmEnabled = false
local farmTarget = nil

createButton("Toggle Auto Farm", function()
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
end, yPos)
yPos = yPos + 35

-- Fly
local flyEnabled = false
local flySpeed = 50
local flyBodyVelocity = nil

createButton("Toggle Fly", function()
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
end, yPos)
yPos = yPos + 35

-- Speed
local speedEnabled = false
local speedAmount = 50

createButton("Toggle Speed", function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        humanoid.WalkSpeed = speedAmount
    else
        humanoid.WalkSpeed = 16
    end
end, yPos)
yPos = yPos + 35

-- Teleport
createButton("Teleport to Spawn", function()
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if spawn then
        rootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
    else
        rootPart.CFrame = CFrame.new(0, 10, 0)
    end
end, yPos)
yPos = yPos + 35

-- Infinite Jump
local jumpEnabled = false

createButton("Toggle Infinite Jump", function()
    jumpEnabled = not jumpEnabled
end, yPos)
yPos = yPos + 35

-- Noclip
local noclipEnabled = false

createButton("Toggle Noclip", function()
    noclipEnabled = not noclipEnabled
end, yPos)

-- Keybinds
game:GetService("UserInputService").JumpRequest:Connect(function()
    if jumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        return true
    end
end)

-- Loop
game:GetService("RunService").Heartbeat:Connect(function()
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
    
    if farmEnabled and farmTarget and farmTarget:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = farmTarget.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        wait(0.1)
        farmTarget = nil
        farmEnabled = false
    end
    
    if noclipEnabled then
        character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Climbing)
    end
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

print("Delta Script Loaded successfully!")