local dap     = require("dap")
local dapui   = require("dapui")
local mason   = require("mason")
local mndap   = require("mason-nvim-dap")

-- Install and configure adapters via Mason
mason.setup()
mndap.setup({
  ensure_installed      = { "debugpy", "codelldb" },
  automatic_installation = true,
})

-- ─── Define custom DAP signs ────────────────────────────────────────────────────
vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "Error"     })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "WarningMsg" })
vim.fn.sign_define("DapLogPoint",            { text = "◆", texthl = "Identifier"})
vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "Comment"   })

-- ─── dap-ui setup (run once) ───────────────────────────────────────────────────
dapui.setup({
  icons = {
    expanded      = "▼",
    collapsed     = "▶",
    current_frame = "",
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
      size     = 40,
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      position = "bottom",
      size     = 10,
    },
  },
  controls = {
    enabled  = true,
    element  = "repl",
    icons = {
      pause      = "",
      play       = "",
      step_into  = "",
      step_over  = "",
      step_out   = "",
      step_back  = "",
      run_last   = "↻",
      terminate  = "□",
    },
  },
})

-- ─── Python adapter & configuration ────────────────────────────────────────────
local python_exe = vim.fn.exepath("python3")
if python_exe ~= "" then
  dap.adapters.python = {
    type    = "executable",
    command = python_exe,
    args    = { "-m", "debugpy.adapter" },
  }
  dap.configurations.python = {
    {
      type        = "python",
      request     = "launch",
      name        = "Launch file",
      program     = "${file}",
      pythonPath  = function()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv then
          return venv .. "/bin/python"
        end
        return python_exe
      end,
    },
  }
end

-- ─── C/C++ adapter & Makefile‐driven configuration ────────────────────────────
dap.adapters.cpp = {
  type    = "executable",
  command = "codelldb",
  attach  = { pidProperty = "pid", pidSelect = "ask" },
}

dap.configurations.cpp = {
  {
    name        = "Launch via Makefile",
    type        = "cpp",
    request     = "launch",
    stopOnEntry = true,           -- only stop at your breakpoints
    cwd         = "${workspaceFolder}",

    program = function()
      -- save all buffers
      vim.cmd("silent! wall")

      -- default Make target: project folder name
      local default_target = "myapp"
      -- prompt for target, fallback to default
      local target = vim.fn.input("Make target (default: " .. default_target .. "): ")
                  :gsub("^%s*(.-)%s*$", "%1")
      if target == "" then
        target = default_target
      end

      -- build it
      local cmd = "make debug TARGET=" .. target
      print("→ " .. cmd)
      local out = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        error("Make failed:\n" .. out)
      end

      -- executable path
      local exe = vim.fn.getcwd() .. "/" .. target
      if vim.fn.executable(exe) == 0 then
        error("Executable not found: " .. exe)
      end
      return exe
    end,

    setupCommands = {
      { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
    },
  },
}

-- Mirror C configuration to C++ one
dap.configurations.c = dap.configurations.cpp

-- ─── Auto open/close dap-ui on debug start/stop ────────────────────────────────
dap.listeners.after.event_initialized["dapui"] = function() dapui.open()  end
dap.listeners.before.event_terminated   ["dapui"] = function() dapui.close() end
dap.listeners.before.event_exited       ["dapui"] = function() dapui.close() end

-- ─── Keymaps for DAP controls ─────────────────────────────────────────────────
vim.keymap.set("n", "<F5>",     dap.continue,        { desc = "DAP: Continue"          })
vim.keymap.set("n", "<F10>",    dap.step_over,       { desc = "DAP: Step Over"         })
vim.keymap.set("n", "<F11>",    dap.step_into,       { desc = "DAP: Step Into"         })
vim.keymap.set("n", "<F12>",    dap.step_out,        { desc = "DAP: Step Out"          })
vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Set Conditional Breakpoint" })
vim.keymap.set("n", "<Leader>dr", dap.repl.open,       { desc = "DAP: Open REPL"           })
vim.keymap.set("n", "<Leader>dl", dap.run_last,        { desc = "DAP: Run Last"            })
vim.keymap.set("n", "<Leader>du", dapui.toggle,        { desc = "DAP: Toggle DAP UI"       })
