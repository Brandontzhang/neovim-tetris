local Board = require("tetris.board")

Game = {}
Game.__index = Game

-- TODO: Score tracking
-- TODO: Piece queue and generation

function Game:new()
	local game = setmetatable({}, Game)

	self.board = Board:new()

	return game
end

function Game:setTetrisKeymaps(buffer)
	local opts = { noremap = true, silent = true, buffer = buffer }

	-- Movement
	vim.keymap.set("n", "<Left>", function()
		self:moveLeft()
	end, opts)
	vim.keymap.set("n", "<Right>", function()
		self:moveRight()
	end, opts)
	vim.keymap.set("n", "<Down>", function()
		self:moveDown()
	end, opts)
	vim.keymap.set("n", "<Up>", function()
		self:rotateClockwise()
	end, opts)
	vim.keymap.set("n", "<Space>", function()
		self:hardDrop()
	end, opts)

	-- Rotation
	vim.keymap.set("n", "z", function()
		self:rotateCounterClockwise()
	end, opts)
	vim.keymap.set("n", "x", function()
		self:rotateClockwise()
	end, opts)

	-- Hold piece
	vim.keymap.set("n", "c", function()
		self:holdPiece()
	end, opts)
end

function Game:moveLeft()
	self.board:moveLeft()
end

function Game:moveRight()
	self.board:moveRight()
end

function Game:moveDown()
	self.board:moveDown()
end

function Game:hardDrop()
	-- Hard Drop
	vim.notify("Hard drop", vim.log.levels.DEBUG)
end

function Game:rotateCounterclockwise()
	self.board:rotate("CCW")
end

function Game:rotateClockwise()
	self.board:rotate("CW")
end

function Game:holdPiece()
	-- Hold Piece
	vim.notify("Hold", vim.log.levels.DEBUG)
end

function Game:renderBoard()
	return self.board:render()
end

function Game:tick()
	self.board:tick()
end

return Game
