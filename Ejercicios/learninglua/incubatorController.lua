-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--  anabella scigliano
--
--  License:
-----------------------------------------------------------------------------
incubator = require("incubator")

------------------------------------------------------------------------------------
-- ! @function tempcontrol						activates or deactivates temperature control 
-- !                                             
-- ! @param temperature							saves sensor temperature
--	
-- ! @const temp_on								saves maximum temperature
-- ! @const temp_off 							saves minimum temperature
--
------------------------------------------------------------------------------------

function tempcontrol(temperature, temp_on, temp_off)

	if temperature <= temp_on then
		incubator.heater(true)
	elseif temperature >= temp_off then
		incubator.heater(false)
	end -- end if

end -- end function

------------------------------------------------------------------------------------
-- ! @function humidity_control					activates or deactivates humidity control 
-- !                                             
-- ! @param humidity							saves sensor humidity
--	
-- ! @const hum_on								saves maximum humidity
-- ! @const hum_off								saves minimum humidity
--
------------------------------------------------------------------------------------

function humidity_control(humidity, hum_on, hum_off)

	if humidity <= hum_on then
		incubator.humidifier(true)
	elseif humidity >= hum_off then
		incubator.humidifier(false)		
	end -- end if

end -- end function

local clock = os.clock
function sleep(n) -- seconds
	local t0 = clock()
	while clock() - t0 <= n do
	end -- end while
end

while (true) do
	--os.execute("sleep " .. tonumber(1))
	sleep(1)

	temperature,humidity,pressure=incubator.getValues()

	tempcontrol(temperature, 36, 38)
	humidity_control(humidity,10, 20)
	
	print('Temperatura actual: ' .. incubator.temperature)
	print('Humedad actual: ' .. incubator.humidity)

end -- end while