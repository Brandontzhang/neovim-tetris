local Board = {}
Board.__index = Board

function Board:new()
	local instance = setmetatable({}, Board)
	instance.width = 10
	instance.height = 20
	instance.grid = {}

	for y = 1, instance.height do
		instance.grid[y] = {}
		for x = 1, instance.width do
			instance.grid[y][x] = "_"
		end
	end

	return instance
end

function Board:addPiece(piece)
	-- TODO: Add pieces to the board grid based on the piece's position and rotation
	if piece.type == "I" then
	elseif piece.type == "T" then
	elseif piece.type == "S" then
	elseif piece.type == "Z" then
	elseif piece.type == "O" then
	elseif piece.type == "L" then
	elseif piece.type == "J" then
	end
end

function Board:render()
	local renderBoard = ""
	for y = 1, self.height do
		for x = 1, self.width do
			renderBoard = renderBoard .. self.grid[y][x]
		end
		renderBoard = renderBoard .. "\n"
	end

	return renderBoard
end

return Board
