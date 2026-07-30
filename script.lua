-- LANG SKIE STORE HUB - Modified
-- Background + Custom Logo

local HttpGet = game.HttpGet
local GameId = game.GameId

local Games = loadstring(
  HttpGet(game, "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/GameList.lua")
)()

local URL = Games[GameId]
if not URL then return end

-- Core script
local coreScript = loadstring(HttpGet(game, URL))

-- Mini GUI for Android
local player = game:GetService("Players").LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")
screenGui.Name = "LSS_Gui"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Background Image (Ganti link dengan gambar kamu)
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "https://i.imgur.com/your-image.jpg"  -- Ganti link gambar kamu
bg.ScaleType = Enum.ScaleType.Fit
bg.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BackgroundTransparency = 0.5
titleBar.Parent = mainFrame

-- Logo kecil di title bar
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 20, 0, 20)
logo.Position = UDim2.new(0, 5, 0, 4)
logo.BackgroundTransparency = 1
logo.Image = "https://i.imgur.com/your-logo.png"  -- Ganti link logo kamu
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

-- Minimize button
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
        contentFrame.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 280, 0, 200)
        minimizeBtn.Text = "−"
        contentFrame.Visible = true
    end
end)

-- Close button
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

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -38)
contentFrame.Position = UDim2.new(0, 5, 0, 32)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Load Speed Hub X
local function loadSpeedHub()
    pcall(function()
        coreScript()
    end)
end

spawn(function()
    loadSpeedHub()
end)

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

print("LANG SKIE STORE HUB Loaded!")
