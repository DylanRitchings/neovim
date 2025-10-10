local U = {}

function U.ex_in_dir(func)
  return function()
    func({ cwd = vim.fn.expand("%:p:h") })
  end
end

function U.OpenExplorer()
  local current_dir = vim.fn.expand("%:p:h")
  local cmd = string.format('cd "%s" && explorer .', current_dir)
  print(cmd)
  vim.fn.jobstart(cmd, { detach = true })
end

function U.open_browser(link)
  local cmd = ""
  if vim.fn.has("mac") == 1 then
    cmd = "open"
  elseif vim.fn.has("unix") == 1 then
    cmd = "xdg-open"
  elseif vim.fn.has("win32") == 1 then
    cmd = "start"
  end

  if cmd ~= "" then
    vim.fn.system(cmd .. " " .. link)
  else
    print("Unsupported operating system")
  end
end

local function in_visual_mode()
    local mode = vim.api.nvim_get_mode().mode
    return mode == 'v' or mode == 'V' or mode == '\22' -- '\22' represents Ctrl-V (Visual Block mode)
end

function U.open_github()
  local file_path = vim.fn.expand("%")
  local branch_name = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local repo_url = vim.fn.system("git remote get-url origin"):gsub("\n", "") -- TODO remove git
  
  local repo_path = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  repo_path = repo_path:gsub("%.git$", "")
  -- TODO windows conversion
  local rel_file_path = string.gsub(file_path, repo_path, "")

  local line_num = ""
  if in_visual_mode() then
    local start_pos = vim.api.nvim_win_get_cursor(0)[1] 
    local end_pos = vim.fn.getpos('v')[2]
    line_num = "#L" .. start_pos .. "-L" .. end_pos
  end

  local github_link = repo_url .. "/blob/" .. branch_name .. "/" .. rel_file_path .. line_num
  U.open_browser(github_link)

  vim.fn.setreg('+', github_link)
end


function U.open_cdk_docs()
  local word = vim.fn.expand("<cword>")
  local url = "https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk/" .. word .. ".html"

  U.open_browser(url)
end

-- vim.api.nvim_set_keymap('n', '<leader>co', U.open_cdk_docs, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>co', U.open_cdk_docs, { noremap = true, silent = true })


-- local function get_venv_in_repo_root()
--   local util = require("lspconfig.util")
--   local root = util.find_git_ancestor(vim.fn.getcwd())
--   if root then
--     local venv_path = root .. "/.venv"
--     if vim.fn.isdirectory(venv_path) == 1 then
--       return venv_path
--     end
--   end
--   return nil
-- end
-- require("dap-python").setup(get_venv_in_repo_root() or vim.fn.exepath("python"))
-- function U.GetPdmVenvPath()
--   local handle = io.popen("pdm venv list | grep 'in-project' | awk '{print $3}'")
--   local result = handle:read("*a")
--   handle:close()
--
--   -- Remove trailing newline
--   result = result:gsub("[\n\r]", "")
--
--   if result ~= "" then
--     return result
--   else
--     return nil
--   end
-- end
--
-- vim.api.nvim_create_user_command("CopyRelPath", function()
--   vim.fn.setreg('+', vim.fn.expand('%'))
-- end, {})
--
-- function U.telescope_grep_and_replace()
--   -- Use Telescope for live_grep
--   require('telescope.builtin').live_grep({
--     prompt_title = "Live Grep (for replace)",
--     attach_mappings = function(prompt_bufnr, map)
--       -- Override the default 'enter' key to send results to quickfix
--       map('i', '<CR>', function()
--         require('telescope.actions').send_to_qflist(prompt_bufnr)
--         require('telescope.actions').close(prompt_bufnr)
--
--         -- Prompt for search and replace terms
--         vim.ui.input({prompt = "Search term: "}, function(search_term)
--           if search_term then
--             vim.ui.input({prompt = "Replace with: "}, function(replace_term)
--               if replace_term then
--                 -- Perform the substitution
--                 vim.cmd('cdo s/' .. search_term .. '/' .. replace_term .. '/g | update')
--                 print("Replacement complete!")
--               end
--             end)
--           end
--         end)
--       end)
--       return true
--     end,
--   })
-- end
--
-- vim.api.nvim_create_user_command('TelescopeGrepAndReplace', U.telescope_grep_and_replace, {})
-- vim.keymap.set('n', '<leader>pr', U.telescope_grep_and_replace, { noremap = true, silent = true })

-- compile latex on save
vim.api.nvim_create_augroup("AutoPdf", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.tex",
  group = "AutoPdf",
  callback = function()
    -- vim.cmd([[!latexmk -pdf -pv -xelatex]])
    local filename = vim.fn.expand("%")
    vim.cmd("!xelatex " .. filename)
  end,
})

-- TODO change to when python file is opened
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto select virtualenv Nvim open",
  pattern = "*",
  callback = function()
    local venv = string.format("%s/.venv", ROOT_DIR)
    if venv ~= "" then
  -- require("venv-selector").retrieve_from_cache()
    end
  end,
  once = true,
})

-- TODO  
-- Get list of commits for file
-- Open file in the latest commit
-- Cycle back and forth between commits 
-- Create the same for oil
local function get_file_commits()
    -- Get the full path of the current file
    local file_path = vim.fn.expand('%:p')

    -- Run git log for the file and get output as a table
    local commits = vim.fn.systemlist('git log --oneline -- ' .. vim.fn.shellescape(file_path))

    -- Check for errors
    if vim.v.shell_error ~= 0 then
        print("Error: Not a git repository or file not tracked")
        return {}
    end

    -- Return the commits table
    return commits
end

-- Example usage: print the commits
local commits = get_file_commits()
for _, commit in ipairs(commits) do
    print(commit)
end


-- local ts_utils = require("nvim-treesitter.ts_utils")
-- -- Get the current node at cursor
-- local function get_node_at_cursor()
--     local node = ts_utils.get_node_at_cursor()
--     if not node then return end
--     return node
-- end
--
-- -- Select inner part of the current node
-- function U.select_down()
--     local node = get_node_at_cursor()
--     if not node then return end
--     local children = { node:iter_children() }
--     local inner = nil
--     for child in node:iter_children() do
--         if child:range() then
--             inner = child
--             break
--         end
--     end
--     if not inner then return end
--
--     local s_row, s_col, e_row, e_col = inner:range()
--     vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
--     vim.cmd('normal! v')
--     vim.api.nvim_win_set_cursor(0, { e_row + 1, e_col })
-- end
--
-- -- Move to next sibling node of the same type
-- function U.select_next()
--     local node = get_node_at_cursor()
--     if not node then return end
--     local parent = node:parent()
--     if not parent then return end
--
--     local found = false
--     for child in parent:iter_children() do
--         if found then
--             -- select next sibling
--             local s_row, s_col, e_row, e_col = child:range()
--             vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
--             vim.cmd('normal! v')
--             vim.api.nvim_win_set_cursor(0, { e_row + 1, e_col })
--             return
--         end
--         if child == node then
--             found = true
--         end
--     end
-- end
-- -- Move to previous sibling node of the same type
-- function U.select_prev()
--     local node = get_node_at_cursor()
--     if not node then return end
--     local parent = node:parent()
--     if not parent then return end
--
--     local last = nil
--     for child in parent:iter_children() do
--         if child == node and last then
--             local s_row, s_col, e_row, e_col = last:range()
--             vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
--             vim.cmd('normal! v')
--             vim.api.nvim_win_set_cursor(0, { e_row + 1, e_col })
--             return
--         end
--         last = child
--     end
-- end
return U

