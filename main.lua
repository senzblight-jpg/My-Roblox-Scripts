-- [[ Force-Toggle AutoTake for Delta ]]
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Local variable for better performance
local enabled = false

-- [[ UI SETUP ]]
if PlayerGui:FindFirstChild("ForceToggleUI") then
    PlayerGui.ForceToggleUI:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "ForceToggleUI"
sg.Parent = PlayerGui
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Parent = sg
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0.5, -80, 0.15, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.Text = "AUTO-TAKE: OFF"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Active = true
btn.Draggable = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- [[ THE TOGGLE - REVISED ]]
btn.MouseButton1Click:Connect(function()
    print("Button Clicked!") -- Check your Delta Console for this!
    
    enabled = not enabled -- Flip the switch
    
    if enabled then
        btn.Text = "AUTO-TAKE: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("Status changed to: ON")
    else
        btn.Text = "AUTO-TAKE: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("Status changed to: OFF")
    end
end)

-- [[ THE ACTION LOOP ]]
task.spawn(function()
    while task.wait(0.3) do
        if enabled then
            -- Looking for Bloxburg's specific interaction buttons
            for _, v in pairs(PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    if v.Text == "Take" and v.Visible then
                        local clickTarget = v:IsA("TextButton") and v or v:FindFirstAncestorOfClass("TextButton")
                        if clickTarget then
                            -- Try multiple ways to click it for Delta
                            if firesignal then
                                firesignal(clickTarget.MouseButton1Click)
                            end
                            clickTarget:Activate()
                        end
                    end
                end
            end
        end
    end
end)

print("Script Loaded! Try clicking the button now.")
