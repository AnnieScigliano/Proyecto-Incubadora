-----------------------------------------------------------------------------
--  This is the reference implementation to simulate the M.
--  this model implements an icubator whos ambient temperatura is always
--  below the control temperature. It also suposes tha when you turn on actuators
--  variables change.
--
--  javier jorge
--
--  License:
-----------------------------------------------------------------------------

dofile('credentials.lua')

local M = {
	name          = ..., -- module name, upvalue from require('module-name')
	model         = nil, -- M model:
	resistor      = true,
	humidifier    = false,
	temperature   = 29, -- integer value of temperature [0.01 C]
	pressure      = 0, -- integer value of preassure [Pa]=[0.01 hPa]
	humidity      = 0, -- integer value of rel.humidity [0.01 %]
	testing       = false,
	testingmaxtem = 0,
	testingmintem = 0,
	
}

_G[M.name]=M

local sensor = require('bme280')
local simulatetemplocal = false
local is_sensorok = false

function M.initValues()
	if sensor.init(GPIOBMESDA, GPIOBMESCL, true) then
		is_sensorok = true
	end -- end if()
	gpio.config( { gpio={14,15,13,12}, dir=gpio.OUT })
	gpio.set_drive(13, gpio.DRIVE_3)
	gpio.set_drive(14, gpio.DRIVE_3)
	gpio.set_drive(15, gpio.DRIVE_3)
    gpio.set_drive(12, gpio.DRIVE_3)
    gpio.write(13, 1)
    gpio.write(14, 1)
    gpio.write(15, 1)
    gpio.write(12, 1)
    
end -- end function

-------------------------------------
-- Enables testing mode asserting correct M funcioning
--
-- @param status "on" increments temperature, "off" temp changes randomly
-------------------------------------
function M.enableTesting(min, max,simulatetemp)
	M.testing = true;
	simulatetemplocal= simulatetemp
	M.testingmaxtem = max
	M.testingmintem = min
end --end function

-------------------------------------
-- simulates a change in sensors acording to actuators and returns sensor readings
--
-- @returns temperature, humidity, pressure
-------------------------------------
function M.getValues()
	if simulatetemplocal then
		if M.resistor then
			M.temperature = (M.temperature + 1)
		else
			M.temperature = (M.temperature - math.random(1, 4))
		end --endif

		if M.humidifier then
			M.humidity = (M.humidity + 1)
		else
			M.humidity = (M.humidity - math.random(1, 4))
		end --endif
	else
		if is_sensorok then
			sensor.read()
			M.temperature = (sensor.temperature / 100)
			M.humidity = (sensor.humidity / 100)
			M.pressure = math.floor(sensor.pressure) / 100
		else
			M.pressure = 0
			M.pressure = 0
			M.pressure = 0
			print('[!] Failed to start bme')
		end -- end if
	end

	return M.temperature, M.humidity, M.pressure
end --endfunction

-------------------------------------
-- Activates or deactivates temperature control
--
-- @param status "true" increments temperature, "false" temp decrements randomly
-------------------------------------
function M.heater(status --[[bool]])
	M.resistor = status
	if status then
		gpio.write(12, 0)
	else
		gpio.write(12, 1)
	end
	print(status)
	M.assertconditions()
end --endfuction

function M.assertconditions()
	print(M.temperature, M.testingmaxtem, M.testingmintem, M.resistor)
	if M.testing then
		if (M.temperature > M.testingmaxtem) then
			assert(not M.resistor)
		end --if
		if (M.temperature < M.testingmintem) then
			assert(M.resistor)
		end --if
	end -- if testing
end   --endfucition

-------------------------------------
-- Activates or deactivates humidity control
--
-- @param status "true" increments humidity, "false" humidity decrements randomly
-------------------------------------
function M.humidifier(status)
	humidifier = status
	if status then
		gpio.write(13, 0)
	else
		gpio.write(13, 1)
	end
	print(status)
end

return M
