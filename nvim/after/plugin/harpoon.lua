local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>aa", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>v", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end) 
vim.keymap.set("n", "<leader>dd", function() harpoon:list():delete() end)

vim.keymap.set("n", "<C-a>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-w>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-e>", function() harpoon:list():select(3) end)
