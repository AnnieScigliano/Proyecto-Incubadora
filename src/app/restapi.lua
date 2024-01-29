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
	configurator.save_config(req)
	config_table = configurator.read_config_file()
	configurator.change_config_file(config_table)
end

-------------------------------------
-- ! @function config_get   get the current config.json parameters
-------------------------------------

function restapi.config_get()
	configurator.get_config()
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

	-- * dynamic routes to serve
	httpd.dynamic(httpd.GET, "/config", restapi.config_get)
	httpd.dynamic(httpd.POST, "/config", restapi.change_config_file)
	httpd.dynamic(httpd.GET, "/actual", restapi.actual_ht)
end

return restapi
