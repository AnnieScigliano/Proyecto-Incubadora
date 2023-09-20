-----------------------------------------------------------------------------
-- Copyright (c) 2023  Javier Jorge <jjorge@inti.gob.ar>
-- Copyright (c) 2023  Jeremias Castro <jerecastro2012@gmail.com>
-- todo: add annie santi ... 
-- Copyright (c) 2023  Instituto Nacional de Tecnología Industrial
-- Copyright (C) 2023  Asociación Civil Altermundi <info@altermundi.net>
--
--  SPDX-License-Identifier: AGPL-3.0-only

-----------------------------------------------------------------------------


-- modules 
dofile('SendToGrafana.lua')
dofile('credentials.lua')
incubator = require('incubator')
sensor = require('bme280')


-- Funcion to read and send data to grafana
function read_and_send_data()
    -- init the sensor
    sensor.init(15,14, true)
    -- reading the data to update the variables temp, hum, and press
    sensor.read()
    -- set values 
    local temp = (sensor.temperature / 100)
    local hum = (sensor.humidity / 100)
    local press = (sensor.pressure / 100)
    -- sending data 
    -- send_data_grafana it is inside of SendToGrafana.lua
    send_data_grafana(temp, hum, press, INICIALES .. "-bme")
end

-- timer setting
local send_data_timer = tmr.create()
send_data_timer:register(3000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()