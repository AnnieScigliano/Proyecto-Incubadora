configurator =
{
  wifi = {},
  incubator = nil

}

-------------------------------------------------------------------------------------
-- @method configurator:encode_config_file	encode the new config.json
-------------------------------------------------------------------------------------
function configurator:encode_config_file(new_config_table)
  local table_to_json = sjson.encode(new_config_table)

  local new_config_file = io.open("config.json", "w")
  if new_config_file then
    new_config_file:write(table_to_json)
    new_config_file:close()
    return { status = "201 Created", type = "application/json", body = "JSON updated and encoded successfully" }
  else
    return { status = "400", type = "application/json", body = "Error in encode_config_file" }
  end -- if else end
end

-------------------------------------------------------------------------------------
-- @method configurator:create_config_file	create a new one config.json
-------------------------------------------------------------------------------------

function configurator:create_config_file()
  print("[!] Failed to read JSON file, creating a new one")
  new_file = io.open("config.json", "w")
  new_file:write(
    '{"rotation_duration":360000,"min_temperature":37.3,"max_temperature":37.8,"ssid":"incubator","passwd":"1234554321"}')
  new_file:close()
end

-------------------------------------------------------------------------------------
-- @method configurator.read_config_file	read the current config.json in the file
-------------------------------------------------------------------------------------

function configurator:read_config_file()
  local file = io.open("config.json", "r")
  if file then
    local config_json = file:read("*a")
    file:close()
    local config_table = sjson.decode(config_json)
    return config_table
  else
    configurator:create_config_file()
  end
end

-----------------------------------------------------------------------------------
-- @method configurator.change_config	change the currents parameters in the file
-----------------------------------------------------------------------------------

function configurator:load_objects_data(new_config_table)
  for param in pairs(new_config_table) do
    if param == tostring(new_config_table.min_temperature) then
      local status_min_temp = incubator.set_min_temp(tonumber(new_config_table.min_temperature))
      if status_min_temp == false then
        return { status = "400", type = "application/json", body = "Error in set_max_temp" }
      end -- if end
    end   -- if end
    if param == tostring(new_config_table.max_temperature) then
      local status_max_temp = incubator.set_max_temp(tonumber(new_config_table.max_temperature))
      if status_max_temp == false then
        return { status = "400", type = "application/json", body = "Error in set_min_temp" }
      end -- if end
    end   -- if end
    if param == tostring(new_config_table.rotation_duration) then
      local status_rotation_duration = incubator.set_rotation_duration(tonumber(new_config_table.rotation_duration))
      if status_rotation_duration == false then
        return { status = "400", type = "application/json", body = "Error in set_rotation_duration" }
      end -- if end
    end   --if end
    if param == tostring(new_config_table.rotation_period) then
      local status_rotation_period = incubator.set_rotation_period(tonumber(new_config_table.rotation_period))
      if status_rotation_period == false then
        return { status = "400", type = "application/json", body = "Error in set_rotation_period" }
      end -- if end
    end   -- if end
    if param == tostring(new_config_table.ssid) then
      local status_ssid = incubator.set_new_ssid(tostring(new_config_table.ssid))
      if status_ssid == false then
        return { status = "400", type = "application/json", body = "Error in set_new_ssid" }
      end -- if end
    end   -- if end
    if param == tostring(new_config_table.passwd) then
      local status_passwd = incubator.set_passwd(tostring(new_config_table.passwd))
      if status_passwd == false then
        return { status = "400", type = "application/json", body = "Error in set_passwd" }
      end -- if end
    end   -- if end
  end     -- for end
end       -- function end

-------------------------------------------------------------------------------------
-- @method configurator.set_new_credentials	set the new credentials for wifi
-------------------------------------------------------------------------------------
function configurator.wifi:set_new_credentials(ssid, passwd)
  incubator.set_new_ssid(ssid)
  incubator.set_passwd(passwd)
end

-------------------------------------------------------------------------------------
--------------------------        API REST       ------------------------------------
-------------------------------------------------------------------------------------
-- @method configurator.read_config_file	get the current config.json in json format
-------------------------------------------------------------------------------------
function configurator:get_config(config_table)
  local body_json = sjson.encode(config_table)
  return body_json
end -- function end

-------------------------------------------------------------------------------------
-- @method configurator.update_config_from_request	save the new config.json in the file
-------------------------------------------------------------------------------------
function configurator:update_config_from_request(request)
  local request_body_json = request.getbody()
  local body_table = sjson.decode(request_body_json)
  return body_table
end -- function end
