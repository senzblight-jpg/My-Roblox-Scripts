local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

-- Instead of searching ServerStorage (which you can't see from a client)
-- You have to find where the game puts the food in the workspace
local function findFood()
    for _, item in pairs(workspace:GetDescendants()) do
        -- Most games use a specific name or a "ClickDetector"
        if item.Name == "FoodPart" and item:FindFirstChildOfClass("ClickDetector") then
            return item
        end
    end
end

-- Simulating the interaction
local food = findFood()
if food then
    -- This triggers the 'E' or Click interaction if the game uses ClickDetectors
    fireclickdetector(food.ClickDetector) 
end
