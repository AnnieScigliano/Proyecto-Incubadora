-- incubatorController2.lua

-- Cargar las funciones necesarias desde SendToGrafana.lua
dofile('SendToGrafana.lua')
dofile('credentials.lua')
incubator = require('incubator')
sensor = require('bme280')


-- Función para leer datos y enviar a Grafana
function read_and_send_data()
    sensor.init(15,14, true)
    sensor.read()
    local temp = (sensor.temperature / 100)
    local hum = (sensor.humidity / 100)
    local press = (sensor.pressure / 100)
    send_data_grafana(temp, hum, press, INICIALES .. "-bme")
end

-- Configurar temporizador para llamar a la función cada 3 segundos
local send_data_timer = tmr.create()
send_data_timer:register(3000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()
