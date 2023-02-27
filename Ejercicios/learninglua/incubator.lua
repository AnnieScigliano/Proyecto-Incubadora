-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It 
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License: 
-----------------------------------------------------------------------------


local incubator =  {
  name=...,       -- module name, upvalue from require('module-name')
  model=nil,      -- sensor model: BME280
	resistor=false,
	humidifier=false,
  temperature=0,-- integer value of temperature [0.01 C]
  pressure   =0,-- integer value of preassure [Pa]=[0.01 hPa]
  humidity   =0 -- integer value of rel.humidity [0.01 %]
}


-------------------------------------
-- simulates a change in sensors acording to actuators and returns sensor readings
--
-- @param status "on" increments temperature, "off" temp changes randomly
-------------------------------------
function incubator.getValues()
	
	if resistor then
		incubator.temperature = (incubator.temperature +1) 
	else
		incubator.temperature = (incubator.temperature - math.random(1,10)) 
	end
	
	if humidifier then
		incubator.humidity = (incubator.humidity +1) 
	else
		incubator.humidity = (incubator.humidity - math.random(1,10)) 
	end
	
	return incubator.temperature, incubator.humidity, incubator.pressure
	
end

-------------------------------------
-- Activates or deactivates temperature control
--
-- @param status "true" increments temperature, "false" temp changes randomly
-------------------------------------
function incubator.temp_control(status--[[bool]])
	resistor = status
end


-------------------------------------
-- Activates or deactivates humidity control
--
-- @param status "true" increments humidity, "false" humidity changes randomly
-------------------------------------
function incubator.humidity_control(status)
	humidifier = status
end

return incubator	


