-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License:
-----------------------------------------------------------------------------
incubator = require("incubator")


function tempcontrol(temperature, TEMP_ON, TEMP_OFF)

	local TEMP_ON = 36
	local TEMP_OFF = 38

	if temperature <= TEMP_ON then
		incubator.heater(true)
	elseif temperature >= TEMP_OFF then
		incubator.heater(false)
	end

end

function humidity_control(humidity, HUM_ON, HUM_OFF)

	local HUM_ON = HUM_ON
	local HUM_OFF = HUM_OFF

	if humidity <= HUM_ON then
		incubator.humidifier(true)
	elseif humidity >= HUM_OFF then
		incubator.humidifier(false)		
	end

end

local clock = os.clock
function sleep(n) -- seconds
	local t0 = clock()
	while clock() - t0 <= n do
	end
end

while (true) do
	--os.execute("sleep " .. tonumber(1))
	sleep(1)

	incubator.getValues()
	temperature = incubator.temperature
	humidity = incubator.humidity
	pressure = incubator.preassure

	tempcontrol(temperature, 36, 38)
	humidity_control(humidity,10, 20)
	
	print('Temperatura actual: ' .. incubator.temperature)
	print('Humedad actual: ' .. incubator.humidity)

end