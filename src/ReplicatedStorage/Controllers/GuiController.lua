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
    for _, v in pairs(ReplicatedStorage:WaitForChild("Guis"):GetChildren()) do
        v.Parent = Player:WaitForChild("PlayerGui")
    end
    MainGui = Player:WaitForChild("PlayerGui"):WaitForChild("MainGui")

    MainGui.MainBar.Inner.Build.MouseButton1Down:Connect(function()
        self:SetState("Build")
    end)

    self.StateChange:Connect(function(state: string)
        if state == "Build" then
            MainGui.MainBar:TweenPosition(UDim2.fromScale(0.5, 1.1), "Out", "Quad", 0.25, true, function()
                MainGui.MainBar.Visible = false
            end)
        elseif state == "None" then
            MainGui.MainBar.Visible = true
            MainGui.MainBar:TweenPosition(UDim2.fromScale(0.5, 1), "In", "Quad", 0.25, true)
        end
    end)
end

function GuiController:SetState(state: string)
    self.State = state
    self.StateChange:Fire(state)
end

return GuiController