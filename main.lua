-- [[ BLOXBURG ULTIMATE AUTO-TAKE ]]
-- Optimized for Delta Mobile
print("Delta: Starting Fresh Build...")

-- 1. Configuration
local TargetText = "Take" -- The text we are hunting for
_G.AutoTakeActive = true  -- Starts ON as requested

-- 2. Cleanup existing UI to avoid glitching
local old = game.Players.LocalPlayer.PlayerGui:FindFirstChild("BloxburgHelper")
if old then old:Destroy() end

-- 3. Create the UI
local sg = Instance.new("ScreenGui")
sg.Name = "BloxburgHelper"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Name = "Toggle"
btn.Parent = sg
btn.Size = UDim2.new(0, 150, 0, 45)
btn.Position = UDim2.new(0.5, -75, 0.15, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- Starts Green (ON)
btn.Text = "AUTO-TAKE: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16
btn.Draggable = true -- Essential for mobile/Delta users

-- Add a nice rounded corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = btn

-- 4. Toggle Function
btn.MouseButton1Click:Connect(function()
    _G.AutoTakeActive = not _G.AutoTakeActive
    if _G.AutoTakeActive then
        btn.Text = "AUTO-TAKE: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        btn.Text = "AUTO-TAKE: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- 5. The "Brute Force" Logic
-- This loop checks for BOTH UI buttons and ProximityPrompts
task.spawn(function()
    while task.wait(0.2) do -- Fast enough to be "auto", slow enough to not crash
        if _G.AutoTakeActive then
            -- METHOD A: Search UI (For the menu you see in your image)
            local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, v in pairs(pGui:GetDescendants()) do
                    if v:IsA("TextButton") and v.Visible and (v.Text:find(TargetText) or v.Name:find(TargetText)) then
                        -- Delta specific click triggers
                        pcall(function()
                            if firesignal then
                                firesignal(v.MouseButton1Click)
                            end
                            v:Activate()
                        end)
                    end
                end
            end
            
            -- METHOD B: Search for ProximityPrompts (In case Bloxburg updated)
            for _, prompt in pairs(game:GetService("ProximityPromptService"):GetProximityPrompts()) do
                if prompt.ActionText:find(TargetText) or prompt.ObjectText:find(TargetText) then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end)

print("Delta: Bloxburg Script Ready & Active!")
