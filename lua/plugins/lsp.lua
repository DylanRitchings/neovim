return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      -- Recommended coc.nvim keybindings
      vim.keymap.set("n", "[g", '<Plug>(coc-diagnostic-prev)', { desc = "Go to previous diagnostic" })
      vim.keymap.set("n", "]g", '<Plug>(coc-diagnostic-next)', { desc = "Go to next diagnostic" })
      -- Only set coc.nvim keybindings for diagnostics, keep LSP for navigation/actions
      -- Unified coc.nvim keybindings and settings
      vim.keymap.set("n", "gD", ':call CocActionAsync("jumpDeclaration")<CR>', { desc = "Go to declaration" })
      vim.keymap.set("n", "gd", '<Plug>(coc-definition)', { desc = "Go to definition" })
      vim.keymap.set("n", "gi", '<Plug>(coc-implementation)', { desc = "Go to implementation" })
      vim.keymap.set("n", "gt", '<Plug>(coc-type-definition)', { desc = "Go to type definition" })
      vim.keymap.set("n", "gr", '<Plug>(coc-references)', { desc = "Find references" })
      vim.keymap.set("n", "gR", '<Plug>(coc-rename)', { desc = "Rename symbol" })
      vim.keymap.set("n", "gf", ':call CocActionAsync("format")<CR>', { desc = "Format buffer" })
      vim.keymap.set("n", "ga", ':CocAction<CR>', { desc = "Code action" })
      vim.keymap.set("n", "gh", ':call CocActionAsync("doHover")<CR>', { desc = "Hover documentation" })
      vim.keymap.set("n", "gs", ':call CocActionAsync("showSignatureHelp")<CR>', { desc = "Signature help" })
      vim.keymap.set("n", "gk", '<Plug>(coc-diagnostic-info)', { desc = "Show diagnostics" })
      vim.keymap.set("n", "gn", '<Plug>(coc-diagnostic-next)', { desc = "Next diagnostic" })
      vim.keymap.set("n", "gp", '<Plug>(coc-diagnostic-prev)', { desc = "Previous diagnostic" })
      vim.keymap.set("n", "gb", function()
        vim.cmd('normal! <C-o>')
      end, { desc = "Go back to previous location" })
      vim.cmd [[
        inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
      ]]
      vim.keymap.set("n", "g<Space>", 'coc#refresh()', { expr = true, silent = true, desc = "Trigger completion" })
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   pattern = "*",
      --   callback = function()
      --     vim.cmd("CocActionAsync('format')")
      --   end,
      -- })
      -- Basic config: show documentation on hover
      --   vim.cmd [[
      --     autocmd CursorHold * silent call CocActionAsync('doHover')
      --     autocmd User CocNvimInit ++once :CocInstall -sync coc-pyright coc-json coc-tsserver coc-lua coc-bash coc-yaml coc-html coc-css coc-markdown coc-powershell coc-docker coc-terraform coc-sql coc-vim | q
      --   ]]
    end,
  },
  "folke/neodev.nvim",
  "jonatan-branting/nvim-better-n",
  -- "hrsh7th/cmp-nvim-lsp",
  {
    "williamboman/mason-lspconfig.nvim",
    version = "v1.32.0"
  },

  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },
  "Chaitanyabsprip/present.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        "tpope/vim-repeat",
      },
    },
    config = function()
      local configs = require("nvim-treesitter.configs")
      require("nvim-treesitter.install").prefer_git = false
      require("nvim-treesitter.install").compilers = { vim.fn.getenv('CC'), "cc", "gcc", "clang", "cl", "zig" }
      local data_dir = vim.fn.stdpath('data')
      configs.setup({
        ensure_installed = {
          "vim", "vimdoc", "query", "heex", "javascript", "html", "css",
          "python", "markdown", "markdown_inline", "bash", "powershell", "yaml", "org",
          "git_config", "git_rebase", "gitignore", "gitcommit", "gitattributes", "diff",
          "json", "make", "editorconfig", "hjson", "http" },
        auto_install = false,
        sync_install = true,
        ignore_install = {},
        -- indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- start selection
            node_incremental = "grn", -- increment to next node
            scope_incremental = "grc", -- increment to scope
            node_decremental = "grm", -- decrement node
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,        -- automatically jump forward to textobj
            keymaps = {
              ["af"] = "@function.outer", -- around function
              ["if"] = "@function.inner", -- inside function
              ["ac"] = "@class.outer", -- around class
              ["ic"] = "@class.inner", -- inside class
              ["ap"] = "@parameter.outer", -- around parameter
              ["ip"] = "@parameter.inner", -- inside parameter
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- set jumps in jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
}

-- let g:markdown_fenced_languages = ['html', 'python', 'lua', 'vim', 'typescript', 'javascript']
