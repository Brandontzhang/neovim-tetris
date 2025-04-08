local Piece = require("tetris.piece")

local Board = {}
Board.__index = Board

-- INFO: There are 20 rows (height) and 10 columns (width) => board[row][col]
function Board:new()
	local board = setmetatable({}, { __index = Board })
	board:setup()

	return board
end

function Board:setup()
	self.grid = {}
	self.width = 10
	self.height = 22 -- allowing for extra space at the top for spawning and rotation
	self.speed = 27

	for row = 1, self.height do
		self.grid[row] = {}
		for col = 1, self.width do
			self.grid[row][col] = " "
		end
	end

	self:generatePiece()
end

function Board:generatePiece()
	local randomType = Piece.types[math.random(1, #Piece.types)]
	self.curPiece = Piece.new(randomType)

	self:drawPiece()
end

-- Draws the piece onto the grid
function Board:drawPiece()
	local piece = self.curPiece

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

-- Clears the piece from the grid
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

-- Goes through the board to remove any lines that are filled completely
function Board:clearLine()
	for index, row in ipairs(self.grid) do
		local isFilled = true
		for _, val in ipairs(row) do
			if val == " " then
				isFilled = false
			end
		end

		if isFilled then
			table.remove(self.grid, index)
			table.insert(self.grid, 1, { " ", " ", " ", " ", " ", " ", " ", " ", " ", " " })
		end
	end
end

-- Returns a 2D array representing the grid surrounding the current piece. +1 on left, right, and bottom
-- Ex. X C X X X    (C is the piece's row/col coords)
--     X J X X X
--     X J J J X
--     X X X X X
-- Different edge cases (left, right, bottom of board). Returns:
-- Left       Right     Bottom
-- C X X X    X C X X   X C X X X
-- J X X X    X J X X   X J X X X
-- J J J X    X J J J   X J J J X
-- X X X X    X X X X
-- Can also return different combinations of above.  Ex. Bottom right edge.
function Board:getPieceSurroundings()
	local piece = self.curPiece
	local retGrid = {}

	for gridRow = piece.row, math.min(piece.row + piece.height, self.height) do
		table.insert(retGrid, {})
		local curRow = retGrid[#retGrid]
		for gridCol = piece.col - 1, piece.col + piece.width do
			-- Left or right edges
			if gridCol == 0 or gridCol == self.width + 1 then
				goto skipColumn
			end

			-- Access the current pieces location if not checking out of bounds
			local pieceRow = gridRow - piece.row + 1
			local pieceCol = gridCol - piece.col + 1
			if piece:getBlock(pieceRow, pieceCol) == 1 then
				table.insert(curRow, "x")
			else
				table.insert(curRow, self.grid[gridRow][gridCol])
			end

			::skipColumn::
		end
	end

	return retGrid
end

function Board:leftCollision()
	local surrounding = self:getPieceSurroundings()

	for rowIndex, row in ipairs(surrounding) do
		for colIndex, val in ipairs(row) do
			local reachedEdge = (colIndex == 1)
			local touchingDifPiece = surrounding[rowIndex][colIndex - 1] ~= " "
				and surrounding[rowIndex][colIndex - 1] ~= "x"

			if val == "x" and (reachedEdge or touchingDifPiece) then
				return true
			end
		end
	end

	return false
end

function Board:rightCollision()
	local surrounding = self:getPieceSurroundings()

	for rowIndex, row in ipairs(surrounding) do
		for colIndex, val in ipairs(row) do
			local reachedEdge = (colIndex == #row)
			local touchingDifPiece = surrounding[rowIndex][colIndex + 1] ~= " "
				and surrounding[rowIndex][colIndex + 1] ~= "x"
			if val == "x" and (reachedEdge or touchingDifPiece) then
				return true
			end
		end
	end

	return false
end

function Board:bottomCollision()
	local surrounding = self:getPieceSurroundings()

	for rowIndex, row in ipairs(surrounding) do
		for colIndex, val in ipairs(row) do
			local reachedBottom = rowIndex == #surrounding
			local touchingDifPiece = rowIndex + 1 <= #surrounding
				and surrounding[rowIndex + 1][colIndex] ~= " "
				and surrounding[rowIndex + 1][colIndex] ~= "x"

			if val == "x" and (reachedBottom or touchingDifPiece) then
				return true
			end
		end
	end

	return false
end

-- TODO: Move some of the game logic out of here into game
-- TODO: Consider when the piece should be placed. Should consider rotation + movement + gravity, and then place?
-- TODO: Separate drawing a piece and locking it in
-- TODO: do checks before locking in the piece
function Board:tick()
	local pieceLanded = self:bottomCollision()
	if pieceLanded then
		self:generatePiece()
	else
		self:clearPiece()
		self.curPiece:moveDown()
	end
end

-- TODO: Check for surroundings before rotating (aka implement wall kicks)
function Board:rotate(direction)
	self:clearPiece()
	self.curPiece:rotate(direction)
end

function Board:moveLeft()
	if not self:leftCollision() then
		self:clearPiece()
		self.curPiece:moveLeft()
	end
end

function Board:moveRight()
	if not self:rightCollision() then
		self:clearPiece()
		self.curPiece:moveRight()
	end
end

function Board:softDrop()
	if not self:bottomCollision() then
		self:clearPiece()
		self.curPiece:moveDown()
	end
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
