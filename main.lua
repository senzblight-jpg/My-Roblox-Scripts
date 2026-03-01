-- [[ BLOXBURG RADIAL AUTO-TAKE ]]
-- Specifically designed to click floating World-UI
print("Delta: Initializing World-Scanner...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- State starts as ON
_G.AutoTakeActive = true

-- [[ UI CLEANUP ]]
if PlayerGui:FindFirstChild("BloxburgRadialFix") then
    PlayerGui.BloxburgRadialFix:Destroy()
end

-- [[ TOGGLE UI ]]
local sg = Instance.new("ScreenGui")
sg.Name = "BloxburgRadialFix"
sg.Parent = PlayerGui
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Parent = sg
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0.5, -80, 0.15, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "AUTO-TAKE: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Draggable = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

btn.MouseButton1Click:Connect(function()
    _G.AutoTakeActive = not _G.AutoTakeActive
    btn.Text = _G.AutoTakeActive and "AUTO-TAKE: ON" or "AUTO-TAKE: OFF"
    btn.BackgroundColor3 = _G.AutoTakeActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- [[ THE RADIAL SCANNER ]]
RunService.Heartbeat:Connect(function()
    if _G.AutoTakeActive then
        -- METHOD 1: Scan Workspace (For BillboardGuis on the food)
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                for _, child in pairs(obj:GetDescendants()) do
                    if (child:IsA("TextLabel") or child:IsA("TextButton")) and child.Visible then
                        if child.Text == "Take" or child.Text == "Take Portion" then
                            local clicker = child:IsA("TextButton") and child or child:FindFirstAncestorOfClass("TextButton")
                            if clicker then
                                pcall(function()
                                    -- Force interactions
                                    if firesignal then
                                        firesignal(clicker.MouseButton1Click)
                                        firesignal(clicker.Activated)
                                    end
                                    clicker:Activate()
                                end)
                            end
                        end
                    end
                end
            end
        end

        -- METHOD 2: Scan PlayerGui (For the radial overlay)
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled then
                for _, element in pairs(gui:GetDescendants()) do
                    if (element:IsA("TextLabel") or element:IsA("TextButton")) and element.Text == "Take" then
                        local target = element:IsA("TextButton") and element or element:FindFirstAncestorOfClass("TextButton")
                        if target then
                            pcall(function()
                                if firesignal then firesignal(target.MouseButton1Click) end
                                target:Activate()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

print("Delta: Scanner Active. Walk to food and press E!")
