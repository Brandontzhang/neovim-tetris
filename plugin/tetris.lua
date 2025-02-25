vim.api.nvim_create_user_command("Tetris", function()
	require("tetris").start_game()
end, { desc = "Start tetris" })
