-- [[ BLOXBURG FULL-AUTO LOOP: SPAM E + TAKE ]]
print("Delta: Cleaning old sessions and injecting Full-Auto...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. DESTROY OLD LOADER (Prevents UI stacking)
if PlayerGui:FindFirstChild("RadialCracker") then 
    PlayerGui.RadialCracker:Destroy() 
    print("Delta: Old UI destroyed.")
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true -- Default to ON

-- 3. CREATE NEW UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "RadialCracker"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0.5, -90, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "FULL AUTO: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE LOGIC
btn.MouseButton1Click:Connect(function()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "FULL AUTO: ON" or "FULL AUTO: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- 5. THE AUTOMATION LOOP
task.spawn(function()
    while task.wait(0.2) do -- Adjust speed here (0.2 is safe for Bloxburg)
        if _G.AutoTakeActive then
            -- PART A: Spam "E" Key
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            -- PART B: Scan for "Take" Button and Tap Coordinates
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and obj.Transparency < 1 then
                    if obj.Text == "Take" or obj.Text == "Take Portion" then
                        
                        local absPos = obj.AbsolutePosition
                        local absSize = obj.AbsoluteSize
                        local centerX = absPos.X + (absSize.X / 2)
                        local centerY = absPos.Y + (absSize.Y / 2)
                        
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        end)
                    end
                end
            end
        end
    end
end)

print("Delta: Full-Auto Loop Active! Stand near food.")
