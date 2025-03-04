Piece = {}
Piece.__index = Piece

function Piece:new(s)
	local piece = setmetatable({}, Piece)
	piece:setType(s)
	piece.x = 5
	piece.y = 21
	return piece
end

function Piece:setType(s)
	local types = { "I", "T", "S", "Z", "O", "L", "J" }

	if types[s] == nil then
		error("Invalid piece type " .. s)
	end

	self.type = s
end

function Piece:setDimensions()
	if self.type == nil then
		error("Piece type not set")
	end

	self.rotation = {}
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
	end
end
