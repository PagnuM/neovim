return {
  'CRAG666/code_runner.nvim',
  config = function()
    require('code_runner').setup {
      filetype = {
        java = {
          'cd $dir &&',
          'javac $fileName &&',
          'java $fileNameWithoutExt',
        },
        python = 'python3 -u',
        javascript = 'node $fileName',
        typescript = 'deno run',
        bash = 'bash',
        sh = 'bash',
        go = 'go run',
        haskell = 'cd $folder && echo "$folder" && runhaskell $fileName', -- "runhaskell $fileName", "cabal run"
        rust = 'cargo run',
        c = 'cd $folder && gcc $fileName -o $fileNoExt.out && ./$fileNoExt.out',
        cpp = 'cd $folder && g++ -std=c++17 %:p -o $fileNoExt.out -Wall -Wextra -Wshadow && ./$fileNoExt.out',
      },
    }

    vim.keymap.set('n', '<leader>cr', ':RunCode<CR>', { noremap = true, silent = false })
    vim.keymap.set('n', '<leader>cf', ':RunFile<CR>', { noremap = true, silent = false })
    vim.keymap.set('n', '<leader>ct', ':RunFile tab<CR>', { noremap = true, silent = false })
    vim.keymap.set('n', '<leader>cp', ':RunProject<CR>', { noremap = true, silent = false })
    vim.keymap.set('n', '<leader>cc', ':RunClose<CR>', { noremap = true, silent = false })
    vim.keymap.set('n', '<leader>clf', ':CRFiletype<CR>', { noremap = true, silent = false })
    vim.keymap.set('n', '<leader>clp', ':CRProjects<CR>', { noremap = true, silent = false })
  end,
}
