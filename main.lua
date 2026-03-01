-- [[ BLOXBURG MACHINE-GUN BURST: V19 ]]
print("Delta: Injecting Burst-Click Engine...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- 1. CLEANUP
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Overclock") or old.Name:find("God") or old.Name:find("Burst") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 75 -- Your perfect lower-click spot

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "BurstV19"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 220, 0, 50)
btn.Position = UDim2.new(0.5, -110, 0.02, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
btn.Text = "BURST-SPAM [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. Z-TOGGLE (RE-VERIFIED)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "BURST-SPAM [Z]: ON" or "BURST-SPAM [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 50)
    end
end)

-- 5. THE BURST-SPAM ENGINE
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait() -- Run at maximum frame rate
        
        if _G.AutoTakeActive then
            -- STEP 1: TRIGGER INTERACT (E)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: SCAN & BURST
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- Detect the "Take" text
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    
                    local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                    local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                    
                    -- STEP 3: MACHINE-GUN BURST (Sends 5 clicks per scan frame)
                    for _ = 1, 5 do
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end
                    
                    -- Instant break to reset "E" cycle
                    break 
                end
            end
        end
    end
end)

print("Delta: Burst-Spam V19 Active. Speed: Overloaded.")
