local http        = require("socket.http")
local JSON        = require("JSON")
local inspect     = require("inspect")
local ltn12       = require("ltn12")

-- First connect to the incubator's own Wi-Fi to perform unit tests (ssid : incubator | passwd : 12345678)
local apiendpoint = "http://192.168.16.10/"



it("get space station location", function()
	local body, code, _, status, _ = http.request("http://api.open-notify.org/iss-now.json")
	print(code, status, body)
	local lua_value = JSON:decode(body) -- decode example
	print(lua_value.message)
	assert.are_equal(lua_value.message, "success")
	print("\n\n\n[+] La peticíon GET de la estacíon espacial fué exitosa.\n\n\n")
end)


it("get config", function()
	local body, code, _, _ = http.request(apiendpoint .. "config")
	assert.are_equal(code, 200)
	print("[+] La peticíon GET de la configuracion fué exitosa.\n\n\n")
	local body_table = JSON:decode(body)
	assert.are_equal(type(body_table.max_temperature) == "number", true)
	assert.are_equal(type(body_table.min_temperature) == "number", true)
	local pretty_json = JSON:encode_pretty(body_table)
	inspect(print("\n\n\nbody de la peticion GET: \n\n\n" .. pretty_json .. "\n\n\n"))
end)


it("get actual temperature and humidity", function()
	print("[+] La peticíon GET de la temperatura y humedad actual fué exitosa.")
	local body, code, _, _, _ = http.request(apiendpoint .. "temperatureactual")
	local decode_body = JSON:decode(body)
	local pretty_json = JSON:encode_pretty(decode_body)
	inspect(print("\n\n\nbody de la peticion GET: \n\n\n" .. pretty_json .. "\n\n\n"))
	assert.are_equal(code, 200)
	local body_table = JSON:decode(body)

	assert.are_equal(tonumber(body_table.a_temperature) > -40, true)
	assert.are_equal(tonumber(body_table.a_temperature) < 100, true)
	assert.are_equal(tonumber(body_table.a_humidity) > 0, true)
	assert.are_equal(tonumber(body_table.a_humidity) < 100, true)
end)

function timer_for_wifi(segundos)
	print("[!] Esperando el escaneo de redes: ")
	os.execute("sleep " .. segundos)
	local body_table = JSON:decode(body)
	local pretty_json = JSON:encode_pretty(body_table)
	inspect(print("\n\n\n Redes disponibles: \n\n\n" .. pretty_json .. "\n\n\n"))
end

it("Obtener redes disponibles", function()
	local body, code, headers, status, message = http.request(apiendpoint .. "wifi")
	inspect(print("\nBody de la peticion GET: \n " .. body))
	assert.are_equal(code, 200)
	timer_for_wifi(5)

	print("[+] La peticíon GET de las redes disponibles fué exitosa.\n\n")
end)



it("POST peticion", function()
	local post_data = '{"rotation_time":3600000,"min_temperature":40,"max_temperature":50}'

	local _, code, _, _ = http.request {
		url = apiendpoint .. "config",
		method = 'POST',
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = #post_data
		},
		source = ltn12.source.string(post_data)

	}
	inspect(print("\n\n\n peticion POST exítosa: \n\n\n"))
	assert.are_equal(code, 200)
end)


it("POST validacion", function()
	local body, code, _, _ = http.request(apiendpoint .. "config")
	print("[+] Verificando que el archivo config.json cambió.\n\n\n")
	local body_table = JSON:decode(body)
	local pretty_json = JSON:encode_pretty(body_table)
	inspect(print("\n\n\n Nuevo archivo de configuracion: \n\n\n" .. pretty_json .. "\n\n\n"))
	assert.are_equal(code, 200)
end)




it("Segunda peticíon POST", function()
	local post_data = '{"rotation_time":3600000,"min_temperature":30,"max_temperature":40}'

	local _, code, _, _ = http.request {
		url = apiendpoint .. "config",
		method = 'POST',
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = #post_data
		},
		source = ltn12.source.string(post_data)

	}
	inspect(print("\n\n\n peticion POST exítosa: \n\n\n"))
	assert.are_equal(code, 200)
end)

it("Validar los cambios", function()
	local body, code, _, _ = http.request(apiendpoint .. "config")
	print("[+] Verificando que el archivo config.json cambió por segunda vez.\n\n\n")
	local body_table = JSON:decode(body)
	local pretty_json = JSON:encode_pretty(body_table)
	inspect(print("\n\n\n Nuevo archivo de configuracion: \n\n\n" .. pretty_json .. "\n\n\n"))

	assert.are_equal(code, 200)
end)
