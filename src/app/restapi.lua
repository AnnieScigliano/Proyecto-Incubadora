local restapi = { incubator = require("incubator") }

-------------------------------------
-- ! @function change config   modify the current config.json file
--
-- !	@param req  		      		server request
-------------------------------------

function restapi.read_config()
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
		print("[!] Failed to read JSON file")
		return nil
	end   -- if end
end     -- function end

-------------------------------------
-- ! @function change config   modify the current config.json file
--
-- !	@param req  		      		server request
-------------------------------------
function restapi.change_config(req)
	-- Local variables
	local request_body_json = req.getbody()
	local body_table = sjson.decode(request_body_json)

	-- Update the configuration values from the request body
	if body_table.max_temperature then
		body_table.max_temperature = tonumber(body_table.max_temperature)
		restapi.incubator.set_max_temp(body_table.max_temperature)
	end

	if body_table.min_temperature then
		body_table.min_temperature = tonumber(body_table.min_temperature)
	end

	if body_table.rotation_time then
		body_table.rotation_time = tonumber(body_table.rotation_time)
	end

	local json_config_file = sjson.encode(body_table)

	local config_file, err = io.open("config.json", "w")
	if config_file then
		config_file:write(json_config_file)
		config_file:close()

		local success_response = {
			status = "200 OK",
			type = "application/json",
			body = sjson.encode({ message = "Json updated successfully" })
		}

		return success_response
	else
		print("Failed to open the config file for writing. Error: " ..
			tostring(err))

		local error_response = {
			status = "500 Internal Server Error",
			type = "application/json",
			body = sjson.encode({ message = "Failed to update JSON file" })
		}

		return error_response
	end
end

-------------------------------------
-- ! @function change_file   get the current config.json parameters
--
-- !	@param req  		      		server request
-------------------------------------

function restapi.config_get()
	local body_data = restapi.read_config()
	local body_json = sjson.encode(body_data)

	return { status = "200 OK", type = "application/json", body = body_json }
end

-------------------------------------
-- ! @function wifi_scan_get   get the current humidity and temperature
--
-- !	@param req  		      		server request
-------------------------------------
function restapi.actual_ht(a_temperature, a_humidity)
	a_temperature, a_humidity, _ = restapi.incubator.get_values()

	local body_data = {
		a_temperature = tonumber(a_temperature),
		a_humidity = tonumber(a_humidity)
	}

	local body_json = sjson.encode(body_data)

	return { status = "200 OK", type = "application/json", body = body_json }
end

-- * start local serve
httpd.start({ webroot = "web", auto_index = httpd.INDEX_ALL })

-- * dynamic routes to serve
httpd.dynamic(httpd.GET, "/config", restapi.config_get)
httpd.dynamic(httpd.POST, "/config", restapi.change_config)
httpd.dynamic(httpd.GET, "/temperatureactual", restapi.actual_ht)
