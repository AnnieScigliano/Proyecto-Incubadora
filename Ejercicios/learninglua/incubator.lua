-----------------------------------------------------------------------------
--  This is the reference implementation to simulate the incubator.
--  this model implements an icubator whos ambient temperatura is always 
--  below the control temperature. It also suposes tha when you turn on actuators 
--  variables change.
--
--  javier jorge
--
--  License: 
-----------------------------------------------------------------------------


local incubator =  {
	name=...,       -- module name, upvalue from require('module-name')
	model=nil,      -- incubator model: 
	resistor=true,
	humidifier=false,
	temperature=29,-- integer value of temperature [0.01 C]
	pressure   =0,-- integer value of preassure [Pa]=[0.01 hPa]
	humidity   =0, -- integer value of rel.humidity [0.01 %]
	testing	= false,
	testingmaxtem=0, 
	testingnintem=0
}

-------------------------------------
-- Enables testing mode asserting correct incubator funcioning
--
-- @param status "on" increments temperature, "off" temp changes randomly
-------------------------------------
function enableTesting(max,min)
	testing = true;
	testingmaxtem = max
	testingnintem = min
end


-------------------------------------
-- simulates a change in sensors acording to actuators and returns sensor readings
--
-- @param status "on" increments temperature, "off" temp changes randomly
-------------------------------------
function incubator.getValues()
	
	if testing then
		print(incubator.temperature,testingmaxtem,testingnintem, incubator.resistor)
		if (incubator.temperature > testingmaxtem) then
			assert(not incubator.resistor)
		end --if
		if (incubator.temperature < testingnintem) then
			assert( incubator.resistor)
		end --if
	end -- if testing

	if resistor then
		incubator.temperature = (incubator.temperature +1) 
	else
		incubator.temperature = (incubator.temperature - math.random(1,4)) 
	end
	
	if humidifier then
		incubator.humidity = (incubator.humidity +1) 
	else
		incubator.humidity = (incubator.humidity - math.random(1,4)) 
	end


	return incubator.temperature, incubator.humidity, incubator.pressure
	
end

-------------------------------------
-- Activates or deactivates temperature control
--
-- @param status "true" increments temperature, "false" temp decrements randomly
-------------------------------------
function incubator.heater(status--[[bool]])
	resistor = status
	print(status)
end


-------------------------------------
-- Activates or deactivates humidity control
--
-- @param status "true" increments humidity, "false" humidity decrements randomly
-------------------------------------
function incubator.humidifier(status)
	humidifier = status
	print(status)
end

return incubator	


