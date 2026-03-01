-- [[ BLOXBURG DEEP-CLICK: COORDINATE RE-RE-CALIBRATION ]]
print("Delta: Injecting Deep-Click Precision Build...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. FORCE CLEANUP (Ensures zero interference)
local function cleanup()
    for _, old in pairs(PlayerGui:GetChildren()) do
        if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") or old.Name:find("Perfect") then
            old:Destroy()
        end
    end
end
cleanup()

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local RADIAL_DELAY = 1.2  -- Time for the menu to stop moving
local DEEP_Y_OFFSET = 60  -- INCREASED: Moves the click 60 pixels DOWN from the text

-- 3. CREATE CLEAN UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "DeepRadialV9"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue for V9
btn.Text = "DEEP-TAKE [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE LOGIC (Z-KEY)
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "DEEP-TAKE [Z]: ON" or "DEEP-TAKE [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 50, 50)
end

btn.MouseButton1Click:Connect(toggle)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then toggle() end
end)

-- 5. THE DEEP-SCAN LOOP
task.spawn(function()
    while task.wait(0.7) do
        if _G.AutoTakeActive then
            -- Open Menu
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            task.wait(RADIAL_DELAY)

            -- Scan with Deep-Y Logic
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- Detect "Take" or "Take Portion"
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    
                    local absPos = obj.AbsolutePosition
                    local absSize = obj.AbsoluteSize
                    
                    --[[
                        CALIBRATION LOGIC:
                        We take the center-width of the text (centerX).
                        We take the top of the text and add a heavy offset (centerY).
                        This forces the tap to occur well below the text label.
                    ]]
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + DEEP_Y_OFFSET 
                    
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end)
                    
                    print("Deep Click Executed at: " .. math.floor(centerX) .. ", " .. math.floor(centerY))
                    break 
                end
            end
        end
    end
end)

print("Delta: Deep-Click V9 Loaded. Target: Middle of Button Box.")
