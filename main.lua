-- [[ BLOXBURG PRO-AUTO-TAKE: COORDINATE HOOK ]]
-- Designed for Delta Mobile / Bloxburg Radial Menus
print("Delta: Injecting Professional Coordinate Hook...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Configuration
_G.AutoTakeActive = true

-- [[ UI SETUP ]]
if PlayerGui:FindFirstChild("ProAutoTake") then PlayerGui.ProAutoTake:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ProAutoTake"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 160, 0, 45)
btn.Position = UDim2.new(0.5, -80, 0.1, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "PRO-TAKE: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "PRO-TAKE: ON" or "PRO-TAKE: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- [[ THE PROFESSIONAL CLICKER ]]
RunService.RenderStepped:Connect(function()
    if not _G.AutoTakeActive then return end
    
    -- We scan everything for the text "Take"
    local allGuis = PlayerGui:GetDescendants()
    for i = 1, #allGuis do
        local obj = allGuis[i]
        
        -- If it's the "Take" button/text and it's visible on screen
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible and obj.Transparency < 1 then
            if obj.Text == "Take" or obj.Text == "Take Portion" then
                
                -- Get the Absolute Position of the button on your phone screen
                local pos = obj.AbsolutePosition
                local size = obj.AbsoluteSize
                local centerX = pos.X + (size.X / 2)
                local centerY = pos.Y + (size.Y / 2)
                
                -- PRO METHOD: Use VirtualInputManager to tap the screen center
                pcall(function()
                    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                    
                    -- Secondary fallback for executors that don't support VIM
                    if firesignal then
                        local btnObj = obj:IsA("TextButton") and obj or obj:FindFirstAncestorOfClass("TextButton")
                        if btnObj then
                            firesignal(btnObj.MouseButton1Click)
                            firesignal(btnObj.Activated)
                        end
                    end
                end)
            end
        end
    end
end)

print("Delta: Pro-Script Active. No button can hide now.")
