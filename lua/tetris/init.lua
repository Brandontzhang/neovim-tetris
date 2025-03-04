local Board = require("tetris.board")
local constants = require("tetris.constants")
local tetris = {}

function tetris:start_game()
	self:open_tetris()
end

function tetris:open_tetris()
	local buffer = self:setupBuffer()
	self:setupWindow(buffer)
end

-- Setup the buffer
function tetris:setupBuffer()
	local buf = vim.api.nvim_create_buf(false, true) -- unlisted (not in tab list) and scratch (empty text file) buffer

	-- buffer options
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf }) -- wipe the buffer when it's hidden
	vim.api.nvim_set_option_value("filetype", "tetris", { buf = buf })
	vim.api.nvim_buf_set_name(buf, "tetris")

	do
		local width = vim.api.nvim_get_option_value("columns", { scope = "local" })
		local height = vim.api.nvim_get_option_value("lines", { scope = "local" })
	end

	return buf
end

-- Setup window view options
function tetris:setupWindow(buf)
	-- Tetris board dimensions
	local tetrisWidth = (constants.board.columns * constants.square.width) + (constants.border.width * 2)
	local tetrisHeight = (constants.board.rows * constants.square.height) + (constants.border.width * 2)

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

return tetris
