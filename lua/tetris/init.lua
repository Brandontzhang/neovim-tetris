local Board = require("tetris.board")
local Piece = require("tetris.piece")
local Game = require("tetris.game")
local constants = require("tetris.constants")
local tetris = {}
local timerInit = false

function tetris:start_game()
	self:open_tetris()
end

function tetris:open_tetris()
	local buf = self:setupBuffer()
	self:setupWindow(buf)
	self:initBoard(buf)

	self:gameLoop(buf)
end

-- Setup the buffer
function tetris:setupBuffer()
	local buf = self:checkExistingTetrisBuf()

	if buf == nil then
		buf = vim.api.nvim_create_buf(false, true) -- unlisted (not in tab list) and scratch (empty text file) buffer

		-- buffer options
		vim.api.nvim_set_option_value("filetype", "tetris", { buf = buf })
		vim.api.nvim_buf_set_name(buf, "tetris")
	end

	-- Create header and borders
	do
		vim.api.nvim_set_hl(0, "borderHighlight", { fg = "white", bg = "gray" })
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { string.rep(" ", 7) .. "Tetris" .. string.rep(" ", 7) })
		vim.api.nvim_buf_add_highlight(buf, -1, "borderHighlight", 0, 0, -1)
	end

	-- Add controls to the buffer
	Game:setTetrisKeymaps(buf)
	return buf
end

function tetris:checkExistingTetrisBuf()
	local buf = nil

	for _, existingBuf in ipairs(vim.api.nvim_list_bufs()) do
		local fullPath = vim.api.nvim_buf_get_name(existingBuf)
		local bufName = fullPath:match("^.+/(.+)$") or fullPath

		if bufName == "tetris" then
			buf = existingBuf
			break
		end
	end

	return buf
end

function tetris:setupHighlights(buf)
	vim.api.nvim_set_hl(0, "tHighlight", { fg = "purple", bg = "purple" })
	vim.api.nvim_set_hl(0, "sHighlight", { fg = "pink", bg = "pink" })
	vim.api.nvim_set_hl(0, "zHighlight", { fg = "green", bg = "green" })
	vim.api.nvim_set_hl(0, "lHighlight", { fg = "blue", bg = "blue" })
	vim.api.nvim_set_hl(0, "jHighlight", { fg = "orange", bg = "orange" })
	vim.api.nvim_set_hl(0, "iHighlight", { fg = "teal", bg = "teal" })
	vim.api.nvim_set_hl(0, "oHighlight", { fg = "yellow", bg = "yellow" })

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	for line_num, line in ipairs(lines) do
		if line_num == 1 then
			goto continue
		end

		for col = 1, #line do
			if line:sub(col, col) == "T" then
				vim.api.nvim_buf_add_highlight(buf, -1, "tHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "S" then
				vim.api.nvim_buf_add_highlight(buf, -1, "sHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "Z" then
				vim.api.nvim_buf_add_highlight(buf, -1, "zHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "L" then
				vim.api.nvim_buf_add_highlight(buf, -1, "lHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "J" then
				vim.api.nvim_buf_add_highlight(buf, -1, "jHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "I" then
				vim.api.nvim_buf_add_highlight(buf, -1, "iHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "O" then
				vim.api.nvim_buf_add_highlight(buf, -1, "oHighlight", line_num - 1, col - 1, col)
			end
		end
		::continue::
	end
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

	return window
end

function tetris:initBoard(buf)
	local board = Board:new()
	Game:setBoard(board)

	self:renderBoard(buf)
end

function tetris:renderBoard(buf)
	local header_end = vim.api.nvim_buf_line_count(buf)
	vim.api.nvim_buf_set_lines(buf, 1, -1, false, {}) -- Clears everything except the first line
	vim.api.nvim_buf_set_lines(buf, header_end, header_end, false, Game:getBoard():render())
	tetris:setupHighlights(buf)
end

function tetris:is_buffer_open(buf)
	local buf_exists = vim.api.nvim_buf_is_valid(buf)
	local buf_visible = vim.fn.bufwinnr(buf) ~= -1
	return buf_exists and buf_visible
end

-- Game timer for automated tasks
-- Gravity for pieces
function tetris:gameLoop(buf)
	if not timerInit then
		local gameTimer = vim.loop.new_timer()
		timerInit = true
		gameTimer:start(
			0,
			250,
			vim.schedule_wrap(function()
				if not self:is_buffer_open(buf) then
					return
				end

				Game.gravity()
				tetris:renderBoard(buf)
			end)
		)
	end
end

return tetris
