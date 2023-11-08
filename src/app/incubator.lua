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

require('credentials')

local M = {
	name                   = ..., -- module name, upvalue from require('module-name')
	model                  = nil, -- M model:
	resistor               = false,
	humidifier             = false,
	rotation               = false,
	temperature            = 99.9, -- integer value of temperature [0.01 C]
	pressure               = 0, -- integer value of preassure [Pa]=[0.01 hPa]
	humidity               = 0, -- integer value of rel.humidity [0.01 %]
	is_testing             = false,
	max_temp               = 38,
	min_temp               = 37.5,
	is_sensorok            = false,
	is_simulate_temp_local = false
}

_G[M.name] = M

local sensor = require('bme280')

function M.startbme()
	if sensor.init(GPIOBMESDA, GPIOBMESCL, true) then
		M.is_sensorok = true
	else
		M.is_sensorok = false
	end
end

function M.init_values()
	M.startbme()
	gpio.config({ gpio = { GPIOVOLTEO, GPIORESISTOR, 13, 12 }, dir = gpio.OUT })
	gpio.set_drive(13, gpio.DRIVE_3)
	gpio.set_drive(GPIOVOLTEO, gpio.DRIVE_3)
	gpio.set_drive(GPIORESISTOR, gpio.DRIVE_3)
	gpio.set_drive(12, gpio.DRIVE_3)
	gpio.write(13, 1)
	gpio.write(GPIOVOLTEO, 1)
	gpio.write(GPIORESISTOR, 1)
	gpio.write(12, 1)
end -- end function

-------------------------------------
-- @function enable_testing 	Enables testing mode asserting correct M funcioning
--
-- @param min 								is equal to the minimum temperature to test
-- @param max 								is equal to the maximum temperature to test
-------------------------------------
function M.enable_testing(simulatetemp)
	M.is_testing = true;
	M.is_simulate_temp_local = simulatetemp
end --end function

-------------------------------------
-- simulates a change in sensors acording to actuators and returns sensor readings
--
-- @returns temperature, humidity, pressure
-------------------------------------
function M.get_values()
	if M.is_simulate_temp_local then
		if M.resistor then
			M.temperature = (M.temperature + 1)
		else
			M.temperature = (M.temperature - math.random(1, 15))
		end --end if

		if M.humidifier then
			M.humidity = (M.humidity + 1)
		else
			M.humidity = (M.humidity - math.random(1, 4))
		end --end if
	else
		M.startbme()
		if M.is_sensorok then
			sensor.read()
			print("temp ", sensor.temperature)
			if (sensor.temperature / 100)< -40 or (sensor.temperature / 100) > 86 then
				M.temperature = 99.9
				M.humidity = 99.9
				M.pressure = 99.9
				print('[!] Failed to read bme')
				alerts.send_alert_to_grafana("[!] Failed to read bme")
				--try to restart bme
			else
				M.temperature = (sensor.temperature / 100)
				M.humidity = (sensor.humidity / 100)
				M.pressure = (sensor.pressure) / 100
			end
		else
			M.temperature = 99.9
			M.humidity = 99.9
			M.pressure = 99.9
			alerts.send_alert_to_grafana("[!] Failed to start bme")
			print('[!] Failed to start bme')
		end -- end if
	end --if end

	return M.temperature, M.humidity, M.pressure
end --end function

-------------------------------------
-- @function heater 					Activates or deactivates heater
--
-- @param status "true" 			increments temperature, "false" temp "decrements"
-------------------------------------
function M.heater(status --[[bool]])
	M.resistor = status
	if status then
		gpio.write(GPIORESISTOR, 0)
	else
		gpio.write(GPIORESISTOR, 1)
	end
	print(status)
	M.assert_conditions()
end --end function

function M.assert_conditions()
	print("temp actual ", M.temperature, ", max ", M.max_temp, ",min ", M.min_temp, ",resitor status ", M.resistor)
	if M.is_testing then
		if (M.temperature > M.max_temp and M.resistor) then
			alerts.send_alert_to_grafana("temperature > max_temp and resistor is on")
			--assert(not M.resistor)
		end --if end
		if (M.temperature < M.min_temp and not M.resistor) then
			alerts.send_alert_to_grafana("temperature < M.min_temp and resistor is off")
			--assert(M.resistor)
		end --if end
	end -- if is_testing
end   --end fucition

-------------------------------------
-- @function humidifier 			Activates or deactivates humidifier
--
-- @param status "true" 		  increments humidity, "false" humidity "decrements"
-------------------------------------
function M.humidifier(status)
	humidifier = status
	if status then
		gpio.write(14, 0)
	else
		gpio.write(14, 1)
	end -- if end
	print("humidifier ", status)
end  -- function end

-------------------------------------
-- @function rotation 			Activates or deactivates rotation
--
-- @param status "true" activates rotation, "false" stops rotation
-------------------------------------
function M.rotation(status)
	rotation = status
	if status then
		gpio.write(GPIOVOLTEO, 0)
	else
		gpio.write(GPIOVOLTEO, 1)
	end -- if end
	--todo: implement logger for debug
	print("rotation ", status)
end -- function end

return M
