local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Knit"))
local BuildController = Knit.CreateController({ Name = "BuildController" })
local Functions = require(Knit.Util.Tower.Functions)

local Player = game:GetService("Players").LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Mouse = Player:GetMouse()

local RunService = game:GetService("RunService")

function BuildController:KnitStart()
    local GuiController = Knit.Controllers.GuiController
    local BuildGui = Player.PlayerGui:WaitForChild("BuildGui")

    local startPosition = BuildGui.Menu.Position

    self.plot = game.Workspace:WaitForChild("Plots"):WaitForChild(Player.Name)
    self.base = self.plot.Base
    self.mouseRaycast = RaycastParams.new()
    self.mouseRaycast.FilterType = Enum.RaycastFilterType.Whitelist
    self.mouseRaycast.FilterDescendantsInstances = {self.plot.Base}

    self.buildMode = false
    self.buildGhost = nil

    BuildGui.Menu.Close.MouseButton1Down:Connect(function()
        GuiController:SetState("None")
    end)

    GuiController.StateChange:Connect(function(state)
        if state == "Build" then
            wait(0.25)
            self.BuildMode = true
            BuildGui.Enabled = true
            BuildGui.Menu.Position = startPosition + UDim2.fromScale(0, 0.4)
            BuildGui.Menu:TweenPosition(startPosition, "In", "Quad", 0.2, true)
        else
            self.BuildMode = false
            BuildGui.Menu:TweenPosition(startPosition + UDim2.fromScale(0, 0.4), "Out", "Quad", 0.2, true, function()
                BuildGui.Enabled = false
            end)
        end
    end)

    RunService.RenderStepped:Connect(function(delta)
        if self.buildMode and self.buildGhost then
		    local screenRay = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
		    local raycastResult = game.Workspace:Raycast(screenRay.Origin, screenRay.Direction * 500, self.mouseRaycast)
            if raycastResult and raycastResult.Normal == Vector3.new(0, 1, 0) then
                local position = Functions.getSmallGrid(self.base, raycastResult.Position)
                self.buildGhost:SetPrimaryPartCFrame(position)
                print((position.X / 4), (position.Z / 4))
            end
        end
    end)
end

return BuildController