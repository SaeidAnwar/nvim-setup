vim.keymap.set("v", "<C-y>", '"*y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", '"*p', { noremap = true, silent = true })
vim.keymap.set("v", "<C-p>", '"*p', { noremap = true, silent = true })

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Telescope git files' })
vim.keymap.set('n', '<leader>fg', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        require("conform").format()
    end,
})

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
vim.keymap.set('n', '<leader>ha', mark.add_file)
vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu)
vim.keymap.set('n', '<leader>hf', function() ui.nav_prev() end)
vim.keymap.set('n', '<leader>hn', function() ui.nav_next() end)
vim.keymap.set('n', '<leader>hq', function() ui.nav_file(1) end)
vim.keymap.set('n', '<leader>hw', function() ui.nav_file(2) end)
vim.keymap.set('n', '<leader>he', function() ui.nav_file(3) end)
vim.keymap.set('n', '<leader>hr', function() ui.nav_file(4) end)

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, bufopts)
vim.keymap.set("n", "<leader>ll", vim.lsp.buf.hover, bufopts)
vim.keymap.set("n", "<leader>ls", vim.lsp.buf.implementation, bufopts) 
