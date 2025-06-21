require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "debugpy", "codelldb" },
    automatic_installation = true,
})

local dap = require('dap')

-- Optionally, require and configure nvim-dap-ui if you want a graphical interface.
local dapui = require("dapui")
dapui.setup()

-- Define custom icons for breakpoints.
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error",      linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "WarningMsg", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "Identifier", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "Comment",    linehl = "", numhl = "" })

dapui.setup({
  icons = {
    expanded = "▼",
    collapsed = "▶",
    current_frame = "",  -- Icon for the current frame marker.
  },
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      position = "bottom",
      size = 10,
    },
  },
  controls = {
      enabled = true,
      element = "repl",
      icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "↻",
          terminate = "□",
      },
  },
})

-- Python configuration using debugpy.
local python_exe = vim.fn.exepath("python3")
if python_exe == "" then
  error("python3 executable not found. Please install Python 3 and ensure it is in your PATH.")
end

dap.adapters.python = {
  type = 'executable',
  command = python_exe,
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      local venv_folder = os.getenv("VIRTUAL_ENV")
      if venv_folder then
        return venv_folder .. '/bin/python'
      else
        return python_exe
      end
    end,
  },
}

require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "debugpy", "codelldb" },
    automatic_installation = true,
})

local dap = require('dap')

-- Optionally, require and configure nvim-dap-ui if you want a graphical interface.
local dapui = require("dapui")
dapui.setup()

-- Define custom icons for breakpoints.
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error",      linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "WarningMsg", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "Identifier", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "Comment",    linehl = "", numhl = "" })

dapui.setup({
  icons = {
    expanded = "▼",
    collapsed = "▶",
    current_frame = "",  -- Icon for the current frame marker.
  },
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      position = "bottom",
      size = 10,
    },
  },
  controls = {
      enabled = true,
      element = "repl",
      icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "↻",
          terminate = "□",
      },
  },
})
-- Python configuration using debugpy.
local python_exe = vim.fn.exepath("python3")
if python_exe == "" then
  error("python3 executable not found. Please install Python 3 and ensure it is in your PATH.")
end

dap.adapters.python = {
  type = 'executable',
  command = python_exe,
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      local venv_folder = os.getenv("VIRTUAL_ENV")
      if venv_folder then
        return venv_folder .. '/bin/python'
      else
        return python_exe
      end
    end,
  },
}

-- C++ configuration using CodeLLDB.
dap.adapters.cpp = {
  type = 'executable',
  attach = { pidProperty = "pid", pidSelect = "ask" },
  command = 'codelldb',
}

dap.configurations.cpp = {
  {
    name = "Launch file (build temporary)",
    type = "cpp",
    request = "launch",
    program = function()
      local filename = vim.fn.expand("%:p")
      if filename == "" then
        error("Please open a file to debug")
      end
      local tmp_exe = vim.fn.tempname() .. ".out"
      local cmd = string.format("g++ -g %s -o %s", filename, tmp_exe)
      print("Compiling with: " .. cmd)
      local output = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        error("Compilation failed: " .. output)
      end
      print("Compiled temporary executable: " .. tmp_exe)
      return tmp_exe
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty printing for gdb',
        ignoreFailures = false,
      },
    },
  },
}
dap.configurations.c = dap.configurations.cpp

-- VALGRIND INTEGRATION (dlyongemallo/valgrind.nvim)
local has_valgrind, valgrind = pcall(require, 'valgrind')
if has_valgrind then
  valgrind.setup({
    -- Default configuration for dlyongemallo/valgrind.nvim
    -- This plugin integrates with DAP automatically
  })
end

-- Keymaps for dap functionality.
vim.keymap.set('n', '<F5>', require('dap').continue, { desc = "DAP: Continue" })
vim.keymap.set('n', '<F10>', require('dap').step_over, { desc = "DAP: Step Over" })
vim.keymap.set('n', '<F11>', require('dap').step_into, { desc = "DAP: Step Into" })
vim.keymap.set('n', '<F12>', require('dap').step_out, { desc = "DAP: Step Out" })
vim.keymap.set('n', '<Leader>db', require('dap').toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "DAP: Set Conditional Breakpoint" })
vim.keymap.set('n', '<Leader>dr', require('dap').repl.open, { desc = "DAP: Open REPL" })
vim.keymap.set('n', '<Leader>dl', require('dap').run_last, { desc = "DAP: Run Last" })

-- Optional keymap to toggle the DAP UI.
vim.keymap.set('n', '<Leader>du', dapui.toggle, { desc = "Toggle DAP UI" })

-- VALGRIND KEYMAPS (dlyongemallo/valgrind.nvim)
if has_valgrind then
  -- This plugin automatically adds Valgrind configurations to DAP
  -- You can access them through the normal DAP interface with <F5>
  vim.keymap.set('n', '<Leader>vv', function()
    -- Start Valgrind debugging session
    require('dap').continue()
  end, { desc = "Start Valgrind debugging" })
end

-- Manual Valgrind keymap (fallback)
vim.keymap.set('n', '<Leader>dv', function()
  local filename = vim.fn.expand("%:p")
  if filename == "" then
    print("Please open a C/C++ file")
    return
  end
  
  local filetype = vim.bo.filetype
  if filetype ~= "c" and filetype ~= "cpp" then
    print("Valgrind only works with C/C++ files")
    return
  end
  
  local tmp_exe = vim.fn.tempname() .. ".out"
  local compiler = filetype == "cpp" and "g++" or "gcc"
  local compile_cmd = string.format("%s -g -O0 -Wall %s -o %s", compiler, filename, tmp_exe)
  
  print("Compiling: " .. compile_cmd)
  local output = vim.fn.system(compile_cmd)
  if vim.v.shell_error ~= 0 then
    print("Compilation failed: " .. output)
    return
  end
  
  local valgrind_cmd = string.format(
    "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose %s; echo 'Press Enter to close...'; read", 
    tmp_exe
  )
  vim.cmd("split | terminal " .. valgrind_cmd)
end, { desc = "Quick Valgrind run" })

-- Automatically open and close dap-ui when debugging starts and stops.
dap.listeners.after.event_initialized["dapui_config"] = function()
  require("dapui").open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  require("dapui").close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  require("dapui").close()
end
