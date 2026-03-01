-- [[ BLOXBURG OVERCLOCK: V18 MAXIMUM SPEED ]]
print("Delta: Injecting Overclock Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- 1. CLEANUP PREVIOUS SCRIPTS
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("God") or old.Name:find("Sync") or old.Name:find("Overclock") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 75 

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "OverclockV18"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 220, 0, 50)
btn.Position = UDim2.new(0.5, -110, 0.02, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "OVERCLOCK [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 0, 0)
btn.Font = Enum.Font.RobotoMono
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. INSTANT Z-TOGGLE
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "OVERCLOCK [Z]: ON" or "OVERCLOCK [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
    end
end)

-- 5. THE OVERCLOCK ENGINE (No task.wait inside active loops)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait() -- Syncs with Physics
        
        if _G.AutoTakeActive then
            -- STEP 1: SPAM E (Multiple signals per frame)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: PARALLEL SCAN (Checks all descendants simultaneously)
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- Check for "Take" text instantly
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    
                    local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                    local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                    
                    -- STEP 3: BURST CLICK (Sends 3 clicks in a single frame to override lag)
                    for _ = 1, 3 do
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end
                    
                    break -- Move to next E-cycle immediately
                end
            end
        end
    end
end)

print("Delta: Overclock V18 Active. Stand near food and hold Z if needed.")
