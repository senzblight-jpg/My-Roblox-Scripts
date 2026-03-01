-- Settings
local buttonName = "Take" -- Change this to the actual name found in Dex

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Function to auto-click
local function autoClick()
    -- This searches the entire Gui for a button named "Take" that is visible
    for _, v in pairs(playerGui:GetDescendants()) do
        if v:IsA("TextButton") and v.Name == buttonName and v.Visible then
            -- Simulate a click
            firesignal(v.MouseButton1Click) 
            print("Automatically took the food!")
        end
    end
end

-- Run the check every 0.1 seconds
task.spawn(function()
    while task.wait(0.1) do
        autoClick()
    end
end)
