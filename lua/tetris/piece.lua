Piece = {}
Piece.__index = Piece

Piece.types = { "I", "T", "S", "Z", "O", "L", "J" }

function Piece.new(t)
	local piece = setmetatable({}, Piece)

	piece:setType(t)

	piece.rotation = {}
	piece:initRotation()

	return piece
end

function Piece:setType(t)
	self.type = t

	-- Height and width of table holding the piece, including +1 on edges for collision checking
	-- The row and col represent where the top left corner of the piece rotation is located on the grid. Adjusted to center on spawn
	if t == "O" then
		self.height = 4
		self.width = 4
		self.row = 1
		self.col = 4
	elseif t == "I" then
		self.height = 6
		self.width = 6
		self.row = 1
		self.col = 4
	else
		self.height = 4
		self.width = 5
		self.row = 1
		self.col = 4
	end
end

function Piece:moveLeft()
	if self.col > 0 then
		self.col = self.col - 1
	end
end

function Piece:moveDown()
	-- TODO: Detect collision to stop
	if self.row <= 20 - self.height + 1 then
		self.row = self.row + 1
	end
end

function Piece:initRotation()
	if self.type == nil then
		error("Piece type not set")
	end

	for row = 1, self.height do
		self.rotation[row] = {}
		for col = 1, self.width do
			self.rotation[row][col] = 0 -- Fill with 0
		end
	end

	if self.type == "T" then
		self.rotation[2][3] = 1
		self.rotation[3][2] = 1
		self.rotation[3][3] = 1
		self.rotation[3][4] = 1
	elseif self.type == "Z" then
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1
		self.rotation[3][3] = 1
		self.rotation[3][4] = 1
	elseif self.type == "S" then
		self.rotation[2][3] = 1
		self.rotation[2][2] = 1
		self.rotation[3][2] = 1
		self.rotation[3][3] = 1
	elseif self.type == "L" then
		self.rotation[2][4] = 1
		self.rotation[3][2] = 1
		self.rotation[3][3] = 1
		self.rotation[3][4] = 1
	elseif self.type == "J" then
		self.rotation[2][2] = 1
		self.rotation[3][2] = 1
		self.rotation[3][3] = 1
		self.rotation[3][4] = 1
	elseif self.type == "I" then
		self.rotation[3][1] = 1
		self.rotation[3][2] = 1
		self.rotation[3][3] = 1
		self.rotation[3][4] = 1
	elseif self.type == "O" then
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1
		self.rotation[3][2] = 1
		self.rotation[3][3] = 1
	end
end

return Piece
