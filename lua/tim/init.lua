local M = {}

function M.start_game()
	vim.api.nvim_out_write("Starting tetris...")
end

vim.api.nvim_create_user_command("tetris", M.start_game(), { desc = "Start tetris" })

return M
