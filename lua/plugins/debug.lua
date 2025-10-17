-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)local lfs = require("lfs")

local function folder_exists(path)
    local attr = lfs.attributes(path)
    return attr and attr.mode == "directory"
end

local function create_folder(path)
    if not folderExists(path) then
        local success, err = lfs.mkdir(path)
        if success then
            print("Folder created successfully.")
            return true
        else
            print("Failed to create folder: " .. err)
        end
    else
        print("Folder already exists.")
    end
end

local function get_node_version()
  local handle = io.popen('node -v')
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result
  end
end

local function get_js_debug_build()
  local node_version = get_node_version()
  local debugger_path = '../' .. 'vscode-js-debug-' .. node_version .. '/out'

end

local function resize()
  -- Get our current buffer number
  local tn = vim.api.nvim_get_current_tabpage()
  local tree_win_handle = nil
  for _, window_handle in ipairs(vim.api.nvim_tabpage_list_wins(tn)) do
    local buffer_handle = vim.api.nvim_win_get_buf(window_handle)
    local buf_name = vim.fn.bufname(buffer_handle)
    if buf_name == 'neo-tree filesystem [1]' then
      tree_win_handle = window_handle
      break
    end
  end
  if tree_win_handle == nil then
    -- Did not find window for neo-tree, could not reset size.
    return
  end
  local configured_width = require('neo-tree').config.filesystem.window.width or 40
  if vim.api.nvim_win_get_width(tree_win_handle) > configured_width then
    -- Reset neo-tree window size to proper value.
    vim.api.nvim_win_set_width(tree_win_handle, configured_width)
    return
  end
  -- Did not find window in tabpage, could not reset size.
end

vim.keymap.set('n', '<F7>', function()
  dapui.toggle()
  require('neotreenormalized').resize()
end, { desc = 'Toggle nvim-dap-ui' })
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mxsdev/nvim-dap-vscode-js',
    {
      'microsoft/vscode-js-debug',
      build = 'npm i && npm run compile vsDebugServerBundle && mv dist out',
    },
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
        resize()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F4>',
      function()
        require('dap').restart()
        resize()
      end,
      desc = 'Debug: Restart',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
        resize()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>e',
      function()
        require('dapui').eval()
      end,
      desc = 'Debug: Evaluate selection.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Resize NeoTree when openin
    dap.listeners.after.event_terminated['dapui_config'] = resize
    dap.listeners.after.event_exited['dapui_config'] = resize

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'dap-python',
        'js-debug-adapter'
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      force_buffers = true,
      layouts = {
        {
          elements = {
            {
              id = 'repl',
              size = 0.333,
            },
            {
              id = 'scopes',
              size = 0.333,
            },
            {
              id = 'watches',
              size = 0.333,
            },
          },
          position = 'bottom',
          size = 10,
        },
        {
          elements = {
            {
              id = 'console',
              size = 0.5,
            },
            {
              id = 'breakpoints',
              size = 0.333,
            },
            {
              id = 'stacks',
              size = 0.333,
            },
          },
          position = 'left',
          size = 40,
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    require('dap-vscode-js').setup {
      debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
      adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' },
    }
    require('dap-python').setup '~/.virtualenvs/debugpy/bin/python'
    require('dap').configurations.python = {}
    -- require('mason-nvim-dap').setup {
    --   automatic_installation = false,
    --   ensure_installed = {
    --     'js@v1.76.1',
    --   },
    -- }
    require('dap').adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = { '${port}' }
        -- command = 'node',
        -- 💀 Make sure to update this path to point to your installation
        -- args = { vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug/out/src/vsDebugServer.js', '${port}' },
      },
    }
    require('dap').configurations.javascript = {}
  end,
}
