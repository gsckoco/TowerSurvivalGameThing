local Plot = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Functions = require(ReplicatedStorage.Knit.Util.Tower.Functions)

Plot.__index = Plot

local MAX_SIZE = 35

function Plot.new(plotModel: Model)
	local self = setmetatable({}, Plot)

    self.plot = plotModel
    self.owner = ""
    self.items = {}

    self.grid = {}
    self.gridDebug = {}
    self.debugTiles = {}
    for x = 1, MAX_SIZE do
        self.grid[x] = {}
        self.gridDebug[x] = {}
        for y = 1, MAX_SIZE do
            self.grid[x][y] = nil
            local part = Instance.new("Part")
            part.Anchored = true
            part.Parent = self.plot.Tiles
            part.CanCollide = false
            part.Transparency = 1
            part.Material = "Neon"
            part.Color = Color3.fromRGB(0, 255, 0)
            part.Size = Vector3.new(3.9, 1.2, 3.9)
            part.CFrame = self.plot.Base.CFrame:ToWorldSpace(CFrame.new(4 * (x - 15), 0, 4 * (y - 15) ))
            part.Name = x .. "," .. y
            self.gridDebug[x][y] = part
            table.insert(self.debugTiles, part)
        end
    end

	return self
end

function Plot:SetSize(size: number)
    size = math.clamp(size, 0, MAX_SIZE - 11) + 11
    self.plot:SetAttribute("PlotSize", size)
    self.plot.Base.Size = Vector3.new(4 * size, 1, 4 * size)
end

function Plot:Reset()
    self:Clear()
    self:SetSize(0)
    self:PlaceItem("Base", Vector2.new(0, 0), 0)
end

function Plot:Clear()
    for _, v in pairs(self.items) do
        v:Destroy()
    end
    self.items = {}
    for _, v in pairs(self.debugTiles) do
        v.Color = Color3.fromRGB(0, 255, 0)
        v.Transparency = 1
    end
end

function Plot:SetOwner(owner: string)
    self.owner = owner
    self.plot:SetAttribute("Owner", owner)
    self.plot.Name = owner
end

function Plot:PlaceItem(item, position, rotation)
    local itemModule = require(ReplicatedStorage.Items:FindFirstChild(item))
    local model = itemModule.Model:Clone()
    model:SetPrimaryPartCFrame(self.plot.Base.CFrame:ToWorldSpace(CFrame.new(position.X * 4, 0, position.Y * 4) * CFrame.Angles(0, math.rad(90 * rotation), 0)))
    model.Parent = self.plot.Items

    for _, v in pairs(model.Footprint:GetChildren()) do
        local gridPosition = self.plot.Base.CFrame:ToObjectSpace(Functions.getSmallGrid(self.plot.Base, v.Position))
        local x, y = 15 + (gridPosition.X / 4), 15 + (gridPosition.Z / 4)
        self.gridDebug[x][y].Color = Color3.new(1, 0, 0)
        self.gridDebug[x][y].Transparency = .6
    end
end

return Plot