local tetris = require("tetris")

vim.api.nvim_create_user_command("Tetris", function()
	tetris:start_game()
end, { desc = "Start Tetris" })
