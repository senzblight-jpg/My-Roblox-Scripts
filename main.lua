-- [[ BLOXBURG MICRO-SYNC: CALIBRATED DEEP-CLICK ]]
print("Delta: Injecting Calibrated Micro-Sync...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- 1. CLEANUP
local function cleanup()
    for _, old in pairs(PlayerGui:GetChildren()) do
        if old.Name:find("MicroSync") or old.Name:find("Zero") or old.Name:find("NoSkip") then
            old:Destroy()
        end
    end
end
cleanup()

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 65 -- Re-applied your 100% accurate lower position

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "MicroSyncV15"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 255) -- Purple
btn.Text = "CALIBRATED [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE LOGIC (Z-Key Verified)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "CALIBRATED [Z]: ON" or "CALIBRATED [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(200, 0, 255) or Color3.fromRGB(50, 50, 50)
    end
end)

-- 5. THE CALIBRATED ENGINE
task.spawn(function()
    while true do
        task.wait(0.15) -- Short E-Cycle Delay
        
        if _G.AutoTakeActive then
            -- STEP 1: TRIGGER INTERACT (E)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: HIGH-SPEED SCAN (Locked until click)
            local startTime = tick()
            local clicked = false
            
            while tick() - startTime < 2 and not clicked and _G.AutoTakeActive do
                local guis = PlayerGui:GetDescendants()
                for i = 1, #guis do
                    local obj = guis[i]
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                        
                        -- Center-Width with the DEEP-Y Offset
                        local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                        local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                        
                        -- STABLE DEEP CLICK
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05) -- Registration delay
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        
                        clicked = true
                        break
                    end
                end
                RunService.Heartbeat:Wait() -- Fast Scan
            end
            
            -- STEP 3: RESET DELAY (Ensures menu is cleared)
            task.wait(0.1) 
        end
    end
end)

print("Delta: V15 Loaded. Position: Deep-Lower. Keybind: Z.")
