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

	-- TODO: Implement line clearing
end

-- TODO: Check for surroundings before rotating (aka implement wall kicks)
function Board:rotate(direction)
	self:clearPiece()
	self.curPiece:rotate(direction)
end

function Board:moveLeft()
	if not self:leftEdge() then
		self:clearPiece()
		self.curPiece:moveLeft()
	end
end

function Board:moveRight()
	if not self:rightEdge() then
		self:clearPiece()
		self.curPiece:moveRight()
	end
end

-- TODO: Refactor for better readability and memoization
-- Technically only need the right two columns as well
function Board:rightEdge()
	local piece = self.curPiece
	local localGrid = {}

	-- INFO:
	-- Local Coords are with respect to the piece's grid
	-- col/row are wtih respect to the board's grid
	-- Reaching one further if necessary to check surrounding

	for row = piece.row, piece.row + piece.height - 1 do
		local localRow = (row - piece.row) + 1
		localGrid[localRow] = {}

		for col = piece.col, math.min(piece.col + piece.width + 1, self.width) do
			local localCol = (col - piece.col) + 1

			if piece.grid[localRow][localCol] == 1 then
				localGrid[localRow][localCol] = "x"
			else
				localGrid[localRow][localCol] = self.grid[row][col]
			end
		end
	end

	for rowIndex, row in ipairs(localGrid) do
		for colIndex, val in ipairs(row) do
			local reachedEdge = (colIndex == #row)
			local touchingDifPiece = localGrid[rowIndex][colIndex + 1] ~= " "
				and localGrid[rowIndex][colIndex + 1] ~= "x"

			if val == "x" and (reachedEdge or touchingDifPiece) then
				return true
			end
		end
	end

	return false
end

function Board:leftEdge()
	local piece = self.curPiece
	local localGrid = {}

	for row = piece.row, piece.row + piece.height - 1 do
		local localRowIndex = (row - piece.row) + 1
		localGrid[localRowIndex] = {}
		local localRow = localGrid[localRowIndex]

		for col = math.max(0, piece.col - 1), piece.col + piece.width do
			local localColIndex = (col - piece.col) + 1

			if localColIndex <= 0 then
				table.insert(localRow, self.grid[row][col])
			elseif piece.grid[localRowIndex][localColIndex] == 1 then
				table.insert(localRow, "x")
			else
				table.insert(localRow, self.grid[row][col])
			end
		end
	end

	for rowIndex, row in ipairs(localGrid) do
		local str = ""
		for colIndex, val in ipairs(row) do
			str = str .. val
			local reachedEdge = (colIndex == 1)
			local touchingDifPiece = localGrid[rowIndex][colIndex - 1] ~= " "
				and localGrid[rowIndex][colIndex - 1] ~= "x"

			if val == "x" and (reachedEdge or touchingDifPiece) then
				return true
			end
		end
	end

	return false
end

function Board:moveDown()
	if not self:bottomEdge()() then
		self:clearPiece()
		self.curPiece:moveDown()
	end
end

function Board:gravity()
	local pieceLanded = self:bottomEdge()
	if pieceLanded then
		-- TODO: do checks before locking in the piece
		self:generatePiece()
	else
		self:clearPiece()
		self.curPiece:moveDown()

		-- TODO: Consider when the piece should be placed. Should consider rotation + movement + gravity, and then place?
		self:placePiece()
	end
end

function Board:bottomEdge()
	local piece = self.curPiece

	local height = 0
	local localGrid = {}

	-- I think the error has to do with piece.row being 0 ...
	for row = piece.row, math.min(piece.row + piece.height, self.height) do
		local localRowIndex = (row - piece.row) + 1
		localGrid[localRowIndex] = {}
		local localRow = localGrid[localRowIndex]

		for col = piece.col, piece.col + piece.width do
			local localColIndex = (col - piece.col) + 1

			if col <= 0 then
				goto continue
			elseif localRowIndex <= piece.height and piece.grid[localRowIndex][localColIndex] == 1 then
				table.insert(localRow, "x")
			else
				table.insert(localRow, self.grid[row][col])
			end
			::continue::
		end

		height = height + 1
	end

	for rowIndex, row in ipairs(localGrid) do
		for colIndex, val in ipairs(row) do
			local reachedBottom = rowIndex == height
			local touchingDifPiece = rowIndex + 1 < #localGrid
				and localGrid[rowIndex + 1][colIndex] ~= " "
				and localGrid[rowIndex + 1][colIndex] ~= "x"

			if val == "x" and (reachedBottom or touchingDifPiece) then
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
