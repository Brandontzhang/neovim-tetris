local Board = require("tetris.board")
local Piece = require("tetris.piece")
local constants = require("tetris.constants")
local tetris = {}

function tetris:start_game()
	self:open_tetris()
end

function tetris:open_tetris()
	local buf = self:setupBuffer()
	self:setupWindow(buf)

	self:initBoard(buf)
end

-- Setup the buffer
function tetris:setupBuffer()
	local buf = vim.api.nvim_create_buf(false, true) -- unlisted (not in tab list) and scratch (empty text file) buffer

	-- buffer options
	vim.api.nvim_set_option_value("filetype", "tetris", { buf = buf })
	vim.api.nvim_buf_set_name(buf, "tetris")

	-- Create header and borders
	do
		vim.api.nvim_set_hl(0, "borderHighlight", { fg = "white", bg = "gray" })
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { string.rep(" ", 7) .. "Tetris" .. string.rep(" ", 7) })
		vim.api.nvim_buf_add_highlight(buf, -1, "borderHighlight", 0, 0, -1)
	end

	return buf
end

-- Setup window view options
function tetris:setupWindow(buf)
	-- Tetris board dimensions
	local tetrisWidth = (constants.board.columns * constants.square.width)
	local tetrisHeight = (constants.board.rows * constants.square.height) + constants.header.height

	-- center the window around the editor
	local editorWidth = vim.api.nvim_get_option_value("columns", { scope = "global" })
	local editorHeight = vim.api.nvim_get_option_value("lines", { scope = "global" })
	local col = math.ceil(((editorWidth - tetrisWidth) / 2))
	local row = math.ceil((editorHeight - tetrisHeight) / 2)

	local windowOpts = {
		relative = "editor",
		border = "rounded",
		style = "minimal",
		width = tetrisWidth,
		height = tetrisHeight,
		row = row,
		col = col,
	}
	local window = vim.api.nvim_open_win(buf, true, windowOpts)
end

function tetris:initBoard(buf)
	local board = Board:new()

	local header_end = vim.api.nvim_buf_line_count(buf)

	local test_piece = Piece:new("T")

	test_piece.x = 3
	test_piece.y = 10

	board:addPiece(test_piece)

	vim.api.nvim_buf_set_lines(buf, header_end, header_end, false, board:render())
end

return tetris
