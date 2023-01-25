-- Conexion Wifi
wifi.mode(wifi.STATION)
wifi.start()
wifi.sta.config({ssid="", pwd=""})

--llama al sensor
local sensor = require('bme280')

--TIMER
local mytimer = tmr.create()

mytimer:register(5000, tmr.ALARM_AUTO, function (t) --Datos del sensor en variables
   

    if sensor.init(14, 15, true) then 
        sensor.read()
        temperature = (sensor.temperature/100)
        humidity = (sensor.humidity/100)
        pressure = (sensor.pressure/100)
    end
    
    -- Define la URL y los datos a enviar en json(?)
    local url = "http://grafana.altermundi.net:8086/write?db=cto"
    local datos = "mediciones,device=xx-bme280 temp="..temperature..",hum="..humidity..",press="..pressure
    local tokenGrafana = "token:e98697797a6a592e6c886277041e6b95"
    -- Crea la petición HTTP
    local headers = {
        ["Content-Type"] = "text/plain",
        ["Authorization"] = "Basic " .. tokenGrafana
    }
    
    http.post(url, { headers = headers }, datos, 
    function(codigo, datos)
        print(codigo)
        print(datos)
    end) 
    
end)
mytimer:start()

