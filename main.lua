-- [[ BLOXBURG MICRO-SYNC: FASTEST STABLE BUILD ]]
print("Delta: Injecting Micro-Sync Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- 1. CLEANUP
local function cleanup()
    for _, old in pairs(PlayerGui:GetChildren()) do
        if old.Name:find("Zero") or old.Name:find("NoSkip") or old.Name:find("Sync") then
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
sg.Name = "MicroSyncV14"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
btn.Text = "MICRO-SYNC [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE LOGIC (Z-Key)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "MICRO-SYNC [Z]: ON" or "MICRO-SYNC [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 50)
    end
end)

-- 5. THE MICRO-SYNC ENGINE
task.spawn(function()
    while true do
        task.wait(0.1) -- Very short "E" cycle delay
        
        if _G.AutoTakeActive then
            -- STEP 1: TRIGGER INTERACT (E)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.02)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: STABILIZED SCAN
            local startTime = tick()
            local clicked = false
            
            -- Scan for 2 seconds max
            while tick() - startTime < 2 and not clicked and _G.AutoTakeActive do
                local guis = PlayerGui:GetDescendants()
                for i = 1, #guis do
                    local obj = guis[i]
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                        
                        local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                        local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                        
                        -- STABLE CLICK
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.03) -- Micro-delay for click registration
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        
                        clicked = true
                        break
                    end
                end
                RunService.Heartbeat:Wait() -- High-speed scan
            end
            
            -- STEP 3: RE-SYNC DELAY
            task.wait(0.05) -- Tiny pause before next "E" to let UI clear
        end
    end
end)

print("Delta: Micro-Sync Build V14 Active.")
