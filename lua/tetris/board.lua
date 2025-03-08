local Piece = require("tetris.piece")

local Board = {}
Board.__index = Board

function Board:new()
	local instance = setmetatable({}, Board)
	instance.width = 10
	instance.height = 20
	instance.grid = {}

	for x = 1, instance.width do
		instance.grid[x] = {}
		for y = 1, instance.height do
			instance.grid[x][y] = " "
		end
	end

	instance:generatePiece()

	return instance
end

function Board:generatePiece()
	local randomType = Piece.types[math.random(1, #Piece.types)]
	self.curPiece = Piece.new(randomType)

	self:placePiece()
end

function Board:placePiece()
	local piece = self.curPiece
	local rotation = piece.rotation

	for x = piece.row, piece.row + piece.width - 1 do
		for y = piece.col, piece.col + piece.height - 1 do
			local val = rotation[(x - piece.row) + 1][(y - piece.col) + 1]
			if val == 1 then
				self.grid[x][y] = piece.type
			end
		end
	end
end

function Board:render()
	local renderBoard = {}
	for x = 1, self.width do
		local row = ""
		for y = 1, self.height do
			row = row .. self.grid[x][y] .. self.grid[x][y]
		end
		table.insert(renderBoard, row)
	end

	return renderBoard
end

return Board
