local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Knit"))

Knit.Classes = script.Parent.Classes

-- Load modules
for _, v in pairs(script.Parent.Services:GetChildren()) do
    require(v)
end


Knit.Start():Catch(warn)