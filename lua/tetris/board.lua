local Piece = require("tetris.piece")

local Board = {}

-- INFO: There are 20 rows (height) and 10 columns (width) => board[row][col]
function Board:new()
	local instance = setmetatable({}, { __index = Board })
	instance.width = 10
	instance.height = 22 -- allowing for extra space at the top for spawning and rotation
	instance.grid = {}

	for row = 1, instance.height do
		instance.grid[row] = {}
		for col = 1, instance.width do
			instance.grid[row][col] = " "
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

function Board:clearPiece()
	local piece = self.curPiece
	local rotation = piece.rotation

	for row = piece.row, piece.row + piece.height - 1 do
		for col = piece.col, piece.col + piece.width - 1 do
			local pieceRow = (row - piece.row) + 1
			local pieceCol = (col - piece.col) + 1
			local val = rotation[pieceRow][pieceCol]

			if col < 0 or row > self.height - 1 then
				goto continue
			elseif val == 1 then
				self.grid[row][col] = " "
			end
			::continue::
		end
	end
end

-- TODO: adjust for upper collision detection area on spawn
function Board:placePiece()
	local piece = self.curPiece
	local rotation = piece.rotation

	-- The board should have 22 rows. 2 at the top which aren't displayed... meaning that should only be handled in the render. No need to worry about it here.
	for row = piece.row, piece.row + piece.height - 1 do
		for col = piece.col, piece.col + piece.width - 1 do
			local pieceRow = (row - piece.row) + 1
			local pieceCol = (col - piece.col) + 1
			local val = rotation[pieceRow][pieceCol]

			if col < 0 or row > self.height - 1 then
				goto continue
			elseif val == 1 then
				self.grid[row][col] = piece.type
			end
			::continue::
		end
	end
end

function Board:rotateCW()
	self.curPiece.rotateCW()
end

function Board:moveLeft()
	self.curPiece:moveLeft()
end

function Board:gravity()
	-- Removing the piece's previous position before moving it and redrawing with new location
	self:clearPiece()
	self.curPiece:moveDown()
	self:placePiece()
end

function Board:render()
	local renderBoard = {}

	for row = 3, self.height do
		local rowStr = ""
		for col = 1, self.width do
			rowStr = rowStr .. self.grid[row][col] .. self.grid[row][col]
		end
		table.insert(renderBoard, rowStr)
	end

	return renderBoard
end

return Board
