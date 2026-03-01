-- [[ BLURRY'S BLOXBURG AUTO-TAKE ]]
print("Delta: Initializing Bloxburg Script...")

-- [[ SETTINGS ]]
local TargetText = "Take" -- We will look for the word "Take" inside the button
_G.AutoTakeEnabled = false

-- [[ UI CLEANUP ]]
local oldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("BloxburgAutoTake")
if oldGui then oldGui:Destroy() end

-- [[ CREATE DELTA UI ]]
local sg = Instance.new("ScreenGui")
sg.Name = "BloxburgAutoTake"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 140, 0, 45)
btn.Position = UDim2.new(0.5, -70, 0.05, 0) -- Near the top of the screen
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.BorderSizePixel = 2
btn.Text = "Auto-Take: OFF"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Parent = sg
btn.Active = true
btn.Draggable = true 

-- [[ TOGGLE LOGIC ]]
btn.MouseButton1Click:Connect(function()
    _G.AutoTakeEnabled = not _G.AutoTakeEnabled
    if _G.AutoTakeEnabled then
        btn.Text = "Auto-Take: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Green
        print("Bloxburg Auto-Take: Active")
    else
        btn.Text = "Auto-Take: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Red
        print("Bloxburg Auto-Take: Disabled")
    end
end)

-- [[ SCANNER LOGIC ]]
task.spawn(function()
    while task.wait(0.3) do -- Slightly slower to prevent Bloxburg from lagging/kicking
        if _G.AutoTakeEnabled then
            local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                -- Search specifically for the Bloxburg Interaction Menu
                for _, v in pairs(pGui:GetDescendants()) do
                    -- In Bloxburg, the button text is what matters
                    if v:IsA("TextLabel") or v:IsA("TextButton") then
                        if v.Text == TargetText and v.Visible then
                            -- We found the 'Take' text, now find its parent button to click
                            local clickable = v:IsA("TextButton") and v or v:FindFirstAncestorOfClass("TextButton")
                            
                            if clickable then
                                if firesignal then
                                    firesignal(clickable.MouseButton1Click)
                                else
                                    clickable:Activate()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("Delta: Bloxburg Script Ready!")
