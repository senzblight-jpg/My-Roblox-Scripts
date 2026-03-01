-- [[ BLOXBURG SEQUENTIAL-TAKE: NO-SKIP EDITION ]]
print("Delta: Injecting Sequential Sync Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP
local function cleanup()
    for _, old in pairs(PlayerGui:GetChildren()) do
        if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") or old.Name:find("Sync") then
            old:Destroy()
        end
    end
end
cleanup()

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 65 -- Your 100% accurate position

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "NoSkipV11"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
btn.Text = "NO-SKIP [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. RAW KEYBIND FIX (Ensures Z works on Mobile)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "NO-SKIP [Z]: ON" or "NO-SKIP [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(200, 50, 50)
    end
end)

-- 5. SEQUENTIAL INTERACTION ENGINE
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoTakeActive then
            -- STEP 1: PRESS E
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: WAIT & LOCK (Ensures we don't skip)
            local startTime = tick()
            local clicked = false
            
            -- Keep scanning for up to 3 seconds for the "Take" button
            while tick() - startTime < 3 and not clicked and _G.AutoTakeActive do
                local guis = PlayerGui:GetDescendants()
                for i = 1, #guis do
                    local obj = guis[i]
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                        
                        -- Target the precise location
                        local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                        local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                        
                        -- DOUBLE-TAP FOR SERVER SYNC
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        
                        clicked = true
                        print("Sequential Hit: Take successful.")
                        break
                    end
                end
                task.wait(0.1) -- Rapid scan frequency
            end
            
            -- Wait a moment before the next "E" cycle to let Bloxburg's inventory update
            task.wait(0.5)
        end
    end
end)

print("Delta: No-Skip Sequential Build Active.")
