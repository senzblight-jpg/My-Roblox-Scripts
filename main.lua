-- [[ BLOXBURG PERFECT-HIT: COORDINATE RE-CALIBRATION ]]
print("Delta: Injecting Calibrated Scratch Build...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP PREVIOUS ATTEMPTS
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") or old.Name:find("Perfect") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local RADIAL_DELAY = 1.1 -- Wait for Bloxburg animation
local VERTICAL_FIX = 45  -- ADJUSTED: Moves the click 45 pixels LOWER than the text

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "PerfectRadialV8"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "PERFECT AUTO [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE FUNCTION (Z-KEY)
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "PERFECT AUTO [Z]: ON" or "PERFECT AUTO [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end

btn.MouseButton1Click:Connect(toggle)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then toggle() end
end)

-- 5. THE RE-CALIBRATED LOOP
task.spawn(function()
    while task.wait(0.6) do
        if _G.AutoTakeActive then
            -- Trigger "E"
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            task.wait(RADIAL_DELAY)

            -- SCAN WITH NEW COORDINATE MAPPING
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- Check for the specific text from your photos
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    
                    -- Get the raw coordinates of the text
                    local absPos = obj.AbsolutePosition
                    local absSize = obj.AbsoluteSize
                    
                    -- Calculate the Center-Width but shift the Y significantly DOWN
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + (absSize.Y / 2) + VERTICAL_FIX
                    
                    -- Execute Virtual Tap
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end)
                    
                    print("Precision Tap: " .. centerX .. ", " .. centerY)
                    break 
                end
            end
        end
    end
end)
