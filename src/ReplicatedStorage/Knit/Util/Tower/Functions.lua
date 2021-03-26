local functions = {}

function functions.getSmallGrid(base, position)
	local relativePosition = base.CFrame:ToObjectSpace(CFrame.new(position))
	local x, y = math.floor((relativePosition.X / 4) + 0.5), math.floor((relativePosition.Z / 4) + 0.5)
	
	return base.CFrame * CFrame.new(x * 4, 0, y * 4)
end

return functions