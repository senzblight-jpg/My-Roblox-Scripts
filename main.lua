-- [[ Bloxburg Auto-Take for Delta ]]
print("Delta: Initializing Bloxburg Script...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Global variable to track state
_G.AutoTakeEnabled = false

-- [[ UI CONSTRUCTION ]]
-- Deletes old UI if it exists to prevent stacking
if PlayerGui:FindFirstChild("BloxburgAutomation") then
    PlayerGui.BloxburgAutomation:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxburgAutomation"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false 

local MainButton = Instance.new("TextButton")
MainButton.Name = "ToggleButton"
MainButton.Parent = ScreenGui
MainButton.Size = UDim2.new(0, 150, 0, 50)
MainButton.Position = UDim2.new(0.5, -75, 0.05, 0) -- Top Center
MainButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Initial Red
MainButton.Text = "Auto-Take: OFF"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 16
MainButton.Draggable = true -- So you can move it on mobile

-- Rounded corners for a cleaner look
local Corner = Instance.new("UICorner")
Corner.CornerRadius = ToolPunch.new(0, 8)
Corner.Parent = MainButton

-- [[ TOGGLE FUNCTIONALITY ]]
MainButton.MouseButton1Click:Connect(function()
    _G.AutoTakeEnabled = not _G.AutoTakeEnabled
    
    if _G.AutoTakeEnabled then
        MainButton.Text = "Auto-Take: ON"
        MainButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80) -- Green
        print("Auto-Take Enabled")
    else
        MainButton.Text = "Auto-Take: OFF"
        MainButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Red
        print("Auto-Take Disabled")
    end
end)

-- [[ AUTO-CLICK LOGIC ]]
task.spawn(function()
    while task.wait(0.2) do -- Checks 5 times per second
        if _G.AutoTakeEnabled then
            -- Bloxburg uses "BillboardGuis" or "ScreenGuis" for interactions
            for _, v in pairs(PlayerGui:GetDescendants()) do
                -- Check if the element is a button/label and contains the text "Take"
                if (v:IsA("TextButton") or v:IsA("TextLabel")) and v.Visible then
                    if v.Text == "Take" or v.Text:find("Take") then
                        
                        -- Find the actual clickable button if we are looking at a label
                        local target = v:IsA("TextButton") and v or v:FindFirstAncestorOfClass("TextButton")
                        
                        if target then
                            -- Delta's preferred way to simulate a click
                            if firesignal then
                                firesignal(target.MouseButton1Click)
                            else
                                target:Activate()
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("Delta: Script Fully Loaded!")
