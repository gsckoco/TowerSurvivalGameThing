local ReplicatedStorage = game.ReplicatedStorage
local Knit = require(ReplicatedStorage:WaitForChild("Knit"))
local Signal = require(Knit.Util.Signal)
local GuiController = Knit.CreateController({ Name = "GuiController", State = "None" })

local Player = game.Players.LocalPlayer
local MainGui


function GuiController:KnitInit()
    GuiController.StateChange = Signal.new()
end

function GuiController:KnitStart()
    MainGui = ReplicatedStorage:WaitForChild("MainGui")
    MainGui.Parent = Player:WaitForChild("PlayerGui")

    MainGui.MainBar.Inner.Build.MouseButton1Down:Connect(function()
        self:SetState("Build")
    end)

    self.StateChange:Connect(function(state)
        if state == "Build" then
            MainGui.MainBar:TweenPosition(UDim2.fromScale(0.5, 1.1), "Out", "Quad", 0.5, true, function()
                MainGui.MainBar.Visible = false
            end)
        elseif state == "None" then
            MainGui.MainBar.Visible = true
            MainGui.MainBar:TweenPosition(UDim2.fromScale(0.5, 1), "In", "Quad", 0.5, true)
        end
    end)
end

function GuiController:SetState(state: string)
    self.State = state
    self.StateChange:Fire(state)
end

return GuiController