-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge 
--  Jere Castro
--
--  License: 
-----------------------------------------------------------------------------

incubator = require("incubator") -- module 

-----------------------------------------------------------------------------
--  @function temp_control				activates or deactivates temperature control 
--  @param temperature 					save sensor temperature
-- 	@const TEMP_ON 							save maximum temperature
-- 	@const TEMP_ON 							save minimum temperature
-----------------------------------------------------------------------------
function temp_control(temperature, TEMP_ON, TEMP_OFF)

	local TEMP_ON = TEMP_ON
	local TEMP_OFF = TEMP_OFF

	if temperature <= TEMP_ON then
		incubator.heater(true)
	elseif temperature >= TEMP_OFF then
		incubator.heater(false)
	end -- end if

end -- end temp_control

-----------------------------------------------------------------------------
--  @function humidity_control	activates or deactivates humidity control 
--  @param temperature 					save sensor humidity
-- 	@const TEMP_ON 							save maximum humidity
-- 	@const TEMP_ON 							save minimum humidity
-----------------------------------------------------------------------------

function humidity_control(humidity, HUM_ON, HUM_OFF)

	local HUM_ON = HUM_ON
	local HUM_OFF = HUM_OFF

	if humidity <= HUM_ON then
		incubator.humidifier(true)
	elseif humidity >= HUM_OFF then
		incubator.humidifier(false)
	end -- end if

end -- end humidity_control

local clock = os.clock
function sleep(n) -- seconds
	local t0 = clock()
	while clock() - t0 <= n do
	end -- end while 
end -- end sleep

while (true) do
	--os.execute("sleep " .. tonumber(1))
	sleep(1)

	incubator.getValues()
	temperature = incubator.temperature
	humidity = incubator.humidity
	pressure = incubator.preassure

	temp_control(temperature, 36, 38)
	humidity_control(humidity,10, 20)
	print('Temperatura actual: ' .. incubator.temperature)
	print('Humedad actual: ' .. incubator.humidity)

end