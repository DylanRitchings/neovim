local M = {}
local ts = vim.treesitter
local ts_utils = require('nvim-treesitter.ts_utils')
-- IDEAS
-- go down to first child with interested type
-- go up to next interested typ

INTERESTED_TYPES = {
  -- Functions / Methods
  "function", "function_definition", "function_declaration",
  "method_definition", "method_declaration", "body",

  -- Variables / Assignments
  "variable", "variable_declaration", "assignment_statement", "local_variable_declaration", "let_declaration",
  "const_declaration", "comment",

  -- Classes / Structs / Types
  "class", "class_definition",
  "struct", "struct_definition",
  "interface", "type_declaration",

  -- Modules / Namespaces / Packages
  "module", "module_declaration", "namespace", "package",

  -- Objects / Records / Maps / Tables
  "object", "pair", "table_constructor", "record",

  -- Enums / Constants
  "enum", "enum_declaration", "const_declaration",

  -- Blocks / Loops / Conditional Statements (optional)
  "if_statement", "for_statement", "while_statement", "loop_statement", "block",

  -- Misc / JSON-like
  "array", "array_element", "key_value_pair", "key",
}


local function attach_parser()
  local parser = ts.get_parser(0, vim.bo.filetype)
  if parser then
    parser:parse()
  end
end

local function get_tree_root()
  local buf = 0

  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.bo[bufnr].filetype
  local parser = ts.get_parser(buf, lang)

  local tree = parser:parse()[1]
  print("First tree object:", tree)

  local root = tree:root()

  return tree, root
end

local function get_current_node()
  return ts_utils.get_node_at_cursor()
end

local function move_cursor_to_node(node)
  local row, col, _ = node:start()
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

local function print_n(node)
  print(node)
  print(node:id())
  print(node:type())

  local row, col, _ = node:start()
  print("row: ", row)
  print("col: ", col)
  print()
end

local function find_first_parent_of_type(node, types)
  while node do
    for _, t in ipairs(types) do
      if node:type() == t then
        return node
      end
    end
    node = node:parent()
  end
  return nil
end



local function get_next_sibling(node)
  node = find_first_parent_of_type(node, INTERESTED_TYPES)

  local target_type = node:type()
  local parent = node:parent()
  local found_original = false
  local first_node

  for child in parent:iter_children() do
    print_n(child)
    if not first_node and child:type() == target_type then
      first_node = child
    end
    if not found_original and child:id() == node:id() then --currently elseif doesnt count as if
      found_original = true
    elseif child:type() == target_type and found_original then
      return child
    end
  end

  if first_node then
    return first_node
  else
    return node
  end
end

local function current_value_in_list(value, list)
  for _, v in ipairs(list) do
    if v == value then
      return true
    end
  end
  return false
end

local function find_first_child_of_type(node)
  if not node then return nil end

  -- types that are considered "blocks" or containers
  local container_types = {
    ["object"] = true,
    ["array"] = true,
    ["block"] = true,
    ["function_definition"] = true,
    ["for_statement"] = true,
    ["while_statement"] = true,
    ["if_statement"] = true,
    ["class_definition"] = true,
    ["switch_statement"] = true,
  }

  -- find first descendant that is a container
  local function traverse(n)
    for i = 0, n:named_child_count() - 1 do
      local child = n:named_child(i)
      if container_types[child:type()] then
        return child
      else
        local found = traverse(child)
        if found then return found end
      end
    end
    return nil
  end

  return traverse(node)
end

function M.go_to_first_child()
  attach_parser()
  local node = get_current_node()
  if not node then return end

  local first_child = find_first_child_of_type(node)

  if first_child and first_child:id() ~= node:id() then
    move_cursor_to_node(first_child)
  else
    print("No child")
  end
end

function M.next_sibling()
  attach_parser()
  local node = get_current_node()
  if not node then return end
  local next_sibling = get_next_sibling(node)
  if not next_sibling then next_sibling = node end
  move_cursor_to_node(next_sibling)
end

function M.prev_sibling()
end

function M.go_to_parent()
  attach_parser()
  local node = get_current_node()
  if not node then return end
  node = find_first_parent_of_type(node, INTERESTED_TYPES)
  local parent_node = find_first_parent_of_type(node:parent(), INTERESTED_TYPES)
  if not parent_node then parent_node = node end
  move_cursor_to_node(parent_node)
end

local last_motion = nil

local function repeatable(fn)
  return function()
    fn()
    last_motion = fn
  end
end

-- Call this to repeat the last motion
local function repeat_last()
  if last_motion then
    last_motion()
  end
end

vim.keymap.set({ "n", "v" }, 'm', repeat_last, { desc = "Repeat last repeatable function" })
vim.keymap.set({ 'n', 'x' }, '<leader>N', repeatable(M.go_to_parent), { desc = "Go to parent node" })
vim.keymap.set({ 'n', 'x' }, '<leader>s', repeatable(M.next_sibling), { desc = "Go to next sibling node" })
-- vim.keymap.set({'n', 'x'}, '<leader>S', M.prev_sibling,        { desc = "Go to previous sibling node" })
vim.keymap.set({ 'n', 'x' }, '<leader>n', repeatable(M.go_to_first_child), { desc = "Go to first child node" })
return M

-- presentation:
-- Using treesitter to parse large json files (slightly technical)
-- problem: struggle to parse large json files (show a large json object and show what you have to do get the value you want)
-- - (could also show that tab column thing)
-- - (multicoloured brackets)
-- goals:
-- - want to go up and down json objects
-- - want to cycle through each object at same level
-- solution: use a thing called treesitter (this is what a lot of IDEs use in the background)
-- what is treesitter?
-- show the tree for a json file and then a python file
-- neovim is what makes it so easy to write functions for your text editor to use
-- - (allows you write code using the language lua that can be used in your IDE similar to a bash script)
-- - (you could do this in another IDE but it will probably be harder to get started with)
-- how I have used treesitter
-- - (what functions I have created...)
-- - (more similar functions could be created)
-- show moving around in json (how it can be used )
-- try xml?
-- language agnostic so it can be used in a normal programming language or data formats like json
--
-- notes:
-- a dev workflow improvement
-- its harder to get neovim setup on windows than on mac or linux
