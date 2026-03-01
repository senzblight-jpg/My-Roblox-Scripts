-- [[ SETTINGS ]]
local ButtonToClick = "Take" -- Change this if the button name in the game is different
local _G.AutoTakeEnabled = false -- Default state is OFF

-- [[ CREATE THE TOGGLE UI ]]
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui -- Puts it in the hidden developer GUI folder
ScreenGui.Name = "AutoTakeGui"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Red initially
ToggleButton.Position = UDim2.new(0, 50, 0, 50) -- Position on screen
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Text = "Auto-Take: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Draggable = true -- You can move it around

-- [[ TOGGLE LOGIC ]]
ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoTakeEnabled = not _G.AutoTakeEnabled
    
    if _G.AutoTakeEnabled then
        ToggleButton.Text = "Auto-Take: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50) -- Green
    else
        ToggleButton.Text = "Auto-Take: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Red
    end
end)

-- [[ AUTOMATION LOOP ]]
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoTakeEnabled then
            local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            -- Search for the "Take" button
            for _, v in pairs(playerGui:GetDescendants()) do
                if v:IsA("TextButton") and v.Name == ButtonToClick and v.Visible then
                    -- If your executor supports firesignal, use it for a cleaner click
                    if firesignal then
                        firesignal(v.MouseButton1Click)
                    else
                        v:Activate() -- Fallback for basic executors
                    end
                end
            end
        end
    end
end)
