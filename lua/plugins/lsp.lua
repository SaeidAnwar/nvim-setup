return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local lspconfig = require("lspconfig")
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_lsp.default_capabilities()
        local luasnip = require("luasnip")

        require("fidget").setup({})
        mason.setup()

        require("conform").setup({
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
                h = { "clang-format" },
                hpp = { "clang-format" },
                glsl = { "clang-format" },
                java = { "clang-format" },
                python = { "black" },
                gdscript = { "gdformat" }, -- GDScript formatter
            },
        })

        local on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    require("conform").format({ async = true })
                end,
            })
        end

        mason_lspconfig.setup({
            ensure_installed = { "clangd", "jdtls", "pyright" }, -- Removed gdscript
            handlers = {
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
                ["jdtls"] = function()
                    local home = vim.fn.expand("~")
                    local workspace_dir = home .. "/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                    lspconfig.jdtls.setup({
                        cmd = { "jdtls", "--jvm-arg=-Xmx2G" },
                        root_dir = lspconfig.util.root_pattern("pom.xml", "gradle.build", ".git"),
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            java = {
                                configuration = {
                                    runtimes = {
                                        { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/" },
                                        { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk/" },
                                    }
                                }
                            }
                        },
                        init_options = { workspace = workspace_dir },
                    })
                end,
            },
        })

        -- Set up GDScript filetype detection
        vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
            pattern = "*.gd",
            callback = function()
                vim.bo.filetype = "gdscript"
            end,
        })

        -- Manual setup for GDScript LSP (not handled by Mason)
        local gdscript_capabilities = vim.tbl_deep_extend("force", capabilities, {
            workspace = {
                configuration = false,
                didChangeConfiguration = {
                    dynamicRegistration = false,
                },
            },
            textDocument = {
                synchronization = {
                    dynamicRegistration = false,
                    didSave = true,
                    willSave = false,
                    willSaveWaitUntil = false,
                },
            },
        })

        lspconfig.gdscript.setup({
            cmd = { "nc", "localhost", "6005" },
            filetypes = { "gdscript" },
            root_dir = lspconfig.util.root_pattern("project.godot", ".git"),
            capabilities = gdscript_capabilities,
            on_attach = on_attach,
            settings = {},
            flags = {
                debounce_text_changes = 150,
            },
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            }),
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<Down>'] = cmp.mapping.select_next_item(),
                ['<Up>'] = cmp.mapping.select_prev_item(),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
