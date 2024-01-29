configurator =
{
  wifi = nil,
  incubator = nil

}

-------------------------------------------------------------------------------------
-- @function configurator.read_config_file	read the current config.json in the file
-------------------------------------------------------------------------------------

function configurator.read_config_file()
  local file = io.open("config.json", "r")
  if file ~= nil then
    local config_json = file:read("*a")
    file:close()

    local config_table = sjson.decode(config_json)
    return config_table
  else
    print("[!] Failed to read JSON file, creating a new one")
    new_file = io.open("config.json", "w")
    new_file:write(
      '"rotation_duration":360000,"min_temperature":37.3,"max_temperature":37.8,"ssid":"incubator","passwd":"1234554321"')
    new_file:close()
    print("[+] the file was created successfully")
  end
end

-----------------------------------------------------------------------------------
-- @function configurator.change_config	change the currents parameters in the file
-----------------------------------------------------------------------------------

function configurator.change_config_file(config_table)
  incubator.set_max_temp(config_table.max_temperature)
  incubator.set_min_temp(config_table.min_temperature)
  incubator.set_rotation_duration(config_table.rotation_duration)
  incubator.set_rotation_period(config_table.rotation_period)
end

-------------------------------------------------------------------------------------
-- @function configurator.set_new_credentials	set the new credentials for wifi
-------------------------------------------------------------------------------------
function config.wifi.set_new_credentials(config_table)
  incubator.set_new_ssid(config_table.ssid)
  incubator.set_passwd(config_table.passwd)
end

-------------------------------------------------------------------------------------
--------------------------        API REST       ------------------------------------
-------------------------------------------------------------------------------------
-- @function configurator.read_config_file	get the current config.json in json format
-------------------------------------------------------------------------------------
function configurator.get_config()
  local config_table = configurator.read_config_file()
  local body_json = sjson:enconde(config_table)

  if body_json == nil then
    return error_bad_request
  end -- if end
  return { status = "200 OK", type = "application/json", body = body_json }
end   -- function end

-------------------------------------------------------------------------------------
-- @function configurator.save_config	save the new config.json in the file
-------------------------------------------------------------------------------------

function save_config(req)
  local request_body_json = req.getbody()
  local body_table = sjson.decode(request_body_json)
  local success_response =
  {
    status = "201 Created",
    type = "application/json",
    body = sjson.encode({ message = "JSON updated successfully" })
  }

  for param in pairs(body_table) do
    if param == tostring(body_table.min_temperature) then
      local status_min_temp = incubator.set_min_temp(tonumber(body_table.min_temperature))
      if status_min_temp == false then
        return { status = "400", type = "application/json", body = "Error in set_max_temp" }
      end -- if end
    end   -- if end
    if param == tostring(body_table.max_temperature) then
      local status_max_temp = incubator.set_max_temp(tonumber(body_table.max_temperature))
      if status_max_temp == false then
        return { status = "400", type = "application/json", body = "Error in set_min_temp" }
      end -- if end
    end   -- if end
    if param == tostring(body_table.rotation_duration) then
      local status_rotation_duration = incubator.set_rotation_duration(tonumber(body_table.rotation_duration))
      if status_rotation_duration == false then
        return { status = "400", type = "application/json", body = "Error in set_rotation_duration" }
      end -- if end
    end   --if end
    if param == tostring(body_table.rotation_period) then
      local status_rotation_period = incubator.set_rotation_period(tonumber(body_table.rotation_period))
      if status_rotation_period == false then
        return { status = "400", type = "application/json", body = "Error in set_rotation_period" }
      end -- if end
    end   -- if end
  end     -- for end
  -- write and save config
  local json_config_file = sjson.encode(body_table)
  local config_file = io.open("config.json", "w")
  if config_file then
    config_file:write(json_config_file)
    config_file:close()
    return success_response
  else
    return { status = "400", type = "application/json", body = "Error saving the new config" }
  end -- if else end
end   -- function end
