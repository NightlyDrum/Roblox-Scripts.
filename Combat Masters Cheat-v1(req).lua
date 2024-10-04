-- Load the library
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)("Pepsi's UI Library")

-- Create the Window
local Window = Library:CreateWindow({
    Name = 'Combat Warriors Cheat Menu',
    Themeable = {
        Info = 'Discord Server: g659uxUxm8',
        Credit = true,
    },
    DefaultTheme = shared.themename or '{"__Designer.Colors.main":"4dbed9"}'
})

-- Create a Tab for Combat Warriors cheats
local CheatsTab = Window:CreateTab({
    Name = 'Combat Warriors'
})

-- Create a Section for Player Features
local PlayerSection = CheatsTab:CreateSection({
    Name = 'Player Features',
    Side = 'Right'
})

-- Spinbot Toggle
local SpinbotToggle = PlayerSection:AddToggle({
    Name = 'Spinbot',
    Value = false,
    Callback = function(state)
        if state then
            local character = game.Players.LocalPlayer.Character
            while state do
                character:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame() * CFrame.Angles(0, math.rad(30), 0))
                wait(0.1)
            end
        end
    end
})

-- ESP Toggle
local ESPToggle = PlayerSection:AddToggle({
    Name = 'ESP',
    Value = false,
    Callback = function(state)
        if state then
            -- ESP Logic
            local function createESP(player)
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
            end

            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    createESP(player)
                end
            end

            game.Players.PlayerAdded:Connect(function(player)
                createESP(player)
            end)
        else
            -- Remove ESP
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end
        end
    end
})

-- Ragdoll Toggle
local RagdollToggle = PlayerSection:AddToggle({
    Name = 'Ragdoll Mode',
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        else
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
})

-- Jump Height Slider
local JumpHeightSlider = PlayerSection:AddSlider({
    Name = 'Jump Height',
    Min = 50,
    Max = 300,
    Value = 100,
    Callback = function(height)
        local player = game.Players.LocalPlayer
        player.Character.Humanoid.JumpPower = height
    end
})

-- Notify for script activation
Library.Notify({
    Text = "Combat Warriors script activated!",
    Duration = 3
})
