local restapi = { incubator = nil }

-------------------------------------
-- ! @function change config   modify the current config.json file
--
-- !	@param req  		      		server request
-------------------------------------

function restapi.read_config_file()
	-- open file with read permission
	local file = io.open("config.json", "r")

	if file ~= nil then
		-- "*a" read all the file
		local config_json = file:read("*a")
		-- then close the file
		file:close()

		local config_data = sjson.decode(config_json)
		return config_data
	else
		print("[!] Failed to read JSON file, creating a new one")
		new_file = io.open("config.json", "w")
		new_file:write('"rotation_duration":3600000,"min_temperature":37.3,"max_temperature":37.8')
		new_file:close()
		print("[+] the file was created successfully")
	end -- if end
end  -- function end

-------------------------------------
-- ! @function change config   modify the current config.json file
--
-- !	@param req  		      		server request
-------------------------------------
function restapi.change_config(req)
	-- RESPONSES
	local error_changing_config =
	{
		status = "400 Bad Request",
		type = "application/json",
		body = sjson.encode({
			message =
			"Error: It cannot be nil or equal to the existing value."
		})
	}

	local success_response =
	{
		status = "201 Created",
		type = "application/json",
		body = sjson.encode({ message = "JSON updated successfully" })
	}

	local error_response =
	{
		status = "500 Internal Server Error",
		type = "application/json",
		body = sjson.encode({ message = "Failed to update JSON file" })
	}

	-- JSON example: {"rotation_duration":3500000,"rotation_period":5000,"min_temperature":37.3,"max_temperature":37.8}

	-- Local Variables
	local request_body_json = req.getbody()
	local body_table = sjson.decode(request_body_json)

	-- Update the configuration values from the request body
	if body_table.max_temperature then
		body_table.max_temperature = tonumber(body_table.max_temperature)

		local req_change_max_temp =
				restapi.incubator.set_max_temp(body_table.max_temperature)

		if req_change_max_temp == true then
			return success_response
		else
			return --error_changing_config
			{ status = "400", type = "application/json", body = "Error en max_temp" }
		end
	end

	if body_table.min_temperature then
		body_table.min_temperature = tonumber(body_table.min_temperature)

		local req_change_min_temp =
				restapi.incubator.set_min_temp(body_table.min_temperature)

		if req_change_min_temp == true then
			return success_response
		else
			return --error_changing_config
			{ status = "400", type = "application/json", body = "Error en min_temp" }
		end
	end

	if body_table.rotation_period then
		body_table.rotation_period = tonumber(body_table.rotation_period)

		local req_change_rotation_period =
				restapi.incubator.set_rotation_period(body_table.rotation_period)

		if req_change_rotation_period == true then
			return success_response
		else
			return -- error_changing_config
			{ status = "400", type = "application/json", body = "Error en rotation_period" }
		end
	end

	if body_table.rotation_duration then
		body_table.rotation_duration = tonumber(body_table.rotation_duration)

		local req_change_rotation_duration =
				restapi.incubator.set_rotation_time(body_table.rotation_duration)

		if req_change_rotation_duration == true then
			return success_response
		else
			return -- error_changing_config
			{ status = "400", type = "application/json", body = "Error en rotation_duration" }
		end
	end

	local json_config_file = sjson.encode(body_table)

	local config_file, err = io.open("config.json", "w")
	if config_file then
		config_file:write(json_config_file)
		config_file:close()
		return success_response
	else
		return { status = "400", type = "application/json", body = sjson:encode(err) }
	end
end

-------------------------------------
-- ! @function change_file   get the current config.json parameters
--
-- !	@param req  		      		server request
-------------------------------------

function restapi.config_get()
	local body_data = restapi.read_config_file()
	local body_json = sjson.encode(body_data)
	if body_data == nil then
		return error_bad_request
	end
	return { status = "200 OK", type = "application/json", body = body_json }
end

-------------------------------------
-- ! @function wifi_scan_get   get the current humidity and temperature
--
-- !	@param req  		      		server request
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

	-- * dynamic routes to serve
	httpd.dynamic(httpd.GET, "/config", restapi.config_get)
	httpd.dynamic(httpd.POST, "/config", restapi.change_config)
	httpd.dynamic(httpd.GET, "/actual", restapi.actual_ht)
end

return restapi
