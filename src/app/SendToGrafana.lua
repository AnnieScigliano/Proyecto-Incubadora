-- ! Modules 
--dofile('wifiinit.lua')
dofile('credentials.lua')

-- ! Local Variables 
local token_grafana = "token:e98697797a6a592e6c886277041e6b95"
local url = SERVER


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

		local data = "mediciones,device=" .. INICIALES .. " temp=" ..
									temperature .. ",hum=" .. humidity .. ",press=" .. pressure
		--todo: add time source 
		local data = create_grafana_message(temperature,humidity,pressure,INICIALES, string.format("%.0f", ((time.get() - 120) *1000000000))) 

		print(data)

		local headers = {
				["Content-Type"] = "text/plain",
				["Authorization"] = "Basic " .. token_grafana
		}
		http.post(url, {headers = headers}, data,
			function(code_return) 
				print("HTTP POST return " .. code_return)
			
		end) -- function end
end -- send_data_grafana end



