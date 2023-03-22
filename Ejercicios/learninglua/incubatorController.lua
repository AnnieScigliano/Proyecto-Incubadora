-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License:
-----------------------------------------------------------------------------
incubator = require("incubator")


function tempcontrol(temperature, temp_on, temp_off)

	if temperature <= temp_on then
		incubator.heater(true)
	elseif temperature >= temp_off then
		incubator.heater(false)
	end -- end if

end -- end function

local clock = os.clock

function sleep(n) -- seconds
	local t0 = clock()
	while clock() - t0 <= n do
	end
end

while (true)
do
	--os.execute("sleep " .. tonumber(1))
	sleep(1)
	incubator.enableTesting(30,35)
	print(".")
	temp,hum,pres=incubator.getValues()
	tempcontrol(temp, 30, 35)
	incubator.assertconditions()

end
