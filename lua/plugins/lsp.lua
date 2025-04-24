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
        require("conform").setup({
            formatters_by_ft = {
                c = { "clang-format" },
                h = { "clang-format" },
                hpp = { "clang-format" },
                cpp = { "clang-format" },
                glsl = { "clang-format" },
                java = { "clang-format" },
                python = { "black" },
            },
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd", -- C++ and C
                "jdtls",  -- Java
                "pyright", -- Python
            },
            handlers = {
                function(server_name)
                    if server_name == "clangd" then
                        require("lspconfig").clangd.setup {}
                    elseif server_name == "jdtls" then
                        local jdtls = require("lspconfig").jdtls
                        local home = vim.fn.expand("~")
                        local workspace_dir = home .. "/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

                        jdtls.setup({
                            cmd = { "jdtls", "--jvm-arg=-Xmx2G" },
                            root_dir = require("lspconfig.util").root_pattern("pom.xml", "gradle.build", ".git"),
                            capabilities = capabilities,
                            settings = {
                                java = {
                                    configuration = {
                                        runtimes = {
                                            {
                                                name = "JavaSE-17",
                                                path = "/usr/lib/jvm/java-17-openjdk/",
                                            },
                                            {
                                                name = "JavaSE-21",
                                                path = "/usr/lib/jvm/java-21-openjdk/",
                                            }
                                        }
                                    }
                                }
                            },
                            init_options = {
                                workspace = workspace_dir,
                            },
                            on_attach = function(client, bufnr)
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    callback = function()
                                        require("conform").format({ async = true })
                                    end,
                                })
                            end
                        })
                    elseif server_name == "pyright" then
                        require("lspconfig").pyright.setup {
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    callback = function()
                                        require("conform").format({ async = true })
                                    end,
                                })
                            end,
                            settings = {
                                python = {
                                    analysis = {
                                        typeCheckingMode = "basic",
                                        autoImportCompletions = true,
                                    }
                                }
                            }
                        }
                    else
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" or vim.bo.filetype == "java" or vim.bo.filetype == "python" then
                                    vim.api.nvim_create_autocmd("BufWritePre", {
                                        buffer = bufnr,
                                        callback = function()
                                            require("conform").format({ async = true })
                                        end,
                                    })
                                end
                            end
                        }
                    end
                end,
            },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

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
            })
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
