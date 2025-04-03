Piece = {}
Piece.__index = Piece

Piece.types = { "I", "T", "S", "Z", "O", "L", "J" }

-- TODO: Implement wallkicks
function Piece.new(type)
	local piece = setmetatable({}, Piece)

	piece:setupGridDimensions(type)
	piece:initGridValues()

	return piece
end

function Piece:setupGridDimensions(type)
	self.type = type

	-- The row and col represent where the top left corner of the piece grid is located on the grid. Adjusted to center on spawn
	self.row = 1
	self.col = 4

	if type == "O" then
		self.height = 3
		self.width = 4
	elseif type == "I" then
		self.height = 4
		self.width = 4
	else
		self.height = 3
		self.width = 3
	end
end

-- INFO: Follows SRS (Super Rotation System)
function Piece:initGridValues()
	self.grid = {}

	if self.type == nil then
		error("Piece type not set")
	end

	for row = 1, self.height do
		self.grid[row] = {}
		for col = 1, self.width do
			self.grid[row][col] = 0 -- Fill with 0
		end
	end

	if self.type == "T" then
		self.grid[1][2] = 1
		self.grid[2][1] = 1
		self.grid[2][2] = 1
		self.grid[2][3] = 1
	elseif self.type == "Z" then
		self.grid[1][1] = 1
		self.grid[1][2] = 1
		self.grid[2][2] = 1
		self.grid[2][3] = 1
	elseif self.type == "S" then
		self.grid[1][2] = 1
		self.grid[1][3] = 1
		self.grid[2][1] = 1
		self.grid[2][2] = 1
	elseif self.type == "L" then
		self.grid[1][3] = 1
		self.grid[2][1] = 1
		self.grid[2][2] = 1
		self.grid[2][3] = 1
	elseif self.type == "J" then
		self.grid[1][1] = 1
		self.grid[2][1] = 1
		self.grid[2][2] = 1
		self.grid[2][3] = 1
	elseif self.type == "I" then
		self.grid[2][1] = 1
		self.grid[2][2] = 1
		self.grid[2][3] = 1
		self.grid[2][4] = 1
	elseif self.type == "O" then
		self.grid[1][2] = 1
		self.grid[1][3] = 1
		self.grid[2][2] = 1
		self.grid[2][3] = 1
	end
end

function Piece:moveLeft()
	self.col = self.col - 1
end

function Piece:moveRight()
	self.col = self.col + 1
end

function Piece:moveDown()
	self.row = self.row + 1
end

-- Returns 1 for tetris block, 0 for empty space, -1 for out of bounds
function Piece:getBlock(row, col)
	if row >= 1 and row <= self.height and col >= 1 and col <= self.width then
		return self.grid[row][col]
	else
		return -1
	end
end

-- INFO: Doesn't seem to be necessary, but I wrote it and I'll keep it here for now unless it really is necessary
-- Checking if the piece has occupied it's bottom rows for specific rotations
-- Ex. The I piece can move down different amounts depending on it's rotation:
-- X X X X    X X I X    X X X X    X I X X
-- I I I I    X X I X    X X X X    X I X X
-- X X X X    X X I X    I I I I    X I X X
-- X X X X    X X I X    X X X X    X I X X
-- 2 rows     0 row      1 row      0 rows
function Piece:availBottomSpace()
	local availSpace = 0
	for rowIndex = #self.grid, 1, -1 do
		for colIndex = 1, #self.grid[1] do
			if self.grid[rowIndex][colIndex] == 1 then
				goto continue
			end
		end
		availSpace = availSpace + 1
	end

	::continue::
	return availSpace
end

function Piece:rotate(direction)
	if self.type == "O" then
		return
	end

	local function transpose()
		local transposed = {}

		for row = 1, #self.grid do
			transposed[row] = {}
			for col = 1, #self.grid do
				transposed[row][col] = self.grid[col][row]
			end
		end

		return transposed
	end

	local function flipRow()
		local flipped = {}

		for row = 1, #self.grid do
			flipped[row] = {}
			for col = 1, #self.grid do
				flipped[row][col] = self.grid[row][#self.grid - col + 1]
			end
		end

		return flipped
	end

	local function flipCol()
		local flipped = {}

		for row = 1, #self.grid do
			flipped[row] = {}
			for col = 1, #self.grid do
				flipped[row][col] = self.grid[#self.grid - row + 1][col]
			end
		end

		return flipped
	end

	self.grid = transpose()

	if direction == "CW" then
		self.grid = flipRow()
	elseif direction == "CCW" then
		self.grid = flipCol()
	end
end

return Piece
