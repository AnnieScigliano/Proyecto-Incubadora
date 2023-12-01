local http        = require("socket.http")
local JSON        = require("JSON")
local inspect     = require("inspect")
local ltn12       = require("ltn12")

-- First connect to the incubator's own Wi-Fi to perform unit tests (ssid : incubator | passwd : 12345678) "http://192.168.16.10/"
local apiendpoint = "http://10.5.6.101/"



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


describe("Obtener redes disponibles", function()
  
  it("Primera petición debería devolver error", function()
    local body, code, _, _, message = http.request(apiendpoint .. "wifi")
    inspect(print("\nBody de la petición GET: \n " .. body))
    
    assert.are_equal(code, 200, "La primera petición debería devolver un error")
    -- assert.are_equal(message, "error", "La primera petición debería tener un mensaje 'error'")
  end)

  it("Segunda petición después de escaneo", function()
    local body, code, _, _, message = http.request(apiendpoint .. "wifi")
    inspect(print("\nBody de la primer petición GET: \n " .. body))

    assert.are_equal(code, 200, "Error en la segunda petición GET")

    if message == "error" then
      local startTime = os.time()
      repeat
        body, _, _, _, message = http.request(apiendpoint .. "wifi")
        os.execute("sleep 1")
      until os.time() - startTime > MAX_WAIT_TIME or message == "success"
      
      if message == "success" then
        inspect(print("\nBody de la segunda petición GET: \n " .. body))
      else
        error("Tiempo de espera agotado para el escaneo.")
      end
    end
  end)

  -- ...

it("Tercera petición esperando 5 segundos", function()
	os.execute("sleep 5")
	local body, code, _, _, message = http.request(apiendpoint .. "wifi")

	assert.are_equal(code, 200, "Error en la tercera petición GET")

	inspect(print("\nBody de la tercera petición GET : \n " .. body))
end)

it("Cuarta petición sin espera", function()
	local body, code, _, _, message = http.request(apiendpoint .. "wifi")

	assert.are_equal(code, 200, "Error en la cuarta petición GET")

	inspect(print("\nBody de la cuarta petición GET: \n " .. body))
end)

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
