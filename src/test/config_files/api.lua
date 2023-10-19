--* libraries

time = require("time")
sjson = require("sjson")


function read_config()
  -- open t:he file with read permission
  local file = io.open("config.json", "r")

  if file ~= nil then
    --"*a" read all the file
    local config_json = file:read("*a")
    -- then close the file
    file:close()

    local config_data = sjson.decode(config_json)
    return config_data
  else
    print("[!] Failed to read JSON file")
    return nil
  end -- if end
end   -- function end

local config = read_config()

print(config)
if config then
  min_temp = config.min_temperature
  max_temp = config.max_temperature
  r_time = config.rotation_time

  print(min_temp)
  print(max_temp)
  print(r_time)
end


-- change values config.json


--- @diagnostic disable-next-line: lowercase-global
api_key = nil

------------------------- API ------------------------



print(config.max_temperature .. "<---")

-------------------------------------
--! @function max_temp   print the current temperature
--
--!	@param req  				server request
-------------------------------------

function max_temp_get(req)
  local body_data = {
    message = "success",
    maxtemp = max_temp
  }

  local body_json = sjson.encode(body_data)

  return {
    status = "200 OK",
    type = "application/json",
    body = body_json
  }
end -- end function

-------------------------------------
--! @function min_temp   print the current temperature
--
--!	@param req  				server request
-------------------------------------

function min_temp_get(req)
  local body_data = {
    message = "success",
    mintemp = min_temp
  }

  local body_json = sjson.encode(body_data)

  return {
    status = "200 OK",
    type = "application/json",
    body = body_json
  }
end -- end function

--! @function maxtemp   print the current temperature
--
--!	@param req  				server request
-------------------------------------
function max_temp_post(req)
  local reqbody = req.getbody()
  local body_json = sjson.decode(reqbody)
  local new_max_temp = body_json.maxtemp


  if type(new_max_temp) == "number" and
      new_max_temp < 42 and
      new_max_temp >= 0 and
      new_max_temp >= min_temp then
    -- table with the config
    local config = read_config()

    -- change the max_temp with the config max temp
    if config then
      config.max_temperature = new_max_temp
    end

    local config_json = sjson.encode(config)
    -- this delete all the file
    file = io.open("config.json", "w")
    -- if file exist then write
    if file then
      file:write(config_json)
      -- close the new json file
      file:close()
    else
      return {
        status = "config file not found"
      }
    end
    return {
      status = "201 Created"
    }
  else
    return {
      status = "400 Bad Request"
    }
  end
end

--! @function maxtemp   print the current temperature
--
--!	@param req  				server request
-------------------------------------
function min_temp_post(req)
  local reqbody = req.getbody()
  print(reqbody)

  local body_json = sjson.decode(reqbody)

  -- Obtener el nuevo valor de max_temp del cuerpo de la solicitud POST
  print(body_json.mintemp)
  local new_min_temp = body_json.mintemp

  if new_min_temp >= 0 and new_min_temp <= max_temp and type(new_min_temp) == "number" then
    min_temp = new_min_temp
    return {
      status = "201 Created"
    }
  else
    return {
      status = "400 Bad Request"
    }
  end
end

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

-------------------------------------

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
--! @function max_temp   print the current temperature
--
--!	@param req  				server request
-------------------------------------

function rotation_time_get(req)
  local body_data = {
    message = "success",
    rotation = r_time
  }

  local body_json = sjson.encode(body_data)

  return {
    status = "200 OK",
    type = "application/json",
    body = body_json
  }
end

function rotation_time_post(req)
  local reqbody = req.getbody()
  print(reqbody)
  local body_json = sjson.decode(reqbody)
  -- Obtener el nuevo valor de max_temp del cuerpo de la solicitud POST
  print(body_json.rotation)
  local new_rotation_time = body_json.rotation

  if type(new_rotation_time) == "number" then
    r_time_minutes = new_rotation_time * 60000
    r_time = r_time_minutes

    -- decirle al usuario  que ingrese el  valor en minutos * 60000ms
    return {
      status = "201 Created"
    }
  else
    return {
      status = "400 Bad Request"
    }
  end
end

--* start local serversss

function actual_ht(a_temperature, a_humidity)
  a_temperature, a_humidity, _ = incubator.get_values()

  local body_data = {
    a_temperature = tostring(a_temperature),
    a_humidity = tostring(a_humidity),
  }

  local body_json = sjson.encode(body_data)

  return {
    status = "200 OK",
    type = "application/json",
    body = body_json
  }
end

httpd.start({ webroot = "web", auto_index = httpd.INDEX_ALL })


--* dynamic routes to serve

httpd.dynamic(httpd.GET, "/maxtemp", max_temp_get)
httpd.dynamic(httpd.POST, "/maxtemp", max_temp_post)
httpd.dynamic(httpd.GET, "/mintemp", min_temp_get)
httpd.dynamic(httpd.POST, "/mintemp", min_temp_post)
httpd.dynamic(httpd.GET, "/rotation", rotation_time_get)
httpd.dynamic(httpd.POST, "/rotation", rotation_time_post)
httpd.dynamic(httpd.GET, "/temperatureactual", actual_ht)
