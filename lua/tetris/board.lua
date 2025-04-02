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

	for row = piece.row, piece.row + piece.height - 1 do
		for col = piece.col, piece.col + piece.width - 1 do
			local pieceRow = (row - piece.row) + 1
			local pieceCol = (col - piece.col) + 1
			local val = piece.grid[pieceRow][pieceCol]

			if col < 0 or row > self.height - 1 then
				goto continue
			elseif val == 1 then
				self.grid[row][col] = " "
			end
			::continue::
		end
	end
end

function Board:placePiece()
	local piece = self.curPiece

	-- TODO: Considerations for moving pieces left and right (potential for negative starting row)
	for row = piece.row, math.min(piece.row + piece.height - 1, self.height) do
		for col = piece.col, piece.col + piece.width - 1 do
			local pieceRow = (row - piece.row) + 1
			local pieceCol = (col - piece.col) + 1
			local val = piece.grid[pieceRow][pieceCol]

			if val == 1 then
				self.grid[row][col] = piece.type
			end
		end
	end
end

function Board:rotateCW()
	self.curPiece.rotateCW()
end

function Board:moveLeft()
	local piece = self.curPiece

	if piece.col > 1 then
		self:clearPiece()
		self.curPiece:moveLeft()
	end
end

function Board:moveRight()
	local piece = self.curPiece

	if (piece.col + piece.width) <= self.width then
		self:clearPiece()
		self.curPiece:moveRight()
	end
end

function Board:gravity()
	local pieceLanded = self:pieceLanded()
	if pieceLanded then
		-- TODO: do checks before locking in the piece
		self:generatePiece()
	else
		self:clearPiece()
		self.curPiece:moveDown()
		self:placePiece()
	end
end

-- FIXME: Some pieces are still going a bit too far down
function Board:pieceLanded()
	local piece = self.curPiece

	-- 1. Get the surrounding blocks in the area around the current piece
	-- TODO: Memoize the value if the location and piece haven't changed
	local height = 0
	local localGrid = {}
	for row = piece.row, math.min(piece.row + piece.height, self.height) do
		local pieceRow = (row - piece.row) + 1
		localGrid[pieceRow] = {}

		for col = piece.col, piece.col + piece.width - 1 do
			local pieceCol = (col - piece.col) + 1

			if (pieceRow <= piece.height and pieceCol <= piece.col) and piece.grid[pieceRow][pieceCol] == 1 then
				localGrid[pieceRow][pieceCol] = "x"
			else
				localGrid[pieceRow][pieceCol] = self.grid[row][col]
			end
		end

		height = height + 1
	end

	-- 2. if the piece is at the bottom, or has another piece below it, return true
	for rowIndex, row in ipairs(localGrid) do
		for colIndex, val in ipairs(row) do
			if
				val == "x"
				and (
					rowIndex == height
					or (localGrid[rowIndex + 1][colIndex] ~= " " and localGrid[rowIndex + 1][colIndex] ~= "x")
				)
			then
				return true
			end
		end
	end

	return false
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
