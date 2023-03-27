local M = {}

function M.setup()
  local ls_command = 'pwd'
  local handle = io.popen("pwd") 
  local setup_venv_command = 'python -m venv venv'
  local activate_venv_command = '. venv/bin/activate'
  local pip_install_requirements_command = 'pip install -r ./chatgpt-python-api/requirements.txt'
  local handle_venv = io.popen(setup_venv_command)
  local handle_a_venv_command = io.popen(activate_venv_command)
  local handle_pip_install_requirements_command = io.popen(pip_install_requirements_command)
  local result = handle:read("*a")
  handle_venv:close()
  handle_a_venv_command:close()
  handle_pip_install_requirements_command:close()
end

function M.sayHelloWorld()
  print("Hello world")
end

local make_call_to_chatgpt = function(prompt) 
  local command =  './chatgpt-python-api/venv/bin/python ./chatgpt-python-api/chatgpt-interface.py "' .. prompt .. '"'
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  print(result)
end

local embedded_functions = vim.treesitter.parse_query(
    "python",
    [[
      (function_definition) @id
    ]]
)

local get_root = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "python", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local format_dat_function = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype ~= "python" then
    vim.notify("can only be used in python")
    return
  end

  local root = get_root(bufnr)

  local changes = {}

  for id, node in embedded_functions:iter_captures(root, bufnr, 0 ,-1) do
    local name = embedded_functions.captures[id]
    if name == "id" then
      local range = {node:range()}
      local indentation = string.rep(" ", range[2])
      
      -- "Do formatting but for now just print"
      local formatted = vim.treesitter.get_node_text(node, bufnr)
      make_call_to_chatgpt(formatted)
    end
  end
end

vim.api.nvim_create_user_command("ChatGPTMagic", function()
  format_dat_function(vim.api.nvim_get_current_buf())
end, {})
return M
