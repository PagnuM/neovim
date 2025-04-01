return {
  {
    'dmmulroy/tsc.nvim',
    opts = {},
    ft = { 'javascript', 'typescript' },
  },
  {
    'nvim-java/nvim-java',
    ft = { 'java' },
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-refactor',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'stevearc/conform.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      local servers = {
        ts_ls = {
          settings = {
            typescript = { format = { semicolons = 'insert' } },
            javascript = { format = { semicolons = 'insert' } },
          },
        },
        hls = {},
        eslint_d = {},
        ['elixir-ls'] = {},
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
        gopls = {},
        html = {},
        cssls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })

      -- Mason.nvim config
      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('java').setup()
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- LSPs not installed with mason.nvim
      -- nvim_lsp.hls.setup {}

      -- Create Keybinds for LSP
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<CR>', { desc = 'Lsp [I]nfo' })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto [D]eclaration' })
          vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Goto [D]efinition' })
          vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Goto [R]eferences' })
          vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, { desc = 'Goto [I]mplementation' })
          vim.keymap.set('n', 'g<', require('telescope.builtin').lsp_incoming_calls, { desc = 'Goto [<]-- Incoming calls' })
          vim.keymap.set('n', 'g>', require('telescope.builtin').lsp_outgoing_calls, { desc = 'Goto [<]-- Outgoing calls' })
          vim.keymap.set('n', 'gy', require('telescope.builtin').lsp_type_definitions, { desc = 'T[y]pe Definition' })
          vim.keymap.set('n', '<leader>ls', require('telescope.builtin').lsp_document_symbols, { desc = 'Document [S]ymbols' })

          vim.keymap.set('n', '<leader>lg', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'Workspace Symbols' })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Re[n]ame' })
          vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code [A]ction' })
          vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help, { desc = 'Signature [H]elp' })

          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            if client.server_capabilities.documentHighlightProvider then
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
              })
            end
          end
        end,
      })

      -- Use Semantic Tokens AFTER Treesitter (see above to disable semantic tokens)
      -- vim.highlight.priorities.semantic_tokens = 95

      -- Formatters and Linters with conform.nvim, replacing LSP
      local conform = require 'conform'
      conform.setup {
        notify_on_error = true,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
        formatters_by_ft = {
          bash = { 'shfmt' },
          lua = { 'stylua' },
          typescript = { 'eslint_d' },
          javascript = { 'eslint_d' },
          elixir = { 'elixir_ls' },
          haskell = { 'ormolu' },
          python = { 'isort', 'flake8', 'black' },
        },
      }

      vim.keymap.set('n', '<leader>lI', require('conform.health').show_window, { desc = 'Conform [I]nfo' })
      vim.keymap.set('n', '<leader>lf', conform.format, { desc = '[F]ormat document' })
    end,
  },
}
