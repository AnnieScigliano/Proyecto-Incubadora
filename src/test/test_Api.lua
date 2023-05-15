--* libraries

incubator = require("incubator")
time = require("time")
sjson = require("sjson")

-------------------------------------
--! @function version   print the current version
--
--!	@param req  				server request 
-------------------------------------

function version(req)
		
		local body_data = {
				message = "success",
				version = "0.0.1"
				}

		local body_json = sjson.encode(body_data)

		return {
				status = "200 OK",
				type = "application/json",
				body = body_json
				}

end -- end function

-------------------------------------
--! @function maxtemp   print the current temperature
--
--!	@param req  				server request
-------------------------------------

function maxtemp(req)
		
		local body_data = {
				message = "success",
				maxtemp = incubator.temperature
				}

		local body_json = sjson.encode(body_data)

	return {
			 status = "200 OK",
			 type = "application/json",
			 body = body_json
			 }
 
end -- end function

-------------------------------------
--! @function date   		print the current date
--
--!	@param req  				server request
-------------------------------------

function date(req)
	local inc_date = time.get()
		local body_data = {
				message = "success",
				date = inc_date
				}

	return {
			 status = "200 OK",
			 type = "application/json",
			 body = sjson.encode(body_data)
			 }

end -- end function

--* start local server

httpd.start({ webroot = "web", auto_index = httpd.INDEX_ALL})

--* dynamic routes to serve

httpd.dynamic(httpd.GET,"/version", version)
httpd.dynamic(httpd.GET,"/maxtemp", maxtemp)
httpd.dynamic(httpd.GET,"/date", date)


