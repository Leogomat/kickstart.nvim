-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Resizing functionality: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1250
local function resize()
  -- Get our current buffer number
  local tn = vim.api.nvim_get_current_tabpage()
  local debug_win_handle = nil
  for _, window_handle in ipairs(vim.api.nvim_tabpage_list_wins(tn)) do
    local buffer_handle = vim.api.nvim_win_get_buf(window_handle)
    local buf_name = vim.fn.bufname(buffer_handle)
    if buf_name == 'DAP Console' then
      debug_win_handle = window_handle
      local configured_width = require('dapui.config').layouts[2].size
      if vim.api.nvim_win_get_width(debug_win_handle) > configured_width then
        vim.api.nvim_win_set_width(debug_win_handle, configured_width)
        return
      end
      break
    end
  end
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      'ß',
      function()
        vim.api.nvim_command 'Neotree'
        -- resize()
      end,
      desc = 'NeoTree reveal',
      silent = true,
    },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['ß'] = function()
            vim.api.nvim_command 'Neotree close'
            resize()
          end,
        },
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  },
  init = function()
    -- Open NeoTree when NeoVim starts without a file
    vim.api.nvim_create_autocmd('VimEnter', {
      pattern = '*',
      group = vim.api.nvim_create_augroup('NeotreeOnOpen', { clear = true }),
      once = true,
      callback = function(_)
        if vim.fn.argc() == 0 then
          vim.cmd 'Neotree'
        end
      end,
    })
  end,
}
