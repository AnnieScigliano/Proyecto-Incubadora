test = {
	http                 = require("socket.http"),
	JSON                 = require("JSON"),
	inspect              = require("inspect"),
	ltn12                = require("ltn12"),
	http_request_methods = {},
	config               = {}
}

configs_to_test_numbers = {
	config_50_40 =
	'{"max_temperature":40,"min_temperature":50,"rotation_duration":36000,"rotation_period":5000,"ssid": "incubator","passwd":"12345678"}',
	config_40_50 =
	'{"max_temperature":50,"min_temperature":40,"rotation_duration":36000,"rotation_period":5000, "ssid": "incubator", "passwd":"12345678"}',
	config_1_40_50 =
	'{"max_temperature":50,"min_temperature":40,"rotation_duration":1,"rotation_period": 5000,"ssid": "incubator", "passwd":"12345678"}',
	config_m10_50 =
	'{"max_temperature":50,"min_temperature":-10, "rotation_duration":36000,"rotation_period": 5000,"ssid": "incubator", "passwd":"12345678"}',
	config_10_m10 =
	'{"max_temperature":-10,"min_temperature":10, "rotation_duration":36000,"rotation_period": 5000,"ssid": "incubator", "passwd":"12345678"}',

}

config_to_test_str = {
	noise_in_min_temp =
	'{"max_temperature":50,"min_temperature":"lalala","rotation_duration":36000,"rotation_period": 5000,"ssid": "incubator", "passwd":"12345678"}',
	noise_in_rotation_duration =
	'{"max_temperature":50,"min_temperature":40,"rotation_duration":"lalala","rotation_period": 5000,"ssid": "incubator", "passwd":"12345678"}',
	noise_in_max_temperature =
	'{"max_temperature":"lala","min_temperature":20,"rotation_duration":36000,"rotation_period": 5000,"ssid": "incubator", "passwd":"12345678"}'
}



-- to exclude wifi
-- busted --exclude-tags="wifi" ./test_rest_api.lua
-- First connect to the incubator's own Wi-Fi to perform unit tests (ssid : incubator | passwd : 12345678) default url: "http://192.168.16.10/"
local apiendpoint = "http://192.168.16.10/"

function test:get_space_location()
	local body, code, _, status, _ = test.http.request("http://api.open-notify.org/iss-now.json")
	print(code, status, body)
	local lua_value = test.JSON:decode(body) -- decode example
	print(lua_value.message)
	assert.are.equal(lua_value.message, "success")
	print("\n\n\n[+] La peticíon GET de la estacíon espacial fué exitosa.\n\n\n")
	return code
end

function test.config:get_config()
	local body, code, _, _ = test.http.request(apiendpoint .. "config")
	print("[+] La peticíon GET de la configuracion fué exitosa.\n\n\n")
	local body_table = test.JSON:decode(body)
	local pretty_json = test.JSON:encode_pretty(body_table)
	test.inspect(print("\n\n\nbody de la peticion GET: \n\n\n" .. pretty_json .. "\n\n\n"))

	return code
end

-- {"max_temperature":40,"min_temperature":30,"rotation_duration":36000,"rotation_period":5000 ,"ssid":"iPhone de Jere","passwd":"12345678"}

function test.config:get_actual()
	local body, code, _, _, _ = test.http.request(apiendpoint .. "actual")
	test.inspect(print("\nBody de la peticion GET: \n " .. body))
	assert.are.equal(code, 200)
	print("[+] La peticíon GET de la temperatura y humedad actual fué exitosa.\n\n")

	return code
end

function test.config:get_wifi_with_error()
	local body, code, _, _, message = test.http.request(apiendpoint .. "wifi")
	test.inspect(print("\nBody de la petición GET: \n " .. body))
	assert.are.equal(code, 200, "La primera petición debería devolver un error")
end

function test.config:get_wifi()
	local body, code, _, status, _ = test.http.request("http://api.open-notify.org/iss-now.json")
	print(code, status, body)
	local lua_value = JSON:decode(body) -- decode example
	print(lua_value.message)
	assert.are.equal(lua_value.message, "success")
	print("\n\n\n[+] La peticíon GET de la estacíon espacial fué exitosa.\n\n\n")
end

function test.config:get_wifi_with_5s()
	os.execute("sleep 5")
	local body, code, _, _, message = test.http.request(apiendpoint .. "wifi")
	assert.are.equal(code, 200, "Error en la tercera petición GET")
	test.inspect(print("\nBody de la tercera petición GET : \n " .. body))
end

function test.config:get_wifi_without_tmr()
	local body, code, _, _, message = test.http.request(apiendpoint .. "wifi")
	assert.are.equal(code, 200, "Error en la cuarta petición GET")
	test.inspect(print("\nBody de la cuarta petición GET: \n " .. body))
end

function test.http_request_methods:get_and_assert_200(atribute)
	local body, code, headers, status = test.http.request(apiendpoint .. atribute)
	test.inspect(print(code, status, body, headers, atribute))
	assert.are.equal(code, 200)
	return body
end

function test.http_request_methods:post_and_assert_201(atribute, value)
	local body, code, headers, status = test.http.request {
		url = apiendpoint .. atribute,
		headers = {
			["content-Type"] = 'application/json',
			["Accept"] = 'application/json',
			["content-length"] = tostring(#value)
		},
		method = "POST",
		source = test.ltn12.source.string(value)
	}

	assert.are.equal(201, code)
	return body
end

function test.http_request_methods:post_and_assert_400(atribute, value)
	-- In that case, if a body is provided as a string, the function will
	-- perform a POST method in the url.
	local body, code, headers, status = test.http.request {
		url = apiendpoint .. atribute,
		headers = {
			["content-Type"] = 'application/json',
			["Accept"] = 'application/json',
			["content-length"] = tostring(#value)
		},
		method = "POST",
		source = test.ltn12.source.string(value)
	}
	assert.are.equal(400, code)

	return body
end

function test.config:assert_defconfig()
	local body = test.http_request_methods:get_and_assert_200("config")
	local default_config = test.JSON:decode(body)
	test.inspect(print(body))
	assert.are.equal(default_config.min_temperature, 30)
	assert.are.equal(default_config.max_temperature, 40)
	assert.are.equal(default_config.rotation_duration, 36000)
	assert.are.equal(default_config.rotation_period, 5000)
	assert.are.equal(default_config.ssid, "incubator")
	assert.are.equal(default_config.passwd, "12345678")


	return default_config
end

function test.config:set_config_ok()
	-- default config
	local default_config = test.config:assert_defconfig()

	-- save before change config
	local previous_config = test.http_request_methods:get_and_assert_200("config")

	local success, _ = pcall(function()
		test.http_request_methods:post_and_assert_201("config", configs_to_test_numbers.config_40_50)

		-- waiting for the apply
		os.execute("sleep 1")

		-- get before change confing
		local new_config = test.http_request_methods:get_and_assert_200("config")

		-- check the changes
		assert.are.equal(new_config.max_temperature, 50, "Error: max_temperature no es igual a 30")
		assert.are.equal(new_config.min_temperature, 40, "Error: min_temperature no es igual a 40")
		assert.are.equal(new_config.rotation_duration, 36000, "Error: rotation_duration no es igual a 3500000")
		assert.are.equal(new_config.rotation_period, 5000, "Error: rotation_period no es igual a 5000")
		assert.are.equal(new_config.ssid, "incubator", "Error: ssid no coincide")
		assert.are.equal(new_config.passwd, "12345678", "Error: passwd no coincide")
	end)

	-- restore the config
	test.http_request_methods:post_and_assert_201("config", previous_config)

	if success then
		inspect(print("No hubo errores en el cambio"))
	end

	-- restore default configg
	test.http_request_methods:post_and_assert_201("config", test.JSON:encode(default_config))
	test.config:assert_defconfig()
end

function test.config:set_max_fail()
	default_config = test.config:assert_defconfig()
	local body = test.http_request_methods:post_and_assert_400("config", configs_to_test_numbers.config_50_40)
	default_config = test.config:assert_defconfig()

	return body
end

function test.config:set_min_rotation_time_fail()
	default_config = test.config:assert_defconfig()

	local body = test.http_request_methods:post_and_assert_400("config", configs_to_test_numbers.config_1_40_50)
	default_config = test.config:assert_defconfig()

	return body
end

function test.config:set_negative_temps_value_fails()
	default_config = test.config:assert_defconfig()
	local body_negative_1 = test.http_request_methods:post_and_assert_400("config", configs_to_test_numbers.config_m10_50)
	default_config = test.config:assert_defconfig()
	local body_negative_2 = test.http_request_methods:post_and_assert_400("config", configs_to_test_numbers.config_10_m10)
	default_config = test.config:assert_defconfig()

	return body_negative_1, body_negative_2
end

function test.config:set_noise_in_parameters()
	default_config = test.config:assert_defconfig()
	body_noise_1 = test.http_request_methods:post_and_assert_400("config", config_to_test_str.noise_in_min_temp)
	default_config = test.config:assert_defconfig()
	body_noise_2 = test.http_request_methods:post_and_assert_400("config", config_to_test_str.noise_in_rotation_duration)
	default_config = test.config:assert_defconfig()
	body_noise_3 = test.http_request_methods:post_and_assert_400("config", config_to_test_str.noise_in_max_temperature)
	default_config = test.config:assert_defconfig()
	return body_noise_1,body_noise_2, body_noise_3
end

------------------------------------------------------------------------------------
-- TESTS
------------------------------------------------------------------------------------


describe("space station location", function()
	code_req_space_station = test:get_space_location()
	it("get space station location", function()
		assert.are.equal(code_req_space_station, 200)
	end)
end)

describe("get actual config", function()
	local code_req_actual_config = test.config:get_config()
	it("getting config", function()
		assert.are_equal(code_req_actual_config, 200)
	end)
end)

describe("get actual temperature and humidity", function()
	code_req_actual_temp_hum = test.config:get_actual()
	it("getting actual temperature and humidity", function()
		assert.are.equal(code_req_actual_temp_hum, 200)
	end)
end)

describe("Obtener redes disponibles #wifi", function()
	it("Primera petición debería devolver error", test:get_wifi_with_error())
	it("Segunda petición después de escaneo", test:get_wifi())
	it("Tercera petición esperando 5 segundos", test:get_wifi_with_5s())
	it("Cuarta petición sin espera", test:get_wifi_without_tmr())
end)

describe("set config ok", function()
	test.config:set_config_ok()
	it("set configuration ok", function()
	end)
end)

describe("induced fail", function()
	--	set minimum temperature higher than maximum temperature
	local body_req_max_fail = test.config:set_max_fail()
	if body_req_max_fail == 1 then
		body_req_max_fail = "Error in setting min_temp"
	end
	it("set max shaller than min fail", function()
		assert.are.equal(body_req_max_fail, tostring("Error in setting min_temp"))
	end)
	--	set rotation time higher lower
	local body_req_rotation_time = test.config:set_min_rotation_time_fail()
	if body_req_rotation_time == 1 then
		body_req_rotation_time = "Error in setting rotation_duration"
	end
	it("set set rotation time to small", function()
		assert.are.equal(body_req_rotation_time, "Error in setting rotation_duration")
	end)
	--	set negative temps
	local body_req_min_temp_negative, body_req_max_temp_negative = test.config:set_negative_temps_value_fails()
	if body_req_min_temp_negative == 1 then
		body_req_min_temp_negative = "Error in setting min_temp"
	end
	if body_req_max_temp_negative == 1 then
		body_req_max_temp_negative = "Error in setting max_temp"
	end
	it("set negative temps", function()
		assert.are.equal(body_req_min_temp_negative, "Error in setting min_temp")
		assert.are.equal(body_req_max_temp_negative, "Error in setting max_temp")
	end)
	
	local body_req_noise_min_temp,
	body_req_noise_rotation_duration,
	body_req_noise_max_temp = test.config:set_noise_in_parameters()
	
	if body_req_noise_min_temp == 1 then
		body_req_noise_max_temp = "Error in setting max_temp"
	end
	if body_req_noise_rotation_duration == 1 then
		body_req_noise_rotation_duration = "Error in setting rotation_duration"
	end
	if body_req_noise_min_temp == 1 then
		body_req_noise_min_temp = "Error in setting min_temp"
	end

	-- --	set some noise in the parameters
	it("put some small noise in the parameters", function ()
		assert.are.equal(body_req_noise_max_temp, "Error in setting max_temp")
		assert.are.equal(body_req_noise_rotation_duration, "Error in setting rotation_duration")
		assert.are.equal(body_req_noise_min_temp, "Error in setting min_temp")		
	end)
end)
