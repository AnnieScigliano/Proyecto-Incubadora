-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License:
-----------------------------------------------------------------------------
require('credentials')
require("SendToGrafana")
alerts = require("alerts")
incubator = require("incubator")
apiserver = require("restapi")
deque = require ('deque')
log = require ('log')


--log.level = "debug"
--log.usecolor=false


--holds the last 10 values 
local last_temps_queue = deque.new()


-----------------------------------------------------------------------------------
-- ! @function is_temp_changing 	     verifies if temperature is changing 
-- ! @param temperature						 actual temperature
------------------------------------------------------------------------------------
function is_temp_changing(temperature)
    last_temps_queue:push_right(temperature)
    if last_temps_queue:length() < 10  then
        ---les than 9 elements in the queue
        return true
    end
    if last_temps_queue:length() > 10 then
        -- remove one item
        last_temps_queue:pop_left()
    end
    local vant = nil
   
    for i,v in ipairs(last_temps_queue:contents()) do
        log.trace("val:", i, v,vant)
        if vant ~= nil and vant ~= v then
            --everything is fine... 
            return true
        end
        vant = v
    end
    --temp is not changin
    return false
end



-----------------------------------------------------------------------------------
-- ! @function temp_control 	     handles temperature control
-- ! @param temperature						 overall temperature
-- ! @param min_temp 							 temperature at which the resistor turns on
-- ! @param,max_temp 							 temperature at which the resistor turns off
------------------------------------------------------------------------------------
function temp_control(temperature, min_temp, max_temp)   
    log.trace(" temp "..temperature.." min:".. min_temp .." max:".. max_temp)

    if temperature <= min_temp then
        if is_temp_changing(temperature) then
            log.trace("temperature is changing")
            log.trace("trun resistor on")
            incubator.heater(true)
        else
            log.error("temperature is not changing")
            alerts.send_alert_to_grafana("temperature is not changing")
            log.trace("trun resistor off")
            incubator.heater(false)
        end
    elseif temperature >= max_temp then
        incubator.heater(false)
        log.trace("trun resistor off")
    end -- end if

end -- end function

function read_and_control()
	temp,hum,pres=incubator.get_values()
    log.trace(" t:"..temp.." h:"..hum.." p:"..pres)
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
    log.trace("trun rotation off")

end

function rotate()
    incubator.rotation(true)
    log.trace("turn rotation on")
    stoprotation = tmr.create()
    stoprotation:register(incubator.rotation_duration, tmr.ALARM_SINGLE, stop_rot)
    stoprotation:start()
end

incubator.init_values()
apiserver.init_module(incubator)
incubator.enable_testing(false)

local send_data_timer = tmr.create()
send_data_timer:register(10000, tmr.ALARM_AUTO, read_and_send_data)
send_data_timer:start()

local temp_control_timer = tmr.create()
temp_control_timer:register(3000, tmr.ALARM_AUTO, read_and_control)
temp_control_timer:start()

local rotation = tmr.create()
--rotation:register(20000, tmr.ALARM_AUTO, rotate)
rotation:register(incubator.rotation_period, tmr.ALARM_AUTO, rotate)
rotation:start()

