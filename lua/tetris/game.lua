Game = {}

Board = {}

-- TODO: Score tracking
-- TODO: Piece queue and generation

function Game:setBoard(board)
	Board = board
end

function Game:getBoard()
	return Board
end

function Game:setTetrisKeymaps(buf)
	local opts = { noremap = true, silent = true, buffer = buf }

	-- Movement
	vim.keymap.set("n", "<Left>", "<Cmd>lua require('tetris.game').moveLeft()<CR>", opts)
	vim.keymap.set("n", "<Right>", "<Cmd>lua require('tetris.game').moveRight()<CR>", opts)
	vim.keymap.set("n", "<Down>", "<Cmd>lua require('tetris.game').moveDown()<CR>", opts)
	vim.keymap.set("n", "<Up>", "<Cmd>lua require('tetris.game').rotateClockwise()<CR>", opts)
	vim.keymap.set("n", "<Space>", "<Cmd>lua require('tetris.game').hardDrop()<CR>", opts)

	-- Rotation
	vim.keymap.set("n", "z", "<Cmd>lua require('tetris.game').rotateCounterclockwise()<CR>", opts)
	vim.keymap.set("n", "x", "<Cmd>lua require('tetris.game').rotateClockwise()<CR>", opts)

	-- Hold piece
	vim.keymap.set("n", "c", "<Cmd>lua require('tetris.game').holdPiece()<CR>", opts)
end

function Game:moveLeft()
	Board:moveLeft()
end

function Game:moveRight()
	Board:moveRight()
end

function Game:moveDown()
	Board:moveDown()
end

function Game:hardDrop()
	-- Hard Drop
	vim.notify("Hard drop", vim.log.levels.DEBUG)
end

function Game:rotateCounterclockwise()
	Board:rotate("CCW")
end

function Game.rotateClockwise()
	Board:rotate("CW")
end

function Game:holdPiece()
	-- Hold Piece
	vim.notify("Hold", vim.log.levels.DEBUG)
end

function Game.tick()
	Board:tick()
end

return Game
