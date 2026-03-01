-- [[ Bloxburg Auto-Take - Starts ON ]]
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Set starting state to TRUE
local enabled = true 

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
-- Start with Green color and ON text
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) 
btn.Text = "AUTO-TAKE: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Active = true
btn.Draggable = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- [[ THE TOGGLE LOGIC ]]
btn.MouseButton1Click:Connect(function()
    enabled = not enabled 
    
    if enabled then
        btn.Text = "AUTO-TAKE: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("Delta: Auto-Take Enabled")
    else
        btn.Text = "AUTO-TAKE: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("Delta: Auto-Take Disabled")
    end
end)

-- [[ THE ACTION LOOP ]]
task.spawn(function()
    while task.wait(0.3) do
        if enabled then
            for _, v in pairs(PlayerGui:GetDescendants()) do
                if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Visible then
                    -- Bloxburg usually uses "Take" or "Take Portion"
                    if v.Text == "Take" or v.Text == "Take Portion" then
                        local clickTarget = v:IsA("TextButton") and v or v:FindFirstAncestorOfClass("TextButton")
                        if clickTarget then
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

print("Delta: Script Loaded and ACTIVE!")
