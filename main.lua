-- [[ Bloxburg Ultimate Auto-Take - Delta Optimized ]]
print("Delta: Injecting Zero-Fail Build...")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Configuration
_G.AutoTakeEnabled = true -- Starts ON

-- [[ UI SETUP ]]
if PlayerGui:FindFirstChild("BloxburgFinalUI") then
    PlayerGui.BloxburgFinalUI:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "BloxburgFinalUI"
sg.Parent = PlayerGui
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Parent = sg
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0.5, -80, 0.2, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
btn.Text = "AUTO-TAKE: ON"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Active = true
btn.Draggable = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- [[ TOGGLE LOGIC ]]
btn.MouseButton1Click:Connect(function()
    _G.AutoTakeEnabled = not _G.AutoTakeEnabled
    if _G.AutoTakeEnabled then
        btn.Text = "AUTO-TAKE: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    else
        btn.Text = "AUTO-TAKE: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

-- [[ THE INTERACTION HOOK ]]
-- This version searches for the Bloxburg "ActionMenu" which is unique
RunService.RenderStepped:Connect(function()
    if _G.AutoTakeEnabled then
        -- Bloxburg creates a 'Menu' or 'ActionMenu' object when you press E
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and (gui.Name:find("Menu") or gui.Name == "ActionMenu") then
                for _, element in pairs(gui:GetDescendants()) do
                    -- Search for the Text "Take"
                    if (element:IsA("TextLabel") or element:IsA("TextButton")) and 
                       (element.Text == "Take" or element.Text:find("Take")) then
                        
                        -- Find the button to click
                        local clicker = element:IsA("TextButton") and element or element:FindFirstAncestorOfClass("TextButton")
                        
                        if clicker then
                            -- Force the click
                            pcall(function()
                                if firesignal then
                                    firesignal(clicker.MouseButton1Click)
                                    firesignal(clicker.MouseButton1Down)
                                end
                                clicker:Activate()
                            end)
                        end
                    end
                end
            end
        end
        
        -- Fallback: Check for generic buttons named 'Option' or 'Action'
        for _, v in pairs(PlayerGui:GetDescendants()) do
            if v:IsA("TextButton") and v.Visible and v.Text == "Take" then
                pcall(function()
                    if firesignal then firesignal(v.MouseButton1Click) end
                    v:Activate()
                end)
            end
        end
    end
end)

print("Delta: Loaded. Press 'E' on food to see it work!")
