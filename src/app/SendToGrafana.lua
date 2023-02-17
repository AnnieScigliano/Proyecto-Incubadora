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
-- ! @var is_sensorok       boolean that checks the state of the sensor.
-- ! @var sensor            is an instance of the bme280 module
------------------------------------------------------------------------------------

if sensor.init(GPIOBMESDA, GPIOBMESCL, true) then is_sensorok = true end

------------------------------------------------------------------------------------
-- ! @function send_data_grafana    			to read the data from the bme sensor 
-- !                                            and send it by post request 

-- ! @funtion http.post                         nodemcu http library, allows to make web requests
-- ! @var url                                   contains a string with the url to use
-- 
------------------------------------------------------------------------------------

function send_data_grafana()

    local data = "mediciones,device=" .. INICIALES .. "-bme280 temp=" ..
                  temperature .. ",hum=" .. humidity .. ",press=" .. pressure

    local headers = {
        ["Content-Type"] = "text/plain",
        ["Authorization"] = "Basic " .. token_grafana
    }
    http.post(url, {headers = headers}, data,
      
      function(c, d) print("HTTP POST return " .. c)
      
    end) -- * post function end
end -- * send_data_grafana end

------------------------------------------------------------------------------------
-- ! @function data_bme    				 to read the data from the bme sensor 
-- !                                      
--
-- ! @function sensor.read               of the bme280 module that returns the values 
-- !                                     of the measurements
-----------------------------------------------------------------------------------

function data_bme()

    if is_sensorok then sensor.read() end

    temperature = (sensor.temperature / 100)
    humidity = (sensor.humidity / 100)
    pressure = math.floor(sensor.pressure) / 100

    send_data_grafana()

end

------------------------------------------------------------------------------------
-- ! @function data_dht    				 to read the data from the dht22 sensor 
-- 
-- ! @param GPIODHT22                    pin number on which the dht22 is operating
------------------------------------------------------------------------------------

function data_dht()

    is_status, temperature, humidity, temp_dec, humi_dec = dht.read2x(GPIODHT22)

    if is_status == dht.OK then

        pressure = 0

        send_data_grafana()

    end -- if end 
end -- data_dht end

------------------------------------------------------------------------------------
-- ! @function read_and_send_data	     is in charge of calling the read and  data sending
-- !                                     functions
------------------------------------------------------------------------------------

function read_and_send_data()

    data_bme()
    data_dht()

end

------------------------------------------------------------------------------------
--
-- ! @function send_data_timer:register  execute the function every 10 seconds
--
-- ! @param 10000                        time in milliseconds
--
-- ! @param tmr.ALARM_AUTO               automatically execute the function
--
-- ! @param send_data_tmr:start          start the timer
------------------------------------------------------------------------------------

local send_data_timer = tmr.create()
send_data_timer:register(10000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()
