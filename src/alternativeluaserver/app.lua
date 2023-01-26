local lapis = require("lapis")
local app = lapis.Application()
local json_params = require("lapis.application").
json_params

file = io.open("datos.txt", "a")


app:match("/", function(self)
  print (ngx.req.get_body_data())
  file:write(ngx.req.get_body_data() or "sin datos",";",os.date("%c"), "\n")
  return "OK"
end)

return app
