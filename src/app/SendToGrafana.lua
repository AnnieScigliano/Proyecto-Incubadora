-- ! Modules 
dofile('wifiinit.lua')
dofile('credentials.lua')

-- ! Local Variables 
local is_sensorok = false
local sensor = require('bme280')
local token_grafana = "token:e98697797a6a592e6c886277041e6b95"
local url = SERVER

------------------------------------------------------------------------------------
-- ! Initializes the sensor to be able to read the data.
------------------------------------------------------------------------------------

if sensor.init(GPIOBMESDA, GPIOBMESCL, true) then 
		is_sensorok = true 
end -- end if

------------------------------------------------------------------------------------
-- ! @function send_data_grafana    						to read the data from the bme sensor 
-- !                                            and send it by post request 
-- ! @funtion http.post                         nodemcu http library, allows to make web requests
------------------------------------------------------------------------------------
function send_data_grafana()

		local data = "mediciones,device=" .. INICIALES .. "-bme280 temp=" ..
									temperature .. ",hum=" .. humidity .. ",press=" .. pressure
		local headers = {
				["Content-Type"] = "text/plain",
				["Authorization"] = "Basic " .. token_grafana
		}
		http.post(url, {headers = headers}, data,
			function(code_return, data_return) 
				print("HTTP POST return " .. code_return)
			
		end) -- function end
end -- send_data_grafana end

------------------------------------------------------------------------------------
-- ! @function data_bme    							 to read the data from the bme sensor 
-- !                                      
-- ! @function sensor.read               of the bme280 module that returns the values 
-- !                                     of the measurements
-----------------------------------------------------------------------------------
function data_bme()

		if is_sensorok then 		
				sensor.read() 
		end -- end if

		temperature = (sensor.temperature / 100)
		humidity = (sensor.humidity / 100)
		pressure = math.floor(sensor.pressure) / 100

		send_data_grafana()

end -- data_bme end

------------------------------------------------------------------------------------
-- ! @function data_dht    				 to read the data from the dht22 sensor 
------------------------------------------------------------------------------------
function data_dht()
		is_status, temperature, humidity, temp_dec, humi_dec = dht.read2x(GPIODHT22)

		if is_status == dht.OK then
				pressure = 0
				send_data_grafana()
		end -- if end 

end -- data_dht end

------------------------------------------------------------------------------------
-- ! @function read_and_send_data	     		is in charge of calling the read and data sending
-- !                                     functions
------------------------------------------------------------------------------------
function read_and_send_data()
		data_bme()
		data_dht()
end -- read_and_send_data end


local send_data_timer = tmr.create()
send_data_timer:register(10000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()
