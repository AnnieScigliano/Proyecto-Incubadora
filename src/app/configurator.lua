configurator = {
  wifi = nil,
  incubator = nil

}



------------------------------
-- a- init(incubadora)
-- b- json = readconfigfile()
-- c- loadobjectdata(json)
-- d- writeconfigfile(json)



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
  end
end

-----------------------------------------------------------------------------------
-- @function configurator.change_config	change the currents parameters in the file
-----------------------------------------------------------------------------------

config_table = configurator.read_config_file()

function configurator.change_config_file(config_table)
  incubator.set_max_temp(config_table.max_temperature)
  incubator.set_min_temp(config_table.min_temperature)
  incubator.set_rotation_duration(config_table.rotation_duration)
  incubator.set_rotation_period(config_table.rotation_period)
end

function config.wifi.set_new_credentials(config_table)
  incubator.set_new_ssid = config_table.ssid
  incubator.set_new_ssid = config_table.passwd
end

--------------------------------------------------------------------------------
--------------------------        API REST       -------------------------------
--------------------------------------------------------------------------------


function configurator.get_config()
  local config_table = configurator.read_config_file()
  local body_json = sjson:enconde(config_table)

  if body_json == nil then
    return error_bad_request
  end

  return { status = "200 OK", type = "application/json", body = body_json }
end
