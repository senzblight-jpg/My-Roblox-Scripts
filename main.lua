-- [[ BLOXBURG ULTIMATE AUTO-TAKE - FOOL PROOF ]]
print("Delta: Loading Bloxburg Specialist Script...")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- State Variable
_G.AutoTakeActive = true

-- [[ UI CLEANUP ]]
if PlayerGui:FindFirstChild("BloxburgSpecialist") then
    PlayerGui.BloxburgSpecialist:Destroy()
end

-- [[ CREATE MENU ]]
local sg = Instance.new("ScreenGui")
sg.Name = "BloxburgSpecialist"
sg.Parent = PlayerGui
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Parent = sg
btn.Size = UDim2.new(0, 150, 0, 45)
btn.Position = UDim2.new(0.5, -75, 0.15, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 210, 100) -- Start Green
btn.Text = "AUTO-TAKE: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Draggable = true

local corner = Instance.new("UICorner", btn)
corner.CornerRadius = UDim.new(0, 10)

-- [[ TOGGLE LOGIC ]]
btn.MouseButton1Click:Connect(function()
    _G.AutoTakeActive = not _G.AutoTakeActive
    if _G.AutoTakeActive then
        btn.Text = "AUTO-TAKE: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 210, 100)
    else
        btn.Text = "AUTO-TAKE: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
    end
end)

-- [[ THE FOOL-PROOF SCANNER ]]
-- This checks every frame for Bloxburg's specific menu structure
RunService.RenderStepped:Connect(function()
    if _G.AutoTakeActive then
        -- 1. Search for Bloxburg's ActionMenu or circular guis
        for _, gui in pairs(PlayerGui:GetChildren()) do
            -- Bloxburg menus usually have 'Action' or 'Menu' in their name
            if gui:IsA("ScreenGui") or gui:IsA("BillboardGui") then
                for _, obj in pairs(gui:GetDescendants()) do
                    -- Find the Text "Take" (case-sensitive to avoid glitches)
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and (obj.Text == "Take" or obj.Text == "Take Portion") then
                        
                        -- Find the button that owns this text
                        local button = obj:IsA("TextButton") and obj or obj:FindFirstAncestorOfClass("TextButton")
                        
                        if button and button.Visible then
                            -- Force a physical interaction
                            pcall(function()
                                -- Trigger for Delta/Mobile executors
                                if firesignal then
                                    firesignal(button.MouseButton1Click)
                                    firesignal(button.MouseButton1Down)
                                    firesignal(button.Activated)
                                end
                                button:Activate()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

print("Delta: Script Active! Walk to food and press E.")
