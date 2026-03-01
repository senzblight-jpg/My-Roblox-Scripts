-- [[ Bloxburg Auto-Take Toggle for Delta ]]
print("Delta: Injecting Toggle UI...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- State variable
_G.AutoTakeEnabled = false

-- [[ UI CLEANUP ]]
if PlayerGui:FindFirstChild("BloxburgToggleUI") then
    PlayerGui.BloxburgToggleUI:Destroy()
end

-- [[ CREATE THE UI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxburgToggleUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false 

local MainButton = Instance.new("TextButton")
MainButton.Parent = ScreenGui
MainButton.Size = UDim2.new(0, 160, 0, 50)
MainButton.Position = UDim2.new(0.5, -80, 0.1, 0) -- Top of screen
MainButton.BackgroundColor3 = Color3.fromRGB(255, 65, 65) -- Start Red
MainButton.Text = "AUTO-TAKE: OFF"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 14
MainButton.Draggable = true 

-- Add rounded corners
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainButton

-- [[ TOGGLE LOGIC ]]
MainButton.MouseButton1Click:Connect(function()
    -- This flips the value: if it's true, it becomes false. If false, it becomes true.
    _G.AutoTakeEnabled = not _G.AutoTakeEnabled
    
    if _G.AutoTakeEnabled then
        -- Visuals for ON
        MainButton.Text = "AUTO-TAKE: ON"
        MainButton.BackgroundColor3 = Color3.fromRGB(65, 255, 65) -- Green
        print("Status: Auto-Take is now ACTIVE")
    else
        -- Visuals for OFF
        MainButton.Text = "AUTO-TAKE: OFF"
        MainButton.BackgroundColor3 = Color3.fromRGB(255, 65, 65) -- Red
        print("Status: Auto-Take is now DISABLED")
    end
end)

-- [[ AUTO-CLICK LOOP ]]
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoTakeEnabled then
            -- Scan for the "Take" button in Bloxburg's menus
            for _, v in pairs(PlayerGui:GetDescendants()) do
                if (v:IsA("TextButton") or v:IsA("TextLabel")) and v.Visible then
                    if v.Text == "Take" or v.Text:find("Take") then
                        -- Identify the clickable button
                        local targetBtn = v:IsA("TextButton") and v or v:FindFirstAncestorOfClass("TextButton")
                        
                        if targetBtn then
                            if firesignal then
                                firesignal(targetBtn.MouseButton1Click)
                            else
                                targetBtn:Activate()
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("Delta: Toggle Script Loaded! Click the Red button to start.")
