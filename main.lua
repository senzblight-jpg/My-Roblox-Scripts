-- [[ BLOXBURG RADIAL-CRACKER: CENTER-HIT EDITION ]]
print("Delta: Injecting Center-Hit Loader...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP OLD SESSIONS
local uiName = "ZBindRadialV5"
if PlayerGui:FindFirstChild(uiName) then 
    PlayerGui[uiName]:Destroy() 
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local INTERACTION_DELAY = 1.0 -- Slightly longer to ensure radial menu is stable
local TOGGLE_KEY = Enum.KeyCode.Z

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = uiName
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

-- 4. TOGGLE FUNCTION
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "AUTO [Z]: ON" or "AUTO [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end

btn.MouseButton1Click:Connect(toggle)

-- Force-check for Z key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == TOGGLE_KEY then
        toggle()
    end
end)

-- 5. THE AUTOMATION LOOP
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoTakeActive then
            
            -- STEP A: Press "E"
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            -- STEP B: WAIT FOR RADIAL MENU
            task.wait(INTERACTION_DELAY)

            -- STEP C: SCAN AND CENTER-CLICK
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- Check for "Take" or "Take Portion"
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and (obj.Text == "Take" or obj.Text == "Take Portion") then
                    
                    -- Calculate the EXACT center of the button
                    local absPos = obj.AbsolutePosition
                    local absSize = obj.AbsoluteSize
                    
                    -- We add a small offset to the Y axis to click lower into the button
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + (absSize.Y / 2) + 5 -- +5px downward adjustment
                    
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end)
                    
                    print("Clicked " .. obj.Text .. " at: " .. tostring(centerX) .. ", " .. tostring(centerY))
                    break -- Stop scanning once clicked
                end
            end
        end
    end
end)

print("Delta: Z-Toggle Center-Hit Active!")
