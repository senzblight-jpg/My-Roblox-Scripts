-- [[ BLOXBURG RADIAL-CRACKER: Z-FIX & INTERACT RE-SYNC ]]
print("Delta: Injecting Z-Fix and Sync Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP OLD SESSIONS
local function cleanup()
    for _, old in pairs(PlayerGui:GetChildren()) do
        if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") or old.Name:find("Deep") then
            old:Destroy()
        end
    end
end
cleanup()

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local RADIAL_DELAY = 1.3 -- Slightly longer to ensure the server is ready for the click
local DEEP_Y_OFFSET = 65 -- Matches your "almost accurate" position with a tiny +5 nudge

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FinalSyncV10"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
btn.Text = "SYNC-TAKE [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. THE Z-KEYBIND FIX (More aggressive listener)
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "SYNC-TAKE [Z]: ON" or "SYNC-TAKE [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(85, 0, 255) or Color3.fromRGB(200, 50, 50)
    print("Z-Toggle: " .. tostring(_G.AutoTakeActive))
end

-- Listen for Z key even if the game thinks it's "processed"
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        toggle()
    end
end)

btn.MouseButton1Click:Connect(toggle)

-- 5. THE SYNCED AUTOMATION LOOP
task.spawn(function()
    while task.wait(0.8) do
        if _G.AutoTakeActive then
            -- STEP A: Press "E"
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            -- STEP B: Sync Delay (Ensuring menu is fully interactive)
            task.wait(RADIAL_DELAY)

            -- STEP C: Scan and Double-Tap for Success
            local found = false
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    local absPos = obj.AbsolutePosition
                    local absSize = obj.AbsoluteSize
                    
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + DEEP_Y_OFFSET 
                    
                    -- DOUBLE-TAP: Helps ensure Bloxburg's server registers the interaction
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        
                        -- Second tap 0.1s later to catch any lag
                        task.wait(0.1)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end)
                    
                    found = true
                    break 
                end
            end
        end
    end
end)

print("Delta: Sync-Build Loaded. Keybind Z verified.")
