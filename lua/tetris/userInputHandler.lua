UserInputHandler = {}
UserInputHandler.__index = UserInputHandler

function UserInputHandler:new()
	local userInputHandler = setmetatable({}, UserInputHandler)

	-- TODO: Implement buffer size limit
	userInputHandler.inputBuffer = {}

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

function UserInputHandler:handleInput(board)
	local input = table.remove(self.inputBuffer, 1)

	if input == nil then
		return
	end

	local actions = {
		LEFT = function()
			board:moveLeft()
		end,
		RIGHT = function()
			board:moveRight()
		end,
		SD = function()
			board:softDrop()
		end,
		HD = function()
			board:hardDrop()
		end,
		CWR = function()
			board:rotate("CW")
		end,
		CCWR = function()
			board:rotate("CCW")
		end,
		HOLD = function()
			board:hold()
		end,
	}

	-- Run action
	actions[input]()
	board:drawPiece()
end

return UserInputHandler
