-- Conexion Wifi poner los datos de cada wifi en credentials.lua pero no confirmar en el repo
dofile("wifiinit.lua")
dofile("credentials.lua")


local sensorok = false
--Datos del sensor en variables
local sensor = require('bme280')
if sensor.init(GPIOBMESDA, GPIOBMESCL, true) then 
  sensorok = true
end

-- Define la URL y los datos a enviar en json(?)
--local url = "http://grafana.altermundi.net:8086/write?db=cto"
local url = SERVER
local tokenGrafana = "token:e98697797a6a592e6c886277041e6b95"
-- Crea la petición HTTP
local headers = {
  ["Content-Type"] = "text/plain",
  ["Authorization"] = "Basic " .. tokenGrafana
}


function leeryenviardatosbme()
  if sensorok then

    sensor.read()
    temperature = (sensor.temperature/100)
    humidity = (sensor.humidity/100)
    pressure = math.floor(sensor.pressure)/100

    local datos = "mediciones,device="..INICIALES.."-bme280 temp="..temperature..",hum="..humidity..",press="..pressure
    print (datos)
    http.post(url, { headers = headers }, datos, 
      function(codigo, datos)
        print("http post return "..codigo)
        print(datos)
      end)
  end
end

function leeryenviardatosdht()
  status, temperature, humidity, temp_dec, humi_dec = dht.read2x(GPIODHT22)
  if status == dht.OK then
    pressure = 0
    --local datos = "mediciones,device="..INICIALES.."-dht22 temp="..temperature..",hum="..humidity..",press="..pressure
    --datos = string.format("mediciones,device=%s-dht22 temp=%.2f,hum=%.2f,press=%.2f",INICIALES,temperature,humidity,pressure)
    local datos = string.format("mediciones,device=%s-dht22 temp=%d.%03d,hum=%d.%03d,press=%.2f\r\n",
      INICIALES,
      math.floor(temperature),
      temp_dec,
      math.floor(humidity),
      humi_dec
    )
    print (temperature,temp_dec)
    print (datos)
    http.post(url, { headers = headers }, datos, 
      function(codigo, datos)
        print("http post return "..codigo)
        print(datos)
      end)
  end
end

function leeryenviardatos()
  leeryenviardatosbme()
  leeryenviardatosdht()
end

local sendatatmr = tmr.create()
sendatatmr:register(10000, tmr.ALARM_AUTO, leeryenviardatos)
sendatatmr:start()


