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

	-- Game logic update
	game:addTimer(15, function()
		game.board:tick()
		game.board:drawPiece()
	end)

	return game
end

function Game:addTimer(interval, callback)
	table.insert(self.timers, { interval = interval, callback = callback, lastTrigger = self.tickCount })
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
