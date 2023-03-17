-----------------------------------------------------------------------------
--  This is the reference implementation to train lua functions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--	Santiago Rodriguez Cetran
--
--  License:
-----------------------------------------------------------------------------
incubator = require("incubator")

------------------------------------------------------
--function tempcontrol		controls when to turn incubator.heater on and off 
--param temperature			the temperature of the incubator
--param temp_on				sets the temperature for the heater to start
--param temp_off			sets the temperature for the heater to stop
------------------------------------------------------

function tempcontrol(temperature, temp_on, temp_off)

	local temp_on = 36
	local temp_off = 38

	if temperature <= temp_on then
		incubator.heater(true)
	elseif temperature >= temp_off then
		incubator.heater(false)
	end --end if

end --end function

------------------------------------------------------
--function humcontrol		controls when to turn incubator.humidifier on and off					
--param hum_on				sets humidifier on
--param hum_off				sets humidifier off
------------------------------------------------------

function humcontrol(humidity, hum_on, hum_off)

	local hum_on = hum_on
	local hum_off = hum_off

	if humidity <= hum_on then
		incubator.humidifier(true)
	elseif humidity >= hum_off then
		incubator.humidifier(false)
	end -- end if

end -- end function

------------------------------------------------------
--function sleep	sets a timer
------------------------------------------------------

local clock = os.clock
function sleep(n) -- seconds

	local t0 = clock()
	while clock() - t0 <= n do
	end --end while

end --end function

------------------------------------------------------
-- changes the values every one second	
------------------------------------------------------

while (true)
do
	--os.execute("sleep " .. tonumber(1))
	sleep(1)

	incubator.getValues()
	temperature = incubator.temperature
	humidity = incubator.humidity
	pressure = incubator.pressure


	tempcontrol(temperature, 36, 38)
	humcontrol(humidity, 10, 20)

	print('Temperatura actual: ' .. incubator.temperature)
	print('Humedad actual: ' .. incubator.humidity)

end --end while


