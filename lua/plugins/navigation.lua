return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
      },
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<enter>"] = "open",
          ["<space>"] = false,
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
      auto_open = false,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function(_, opts)
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        path_display = { "truncate" },
        layout_config = {
          width = 0.95,
          height = 0.85,
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      })

      opts.pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      }

      return opts
    end,
  },
  "nvim-telescope/telescope-fzf-native.nvim",
  {
    "stevearc/oil.nvim",
    opts = {
      constrain_cursor = "name",
      delete_to_trash = true,
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["Q"] = "actions.close",
        ["<BS>"] = "actions.parent",
        ["gx"] = "actions.open_external",
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)

      -- Guard against a race where oil may touch a buffer that was deleted
      -- before its deferred rename callback runs.
      local util = require("oil.util")
      util.rename_buffer = function(src_bufnr, dest_buf_name)
        if type(src_bufnr) == "string" then
          src_bufnr = vim.fn.bufadd(src_bufnr)
          if not vim.api.nvim_buf_is_loaded(src_bufnr) then
            pcall(vim.api.nvim_buf_delete, src_bufnr, {})
            return false
          end
        elseif type(src_bufnr) == "number" and not vim.api.nvim_buf_is_valid(src_bufnr) then
          return false
        end

        local bufname = vim.api.nvim_buf_get_name(src_bufnr)
        if not vim.loop.fs_stat(dest_buf_name) then
          local altbuf = vim.fn.bufnr("#")
          local ok = pcall(vim.api.nvim_buf_set_name, src_bufnr, dest_buf_name)
          if ok then
            pcall(vim.api.nvim_buf_delete, vim.fn.bufadd(bufname), {})
            if altbuf and vim.api.nvim_buf_is_valid(altbuf) then
              vim.fn.setreg("#", altbuf)
            end
            return false
          end
        end

        if not vim.api.nvim_buf_is_valid(src_bufnr) then
          return false
        end

        local is_modified = false
        local ok_mod, mod_val = pcall(function()
          return vim.bo[src_bufnr].modified
        end)
        if ok_mod then
          is_modified = mod_val
        end

        local dest_bufnr = vim.fn.bufadd(dest_buf_name)
        pcall(vim.fn.bufload, dest_bufnr)

        local ok_listed, src_buflisted = pcall(function()
          return vim.bo[src_bufnr].buflisted
        end)
        if ok_listed and src_buflisted and vim.api.nvim_buf_is_valid(dest_bufnr) then
          vim.bo[dest_bufnr].buflisted = true
        end

        pcall(function()
          vim.bo[src_bufnr].modified = is_modified
        end)

        vim.schedule(function()
          for _, winid in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == src_bufnr then
              if vim.api.nvim_buf_is_valid(dest_bufnr) then
                vim.api.nvim_win_set_buf(winid, dest_bufnr)
              end
            end
          end

          if vim.api.nvim_buf_is_valid(src_bufnr) and vim.api.nvim_buf_is_valid(dest_bufnr) then
            local ok_src_mod, src_mod = pcall(function()
              return vim.bo[src_bufnr].modified
            end)
            if ok_src_mod and src_mod then
              local ok_lines, src_lines = pcall(vim.api.nvim_buf_get_lines, src_bufnr, 0, -1, true)
              if ok_lines then
                pcall(vim.api.nvim_buf_set_lines, dest_bufnr, 0, -1, true, src_lines)
              end
            end
            pcall(vim.api.nvim_buf_delete, src_bufnr, {})
          end

          if vim.api.nvim_buf_is_valid(dest_bufnr) then
            local ok_undofile, undofile_enabled = pcall(function()
              return vim.bo[dest_bufnr].undofile
            end)
            if ok_undofile and undofile_enabled then
              pcall(vim.api.nvim_buf_call, dest_bufnr, function()
                vim.cmd.rundo({
                  args = { vim.fn.undofile(dest_buf_name) },
                  magic = { file = false, bar = false },
                  mods = { emsg_silent = true },
                })
              end)
            end
          end
        end)

        return true
      end
    end,
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
  },
  {
    "aaronik/treewalker.nvim",
    lazy = false,
    opts = {
      highlight = true,
      highlight_duration = 250,
      highlight_group = "CursorLine",
      select = false,
      notifications = true,
      jumplist = true,
    },
    config = function()
      vim.keymap.set({ "n", "v" }, "<C-k>", "<cmd>Treewalker Up<cr>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<C-j>", "<cmd>Treewalker Down<cr>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<C-h>", "<cmd>Treewalker Left<cr>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>Treewalker Right<cr>", { silent = true })

      vim.keymap.set("n", "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true })
      vim.keymap.set("n", "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true })
      vim.keymap.set("n", "<C-S-h>", "<cmd>Treewalker SwapLeft<cr>", { silent = true })
      vim.keymap.set("n", "<C-S-l>", "<cmd>Treewalker SwapRight<cr>", { silent = true })
    end,
  },
}
