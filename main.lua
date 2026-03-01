-- [[ BLOXBURG GOD-SPEED: V17 ]]
print("Delta: Injecting God-Speed Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- 1. CLEANUP
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Sync") or old.Name:find("Hyper") or old.Name:find("God") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 75 -- Your perfect lower-click position

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "GodSpeedV17"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 220, 0, 50)
btn.Position = UDim2.new(0.5, -110, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red for Danger Speed
btn.Text = "GOD-SPEED [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. INSTANT Z-TOGGLE
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "GOD-SPEED [Z]: ON" or "GOD-SPEED [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50)
    end
end)

-- 5. THE GOD-SPEED ENGINE
task.spawn(function()
    while true do
        -- Frame-level wait (Fastest possible loop)
        RunService.Heartbeat:Wait()
        
        if _G.AutoTakeActive then
            -- STEP 1: TRIGGER E (No wait between down/up)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: FRAME-PERFECT SCAN
            local clicked = false
            local startTime = tick()
            
            -- Scan aggressively for 1 second
            while tick() - startTime < 1 and not clicked and _G.AutoTakeActive do
                local guis = PlayerGui:GetDescendants()
                for i = 1, #guis do
                    local obj = guis[i]
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                        
                        -- DEEP OFFSET CALCULATION
                        local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                        local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                        
                        -- FRAME-PERFECT CLICK
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        
                        clicked = true
                        break
                    end
                end
                -- Don't wait at all between scans until found
                if not clicked then RunService.RenderStepped:Wait() end
            end
            
            -- STEP 3: MINIMAL COOLDOWN (Needed so Roblox doesn't kick you)
            task.wait(0.01)
        end
    end
end)

print("Delta: God-Speed V17 Active. Use Z to stop.")
