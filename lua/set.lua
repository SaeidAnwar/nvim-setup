-- vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.scrolloff = 15
vim.opt.colorcolumn = "80"
vim.opt.undofile = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ic = false
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.ignorecase = true  -- Ignore case when searching
vim.opt.smartcase = true   -- Case-sensitive if uppercase is used

vim.api.nvim_create_autocmd({"BufEnter", "FocusGained"}, {
  pattern = "*",
  command = "checktime"
})
