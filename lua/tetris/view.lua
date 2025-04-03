-- INFO: View of the game managed through a buffer and viewed through a window
local constants = require("tetris.constants")

View = {}
View.__index = View

function View.new()
	local view = setmetatable({}, View)

	view:setupBuffer()
	view:setupWindow()

	return view
end

function View:setupWindow()
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

	local window = vim.api.nvim_open_win(self.buffer, true, windowOpts)
	return window
end

-- Setup the buffer
function View:setupBuffer()
	if not self:isBufCreated() then
		self.buffer = vim.api.nvim_create_buf(false, true) -- unlisted (not in tab list) and scratch (empty text file) buffer

		-- buffer options
		vim.api.nvim_set_option_value("filetype", "tetris", { buf = self.buffer })
		vim.api.nvim_buf_set_name(self.buffer, "tetris")
	else
		self.buffer = self:getBuf()
	end

	-- Create header and borders
	do
		if self.buffer ~= nil then
			vim.api.nvim_set_hl(0, "borderHighlight", { fg = "white", bg = "gray" })
			vim.api.nvim_buf_set_lines(
				self.buffer,
				0,
				-1,
				false,
				{ string.rep(" ", 7) .. "Tetris" .. string.rep(" ", 7) }
			)
			vim.api.nvim_buf_add_highlight(self.buffer, -1, "borderHighlight", 0, 0, -1)
		end
	end
end

function View:isBufCreated()
	local existingBuf = self:getBuf()

	return existingBuf ~= nil
end

function View:getBuf()
	for _, existingBuf in ipairs(vim.api.nvim_list_bufs()) do
		local fullPath = vim.api.nvim_buf_get_name(existingBuf)
		local bufferName = fullPath:match("^.+/(.+)$") or fullPath

		if bufferName == "tetris" then
			return existingBuf
		end
	end
end

function View:isBufOpen()
	if self.buffer == nil then
		return false
	end

	local buffer_exists = vim.api.nvim_buf_is_valid(self.buffer)
	local buffer_visible = vim.fn.bufwinnr(self.buffer) ~= -1
	return buffer_exists and buffer_visible
end

function View:setupBufferHighlights()
	if self.buffer == nil then
		return
	end

	vim.api.nvim_set_hl(0, "tHighlight", { fg = "purple", bg = "purple" })
	vim.api.nvim_set_hl(0, "sHighlight", { fg = "green", bg = "green" })
	vim.api.nvim_set_hl(0, "zHighlight", { fg = "red", bg = "red" })
	vim.api.nvim_set_hl(0, "lHighlight", { fg = "orange", bg = "orange" })
	vim.api.nvim_set_hl(0, "jHighlight", { fg = "blue", bg = "blue" })
	vim.api.nvim_set_hl(0, "iHighlight", { fg = "teal", bg = "teal" })
	vim.api.nvim_set_hl(0, "oHighlight", { fg = "yellow", bg = "yellow" })

	local lines = vim.api.nvim_buf_get_lines(self.buffer, 0, -1, false)

	for line_num, line in ipairs(lines) do
		if line_num == 1 then
			goto continue
		end

		for col = 1, #line do
			if line:sub(col, col) == "T" then
				vim.api.nvim_buf_add_highlight(self.buffer, -1, "tHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "S" then
				vim.api.nvim_buf_add_highlight(self.buffer, -1, "sHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "Z" then
				vim.api.nvim_buf_add_highlight(self.buffer, -1, "zHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "L" then
				vim.api.nvim_buf_add_highlight(self.buffer, -1, "lHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "J" then
				vim.api.nvim_buf_add_highlight(self.buffer, -1, "jHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "I" then
				vim.api.nvim_buf_add_highlight(self.buffer, -1, "iHighlight", line_num - 1, col - 1, col)
			elseif line:sub(col, col) == "O" then
				vim.api.nvim_buf_add_highlight(self.buffer, -1, "oHighlight", line_num - 1, col - 1, col)
			end
		end
		::continue::
	end
end

function View:renderBoard(board)
	if self.buffer == nil then
		return
	end

	local header_end = vim.api.nvim_buf_line_count(self.buffer)
	vim.api.nvim_buf_set_lines(self.buffer, 1, -1, false, {}) -- Clears everything except the first line
	vim.api.nvim_buf_set_lines(self.buffer, header_end, header_end, false, board)
	self:setupBufferHighlights()
end

return View
