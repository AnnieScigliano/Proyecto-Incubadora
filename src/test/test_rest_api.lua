--package.path = package.path .. ';../?.lua'
--require("app.SendToGrafana")
local http        = require("socket.http")
local apiendpoint = "http://10.5.3.94/"
local JSON        = require("JSON")
local inspect     = require("inspect")
local ltn12       = require("ltn12")

-- it("json playground", function()
-- 	local raw_json_text    = "[1,2,[3,4]]"

-- 	local lua_value        = JSON:decode(raw_json_text) -- decode example
-- 	local raw_json_text    = JSON:encode(lua_value)  -- encode example
-- 	local pretty_json_text = JSON:encode_pretty(lua_value) -- "pretty printed" version

-- 	print(inspect(lua_value))
-- 	print(inspect(raw_json_text))
-- 	print(inspect(pretty_json_text))
-- 	print("it 1 .........")
-- 	-- obj2 is reset thanks to the before_each
-- 	r, c = http.request {
-- 		url = "http://www.google.com",
-- 		headers = {  ["content-Type"] = 'application/json' },
-- 		body = 87
-- 	}
-- 	print("it 2 .........")

-- 	print(r,c)
-- 	print("it 3 .........")

-- end)


it("get space station location", function()
	local body, code, headers, status, message = http.request("http://api.open-notify.org/iss-now.json")
	print(code, status, body)
	local lua_value = JSON:decode(body) -- decode example
	print(lua_value.message)
	assert.are_equal(lua_value.message, "success")
end)

it("get config", function()
	local body, code, headers, status = http.request(apiendpoint .. "config")
	inspect(print("\nBody de la peticion GET: \n " .. body))
	assert.are_equal(code, 200)
	print("[+] La peticíon GET de la configuracion fué exitosa.\n\n")
end)

it("get actual temperature and humidity", function()
	local body, code, headers, status, message = http.request(apiendpoint .. "temperatureactual")
	inspect(print("\nBody de la peticion GET: \n " .. body))
	assert.are_equal(code, 200)
	print("[+] La peticíon GET de la temperatura y humedad actual fué exitosa.\n\n")
end)

it("get actual wifi's", function()
	local body, code, headers, status, message = http.request(apiendpoint .. "wifi")
	inspect(print("\nBody de la peticion GET: \n " .. body))
	assert.are_equal(code, 200)
	print("[+] La peticíon GET de las redes disponibles fué exitosa.\n\n")
end)


local function get_and_assert_200(atribute)
	local body, code, headers, status = http.request(apiendpoint .. atribute)
	print(code, status, body, headers, atribute)
	assert.are_equal(code, 200)
	return body
end

-- local http = require("socket.http")

-- -- URL de destino
-- local url = "http://ejemplo.com/api/endpoint"

-- -- Datos en formato JSON
-- local postData = '{"parametro1":"valor1","parametro2":"valor2"}'

-- -- Variables para almacenar los valores de retorno
-- local response, statusCode, headers, statusLine = http.request{
-- 		url = url,
-- 		method = "POST",
-- 		headers = {
-- 				["Content-Type"] = "application/json",
-- 				["Content-Length"] = #postData
-- 		},
-- 		source = ltn12.source.string(postData)
-- }

-- -- Imprimir el código de estado y la respuesta del servidor
-- print("Código de Estado:", statusCode)
-- print("Cuerpo de la Respuesta:", response)

function config_post()
	print("[+] La peticíon POST fué exitosa.\n\n")
	local post_data = '{"rotation_time":3600000,"min_temperature":40,"max_temperature":50}'

	local response, code, headers, status = http.request {
		url = apiendpoint .. "config",
		method = 'POST',
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = #post_data
		},
		source = ltn12.source.string(post_data)
	}
	assert.are_equal(code, 200)
	assert.are_equal(message, "Json updated successfully")
	
end
