return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('trouble').setup {}

    vim.keymap.set('n', '<leader>lD', function()
      require('trouble').open {
        mode = 'diagnostics',
        focus = true,
      }
    end, { desc = '[D]iagnostic error messages' })

    vim.keymap.set('n', '<leader>lQ', function()
      require('trouble').open {
        mode = 'quickfix',
        focus = true,
      }
    end, { desc = 'Do [Q]uickfix' })

    vim.keymap.set('n', '<leader>lQ', function()
      require('trouble').open {
        mode = 'qflist',
        focus = true,
      }
    end, { desc = 'Open diagnostic [Q]uickfix list' })

    vim.keymap.set('n', '<leader>lS', function()
      require('trouble').open {
        mode = 'lsp_document_symbols',
        focus = true,
        win = {
          type = 'split',
          size = { width = 70 },
          position = 'right',
        },
      }
    end, { desc = '[S]ymbols outline' })
  end,
}
