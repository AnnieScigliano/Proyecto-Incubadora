package="JSON4Lua"
version="0.9.53-2"
source = {
  url = "git://github.com/amrhassan/json4lua.git",
  tag = "0.9.53"
}
description = {
   summary = "JSON4Lua and JSONRPC4Lua implement JSON (JavaScript Object Notation) encoding and decoding and a JSON-RPC-over-http client for Lua.",
   detailed = [[
      JSON4Lua and JSONRPC4Lua implement JSON (JavaScript Object Notation)
      encoding and decoding and a JSON-RPC-over-http client for Lua.
      JSON is JavaScript Object Notation, a simple encoding of
      Javascript-like objects that is ideal for lightweight transmission
      of relatively weakly-typed data. A sub-package of JSON4Lua is
      JSONRPC4Lua, which provides a simple JSON-RPC-over-http client and server
      (in a CGILua environment) for Lua.
   ]],
   homepage = "http://json.luaforge.net/",
   license = "GPL"
}
dependencies = {
   "luasocket",
}

build = {
   type = "builtin",
   modules = {
     ["json"] = "json/json.lua",
     ["json.rpc"] = "json/rpc.lua"
   }
}
