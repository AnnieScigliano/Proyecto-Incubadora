-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License:
-----------------------------------------------------------------------------
incubator = require("incubator")
require("SendToGrafana")
dofile('credentials.lua')


function tempcontrol(temperature, temp_on, temp_off)

    if temperature <= temp_on then
        incubator.heater(true)
    elseif temperature >= temp_off then
        incubator.heater(false)
    end -- end if

end -- end function

function sleep(n) -- seconds
    local t0 = clock()
    while clock() - t0 <= n do
    end
end

function readandcontrol()
    temp,hum,pres=incubator.getValues()
    tempcontrol(temp, 37.5, 38)
    incubator.assertconditions()
    
end

------------------------------------------------------------------------------------
-- ! @function read_and_send_data           is in charge of calling the read and  data sending
-- !                                    functions
------------------------------------------------------------------------------------
function read_and_send_data()
    send_data_grafana(incubator.temperature,incubator.humidity,incubator.pressure,INICIALES.."-bme")
end -- read_and_send_data end

function stoporot()
    incubator.humidifier(false)
end

function rotate()
    incubator.humidifier(true)
    stoprotation = tmr.create()
    stoprotation:register(10000, tmr.ALARM_SINGLE, stoporot)
    stoprotation:start()
end



incubator.initValues()
incubator.enableTesting(37.5,38,false)

local send_data_timer = tmr.create()
send_data_timer:register(3000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()

local tempcontrol_timer = tmr.create()
tempcontrol_timer:register(1000, tmr.ALARM_AUTO, readandcontrol)
tempcontrol_timer:start()

local rotation = tmr.create()
rotation:register(3600000, tmr.ALARM_AUTO, rotate)
rotation:start()
