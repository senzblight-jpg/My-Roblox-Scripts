-- [[ BLOXBURG SEQUENTIAL-TAKE: RE-SYNCED EDITION ]]
print("Delta: Injecting Optimized Sequential Sync Build...")

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- 1. CLEANUP (Removes previous versions to prevent UI stacking)
local function cleanup()
    for _, old in pairs(PlayerGui:GetChildren()) do
        if old.Name == "NoSkipV11_Fixed" then
            old:Destroy()
        end
    end
end
cleanup()

-- 2. CONFIGURATION
_G.AutoTakeActive = true
local TOGGLE_KEY = Enum.KeyCode.Z
local CLICK_OFFSET = Vector2.new(0, 36) -- Offsets for Roblox Topbar GUI height

-- 3. UI SETUP
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "NoSkipV11_Fixed"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 45)
btn.Position = UDim2.new(0.5, -100, 0.1, 0)
btn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
btn.Text = "AUTO-TAKE [Z]: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.ClipsDescendants = true

local corner = Instance.new("UICorner", btn)
corner.CornerRadius = ToolPunchout.new(0, 8)

-- 4. TOGGLE LOGIC
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end -- Don't trigger if typing in chat
    if input.KeyCode == TOGGLE_KEY then
        _G.AutoTakeActive = not _G.AutoTakeActive
        btn.Text = _G.AutoTakeActive and "AUTO-TAKE [Z]: ON" or "AUTO-TAKE [Z]: OFF"
        btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(80, 80, 80)
    end
end)

-- 5. INTERACTION ENGINE
task.spawn(function()
    while true do
        task.wait(0.3) -- Faster cycle than 0.5
        if _G.AutoTakeActive then
            -- STEP 1: PRESS E
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- STEP 2: SCAN & CLICK
            local startTime = tick()
            local clicked = false
            
            -- Scan for 2 seconds (3 is often too slow for high-efficiency farming)
            while tick() - startTime < 2 and not clicked and _G.AutoTakeActive do
                local foundGui = nil
                
                -- Optimized search: Bloxburg GUIs are usually in specific folders
                for _, obj in ipairs(PlayerGui:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        if obj.Visible and (obj.Text:find("Take") or obj.Text:find("Portion")) then
                            foundGui = obj
                            break
                        end
                    end
                end

                if foundGui then
                    -- Calculate the center of the button on screen
                    local absPos = foundGui.AbsolutePosition
                    local absSize = foundGui.AbsoluteSize
                    -- Add CLICK_OFFSET to account for the Roblox TopBar
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + (absSize.Y / 2) + CLICK_OFFSET.Y
                    
                    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                    task.wait(0.03)
                    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    
                    clicked = true
                    print("Success: Item Taken.")
                end
                task.wait(0.1) 
            end
        end
    end
end)
