Piece = {}
Piece.__index = Piece

function Piece:new(t)
	local piece = setmetatable({}, Piece)
	piece:setType(t)

	piece.rotation = {}
	piece:initRotation()

	-- The x and y coordinate represents where the top left corner of the piece rotation is located on the grid
	piece.x = 3
	piece.y = 21

	-- width of the grid rotation
	piece.width = 3
	piece.height = 3

	return piece
end

function Piece:setType(t)
	local types = { "I", "T", "S", "Z", "O", "L", "J" }

	for _, type in ipairs(types) do
		if t == type then
			self.type = t
			return
		end
	end
	error("Invalid piece type " .. t)
end

function Piece:initRotation()
	if self.type == nil then
		error("Piece type not set")
	end

	for i = 1, 3 do
		self.rotation[i] = {}
		for j = 1, 3 do
			self.rotation[i][j] = 0 -- Fill with 0
		end
	end

	if self.type == "T" then
		self.rotation[1][2] = 1
		self.rotation[2][1] = 1
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1
	elseif self.type == "S" then
		self.rotation[1][2] = 1
		self.rotation[1][3] = 1
		self.rotation[2][1] = 1
		self.rotation[2][2] = 1
	elseif self.type == "Z" then
		self.rotation[1][1] = 1
		self.rotation[1][2] = 1
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1
	elseif self.type == "L" then
		self.rotation[1][3] = 1
		self.rotation[2][1] = 1
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1
	elseif self.type == "J" then
		self.rotation[1][1] = 1
		self.rotation[2][1] = 1
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1
	end

	if self.type == "I" then
		self.rotation = {}
		for i = 1, 4 do
			self.rotation[i] = {}
			for j = 1, 4 do
				self.rotation[i][j] = 0 -- Fill with 0
			end
		end

		self.rotation[2][1] = 1
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1
		self.rotation[2][4] = 1

		self.width = 4
		self.height = 4
	end

	if self.type == "O" then
		self.rotation = {}
		for i = 1, 4 do
			self.rotation[i] = {}
			for j = 1, 3 do
				self.rotation[i][j] = 0 -- Fill with 0
			end
		end

		self.rotation[1][2] = 1
		self.rotation[1][3] = 1
		self.rotation[2][2] = 1
		self.rotation[2][3] = 1

		self.width = 4
	end
end

return Piece
