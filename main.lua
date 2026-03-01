-- [[ CONSOLE LOG ]]
print("Delta: Script Loading...")

-- [[ SETTINGS ]]
local ButtonName = "Take" -- The exact name of the button in the game
_G.AutoTakeEnabled = false

-- [[ CLEAN UP OLD UI ]]
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("DeltaAutoTake") then
    game.Players.LocalPlayer.PlayerGui.DeltaAutoTake:Destroy()
end

-- [[ CREATE UI ]]
local sg = Instance.new("ScreenGui")
sg.Name = "DeltaAutoTake"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false -- Keeps the button there when you die

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0.5, -60, 0.1, 0) -- Top middle of your screen
btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
btn.Text = "Auto-Take: OFF"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Parent = sg
btn.Active = true
btn.Draggable = true -- Allows you to move it if it's blocking your view

-- [[ TOGGLE LOGIC ]]
btn.MouseButton1Click:Connect(function()
    _G.AutoTakeEnabled = not _G.AutoTakeEnabled
    if _G.AutoTakeEnabled then
        btn.Text = "Auto-Take: ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        print("Auto-Take Enabled")
    else
        btn.Text = "Auto-Take: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        print("Auto-Take Disabled")
    end
end)

-- [[ SCANNER LOOP ]]
task.spawn(function()
    while task.wait(0.2) do -- Checks every 0.2s to save battery/performance
        if _G.AutoTakeEnabled then
            local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                -- Find all buttons named "Take" that are currently visible
                for _, v in pairs(pGui:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name == ButtonName and v.Visible then
                        -- Delta specific click method
                        if firesignal then
                            firesignal(v.MouseButton1Click)
                        else
                            v:Activate()
                        end
                    end
                end
            end
        end
    end
end)

print("Delta: Script Loaded Successfully!")
