-- ! Modules 
--dofile('wifiinit.lua')
--dofilerequire('credentials.lua')
require('credentials')

-- ! Local Variables 
token_grafana = "token:e98697797a6a592e6c886277041e6b95"
url = SERVER


------------------------------------------------------------------------------------
-- ! @function create_grafana_message    to read the data from the bme sensor 
-- !                                     and send it by post request 
--                                               
-- ! @var temperature                    stores the temperature returned by the internal
-- !                                     function of sensor
--
-- ! @var humidity                       stores the humidity returned by the internal 
-- !                                     function of sensor
--
-- ! @var pressure                       stores the pressure returned by the internal
-- !                                     function of sensor
--
-- ! @var INICIALES                      user's initials, brought from credential.lua  
--
-- ! @var time							 time in nanosecconds since 
------------------------------------------------------------------------------------
function create_grafana_message(temperature,humidity,pressure,INICIALES,time)
	local data = "mediciones,device=" .. INICIALES .. " temp=" ..
									temperature .. ",hum=" .. humidity .. ",press=" .. pressure .." " .. time
	return data
end


------------------------------------------------------------------------------------
-- ! @function send_data_grafana         to read the data from the bme sensor 
-- !                                     and send it by post request 
--                                               
-- ! @var temperature                    stores the temperature returned by the internal
-- !                                     function of sensor
--
-- ! @var humidity                       stores the humidity returned by the internal 
-- !                                     function of sensor
--
-- ! @var pressure                       stores the pressure returned by the internal
-- !                                     function of sensor
--
-- ! @var  INICIALES                     user's initials, brought from credential.lua   
------------------------------------------------------------------------------------

function send_data_grafana(temperature,humidity,pressure,INICIALES)

		--todo: add time source 
		local data = create_grafana_message(temperature,humidity,pressure,INICIALES, string.format("%.0f", ((time.get()) *1000000000))) 
		local headers = {
				["Content-Type"] = "text/plain",
				["Authorization"] = "Basic " .. token_grafana
		}
		http.post(url, {headers = headers}, data,
			function(code_return, data_return) 
				if (code_return ~= 204) then
					print(" " .. code_return)
				end
		end) -- * post function end
end -- * send_data_grafana end

----------------------------------------------------------------
-- @ function heap_grafana_message  send the free to grafana
----------------------------------------------------------------
function heap_grafana_message()
  local heap_bytes = node.heap()
  local node_heap =  tonumber((heap_bytes / 1048576))  -- 1,048,576 bytes = 1Mb

  local response = "heap,device=" .. INICIALES .. " free_heap=" .. node_heap .. string.format("%.0f", ((time.get()) * 1000000000))

  local headers = {
    ["Content-Type"] = "text/plain",
    ["Authorization"] = "Basic " .. token_grafana
  }
  http.post(url, {headers=headers}, response, function(code, _)
    if(code ~= 204) then
      print(" " .. code)
    end -- if end
  end) -- callback end
end -- function end

-----------------------------------------------------------------
--@ function uptime_grafana_message   send the uptime to grafana
------------------------------------------------------------------

function uptime_grafana_message()
  --The first is the time in microseconds since boot or the last time the counter wrapped 
  -- and the second is the number of times the counter has wrapped.
  local high_bytes, _ = node.uptime()
  local uptime_secs = tonumber((high_bytes / 1000000))
  -- uptime in minutes
  local uptime = tonumber(uptime_secs / 60)

  local response = "uptime,device=" .. INICIALES .. " up_time=" .. uptime .. string.format("%.0f", ((time.get()) * 1000000000))
  local headers = {
    ["Content-Type"] = "text/plain",
    ["Authorization"] = "Basic " .. token_grafana
  }
  http.post(url, {headers=headers}, response, function (code, _)
    if(code ~= 204) then
      print(" " .. code)
    end -- if end 
  end) -- callback end
end -- function end









