-- Load Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "Extreme Hide and Seek Enhancements", HidePremium = false, SaveConfig = true, ConfigFolder = "ExtremeHideAndSeek"})

-- Variables
local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 0, 0)
local spinbotEnabled = false
local defaultWalkSpeed = 16
local walkSpeed = defaultWalkSpeed

-- Function to Create ESP
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = ESPColor
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
    end
end

-- Toggle ESP Function
local function toggleESP(value)
    ESPEnabled = value
    if ESPEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createESP(player)
            end
        end

        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end)

        game.Players.PlayerRemoving:Connect(function(player)
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end)
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end
    end
end

-- Spinbot Function
local function toggleSpinbot(value)
    spinbotEnabled = value
    local player = game.Players.LocalPlayer
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

    if spinbotEnabled and rootPart then
        spawn(function()
            while spinbotEnabled do
                -- Rotate the character by 20,000 degrees per frame
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(20000), 0)
                task.wait() -- No delay for ultra-fast spinning
            end
        end)
    end
end

-- Walk Speed Function
local function setWalkSpeed(value)
    walkSpeed = value
    local player = game.Players.LocalPlayer

    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = walkSpeed
    end
end

-- Create ESP Tab
local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add ESP Toggle
ESPTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = toggleESP
})

-- Add Color Picker for ESP
ESPTab:AddColorpicker({
    Name = "ESP Color",
    Default = ESPColor,
    Callback = function(color)
        ESPColor = color
        if ESPEnabled then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight.FillColor = ESPColor
                end
            end
        end
    end
})

-- Create Spinbot & Speed Tab
local SpinbotTab = Window:MakeTab({
    Name = "Spinbot & Speed",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add Spinbot Toggle
SpinbotTab:AddToggle({
    Name = "Enable Spinbot",
    Default = false,
    Callback = toggleSpinbot
})

-- Add Walk Speed Slider
local speedSlider = SpinbotTab:AddSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 100,
    Default = defaultWalkSpeed,
    Increment = 1,
    ValueName = "Speed",
    Callback = setWalkSpeed
})

-- Add Reset Walk Speed Button
SpinbotTab:AddButton({
    Name = "Reset Walk Speed",
    Callback = function()
        speedSlider:Set(defaultWalkSpeed)
        setWalkSpeed(defaultWalkSpeed)
    end
})

-- Initialize Orion Library UI
OrionLib:Init()
