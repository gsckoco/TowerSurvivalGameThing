local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:WaitForChild("Knit"))
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local Plot = require(Knit.Classes.Plot)

local Players = game:GetService("Players")

local GameService = Knit.CreateService { Name = "GameService", Client = {} }

GameService.Client.PlaceItem = RemoteSignal.new()

function GameService:KnitInit()
    local function CharacterAdded(character)
        wait() -- Character isn't ready for some reason when this event is fired?!?
        -- Teleport character to plot.
        local player = Players:GetPlayerFromCharacter(character)
        local plot = self:GetPlot(player.Name)
        character.HumanoidRootPart.CFrame = plot.plot.Base.CFrame * CFrame.new(0, 5, 0)
    end
    local function PlayerAdded(player)
        player.CharacterAdded:Connect(CharacterAdded)
        -- Select a plot for the player.
        local emptyPlot = self:GetAvailablePlot()
        emptyPlot:Reset()
        emptyPlot:SetOwner(player.Name)
    end
    local function PlayerRemoving(player)
        local playerPlot = self:GetPlot(player.Name)
        playerPlot:Reset()
        playerPlot:SetOwner("")
    end

    self.plots = {}

    for _, v in pairs(game.Workspace.PlotPositions:GetChildren()) do
        local newPlot = ReplicatedStorage.Plot:Clone()
        newPlot.Parent = game.Workspace:WaitForChild("Plots")
        newPlot:SetPrimaryPartCFrame(v.CFrame)
        v:Destroy()
        local newPlotObject = Plot.new(newPlot)
        table.insert(self.plots, newPlotObject)
    end

    Players.PlayerAdded:Connect(PlayerAdded)
    Players.PlayerRemoving:Connect(PlayerRemoving)

    self.Client.PlaceItem:Connect(function(player, item, position)
        local plot = self:GetPlot(player.Name)
        plot:PlaceItem(item, position)
    end)
end

function GameService:GetPlot(owner: string)
    for _, v in pairs(self.plots) do
        if v.owner == owner then
            return v
        end
    end
end

function GameService:GetAvailablePlot()
    for _, v in pairs(self.plots) do
        if v.owner == "" then
            return v
        end
    end
end

return GameService