-----------------------------------------------------------------------------
--  This is the reference implementation to simulate the M.
--  this model implements an icubator whos ambient temperatura is always
--  below the control temperature. It also suposes tha when you turn on actuators
--  variables change.
--
-- Copyright (c) 2023  Javier Jorge <jjorge@inti.gob.ar>
-- todo: add jere annie santi ... 
-- Copyright (c) 2023  Instituto Nacional de Tecnología Industrial
-- Copyright (C) 2023  Asociación Civil Altermundi <info@altermundi.net>
--
--  SPDX-License-Identifier: AGPL-3.0-only

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
	is_testing    = false,
	testing_max_tem = 0,
	testing_min_tem = 0,
	
}

_G[M.name]=M

local sensor = require('bme280')
local is_simulate_temp_local = false
local is_sensorok = false

function M.init_values()
	if sensor.init(GPIOBMESDA, GPIOBMESCL, true) then
		is_sensorok = true
	end -- end if
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
-- @function enable_testing 	Enables testing mode asserting correct M funcioning
--
-- @param min 								is equal to the minimum temperature to test
-- @param max 								is equal to the maximum temperature to test
-------------------------------------
function M.enable_testing(min, max,simulatetemp)
	M.is_testing = true;
	is_simulate_temp_local= simulatetemp
	M.testing_max_tem = max
	M.testing_min_tem = min
end --end function

-------------------------------------
-- simulates a change in sensors acording to actuators and returns sensor readings
--
-- @returns temperature, humidity, pressure
-------------------------------------
function M.get_values()
	if is_simulate_temp_local then
		if M.resistor then
			M.temperature = (M.temperature + 1)
		else
			M.temperature = (M.temperature - math.random(1, 4))
		end --end if

		if M.humidifier then
			M.humidity = (M.humidity + 1)
		else
			M.humidity = (M.humidity - math.random(1, 4))
		end --end if
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
	end --if end 

	return M.temperature, M.humidity, M.pressure
end --end function

-------------------------------------
-- @function heater 					Activates or deactivates temperature control
--
-- @param status "true" 			increments temperature, "false" temp decrements randomly
-------------------------------------
function M.heater(status --[[bool]])
	M.resistor = status
	if status then
		gpio.write(12, 0)
	else
		gpio.write(12, 1)
	end
	print(status)
	M.assert_conditions()
end --end function

function M.assert_conditions()
	print(M.temperature, M.testing_max_tem, M.testing_min_tem, M.resistor)
	if M.is_testing then
		if (M.temperature > M.testing_max_tem) then
			assert(not M.resistor)
		end --if end 
		if (M.temperature < M.testing_min_tem) then
			assert(M.resistor)
		end --if end 
	end -- if is_testing
end   --end fucition

-------------------------------------
-- @function humidifier 			Activates or deactivates humidity control
--
-- @param status "true" 		  increments humidity, "false" humidity decrements randomly
-------------------------------------
function M.humidifier(status)
	humidifier = status
	if status then
		gpio.write(13, 0)
	else
		gpio.write(13, 1)
	end -- if end 
	print(status)
end -- function end 

return M
