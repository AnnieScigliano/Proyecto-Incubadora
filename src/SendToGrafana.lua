-- Conexion Wifi poner los datos de cada wifi en credentials.lua pero no confirmar en el repo
dofile("wifiinit.lua")
dofile("credentials.lua")

--Datos del sensor en variables
local sensor = require('bme280')

if sensor.init(GPIOBMESDA, GPIOBMESCL, true) then 

  -- Define la URL y los datos a enviar en json(?)
  --local url = "http://grafana.altermundi.net:8086/write?db=cto"
  local url = "http://grafana.altermundi.net:8086/write?db=cto"
  local tokenGrafana = "token:e98697797a6a592e6c886277041e6b95"
  -- Crea la petición HTTP
  local headers = {
      ["Content-Type"] = "text/plain",
      ["Authorization"] = "Basic " .. tokenGrafana
  }

  function otracosa()
    print("hola")
  end


  function leeryenviardatos()
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

  local sendatatmr = tmr.create()
  sendatatmr:register(10000, tmr.ALARM_AUTO, leeryenviardatos)
  sendatatmr:start()

end
