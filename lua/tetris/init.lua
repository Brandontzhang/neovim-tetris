local View = require("tetris.view")
local Game = require("tetris.game")
local UserInputHandler = require("tetris.userInputHandler")
local Tetris = {}
local timerInit = false

-- INFO: This class is acting as the controller... might want to move it out?
function Tetris:start_game()
	self:setupView()
	self:setupGame()
	self:gameLoop()
end

function Tetris:setupView()
	self.view = View.new()
end

function Tetris:setupGame()
	self.game = Game:new()
end

function Tetris:setupUserInputHandler()
	self.userInputHandler = UserInputHandler:new()
	self.userInputHandler:setUserKeymaps(self.view.buffer)
end

function Tetris:render()
	local boardView = self.game:renderBoard()
	self.view:renderBoard(boardView)
end

-- Game timer for automated tasks
-- Gravity for pieces
function Tetris:gameLoop()
	if timerInit then
		return
	else
		timerInit = true
	end

	local gameTimer = vim.uv.new_timer()
	if gameTimer == nil then
		return
	end

	gameTimer:start(
		0,
		30,
		vim.schedule_wrap(function()
			if not self.view:isBufOpen() then
				return
			end

			self.game:tick()
			self:render()
		end)
	)
end

return Tetris
