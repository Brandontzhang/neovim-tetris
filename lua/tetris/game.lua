local Board = require("tetris.board")
local UserInputHandler = require("tetris.userInputHandler")

Game = {}
Game.__index = Game

-- TODO: Score tracking
-- TODO: Piece queue and generation

function Game:new()
	local game = setmetatable({}, Game)

	game.board = Board:new()
	game.tickCount = 0
	game.timers = {}

	game.userInputHandler = UserInputHandler:new()

	-- TODO: Main loop timer
	-- Should handle user inputs, logic updates. (What every frame of the game should display)

	-- TODO: Gravity timer
	-- Speed up and down, maximum matching the frame rate
	game:addTimer(30, function()
		local board = game.board

		board:gravity()
	end)

	-- TODO: Lock delay timer
	-- timer when the game piece is hitting something, before it's locked. This might be in the logic updates instead

	-- INFO: Contains the logic of the game that happens every single frame of the game
	game:addTimer(1, function()
		local board = game.board

		board:lockPiece()
		board:drawPiece()

		game.userInputHandler:handleInput(board)
	end)

	return game
end

-- TODO: Convert interval to seconds to make it more intuitive
function Game:addTimer(interval, callback)
	table.insert(self.timers, { interval = interval, callback = callback, lastTrigger = self.tickCount })
end

function Game:renderBoard()
	return self.board:render()
end

-- INFO: This function is called every 30ms
-- TODO: Intake tickCount. Should be managed by controller
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
