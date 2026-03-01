-- [[ BLOXBURG RADIAL-CRACKER V2 ]]
-- Optimized for Delta Mobile & Bloxburg Radial Menus
print("Delta: Injecting Hardware-Level Interaction Hook...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Default state is ON
_G.AutoTakeActive = true

-- [[ UI SETUP ]]
if PlayerGui:FindFirstChild("RadialCracker") then PlayerGui.RadialCracker:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "RadialCracker"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 160, 0, 45)
btn.Position = UDim2.new(0.5, -80, 0.05, 0) -- Top center
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "AUTO-TAKE: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "AUTO-TAKE: ON" or "AUTO-TAKE: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- [[ THE HARDWARE HOOK ]]
RunService.RenderStepped:Connect(function()
    if not _G.AutoTakeActive then return end
    
    -- Bloxburg stores radial menus in various folders. We scan everything.
    for _, gui in pairs(PlayerGui:GetChildren()) do
        -- Only scan visible ScreenGuis or BillboardGuis
        if (gui:IsA("ScreenGui") or gui:IsA("BillboardGui")) then
            for _, obj in pairs(gui:GetDescendants()) do
                -- Look for the specific text "Take" or "Take Portion"
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible then
                    if obj.Text == "Take" or obj.Text == "Take Portion" then
                        
                        -- Calculate the Absolute Center of the button on your phone screen
                        local absPos = obj.AbsolutePosition
                        local absSize = obj.AbsoluteSize
                        local centerX = absPos.X + (absSize.X / 2)
                        local centerY = absPos.Y + (absSize.Y / 2)
                        
                        -- Send a VIRTUAL HARDWARE TAP to that exact pixel
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                            task.wait()
                            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                        end)
                        
                        -- Short cooldown to prevent spamming
                        task.wait(0.1)
                    end
                end
            end
        end
    end
end)

print("Delta: Script Active. Press E on food now!")
