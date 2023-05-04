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

------------------------------------------------------------------------------------
-- ! @function temp_control 	     handles temperature control
-- ! @param temperature						 overall temperature
-- ! @param temp_on 							 temperature at which the resistor turns on
-- ! @param temp_off 							 temperature at which the resistor turns off
------------------------------------------------------------------------------------

function temp_control(temperature, temp_on, temp_off)

    if temperature <= temp_on then
        incubator.heater(true)
    elseif temperature >= temp_off then
        incubator.heater(false)
    end -- end if
end -- end function

function read_and_control()
	temp,hum,pres=incubator.get_values()
	temp_control(temp, 37.5, 38)
end -- end function 

------------------------------------------------------------------------------------
-- ! @function read_and_send_data           is in charge of calling the read and  data sending
-- !                                    functions
------------------------------------------------------------------------------------
function read_and_send_data()
    send_data_grafana(incubator.temperature,incubator.humidity,incubator.pressure,INICIALES.."-bme")
end -- read_and_send_data end

function stop_rot()
    incubator.humidifier(false)
end

function rotate()
    incubator.humidifier(true)
    stoprotation = tmr.create()
    stoprotation:register(10000, tmr.ALARM_SINGLE, stop_rot)
    stoprotation:start()
end



incubator.init_values()
incubator.enable_testing(37.5,38,false)

local send_data_timer = tmr.create()
send_data_timer:register(3000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()

local temp_control_timer = tmr.create()
temp_control_timer:register(1000, tmr.ALARM_AUTO, read_and_control)
temp_control_timer:start()

local rotation = tmr.create()
rotation:register(3600000, tmr.ALARM_AUTO, rotate)
rotation:start()
