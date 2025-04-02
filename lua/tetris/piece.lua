Piece = {}
Piece.__index = Piece

Piece.types = { "I", "T", "S", "Z", "O", "L", "J" }

-- TODO: Implement rotation
function Piece.new(type)
	local piece = setmetatable({}, Piece)

	piece:setupGridDimensions(type)
	piece:initGridValues()

	return piece
end

function Piece:setupGridDimensions(type)
	self.type = type

	-- Height and width of table holding the piece, including +1 on edges for collision checking
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

return Piece
