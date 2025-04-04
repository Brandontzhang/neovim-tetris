local Board = require("tetris.board")

Game = {}
Game.__index = Game

-- TODO: Score tracking
-- TODO: Piece queue and generation

function Game:new()
	local game = setmetatable({}, Game)

	game.board = Board:new()
	game.inputBuffer = {}
	game.tickCount = 0
	game.timers = {}

	-- Game logic update
	game:addTimer(15, function()
		game.board:tick()
		game.board:drawPiece()
	end)

	-- User input update
	game:addTimer(15, function()
		game:handleInput()
	end)

	return game
end

function Game:addTimer(interval, callback)
	table.insert(self.timers, { interval = interval, callback = callback, lastTrigger = self.tickCount })
end

function Game:queueInput(action)
	table.insert(self.inputBuffer, action)
end

function Game:setUserKeymaps(buffer)
	local opts = { noremap = true, silent = true, buffer = buffer }

	-- Movement
	vim.keymap.set("n", "<Left>", function()
		self:queueInput("LEFT")
	end, opts)
	vim.keymap.set("n", "<Right>", function()
		self:queueInput("RIGHT")
	end, opts)
	vim.keymap.set("n", "<Down>", function()
		self:queueInput("SD")
	end, opts)
	vim.keymap.set("n", "<Space>", function()
		self:queueInput("HD")
	end, opts)

	-- Rotation
	vim.keymap.set("n", "<Up>", function()
		self:queueInput("CWR")
	end, opts)
	vim.keymap.set("n", "z", function()
		self:queueInput("CCWR")
	end, opts)
	vim.keymap.set("n", "x", function()
		self:queueInput("CWR")
	end, opts)

	-- Hold piece
	vim.keymap.set("n", "c", function()
		self:queueInput("HOLD")
	end, opts)
end

function Game:handleInput()
	local input = table.remove(self.inputBuffer, 1)

	if input == nil then
		return
	end

	local actions = {
		LEFT = function()
			self.board:moveLeft()
		end,
		RIGHT = function()
			self.board:moveRight()
		end,
		SD = function()
			self.board:softDrop()
		end,
		HD = function()
			self.board:hardDrop()
		end,
		CWR = function()
			self.board:rotate("CW")
		end,
		CCWR = function()
			self.board:rotate("CCW")
		end,
		HOLD = function()
			self.board:hold()
		end,
	}

	-- Run action
	actions[input]()
	self.board:drawPiece()
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
