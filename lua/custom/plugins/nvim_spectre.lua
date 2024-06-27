return {
  'nvim-pack/nvim-spectre',
  opts = {},
  config = function()
    require('spectre').setup {}
    vim.keymap.set('n', '<leader>rr', require('spectre').toggle, { desc = 'Search and [R]eplace' })
  end,
  dependencies = { 'nvim-lua/plenary.nvim' },
}
