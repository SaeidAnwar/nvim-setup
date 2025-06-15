return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    -- Register custom GDScript parser
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.gdscript = {
      install_info = {
        url = 'https://github.com/PrestonKnopp/tree-sitter-gdscript', -- GDScript grammar
        files = { 'src/parser.c' },
        branch = 'main',
      },
      filetype = 'gdscript',
    }

    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'c',
        'json',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'gdscript', -- Custom parser now supported
      },
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end
}
