local Board = {}
Board.__index = Board

function Board:new()
	local instance = setmetatable({}, Board)
	instance.width = 10
	instance.height = 20
	instance.grid = {}

	-- TODO: Fix creation of grid to follow x,y format
	for y = 1, instance.height do
		instance.grid[y] = {}
		for x = 1, instance.width do
			instance.grid[y][x] = "_"
		end
	end

	return instance
end

function Board:addPiece(piece)
	local rotation = piece.rotation

	vim.notify(piece.height .. ", " .. piece.width, vim.log.levels.DEBUG)

	for x = piece.x, piece.x + piece.width - 1 do
		for y = piece.y, piece.y + piece.height - 1 do
			local val = rotation[(x - piece.x) + 1][(y - piece.y) + 1]
			if val == 1 then
				self.grid[x][y] = val
			end
		end
	end
end

function Board:render()
	local renderBoard = {}
	for y = 1, self.height do
		local row = ""
		for x = 1, self.width do
			row = row .. self.grid[y][x] .. self.grid[y][x]
		end
		table.insert(renderBoard, row)
	end

	return renderBoard
end

return Board
