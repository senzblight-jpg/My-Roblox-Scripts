-- [[ BLOXBURG AUTO-TAKE: Z-KEYBIND EDITION ]]
print("Delta: Injecting Z-Keybind Loader...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. CLEANUP OLD SESSIONS
if PlayerGui:FindFirstChild("ZBindRadialV4") then 
    PlayerGui.ZBindRadialV4:Destroy() 
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local INTERACTION_DELAY = 0.8 -- Increased delay for slow-loading menus
local TOGGLE_KEY = Enum.KeyCode.Z

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZBindRadialV4"
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

-- 4. TOGGLE FUNCTION (Button & Keybind)
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "AUTO [Z]: ON" or "AUTO [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    print("Auto-Take Status: " .. tostring(_G.AutoTakeActive))
end

btn.MouseButton1Click:Connect(toggle)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TOGGLE_KEY then
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

            -- STEP B: PROPER DELAY (Waiting for menu to exist and animate)
            task.wait(INTERACTION_DELAY)

            -- STEP C: Coordinate-Based Click
            local found = false
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                -- Look for the Text "Take"
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and obj.Text == "Take" then
                    
                    local absPos = obj.AbsolutePosition
                    local absSize = obj.AbsoluteSize
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + (absSize.Y / 2)
                    
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    end)
                    found = true
                    break 
                end
            end
            
            -- If we didn't find "Take", try "Take Portion"
            if not found then
                for i = 1, #guis do
                    local obj = guis[i]
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and obj.Text == "Take Portion" then
                        local absPos = obj.AbsolutePosition
                        local absSize = obj.AbsoluteSize
                        local centerX = absPos.X + (absSize.X / 2)
                        local centerY = absPos.Y + (absSize.Y / 2)
                        
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        end)
                        break
                    end
                end
            end
        end
    end
end)

print("Delta: Z-Toggle Script Active! Press Z to toggle.")
