-- [[ BLOXBURG PERFECT-AIM: SCRATCH REBUILD ]]
-- Optimized for Delta Mobile & High Precision
print("Delta: Initializing Perfect-Aim Scratch Build...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. SESSION CLEANER: Removes all previous script UI to prevent overlap
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") or old.Name:find("Perfect") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local RADIAL_DELAY = 1.1 -- Wait for Bloxburg animation to stop

-- 3. CREATE CLEAN UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "PerfectRadialV7"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "PERFECT AUTO [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Draggable = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- 4. TOGGLE FUNCTION (Z-KEY VERIFIED)
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "PERFECT AUTO [Z]: ON" or "PERFECT AUTO [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end

btn.MouseButton1Click:Connect(toggle)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        toggle()
    end
end)

-- 5. THE PERFECT-AIM LOOP
task.spawn(function()
    while task.wait(0.6) do
        if _G.AutoTakeActive then
            
            -- Interaction: Spam "E"
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            -- Wait for the radial menu to fully appear
            task.wait(RADIAL_DELAY)

            -- ACCURACY SCAN: Finding the exact center of the "Take" button
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- Detect the "Take" text
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    
                    -- Track back to the actual button container for size data
                    local target = obj:IsA("TextButton") and obj or obj:FindFirstAncestorOfClass("TextButton") or obj
                    
                    -- GEOMETRIC CENTER CALCULATION
                    -- Formula: Center = Position + (Size / 2)
                    local absPos = target.AbsolutePosition
                    local absSize = target.AbsoluteSize
                    
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + (absSize.Y / 2)
                    
                    -- Final Tap Execution
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end)
                    
                    print("Perfect Hit at: " .. math.floor(centerX) .. ", " .. math.floor(centerY))
                    break -- Successful click, end scan for this loop
                end
            end
        end
    end
end)

print("Delta: Perfect-Aim Scratch Build Active. Press Z to Toggle.")
