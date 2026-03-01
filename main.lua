-- [[ BLOXBURG HYPER-FAST: NO-SKIP EDITION ]]
print("Delta: Injecting Hyper-Fast Sync Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP
local function cleanup()
    for _, old in pairs(PlayerGui:GetChildren()) do
        if old.Name:find("NoSkip") or old.Name:find("Radial") or old.Name:find("Take") then
            old:Destroy()
        end
    end
end
cleanup()

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 65 

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "HyperFastV12"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 85, 0) -- Orange for Hyper-Fast
btn.Text = "HYPER-FAST [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE LOGIC
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "HYPER-FAST [Z]: ON" or "HYPER-FAST [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(200, 50, 50)
    end
end)

-- 5. THE HYPER-SPEED ENGINE
task.spawn(function()
    while true do
        task.wait(0.1) -- Reduced main loop delay for faster re-triggers
        if _G.AutoTakeActive then
            -- STEP 1: INSTANT E PRESS
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.01) -- Minimum delay for engine registration
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: HIGH-FREQUENCY SCAN (Locked until click or timeout)
            local startTime = tick()
            local clicked = false
            
            -- Scan every 0.05 seconds (20 times per second)
            while tick() - startTime < 2 and not clicked and _G.AutoTakeActive do
                local guis = PlayerGui:GetDescendants()
                for i = 1, #guis do
                    local obj = guis[i]
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                        
                        local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                        local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                        
                        -- RAPID CLICK
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait() -- Minimal frame wait
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        
                        clicked = true
                        break
                    end
                end
                task.wait(0.05) -- Hyper-fast scan frequency
            end
            
            -- Short rest to let the "Take" animation finish before next "E"
            task.wait(0.2)
        end
    end
end)

print("Delta: Hyper-Fast Build Active. Loop speed maximized.")
