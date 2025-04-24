local opts = {
  ensure_installed = {
    'c',
    'json',
    'lua',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
  },
  auto_install = true,
  sync_install = false,
  highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    }
}

local function config()
  require('nvim-treesitter.configs').setup(opts)
end
return {
  'nvim-treesitter/nvim-treesitter',
  config = config,
  build = ':TSUpdate',
}
