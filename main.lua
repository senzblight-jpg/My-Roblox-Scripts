-- [[ BLOXBURG PRECISION CRACKER: V6 ]]
print("Delta: Injecting Final Precision Fix...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. DESTROY ALL OLD LOADERS (Cleanup)
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local INTERACTION_DELAY = 1.1 -- Slightly longer to let the menu settle
local Y_OFFSET = 25 -- INCREASED OFFSET: This moves the click DOWN into the button
local TOGGLE_KEY = Enum.KeyCode.Z

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZBindRadialV6"
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

-- 4. TOGGLE FUNCTION (Z-KEY VERIFIED)
local function toggle()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "AUTO [Z]: ON" or "AUTO [Z]: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end

btn.MouseButton1Click:Connect(toggle)

UserInputService.InputBegan:Connect(function(input, processed)
    -- "Processed" is ignored to ensure Z works even if game is focused
    if input.KeyCode == TOGGLE_KEY then
        toggle()
    end
end)

-- 5. THE AUTOMATION LOOP
task.spawn(function()
    while task.wait(0.6) do
        if _G.AutoTakeActive then
            
            -- Press "E"
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            task.wait(INTERACTION_DELAY)

            -- SCAN AND CLICK WITH NEW OFFSET
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible then
                    -- Target specific text found in your photos
                    if obj.Text == "Take" or obj.Text == "Take Portion" then
                        
                        local absPos = obj.AbsolutePosition
                        local absSize = obj.AbsoluteSize
                        
                        -- ADJUSTED LOCATION: Clicking center-width but significantly lower
                        local centerX = absPos.X + (absSize.X / 2)
                        local centerY = absPos.Y + (absSize.Y / 2) + Y_OFFSET 
                        
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

print("Delta: Precision V6 Loaded. Z-Toggle is Active.")
