-- Scroll down half a screen and keep cursor in the middle
local map = vim.keymap.set

vim.api.nvim_set_keymap("n", "<C-D>", "<C-D>zz", { noremap = true, silent = true })
-- Scroll up half a screen and keep cursor in the middle
vim.api.nvim_set_keymap("n", "<C-U>", "<C-U>zz", { noremap = true, silent = true })

map('v', '>', '>gv', { noremap = true, silent = true })
map('v', '<', '<gv', { noremap = true, silent = true })

-- Resizing keymaps using Control + . , - =
-- Use Control + h/j/k/l to resize windows
-- map("n", "<C-l>", "<C-w><", { desc = "Decrease width", silent = true })
-- map("n", "<C-h>", "<C-w>>", { desc = "Increase width", silent = true })
-- map("n", "<C-j>", "<C-w>-", { desc = "Decrease height", silent = true })
-- map("n", "<C-k>", "<C-w>+", { desc = "Increase height", silent = true })
map("n", "<M-j>", ":cn<CR>", { desc = "Goto next quickfix", silent = true })
map("n", "<M-k>", ":cp<CR>", { desc = "Goto previous quickfix", silent = true })

map('n', '<C-s>', function()
  vim.cmd('!bash window-split')
end, { noremap = true, silent = true, desc = "Run window-split bash script" })

local utils = require("config.utils")
local ts_utils = require("config.ts_utils")
local wk = require("which-key")
local ts = require("telescope.builtin")
--local test = require("neotest")
-- local git = require("neogit")
wk.add({

  { "<leader>m",        group = "Manage" },
  { "<leader>mp",       "<cmd>Lazy<cr>",                               desc = "Manage plugins" },
  { "<leader>ml",       "<cmd>Mason<cr>",                              desc = "Manage LSP" },


  { "<leader><leader>", "<cmd>Telescope find_files<cr>",               desc = "Search repo" },
  { "<leader><cr>",     function() utils.ex_in_dir(ts.git_files) end,  desc = "Search whole repo" },
  -- { "<leader>.",    function() utils.ex_in_dir(ts.find_files) end,       desc = "Search current dir" },
  -- { "<leader>/",    ts.find_files, desc = "Live grep in root" },
  { "<leader>,",        function() utils.ex_in_dir(ts.live_grep) end,  desc = "Live grep in root" },
  { "<leader>.",        "<cmd>Telescope live_grep<cr>",                desc = "Live grep in root" },

  -- --DIRECTORY
  -- { "<leader>d",    group = "directory" },
  -- {
  --   "<leader>dg",
  --   function()
  --     ts.live_grep({ cwd = vim.fn.expand("%:p:h") })
  --     f
  --   end,
  --   desc = "Live grep in current dir",
  -- },
  --TEST

  { "<leader>t",        group = "toggle" },
  { "<leader>tt",       "<cmd>Neotree reveal<cr>",                     desc = "Neotree" },
  { "<leader>tn",       ":set relativenumber!<CR>",                    desc = "Relative number" },
  --{ "<leader>t",    group = "test" },
  --{ "<leader>tt",   test.run.run(),       desc = "Search current dir" },

  -- FILES
  { "<leader>f",        group = "file" },
  { "<leader>ff",       function() utils.ex_in_dir(ts.find_files) end, desc = "Search current dir" },
  -- { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep in root" },

  -- RUN
  { "<leader>r",        group = "Run" },
  { "<leader>rp",       "<cmd>Telescope oldfiles<cr>",                 desc = "Recent files" },


  {
    "<leader>fg",
    function()
      ts.live_grep({ cwd = vim.fn.expand("%:p:h") })
    end,
    desc = "Live grep in current dir",
  },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                               desc = "Recent files" },
  {
    "<leader>fp",
    function()
      local rel_path = vim.fn.expand("%")
      vim.fn.setreg("+", rel_path)
      vim.notify("Copied path: " .. rel_path)
    end,
    desc = "Copy current file path"
  },
  {
    "<leader>fP",
    function()
      local abs_path = vim.fn.expand("%:p")
      vim.fn.setreg("+", abs_path)
      vim.notify("Copied full path: " .. abs_path)
    end,
    desc = "Copy full path"
  },
  -- { "<leader>fm",   ":Move ",                                                    desc = "Move/Rename current file" },
  { "<leader>fc", "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<cr>", desc = "Config" },

  -- TODO Project  files
  { "<leader>p",  group = "Project" },
  { "<leader>pf", "<cmd>Telescope find_files<cr>",                             desc = "Search repo" },
  { "<leader>pg", "<cmd>Telescope live_grep<cr>",                              desc = "Grep project" },
  { "<leader>pp", "<cmd>Telescope projects<cr>",                               desc = "Grep project" },


  -- BUFFERS
  { "<leader>`",  "<c-^>",                                                     desc = "Switch to last buffer" },
  { "<leader>b",  group = "Buffers" },
  { "<leader>bb", "<cmd>Telescope buffers<cr>",                                desc = "List buffers" },
  { "<leader>bd", function()
    if vim.bo.filetype == "oil" then
      require("oil").close()
    else
      vim.cmd("bdelete")
    end
  end, desc = "Close buffer" },
  { "<leader>bn", "<cmd>bnext<cr>",                                            desc = "Next buffer" },
  { "<leader>bp", "<cmd>bprevious<cr>",                                        desc = "Previous buffer" },

  -- OPEN
  { "<leader>o",  group = "open" },
  {
    "<leader>oe",
    function()
      utils.OpenExplorer()
    end,
    desc = "Open explorer",
  },

  -- OIL
  -- { "<leader>d",  group = "Dired" },
  {
    "<leader>dd",
    "<cmd>Oil %:p:h<cr>",
    desc = "Oil"
  },
  {
    "<leader>dp",
    function()
      require("oil").open(vim.loop.cwd()) -- project root
    end,
    desc = "Oil in project root"
  },
  { "<leader>dh", "<cmd>Oil ~<cr>",                                                                  desc = "Oil in home directory" },
  { "<leader>dD", "<cmd>Oil ~/dev<cr>",                                                              desc = "Oil in dev directory" },
  { "<leader>dr", "<cmd>Oil ~/dev/work_repos<cr>",                                                   desc = "Oil in work repos" },
  { "<leader>dn", "<cmd>Oil ~/dev/notes<cr>",                                                        desc = "Oil in notes" },
  { "<leader>dt", "<cmd>Neotree reveal<cr>",                                                         desc = "Tree" },
  -- { "<leader>of", "<cmd>Oil<cr>",                               desc = "Oil file manager" },
  -- { "<leader>op", "<cmd>Oil .<cr>",                             desc = "Oil in project root" },
  -- { "<leader>oh", "<cmd>Oil ~<cr>",                             desc = "Oil in home directory" },
  -- { "<leader>oD", "<cmd>Oil ~/dev<cr>",                         desc = "Oil in dev directory" },
  -- { "<leader>or", "<cmd>Oil ~/dev/work_repos<cr>",              desc = "Oil in work repos" },
  -- { "<leader>on", "<cmd>Oil ~/dev/notes<cr>",                   desc = "Oil in notes" },
  -- { "<leader>ot", "<cmd>Neotree reveal<cr>",                   desc = "Tree"},

  -- { "<leader>rT", require("dap-python").test_method,            desc = "Debug Test Method" },

  -- Move this
  -- { "<leader>rd", "<cmd> lua vim.diagnostic.open_float() <CR>", desc = "Open float" },

  -- GIT
  { "<leader>g",  group = "Git" },
  { "<leader>gt", "<cmd>!git checkout --theirs -- '%'<cr>",                                          desc = "Git checkout theirs" },
  { "<leader>gm", "<cmd>!git checkout --ours -- '%'<cr>",                                            desc = "Git checkout mine" },
  { "<leader>gn", "<cmd>!git diff --name-only --diff-filter=U | head -n 1 | xargs -I {} vim {}<cr>", desc = "Go to next conflict in repo" },
  { "<leader>gl", function() utils.open_github() end,                                                desc = "Get GitHub link for current file" },

  -- LSP Navigation keymaps are now set in the LSP on_attach function for buffer-local usage.
  -- WINDOW MANAGEMENT
  { "<leader>w",  group = "Window" },
  { "<leader>wh", "<C-w>h",                                                                          desc = "Move to left window" },
  { "<leader>wj", "<C-w>j",                                                                          desc = "Move to bottom window" },
  { "<leader>wk", "<C-w>k",                                                                          desc = "Move to top window" },
  { "<leader>wl", "<C-w>l",                                                                          desc = "Move to right window" },
  { "<leader>w=", "<C-w>=",                                                                          desc = "Equalize window sizes" },
  { "<leader>wh", "<C-w>s",                                                                          desc = "Split window horizontally" },
  { "<leader>wv", "<C-w>v",                                                                          desc = "Split window vertically" },
  { "<leader>wq", "<C-w>q",                                                                          desc = "Close window" },
  { "<leader>wo", "<C-w>o",                                                                          desc = "Close other windows" },
  { "<lader>wT",  "<C-w>T",                                                                          desc = "Move window to new tab" },
  { "<leader>wx", "<C-w>x",                                                                          desc = "Swap with next window" },
  { "<leader>wH", "<C-w>H",                                                                          desc = "Move window to far left" },
  { "<leader>wJ", "<C-w>J",                                                                          desc = "Move window to very bottom" },
  { "<leader>wK", "<C-w>K",                                                                          desc = "Move window to very top" },
  { "<leader>wL", "<C-w>L",                                                                          desc = "Move window to far right" },
  { "<leader>wd", "<C-w>c",                                                                          desc = "Close window" },
  { "<leader>ww", "<C-w>w",                                                                          desc = "Go to next window" },
  -- { "<leader>n",  group = "Obsidian" },
  -- { "<leader>nn", "<cmd>ObsidianNew<CR>",                                                            desc = "New note" },
  -- { "<leader>nq", "<cmd>ObsidianQuickSwitch<CR>",                                                    desc = "Quick switch" },
  -- { "<leader>nd", "<cmd>ObsidianToday<CR>",                                                          desc = "Today" },
  -- { "<leader>nt", "<cmd>ObsidianTomorrow<CR>",                                                       desc = "Tomorrow" },
  -- { "<leader>ny", "<cmd>ObsidianYesterday<CR>",                                                      desc = "Yesterday" },
  -- { "<leader>ns", "<cmd>ObsidianSearch<CR>",                                                         desc = "Search" },
  -- { "<leader>nf", "<cmd>ObsidianFollowLink<CR>",                                                     desc = "Follow link" },
  -- { "<leader>nb", "<cmd>ObsidianBacklinks<CR>",                                                      desc = "Backlinks" },
  -- { "<leader>nl", "<cmd>ObsidianLink<CR>",                                                           desc = "Link" },
  --
  { "<leader>x",  group = "testing" },
  { "<leader>xe", group = "behave" },
  -- mode = { "n", "v" },
  -- {
  --   mode = {"v"},
  --   { "gd", function() utils.select_down() end, desc = "Select inner node" },
  -- },
  -- {
  --   mode = {"v"},
  --   { "gn", function() utils.select_next() end, desc = "Next sibling node" },
  -- },
  -- {
  --   mode = {"v"},
  --   { "gp", function() utils.select_prev() end, desc = "Previous sibling node" },
  -- }

})

-- Use <C-j> and <C-k> to navigate coc.nvim's completion menu
-- map("i", "<C-j>", function()
--   return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
-- end, { expr = true, silent = true })
--
-- map("i", "<C-k>", function()
--   return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
-- end, { expr = true, silent = true })


map("n", "<leader>gH", function()
  local buf_type = vim.bo.filetype
  local filepath = vim.fn.expand("%")
  local cwd = vim.fn.getcwd()

  if buf_type == "oil" then
    vim.cmd("G log -- " .. cwd)
  elseif vim.fn.empty(filepath) == 0 then
    vim.cmd("Gclog " .. filepath)
  else
    print("No file to show git history for.")
  end
end, { desc = "Open Git History (file/folder)" })

map("n", "<leader>gn", ":cnext<CR>", { desc = "Next Git commit" })
map("n", "<leader>gp", ":cprev<CR>", { desc = "Previous Git commit" })

function _G.wild_up_down(dir)
  local key
  if dir == "up" then
    key = vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>"
  else
    key = vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>"
  end
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

-- Mappings
vim.api.nvim_set_keymap('c', '<Up>', 'v:lua.wild_up_down("up")', { expr = true, noremap = true })
vim.api.nvim_set_keymap('c', '<Down>', 'v:lua.wild_up_down("down")', { expr = true, noremap = true })
