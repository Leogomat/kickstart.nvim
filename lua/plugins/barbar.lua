return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
    vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', { desc = 'Switch to last tab' })
    vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', { desc = 'Switch to tab 1' })
    vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', { desc = 'Switch to tab 2' })
    vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', { desc = 'Switch to tab 3' })
    vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', { desc = 'Switch to tab 4' })
    vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', { desc = 'Switch to tab 5' })
    vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', { desc = 'Switch to tab 6' })
    vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', { desc = 'Switch to tab 7' })
    vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', { desc = 'Switch to tab 8' })
    vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', { desc = 'Switch to tab 9' })
    vim.keymap.set('n', '<A-h>', '<Cmd>BufferPrevious<CR>', { desc = 'Switch to previous tab' })
    vim.keymap.set('n', '<A-l>', '<Cmd>BufferNext<CR>', { desc = 'Switch to next tab' })
    vim.keymap.set('n', '<A-,>', '<Cmd>BufferMovePrevious<CR>', { desc = 'Move buffer to the left' })
    vim.keymap.set('n', '<A-.>', '<Cmd>BufferMoveNext<CR>', { desc = 'Move buffer to the right' })
    vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })
    vim.keymap.set('n', '<A-a>', '<Cmd>BufferCloseAllButPinned<CR>', { desc = 'Close all buffers' })
  end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    -- animation = true,
    -- insert_at_start = true,
    -- …etc.
  },
}
