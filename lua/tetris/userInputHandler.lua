UserInputHandler = {}
UserInputHandler.__index = UserInputHandler

function UserInputHandler:new()
	local userInputHandler = setmetatable({}, Game)

	userInputHandler.tickCount = 0
	userInputHandler.timers = {}
	userInputHandler.inputBuffer = {}

	-- TODO: Implement buffer size limit
	-- User input update
	userInputHandler:addTimer(15, function()
		userInputHandler:handleInput()
	end)

	return userInputHandler
end

function UserInputHandler:queueInput(action)
	table.insert(self.inputBuffer, action)
end

function UserInputHandler:setUserKeymaps(buffer)
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

function UserInputHandler:handleInput()
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

-- TODO: Tickcount managed by controller
function UserInputHandler:update(tickCount)
	self.tickCount = self.tickCount + 1

	for _, timer in ipairs(self.timers) do
		if self.tickCount - timer.lastTrigger >= timer.interval then
			timer.callback()
			timer.lastTrigger = self.tickCount
		end
	end
end
