Game = {}

function Game:set_tetris_keymaps(buf)
	local opts = { noremap = true, silent = true, buffer = buf }

	-- Movement
	vim.keymap.set("n", "<Left>", "<Cmd>lua require('tetris').move_left()<CR>", opts)
	vim.keymap.set("n", "<Right>", "<Cmd>lua require('tetris').move_right()<CR>", opts)
	vim.keymap.set("n", "<Down>", "<Cmd>lua require('tetris').move_down()<CR>", opts)
	vim.keymap.set("n", "<Up>", "<Cmd>lua require('tetris').rotate_clockwise()<CR>", opts)
	vim.keymap.set("n", "<Space>", "<Cmd>lua require('tetris').hard_drop()<CR>", opts)

	-- Rotation
	vim.keymap.set("n", "z", "<Cmd>lua require('tetris').rotate_counterclockwise()<CR>", opts)
	vim.keymap.set("n", "x", "<Cmd>lua require('tetris').rotate_clockwise()<CR>", opts)

	-- Hold piece
	vim.keymap.set("n", "<S>", "<Cmd>lua require('tetris').hold_piece()<CR>", opts)
end

return Game
