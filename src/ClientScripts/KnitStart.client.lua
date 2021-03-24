local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Knit"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load modules
for _, v in pairs(ReplicatedStorage.Controllers:GetChildren()) do
    require(v)
end

Knit.Start():Catch(warn)