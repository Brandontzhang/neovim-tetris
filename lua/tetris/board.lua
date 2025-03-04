local Board = {}
Board.__index = Board

function Board:new()
	local instance = setmetatable({}, Board)
	instance.width = 10
	instance.height = 20
	instance.grid = {}

	for y = 1, instance.height do
		instance.grid[y] = {}
		for x = 1, instance.width do
			instance.grid[y][x] = "▣"
		end
	end

	return instance
end

function Board:render()
	local renderBoard = ""
	for y = 1, self.height do
		for x = 1, self.width do
			renderBoard = renderBoard .. self.grid[y][x]
		end
		renderBoard = renderBoard .. "\n"
	end

	return renderBoard
end

return Board
