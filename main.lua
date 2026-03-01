-- [[ BLOXBURG TIMED-BURST: V20 ]]
print("Delta: Injecting Timed-Burst Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Burst") or old.Name:find("Sync") or old.Name:find("Overclock") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 75 -- Your perfect lower-click spot
local APPEAR_DELAY = 0.15 -- The "Sweet Spot" delay for the menu to appear

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "TimedBurstV20"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 220, 0, 50)
btn.Position = UDim2.new(0.5, -110, 0.02, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
btn.Text = "TIMED-BURST [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. Z-TOGGLE (RE-VERIFIED)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "TIMED-BURST [Z]: ON" or "TIMED-BURST [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)
    end
end)

-- 5. THE TIMED-BURST ENGINE
task.spawn(function()
    while true do
        task.wait(0.1) -- Small breath between "E" cycles
        
        if _G.AutoTakeActive then
            -- STEP 1: TRIGGER INTERACT (E)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.02)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: WAIT FOR MENU TO SPAWN (Crucial Fix)
            task.wait(APPEAR_DELAY)

            -- STEP 3: SCAN & BURST-CLICK
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- Detect the "Take" text
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    
                    local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                    local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                    
                    -- STEP 4: BURST-CLICK (3 clicks to ensure registration)
                    for _ = 1, 3 do
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.01)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end
                    
                    break 
                end
            end
        end
    end
end)

print("Delta: Timed-Burst V20 Active. Delay: 0.15s. Position: Deep-Lower.")
