-- [[ BLOXBURG FULL-AUTO: DELAYED INTERACTION ]]
print("Delta: Injecting Delayed Loader...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP OLD SESSIONS
if PlayerGui:FindFirstChild("RadialCrackerV3") then 
    PlayerGui.RadialCrackerV3:Destroy() 
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local INTERACTION_DELAY = 0.4 -- Time (seconds) to wait for the "Take" button to load

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "RadialCrackerV3"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0.5, -90, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "DELAYED AUTO: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "DELAYED AUTO: ON" or "DELAYED AUTO: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- 4. THE AUTOMATION LOOP
task.spawn(function()
    while task.wait(0.5) do -- Main loop speed
        if _G.AutoTakeActive then
            
            -- STEP A: Press "E" to open the menu
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            -- STEP B: WAIT for the menu to finish loading
            task.wait(INTERACTION_DELAY)

            -- STEP C: Scan and Click the "Take" button
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible then
                    if obj.Text == "Take" or obj.Text == "Take Portion" then
                        
                        -- Get screen position
                        local absPos = obj.AbsolutePosition
                        local absSize = obj.AbsoluteSize
                        local centerX = absPos.X + (absSize.X / 2)
                        local centerY = absPos.Y + (absSize.Y / 2)
                        
                        -- Hardware-level tap
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        end)
                        
                        -- Once we click "Take", we stop scanning this frame
                        break 
                    end
                end
            end
        end
    end
end)

print("Delta: Delayed Auto-Loop Active!")
