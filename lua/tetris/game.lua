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

function Game:setUserKeymaps(buffer)
	local opts = { noremap = true, silent = true, buffer = buffer }

	-- Movement
	vim.keymap.set("n", "<Left>", function()
		self.board:moveLeft()
	end, opts)
	vim.keymap.set("n", "<Right>", function()
		self.board:moveRight()
	end, opts)
	vim.keymap.set("n", "<Down>", function()
		self.board:softDrop()
	end, opts)
	vim.keymap.set("n", "<Up>", function()
		self.board:rotate("CW")
	end, opts)
	vim.keymap.set("n", "<Space>", function()
		self.board:hardDrop()
	end, opts)

	-- Rotation
	vim.keymap.set("n", "z", function()
		self.board:rotate("CCW")
	end, opts)
	vim.keymap.set("n", "x", function()
		self.board:rotate("CW")
	end, opts)

	-- Hold piece
	vim.keymap.set("n", "c", function()
		self.board:holdPiece()
	end, opts)
end

function Game:renderBoard()
	return self.board:render()
end

-- TODO: Implement timing. This function is called every 30ms
function Game:tick()
	self.board:tick()

	-- checks
	-- 1. Row completion
	-- 2. Gravity drop based on speed
end

return Game
