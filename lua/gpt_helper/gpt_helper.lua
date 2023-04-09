local M = {}
local curl = require("plenary.curl")
function M.setup()

end

function M.sayHelloWorld()
  print("Hello world")
end
function curl_callback(response, cb)
  print(response)
end
local make_call_to_chatgpt = function(prompt) 
  local messages = {}
  table.insert(messages, { role = "system", content = "Please write documentation for this code: " .. prompt })
  local request_data = {
   model = "gpt-3.5-turbo",
   temperature = 0.7,
   messages = messages,
  }
  local payload_str = vim.fn.json_encode(request_data)
  local handle = io.popen("tail -c 53 .env")
  local result = handle:read("*a")
  handle:close()
  local url = "https://api.openai.com/v1/chat/completions"
  local secret_key = result
  local headers = { Content_Type = "application/json", Authorization = "Bearer " .. secret_key }
  local response = curl.post(url, {
        body = payload_str,
        headers = headers,
    })
  print(response)
  print(vim.inspect(response))
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
