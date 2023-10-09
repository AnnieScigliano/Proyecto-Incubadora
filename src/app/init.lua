
              --------------------------------------------------------------------------------------------------------------------------------------- 
                                                                      -- WIFI SETUP 
              ---------------------------------------------------------------------------------------------------------------------------------------

-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there

-------------------------------------
-- global variables come from credentials.lua
-------------------------------------

dofile("credentials.lua")
ONLINE = 0
IPADD = nil
IPGW = nil

------------------------------------------------------------------------------------
-- 
-- ! @function startup                   opens init.lua if exists, otherwise,
-- !                                     prints "running"
--
------------------------------------------------------------------------------------

function startup()
	if file.open("init.lua") == nil then
		print("init.lua deleted or renamed")
	else
		print("Running")
		file.close("init.lua")
		-------------------------------------
		-- the actual application is stored in 'application.lua'
		-------------------------------------
		dofile("application.lua")
	end -- end else
end -- end if

------------------------------------------------------------------------------------
--
-- ! @function configwifi                sets the wifi configurations
-- !                                     uses SSID and PASSWORD from credentials.lua
--
------------------------------------------------------------------------------------

function configwifi()
	print("Running")
	wifi.sta.on("got_ip", wifi_got_ip_event)
	wifi.sta.on("connected", wifi_connect_event)
	wifi.sta.on("disconnected", wifi_disconnect_event)
	wifi.mode(wifi.STATION)
	wifi.start()
	station_cfg = {}
	station_cfg.ssid = SSID
	station_cfg.pwd = PASSWORD
	wifi.sta.config(station_cfg)
	wifi.sta.connect()
end -- end function

------------------------------------------------------------------------------------
--
-- ! @function wifi_connect_event        establishes connection
--
-- ! @param ev                           event status
-- ! @param info                         net information
--
------------------------------------------------------------------------------------

function wifi_connect_event (ev, info)
	print("Connection to AP(" .. info.ssid .. ") established!")
	print("Waiting for IP address...")
	
	if disconnect_ct ~= nil then 
		
		disconnect_ct = nil 
	
	end -- end if

end -- end function

------------------------------------------------------------------------------------
--
-- ! @function wifi_got_ip_event         prints net ip, netmask and gw
--
-- ! @param ev                           event status
-- ! @param info                         net information
-- ! 
------------------------------------------------------------------------------------

function wifi_got_ip_event (ev, info)
	-------------------------------------
	-- Note: Having an IP address does not mean there is internet access!
	-- Internet connectivity can be determined with net.dns.resolve().
	-------------------------------------
	ONLINE = 1
	IPADD = info.ip
	IPGW = info.gw
	print("NodeMCU IP config:", info.ip, "netmask", info.netmask, "gw", info.gw)
	print("Startup will resume momentarily, you have 3 seconds to abort.")
	print("Waiting...")
	print(time.get(), " hora vieja")
	time.initntp("pool.ntp.org")
	print(time.get(), " hora nueva")

end -- end function

------------------------------------------------------------------------------------
--
-- ! @function wifi_disconnect_event     when not able to connect, prints why
--
-- ! @param ev                           event status
-- ! @param info                         net information
--
------------------------------------------------------------------------------------
function wifi_disconnect_event (ev, info)
	ONLINE = 0
	print(info)
	print(info.reason)
	print(info.ssid)
	if info.reason == 8 then
		-------------------------------------
		--the station has disassociated from a previously connected AP
		-------------------------------------
		return
	end -- end function

	------------------------------------------------------------------------------------
	-- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
	------------------------------------------------------------------------------------
	local total_tries = 10
	print("\nWiFi connection to AP(" .. info.ssid .. ") has failed!")

	------------------------------------------------------------------------------------
	-- There are many possible disconnect reasons, the following iterates through
	-- the list and returns the string corresponding to the disconnect reason.
	------------------------------------------------------------------------------------
	print("Disconnect reason: " .. info.reason)
	if disconnect_ct == nil then
		disconnect_ct = 1
	else
		disconnect_ct = disconnect_ct + 1
	end -- end if
	
	if disconnect_ct < total_tries then
		print("Retrying connection...(attempt " .. (disconnect_ct + 1) .. " of " .. total_tries .. ")")
	else
		wifi.sta.disconnect()
		------------------------------------------------------------------------------------
		--
		-- ! @function wifi.sta.scan         prints avaliable networks
		--
		-- ! @param err                      when scan fails shows the error
		-- ! @param arr                      lists the avaliable networks
		--
		------------------------------------------------------------------------------------
		wifi.sta.scan({ hidden = 1 }, 
			function(err,arr)
				if err then
					print ("Scan failed:", err)
				else
					print(string.format("%-26s","SSID"),"Channel BSSID              RSSI Auth Bandwidth")
					for i,ap in ipairs(arr) do
						print(string.format("%-32s",ap.ssid),ap.channel,ap.bssid,ap.rssi,ap.auth,ap.bandwidth)
					end -- end for
				print("-- Total APs: ", #arr)
				end -- end if
			end) -- end function
		
		print("Aborting connection to AP!")
		mytimer = tmr.create()
		mytimer:register(10000, tmr.ALARM_SINGLE, configwifi)
		mytimer:start()
		disconnect_ct = nil
	end -- end if
end -- end function

configwifi()
print("Connecting to WiFi access point...")

        --------------------------------------------------------------------------------------------------------------------------------------- 
                                                                      -- INCUBATOR CONTROLLER 
        ---------------------------------------------------------------------------------------------------------------------------------------


incubator = require("incubator") 

require("SendToGrafana")
dofile('credentials.lua')

------------------------------------------------------------------------------------
-- ! @function temp_control 	     handles temperature control
-- ! @param temperature						 overall temperature
-- ! @param min_temp 							 temperature at which the resistor turns on
-- ! @param,max_temp 							 temperature at which the resistor turns off
------------------------------------------------------------------------------------
min_temp = 37.5
max_temp = 38
r_time = 3600000
a_temperature = incubator.temperature
a_humidity = incubator.humidity

function temp_control(temperature, min_temp, max_temp)    
    if temperature <= min_temp then
        incubator.heater(true)
    elseif temperature >= max_temp then
        incubator.heater(false)
    end -- end if

end -- end function

function read_and_control()
  temp,hum,pres=incubator.get_values()
  temp_control(temp, min_temp , max_temp)
end -- end function 

------------------------------------------------------------------------------------
-- ! @function read_and_send_data           is in charge of calling the read and  data sending
-- !                                    functions
------------------------------------------------------------------------------------
function read_and_send_data()
    send_data_grafana(incubator.temperature,incubator.humidity,incubator.pressure,INICIALES.."-bme")
end -- read_and_send_data end

function stop_rot()
    incubator.humidifier(false)
end

function rotate()
    incubator.humidifier(true)
    stoprotation = tmr.create()
    stoprotation:register(10000, tmr.ALARM_SINGLE, stop_rot)
    stoprotation:start()
end



incubator.init_values()
incubator.enable_testing(min_temp,max_temp,false)

local send_data_timer = tmr.create()
send_data_timer:register(3000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()

local temp_control_timer = tmr.create()
temp_control_timer:register(1000, tmr.ALARM_AUTO, read_and_control)
temp_control_timer:start()

local rotation = tmr.create()
rotation:register(r_time, tmr.ALARM_AUTO, rotate)
rotation:start()


------------------------- API ------------------------
--* libraries

time = require("time")
sjson = require("sjson")


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
    print(reqbody)
  local body_json = sjson.decode(reqbody)

    -- Obtener el nuevo valor de max_temp del cuerpo de la solicitud POST
    print(body_json.maxtemp)
    local new_max_temp = body_json.maxtemp

    if type(new_max_temp) == "number" and new_max_temp < 42 and new_max_temp  >= 0 and new_max_temp >= min_temp then
    
    max_temp = new_max_temp 
    
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

function actual_ht(a_temperature,a_humidity)

	a_temperature, a_humidity, _ = incubator.get_values()

	local body_data = {
		a_temperature = tostring(a_temperature),
		a_humidity =  tostring(a_humidity),
	}

	local body_json = sjson.encode(body_data)

return {
	 status = "200 OK",
	 type = "application/json",
	 body = body_json
	}
end



	httpd.start({ webroot = "web", auto_index = httpd.INDEX_ALL})


--* dynamic routes to serve

httpd.dynamic(httpd.GET,"/version", version)
httpd.dynamic(httpd.GET,"/maxtemp", max_temp_get)
httpd.dynamic(httpd.POST,"/maxtemp", max_temp_post)
httpd.dynamic(httpd.GET,"/mintemp", min_temp_get)
httpd.dynamic(httpd.POST,"/mintemp", min_temp_post)
httpd.dynamic(httpd.GET,"/rotation", rotation_time_get)
httpd.dynamic(httpd.POST,"/rotation", rotation_time_post)
httpd.dynamic(httpd.GET,"/temperatureactual",actual_ht)
httpd.dynamic(httpd.GET,"/date", date)
httpd.dynamic(httpd.GET,"/rotation", rotation_time_get)
httpd.dynamic(httpd.POST,"/rotation", rotation_time_post)




