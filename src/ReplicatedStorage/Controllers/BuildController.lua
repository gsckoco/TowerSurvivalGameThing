local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Knit"))
local BuildController = Knit.CreateController({ Name = "BuildController" })

function BuildController:KnitStart()
    local GuiController = Knit.Controllers.GuiController
    GuiController.StateChange:Connect(function(state)
        print("State changed: ", state)
    end)
end

return BuildController