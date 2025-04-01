-- Mappings

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Window Keybinds ]].
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-Up>', '<cmd>resize +8<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -8<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +8<cr>', { desc = 'Increase Window Width' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -8<cr>', { desc = 'Decrease Window Width' })

---@param delete_current_buffer boolean
local close_all_buffers = function(delete_current_buffer)
  delete_current_buffer = delete_current_buffer or true
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf_nr in ipairs(vim.api.nvim_list_bufs()) do
    if delete_current_buffer or buf_nr ~= current_buf then
      vim.api.nvim_buf_delete(buf_nr, {})
    end
  end
end

local close_all_buffers_except_current = function()
  close_all_buffers(false)
end

vim.keymap.set('n', 'º', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', 'ª', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>q', ':bdelete<CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bq', close_all_buffers_except_current, { desc = 'Close all buffers except current' })
vim.keymap.set('n', '<leader>bQ', close_all_buffers, { desc = 'Close all buffers' })
-- TODO: Open a buffer tab in a new horizontal split with telescope picker	Leader + bh
-- TODO: Open a buffer tab in a new vertical split with telescope picker	Leader + bv
-- TODO: Create file
