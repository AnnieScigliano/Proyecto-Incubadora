local restapi = { incubator = nil }

-------------------------------------
-- ! @function read config   read the current config.json file
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
		new_file:write('"rotation_duration":360000,"min_temperature":37.3,"max_temperature":37.8')
		new_file:close()
		print("[+] the file was created successfully")
	end -- if end
end  -- function end

-------------------------------------
-- ! @function change config   modify the current config.json file
--
-- !	@param req  		      		server request
-------------------------------------
function restapi.change_config_file(req)
	-- RESPONSES

	local success_response =
	{
		status = "201 Created",
		type = "application/json",
		body = sjson.encode({ message = "JSON updated successfully" })
	}

	-- JSON example: {"rotation_duration":3500000,"rotation_period":5000,"min_temperature":37.3,"max_temperature":37.8}

	-- Local Variables
	local request_body_json = req.getbody()
	local body_table = sjson.decode(request_body_json)

	success, body_table = pcall(sjson.decode, request_body_json)

	if not success or type(body_table) ~= "table" then
		return {
			status = "400 Bad Request",
			type = "application/json",
			body = sjson.encode({
				message = "Error: The request body is not a valid JSON."
			})
		}
	end

	-- Update the configuration values from the request body
	if body_table.max_temperature then
		body_table.max_temperature = tonumber(body_table.max_temperature)

		local req_change_max_temp =
				restapi.incubator.set_max_temp(body_table.max_temperature)

		if req_change_max_temp == true then
		else
			return { status = "400", type = "application/json", body = "Error in max_temp" }
		end
	end

	if body_table.min_temperature then
		body_table.min_temperature = tonumber(body_table.min_temperature)

		local req_change_min_temp =
				restapi.incubator.set_min_temp(body_table.min_temperature)

		if req_change_min_temp == true then

		else
			return { status = "400", type = "application/json", body = "Error in min_temp" }
		end
	end

	if body_table.rotation_period then
		body_table.rotation_period = tonumber(body_table.rotation_period)

		local req_change_rotation_period =
			restapi.incubator.set_rotation_period(body_table.rotation_period)

		if req_change_rotation_period == true then

		else
			return { status = "400", type = "application/json", body = "Error in rotation_period" }
		end
	end

	if body_table.rotation_duration then
		body_table.rotation_duration = tonumber(body_table.rotation_duration)

		local req_change_rotation_duration =
				restapi.incubator.set_rotation_duration(body_table.rotation_duration)

		if req_change_rotation_duration == true then

		else
			return { status = "400", type = "application/json", body = "Error in rotation_duration" }
		end
	end

	-- if body_table.ssid then
	-- 	body_table.ssid = tostring(body_table.ssid)

	-- 	local req_change_ssid = restapi.incubator.set_passwd(body_table.ssid)

	-- 	if req_change_ssid == true then
	-- 		return success_response
	-- 	else
	-- 		return -- error_changing_config
	-- 		{ status = "400", type = "application/json", body = "Error en el ssid" }
	-- 	end
	-- end

	-- if body_table.passwd then
	-- 	body_table.passwd = body_table.passwd

	-- 	local req_change_passwd = restapi.incubator.set_passwd(body_table.passwd)

	-- 	if req_change_passwd == true then
	-- 		return success_response
	-- 	else
	-- 		return -- error_changing_config
	-- 		{ status = "400", type = "application/json", body = "Error en passwd" }
	-- 	end
	-- end

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
-- ! @function config_get   get the current config.json parameters
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
-- ! @functiona actual_ht   get the current humidity and temperature
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

	-- * dynamic routes to serve
	httpd.dynamic(httpd.GET, "/config", restapi.config_get)
	httpd.dynamic(httpd.POST, "/config", restapi.change_config_file)
	httpd.dynamic(httpd.GET, "/actual", restapi.actual_ht)
end

return restapi
