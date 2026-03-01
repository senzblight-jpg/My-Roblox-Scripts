-- [[ BLOXBURG RADIAL-CRACKER: FINAL ACCURACY ]]
print("Delta: Injecting Final Accuracy Fix...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. DESTROY ALL OLD LOADERS (Prevents UI Clutter seen in photos)
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local INTERACTION_DELAY = 1.2 -- Time for radial menu to fully stabilize
local Y_DOWN_OFFSET = 35      -- Shifted down significantly to hit the button center
local TOGGLE_KEY = Enum.KeyCode.Z

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZBindRadialFinal"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.05, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "AUTO [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

-- 4. TOGGLE FUNCTION (Z-KEY FIX)
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "AUTO [Z]: ON" or "AUTO [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end

btn.MouseButton1Click:Connect(toggle)

-- Fixed Z-Toggle to work regardless of game focus
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TOGGLE_KEY then
        toggle()
    end
end)

-- 5. THE AUTOMATION LOOP
task.spawn(function()
    while task.wait(0.7) do
        if _G.AutoTakeActive then
            
            -- Step A: Spam "E"
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            -- Step B: Wait for menu to settle
            task.wait(INTERACTION_DELAY)

            -- Step C: Scan and Click with corrected Y-Offset
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible then
                    if obj.Text == "Take" or obj.Text == "Take Portion" then
                        
                        -- Calculate the Absolute Center of the text label
                        local absPos = obj.AbsolutePosition
                        local absSize = obj.AbsoluteSize
                        
                        -- Center-width, but shifted DOWN to hit the white box center
                        local centerX = absPos.X + (absSize.X / 2)
                        local centerY = absPos.Y + (absSize.Y / 2) + Y_DOWN_OFFSET 
                        
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        end)
                        
                        -- Debug print to verify location in console
                        print("Tapped " .. obj.Text .. " at pixel: " .. tostring(math.floor(centerX)) .. ", " .. tostring(math.floor(centerY)))
                        break 
                    end
                end
            end
        end
    end
end)

print("Delta: Final Accuracy Script Loaded. Press Z to Toggle.")
