-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License:
-----------------------------------------------------------------------------
dofile("credentials.lua")
incubator = require("incubator")
apiserver = require("restapi")
require("SendToGrafana")
dofile('credentials.lua')


------------------------------------------------------------------------------------
-- ! @function temp_control 	     handles temperature control
-- ! @param temperature						 overall temperature
-- ! @param min_temp 							 temperature at which the resistor turns on
-- ! @param,max_temp 							 temperature at which the resistor turns off
------------------------------------------------------------------------------------
function temp_control(temperature, min_temp, max_temp)    
    if temperature <= min_temp then
        incubator.heater(true)
    elseif temperature >= max_temp then
        incubator.heater(false)
    end -- end if

end -- end function

function read_and_control()
	temp,hum,pres=incubator.get_values()
	temp_control(temp, incubator.min_temp , incubator.max_temp)
end -- end function 

------------------------------------------------------------------------------------
-- ! @function read_and_send_data           is in charge of calling the read and  data sending
-- !                                    functions
------------------------------------------------------------------------------------
function read_and_send_data()
	temp,hum,pres=incubator.get_values()
    send_data_grafana(incubator.temperature,incubator.humidity,incubator.pressure,INICIALES.."-bme")
end -- read_and_send_data end

function stop_rot()
    incubator.rotation(false)
end

function rotate()
    incubator.rotation(true)
    stoprotation = tmr.create()
    stoprotation:register(5000, tmr.ALARM_SINGLE, stop_rot)
    stoprotation:start()
end

incubator.init_values()
apiserver.init_module(incubator)
incubator.enable_testing(false)

local send_data_timer = tmr.create()
send_data_timer:register(3000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()

local temp_control_timer = tmr.create()
temp_control_timer:register(1000, tmr.ALARM_AUTO, read_and_control)
temp_control_timer:start()

local rotation = tmr.create()
rotation:register(20000, tmr.ALARM_AUTO, rotate)
--rotation:register(3600000, tmr.ALARM_AUTO, rotate)
rotation:start()

