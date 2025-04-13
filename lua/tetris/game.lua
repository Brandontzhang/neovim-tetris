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

	-- TODO: Lock delay timer
	-- timer when the game piece is hitting something, before it's locked. This might be in the logic updates instead

	-- Game logic update
	game:addTimer(15, function()
		game:frameTimer()
	end)

	return game
end

function Game:addTimer(interval, callback)
	table.insert(self.timers, { interval = interval, callback = callback, lastTrigger = self.tickCount })
end

-- INFO: Contains the logic of the game that happens every single frame of the game
function Game:frameTimer()
	self.board:clearLine()
	self.board:tick()
	self.board:drawPiece()

	self.userInputHandler:handleInput(self.board)
end

function Game:renderBoard()
	return self.board:render()
end

-- INFO: This function is called every 30ms
-- TODO: Intake tickCount. Should be managed by controller
function Game:tick(tickCount)
	self.tickCount = self.tickCount + 1

	for _, timer in ipairs(self.timers) do
		if self.tickCount - timer.lastTrigger >= timer.interval then
			timer.callback()
			timer.lastTrigger = self.tickCount
		end
	end
end

return Game
