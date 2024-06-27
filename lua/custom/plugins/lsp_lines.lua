return {
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  config = function()
    require('lsp_lines').setup()

    local is_diagnostic_virtual_text_active = false
    vim.diagnostic.config { virtual_text = is_diagnostic_virtual_text_active }

    vim.keymap.set('n', '<leader>ld', function()
      require('lsp_lines').toggle()
      is_diagnostic_virtual_text_active = not is_diagnostic_virtual_text_active
      vim.diagnostic.config { virtual_text = is_diagnostic_virtual_text_active }
    end, { desc = 'Toggle line [D]iagnostics' })
  end,
}
