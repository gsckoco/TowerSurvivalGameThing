local Plot = {}

Plot.__index = Plot

function Plot.new(plotModel: Model)
	local self = setmetatable({}, Plot)

    self.plot = plotModel
    self.owner = ""
    self.items = {}

    self.grid = {}
    for i = 1, 29 do
        self.grid[i] = {}
    end

	return self
end

function Plot:SetSize(size: number)
    size = math.clamp(size, 0, 18) + 11
    self.plot:SetAttribute("PlotSize", size)
    self.plot.Base.Size = Vector3.new(4 * size, 1, 4 * size)
end

function Plot:Reset()
    self:Clear()
    self:SetSize(0)
end

function Plot:Clear()
    for _, v in pairs(self.items) do
        v:Destroy()
    end
    self.items = {}
end

function Plot:SetOwner(owner: string)
    self.owner = owner
    self.plot:SetAttribute("Owner", owner)
end

return Plot