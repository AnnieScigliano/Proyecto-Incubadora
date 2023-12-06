local http        = require("socket.http")
local JSON        = require("JSON")
local inspect     = require("inspect")
local ltn12       = require("ltn12")

-- First connect to the incubator's own Wi-Fi to perform unit tests (ssid : incubator | passwd : 12345678) default url: "http://192.168.16.10/"
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
	local body, code, headers, status, message = http.request(apiendpoint .. "actual")
	inspect(print("\nBody de la peticion GET: \n " .. body))
	assert.are_equal(code, 200)
	print("[+] La peticíon GET de la temperatura y humedad actual fué exitosa.\n\n")
end)

-- busted --exclude-tags="wifi" ./test_rest_api.lua
--Esto agrega el tag wifi para excluir la ejecución hasta que este el método listo.
describe("Obtener redes disponibles #wifi", function()
  
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

local function get_and_assert_200(atribute)
    local body, code, headers, status = http.request(apiendpoint .. atribute)
    print(code, status, body, headers, atribute)
    assert.are_equal(code, 200)
    return body
end

local function post_and_assert_201(atribute, value)
	body, code, headers, status = http.request {
			url = apiendpoint .. atribute,
			headers = {
					["content-Type"] = 'application/json',
					["Accept"] = 'application/json',
					["content-length"] = tostring(#value)
			},
			method = "POST",
			source = ltn12.source.string(value)
	}
	assert.are_equal(201, code)
	return body
end

local function post_and_assert_400(atribute, value)
	-- In that case, if a body is provided as a string, the function will
	-- perform a POST method in the url. 
	body, code, headers, status = http.request { 
			url = apiendpoint .. atribute,
			headers = {
					["content-Type"] = 'application/json',
					["Accept"] = 'application/json',
					["content-length"] = tostring(#value)
			},
			method = "POST",
			source = ltn12.source.string(value)
	}
	assert.are_equal(400, code)
assert.are_equal(body.message,"Error: It cannot be nil or equal to the existing value.") 
	return body
end

local function assert_defconfig()
	local body = get_and_assert_200("config")
	local default_config = JSON:decode(body)
	assert.are_equal(default_config.max_temperature, 40)
	assert.are_equal(default_config.min_temperature, 30)
	assert.are_equal(default_config.rotation_time, 3600000)
	return default_config
end

it("set configuration ok", function()
	-- obtener la configuracion por defecto
	local default_config = assert_defconfig()
	-- cambiar la configuracion a la configuracion nueva 3500000/40/50
	local config_40_50 = '{"rotation_time":3500000,"min_temperature":40,"max_temperature":50}'
	post_and_assert_201("config", config_40_50)
	local new_config = get_and_assert_200("config")
	assert.are_equal(new_config.max_temperature, 50)
	assert.are_equal(new_config.min_temperature, 40)
	assert.are_equal(new_config.rotation_time, 3500000)
	-- volver a poner la configuracion por defecto
	post_and_assert_201("config", default_config)
	assert_defconfig()
end)


describe("config fail shal not passssss", function()
	it("set max saller than min fail", function()
			-- obtener la configuracion por defecto
			default_config = assert_defconfig()
			-- cambiar la configuracion a la configuracion nueva 3500000/40/50
			local config_50_40 = '{"rotation_time":3500000,"min_temperature":50,"max_temperature":40}'
			post_and_assert_400("config", config_50_40)
	default_config = assert_defconfig()

	
end)
it("set set rotation time to small", function()

	default_config = assert_defconfig()
	local config_1_40_50 = '{"rotation_time":1,"min_temperature":40,"max_temperature":50}'
			post_and_assert_400("config", config_1_40_50)
	default_config = assert_defconfig()

end)
it("set negative temps", function()

	default_config = assert_defconfig()
	local config_m10_50 = '{"rotation_time":3500000,"min_temperature":-10,"max_temperature":50}'
			post_and_assert_400("config", config_m10_50)
	default_config = assert_defconfig()
	local config_10_m10 = '{"rotation_time":3500000,"min_temperature":10,"max_temperature":-10}'
			post_and_assert_400("config", config_10_m10)
	default_config = assert_defconfig()
	local config_10_m10 = '{"rotation_time":-3540000,"min_temperature":10,"max_temperature":-10}'
			post_and_assert_400("config", config_10_m10)
	default_config = assert_defconfig()

end)
it("put some small noise in the parameters", function()

	default_config = assert_defconfig()
	local config_lalala_50 = '{"rotation_time":3500000,"min_temperature":lalala,"max_temperature":50}'
			post_and_assert_400("config", config_lalala_50)
	default_config = assert_defconfig()
	local config_lalala_50 = '{"rotation_time":lalal,"min_temperature":40,"max_temperature":50}'
			post_and_assert_400("config", config_lalala_50)
	default_config = assert_defconfig()
	local config_lalala_50 = '{"rotation_time":3500000,"min_temperature":20,"max_temperature":lala}'
			post_and_assert_400("config", config_lalala_50)
	default_config = assert_defconfig()

end)
it("just brek the hole json", function()

	default_config = assert_defconfig()
	local garbage = 'hola'
			post_and_assert_400("config", garbage)
	default_config = assert_defconfig()

end)
end)

-- agregar una prueba con un json que le falte un elemento
-- agregar una prueba con un pedazo de json ... ver que no rompa el json ...