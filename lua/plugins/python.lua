PYTHON_PATH = "C:\\Program Files\\Python312\\python.exe"

return {
  -- virtual environment management
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "microsoft/debugpy",
      "mfussenegger/nvim-dap",
    },
    lazy = true,
    opts = {
      stay_on_this_version = true,
      name = {
        ".venv",
        "venv",
        "env",
        ".env",
      },
      dap_enabled = true,
      auto_refresh = true,
      search_venv_managers = {
        hatch = {
          path = vim.fn.expand("~") .. "/Library/Caches/hatch/env/virtual",
          recursive = true,
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "select virtualenv" },
    },
  },

  {
    "avanzzzi/behave.vim",
    -- ft = { "gherkin", "feature", "python" },
    config = function()
      vim.keymap.set("n", "<leader>xeg", ":BehaveGotoStep<CR>", { desc = "Go to step definition" })
      vim.keymap.set("n", "<leader>xeu", ":BehaveFindStep<CR>", { desc = "Find step usages" })
    end,
  },
  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "linux-cultist/venv-selector.nvim",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      require("dap-python").setup(PYTHON_PATH)
      dapui.setup()
      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end

      -- Lua configuration
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
          host = function()
            return "127.0.0.1"
          end,
          port = function()
            local val = tonumber(vim.fn.input("Port: ", "8086"))
            assert(val, "Please provide a valid port number")
            return val
          end,
        },
      }
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    end,
    keys = {
      { "<leader>xb", function() require("dap").toggle_breakpoint() end, desc = "toggle breakpoint" },
      { "<leader>xc", function() require("dap").continue() end, desc = "start/continue" },
      { "<leader>xi", function() require("dap").step_into() end, desc = "step into" },
      { "<leader>xo", function() require("dap").step_over() end, desc = "step over" },
      { "<leader>xr", function() require("dap").repl.open() end, desc = "open debug REPL" },
    },
  },

  -- Testing (pytest + behave)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/fixcursorhold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "tonycsoka/neotest-behave", 
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justmycode = true },
            args = { "--log-level", "DEBUG" },
            runner = "pytest"
          }),
          require("neotest-behave")({
            behave_bin = "behave", -- change if you use poetry run behave, etc.
          }),
        },
      })
    end,
    keys = {
      -- Unit tests
      { "<leader>xt", function() require("neotest").run.run() end, desc = "run nearest test" },
      { "<leader>xd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "debug nearest test" },
      { "<leader>xf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "run tests in current file" },
      { "<leader>xa", function() require("neotest").run.attach() end, desc = "attach to running test" },
      { "<leader>xw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "watch tests in file" },

      -- Behave tests
      { "<leader>xea", function() require("neotest").run.run({ suite = true }) end, desc = "run all behave scenarios" },
      { "<leader>xef", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "run behave file" },
    },
  },
}
