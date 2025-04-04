local Board = require("tetris.board")

Game = {}
Game.__index = Game

-- TODO: Score tracking
-- TODO: Piece queue and generation

function Game:new()
	local game = setmetatable({}, Game)

	game.board = Board:new()
	game.tickCount = 0
	game.timers = {}

	game:addTimer(15, function()
		game.board:tick()
	end)

	return game
end

function Game:addTimer(interval, callback)
	table.insert(self.timers, { interval = interval, callback = callback, lastTrigger = self.tickCount })
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
	vim.keymap.set("n", "<Space>", function()
		self.board:hardDrop()
	end, opts)

	-- Rotation
	vim.keymap.set("n", "<Up>", function()
		self.board:rotate("CW")
	end, opts)
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

-- INFO: This function is called every 30ms
function Game:tick()
	self.tickCount = self.tickCount + 1

	for _, timer in ipairs(self.timers) do
		if self.tickCount - timer.lastTrigger >= timer.interval then
			timer.callback()
			timer.lastTrigger = self.tickCount
		end
	end
end

return Game
