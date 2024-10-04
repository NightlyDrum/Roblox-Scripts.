-- Load Pepsi's UI Library
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)("Pepsi's UI Library")

-- Create Main Window
local Window = Library:CreateWindow({
    Name = 'Combat Masters Script',
    Themeable = {
        Info = 'Combat Masters Script by You',
        Credit = true,
    },
    DefaultTheme = shared.themename or '{"__Designer.Colors.main":"4dbed9"}'
})

-- ========================
-- Spinbot Tab
-- ========================
local SpinTab = Window:CreateTab({
    Name = 'Spinbot'
})

local SpinSection = SpinTab:CreateSection({
    Name = 'Spinbot Settings',
    Side = 'Left'
})

local SpinbotActive = false
local SpinSpeed = 1 -- Default spin speed (in seconds for a full 360)
local SpinKeybind = Enum.KeyCode.X -- Default keybind to toggle Spinbot

local Toggle = SpinSection:AddToggle({
    Name = 'Spinbot',
    Value = false,
    Flag = 'spinbot',
    Keybind = {
        Flag = 'spinbotKeybind',
        Mode = 'Hold',
        Value = SpinKeybind
    },
    Callback = function(state)
        SpinbotActive = state
        if SpinbotActive then
            print("Spinbot Activated")
            SpinCharacter()
        else
            print("Spinbot Deactivated")
        end
    end
})

-- Spin Speed Slider
local Slider = SpinSection:AddSlider({
    Name = 'Spin Speed (Seconds)',
    Flag = "spinSpeed",
    Value = 1,
    Min = 0.1,
    Max = 5,
    Decimals = 1,
    Callback = function(value)
        SpinSpeed = value
        print("Spin Speed set to: ", value)
    end
})

-- Spinbot functionality
function SpinCharacter()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local startTime = tick()
        local endTime = startTime + SpinSpeed
        local originalCFrame = character:GetPrimaryPartCFrame()

        -- Spin coroutine
        coroutine.wrap(function()
            while tick() < endTime do
                local elapsed = tick() - startTime
                local rotationAmount = (elapsed / SpinSpeed) * 360
                character:SetPrimaryPartCFrame(originalCFrame * CFrame.Angles(0, math.rad(rotationAmount), 0))
                wait(0) -- Yield to allow other processes to run
            end
            character:SetPrimaryPartCFrame(originalCFrame) -- Reset to original position
        end)()
    end
end

-- ========================
-- ESP Tab
-- ========================
local ESPTab = Window:CreateTab({
    Name = 'ESP'
})

local ESPSection = ESPTab:CreateSection({
    Name = 'ESP Settings',
    Side = 'Left'
})

local ESPEnabled = false
local ESPColor = Color3.new(1, 0, 0) -- Default ESP color (Red)
local ApplyToEnemiesOnly = false
local ShowNameESP = false
local ShowDistanceESP = false
local ShowHealthESP = false
local ShowBoxESP = false
local ESPConnections = {}
local ESPElements = {}

local function ClearESP()
    -- Disconnect all connections
    for _, conn in pairs(ESPConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    ESPConnections = {}

    -- Remove all ESP elements
    for _, element in pairs(ESPElements) do
        if element then
            element:Destroy()
        end
    end
    ESPElements = {}
end

-- ESP Toggle
local ToggleESP = ESPSection:AddToggle({
    Name = 'ESP',
    Value = false,
    Flag = 'esp',
    Callback = function(state)
        ESPEnabled = state
        if ESPEnabled then
            EnableESP()
            print("ESP Activated")
        else
            DisableESP()
            print("ESP Deactivated")
        end
    end
})

-- ESP Color Picker
local ColorPicker = ESPSection:AddColorPicker({
    Name = "ESP Color",
    Value = ESPColor,
    Callback = function(color)
        ESPColor = color
        print("ESP Color set to: ", color)
    end
})

-- Apply ESP to enemies only
local ToggleEnemiesOnly = ESPSection:AddToggle({
    Name = 'Apply to Enemies Only',
    Value = false,
    Flag = 'enemiesOnly',
    Callback = function(state)
        ApplyToEnemiesOnly = state
        print("ESP will apply to enemies only: ", state)
    end
})

-- Show Player Name ESP
local ToggleNameESP = ESPSection:AddToggle({
    Name = 'Show Player Names',
    Value = false,
    Flag = 'nameESP',
    Callback = function(state)
        ShowNameESP = state
        print("Name ESP: ", state)
    end
})

-- Show Distance ESP
local ToggleDistanceESP = ESPSection:AddToggle({
    Name = 'Show Distance',
    Value = false,
    Flag = 'distanceESP',
    Callback = function(state)
        ShowDistanceESP = state
        print("Distance ESP: ", state)
    end
})

-- Show Health ESP
local ToggleHealthESP = ESPSection:AddToggle({
    Name = 'Show Health',
    Value = false,
    Flag = 'healthESP',
    Callback = function(state)
        ShowHealthESP = state
        print("Health ESP: ", state)
    end
})

-- Show Box ESP
local ToggleBoxESP = ESPSection:AddToggle({
    Name = 'Show Box',
    Value = false,
    Flag = 'boxESP',
    Callback = function(state)
        ShowBoxESP = state
        print("Box ESP: ", state)
    end
})

-- ========================
-- Enhanced ESP Functionality
-- ========================
local function CreateESPPart(parent, color)
    local espPart = Instance.new("BoxHandleAdornment")
    espPart.Size = Vector3.new(4, 7, 4)
    espPart.Transparency = 0.8
    espPart.Color3 = color
    espPart.Adornee = parent
    espPart.AlwaysOnTop = true
    espPart.ZIndex = 10
    espPart.Parent = parent
    return espPart
end

local function CreateBillboard(parent, text)
    local billboard = Instance.new("BillboardGui", parent)
    billboard.Adornee = parent
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    return billboard
end

function EnableESP()
    ClearESP() -- Clear previous ESP elements if any

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            if not ApplyToEnemiesOnly or (ApplyToEnemiesOnly and player.TeamColor ~= game.Players.LocalPlayer.TeamColor) then
                local character = player.Character

                -- Box ESP
                if ShowBoxESP and character:FindFirstChild("HumanoidRootPart") then
                    local espPart = CreateESPPart(character.HumanoidRootPart, ESPColor)
                    table.insert(ESPElements, espPart) -- Store the element for cleanup later
                end

                -- Name ESP
                if ShowNameESP and character:FindFirstChild("HumanoidRootPart") then
                    local nameBillboard = CreateBillboard(character.HumanoidRootPart, player.Name)
                    table.insert(ESPElements, nameBillboard) -- Store the element for cleanup later
                end

                -- Distance ESP
                if ShowDistanceESP and character:FindFirstChild("HumanoidRootPart") then
                    local distanceBillboard = CreateBillboard(character.HumanoidRootPart, "")
                    table.insert(ESPElements, distanceBillboard) -- Store the element for cleanup later

                    -- Update distance in real-time
                    local connection = game:GetService('RunService').Stepped:Connect(function()
                        if character and character.HumanoidRootPart and distanceBillboard then
                            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                            distanceBillboard.TextLabel.Text = "Distance: " .. math.floor(distance) .. " studs"
                        end
                    end)
                    table.insert(ESPConnections, connection) -- Store the connection for cleanup later
                end

                -- Health ESP
                if ShowHealthESP and character:FindFirstChild("Humanoid") then
                    local healthBillboard = CreateBillboard(character.HumanoidRootPart, "")
                    table.insert(ESPElements, healthBillboard) -- Store the element for cleanup later

                    -- Update health in real-time
                    local connection = game:GetService('RunService').Stepped:Connect(function()
                        if character and character:FindFirstChild("Humanoid") and healthBillboard then
                            healthBillboard.TextLabel.Text = "Health: " .. math.floor(character.Humanoid.Health)
                        end
                    end)
                    table.insert(ESPConnections, connection) -- Store the connection for cleanup later
                end
            end
        end
    end
end

function DisableESP()
    ClearESP() -- Properly clear all ESP elements and connections when disabling
end

-- Notification to show script is loaded
Library.Notify({
    Text = "Combat Masters Script Loaded",
    Duration = 3
})
