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
	testingmintem=0
}

-------------------------------------
-- Enables testing mode asserting correct incubator funcioning
--
-- @param status "on" increments temperature, "off" temp changes randomly
-------------------------------------
function incubator.enableTesting(min,max)
	incubator.testing = true;
	incubator.testingmaxtem = max
	incubator.testingmintem = min
end


-------------------------------------
-- simulates a change in sensors acording to actuators and returns sensor readings
--
-- @param status "on" increments temperature, "off" temp changes randomly
-------------------------------------
function incubator.getValues()
	if incubator.resistor then
		incubator.temperature = (incubator.temperature +1) 
	else
		incubator.temperature = (incubator.temperature - math.random(1,4)) 
	end
	
	if incubator.humidifier then
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
	incubator.resistor = status
	print(status)
	incubator.assertconditions()
end

function incubator.assertconditions()
	if incubator.testing then
		print(incubator.temperature,incubator.testingmaxtem,incubator.testingmintem, incubator.resistor)
		if (incubator.temperature > incubator.testingmaxtem) then
			assert(not incubator.resistor)
		end --if
		if (incubator.temperature < incubator.testingmintem) then
			assert( incubator.resistor)
		end --if
	end -- if testing
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


