-- [[ BLOXBURG ZERO-DELAY: CHAIN INTERACT EDITION ]]
print("Delta: Injecting Zero-Delay Chain Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. FORCE CLEANUP
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Fast") or old.Name:find("Radial") or old.Name:find("NoSkip") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local DEEP_Y_OFFSET = 65 

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZeroDelayV13"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150) -- Neon Green
btn.Text = "ZERO-DELAY [Z]: ON"
btn.TextColor3 = Color3.fromRGB(0, 0, 0)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE LOGIC
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "ZERO-DELAY [Z]: ON" or "ZERO-DELAY [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 50, 50)
    end
end)

-- 5. THE CHAIN ENGINE (Zero Delay)
task.spawn(function()
    while true do
        task.wait() -- Run at engine speed (fastest possible)
        
        if _G.AutoTakeActive then
            -- STEP 1: TRIGGER INTERACT (E)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait() -- Smallest possible tick
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: HYPER-SCAN (Zero Delay Lock)
            local startTime = tick()
            local clicked = false
            
            -- Scan continuously until the button is found or 1.5s passes
            while tick() - startTime < 1.5 and not clicked and _G.AutoTakeActive do
                local allGuis = PlayerGui:GetDescendants()
                for i = 1, #allGuis do
                    local obj = allGuis[i]
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                        
                        local centerX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                        local centerY = obj.AbsolutePosition.Y + DEEP_Y_OFFSET 
                        
                        -- INSTANT CLICK
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        
                        clicked = true
                        -- No task.wait here = Instant loop restart
                        break
                    end
                end
                -- Very tiny wait to prevent crashing but keep it "instant"
                RunService.Heartbeat:Wait() 
            end
            
            -- REMOVED task.wait(0.5) to ensure zero delay before next "E"
        end
    end
end)

print("Delta: Zero-Delay Build Active. Chain speed is maximum.")
