local restapi = {
	incubator = nil,
	configurator = require("configurator")
}


-------------------------------------
-- ! @function change config   modify the current config.json file
--
-- !	@param req  		      		server request
-------------------------------------
function restapi.change_config_file(req) 
	local new_config_table = configurator:update_config_from_request(req)
	local is_load_data_success = configurator:load_objects_data(new_config_table)

	if is_load_data_success then
		return { status = "400", type = "application/json", body = is_load_data_success }
	else
		local is_file_encoded = configurator:encode_config_file(new_config_table)
		
		if not is_file_encoded  then
			return { status = "400", type = "application/json", body = is_file_encoded }
		else	
		return is_file_encoded
	end
end
end

-------------------------------------
-- ! @function config_get   get the current config.json parameters
-------------------------------------

function restapi.config_get()
	local config_table = configurator:read_config_file()
	body_json = configurator:get_config(config_table)
	if body_json then
		return { status = "200 OK", type = "application/json", body = body_json }
	else
		return { status = "400", type = "application/json", body = "Error config_table not found" }
	end
end

-------------------------------------
-- ! @function actual_ht   get the current humidity and temperature
--
-- !	@param a_temperature get the current temperature
-- !	@param a_humidity		 get the current humidity
-- !	@param a_pressure		 get the current pressure

-------------------------------------
function restapi.actual_ht(a_temperature, a_humidity, a_pressure)
	a_temperature, a_humidity, a_pressure = restapi.incubator.get_values()

	local body_data = {
		a_temperature = string.format("%.2f", a_temperature),
		a_humidity = string.format("%.2f", a_humidity),
		a_pressure = string.format("%.2f", a_pressure)
	}

	local body_json = sjson.encode(body_data)
	return { status = "200 OK", type = "application/json", body = body_json }
end

function restapi.init_module(incubator_object)
	-- * start local server
	restapi.incubator = incubator_object
	print("starting server .. fyi maxtemp " .. restapi.incubator.max_temp)
	httpd.start({
		webroot = "web",
		auto_index = httpd.INDEX_ALL
	})

	local function config_get_handler(req)
		local headers = {
			['Access-Control-Allow-Origin'] = '*',
			['Access-Control-Allow-Methods'] = 'GET, POST'
		}

		local config_response = restapi.config_get()
		config_response.headers = headers

		return config_response
	end
	-- * dynamic routes to serve
	httpd.dynamic(httpd.GET, "/config", config_get_handler)
	httpd.dynamic(httpd.POST, "/config", restapi.change_config_file)
	httpd.dynamic(httpd.GET, "/actual", restapi.actual_ht)
end

return restapi
