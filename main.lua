-- [[ BLOXBURG PERFECT-AIM: DYNAMIC CENTER CLICK ]]
print("Delta: Injecting Perfect-Aim Logic...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. STRIKE OLD VERSIONS (Ensures no UI ghosting)
for _, old in pairs(PlayerGui:GetChildren()) do
    if old.Name:find("Radial") or old.Name:find("Take") or old.Name:find("ZBind") then
        old:Destroy()
    end
end

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local SEARCH_TEXT = "Take" -- Matches "Take" and "Take Portion"

-- 3. CREATE UI
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZBindRadialPerfect"
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

-- 5. THE PERFECT-AIM LOOP
task.spawn(function()
    while task.wait(0.6) do
        if _G.AutoTakeActive then
            -- Trigger Interaction
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)

            -- Wait for UI to finish animating into position
            task.wait(1.1)

            -- ACCURACY SCAN
            local guis = PlayerGui:GetDescendants()
            for i = 1, #guis do
                local obj = guis[i]
                
                -- We look for the TextLabel, then find its parent button for the center
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and obj.Text:find(SEARCH_TEXT) then
                    
                    -- Find the actual clickable container
                    local targetObj = obj:IsA("TextButton") and obj or obj:FindFirstAncestorOfClass("TextButton") or obj
                    
                    -- PERFECT CENTER CALCULATION
                    local absPos = targetObj.AbsolutePosition
                    local absSize = targetObj.AbsoluteSize
                    
                    -- Mathematical Center: (Position + (Size / 2))
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + (absSize.Y / 2)
                    
                    -- On some high-DPI mobile screens, a small +10 offset helps hit the button "meat"
                    local finalY = centerY + 10 
                    
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(centerX, finalY, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(centerX, finalY, 0, false, game, 1)
                    end)
                    
                    print("Perfect Hit: " .. obj.Text .. " at " .. centerX .. ", " .. finalY)
                    break 
                end
            end
        end
    end
end)
