-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License:
-----------------------------------------------------------------------------
incubator = require("incubator")


function tempcontrol(temp, temp_on, temp_off)
	if temp <= temp_on then
		incubator.heater(true)
	elseif temp >= temp_off then
		incubator.heater(false)
	end -- end if
end --end fucntion

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
	incubator.enableTesting(36,38)
	print(".")
	temp,hum,pres=incubator.getValues()
	tempcontrol(temp, 36, 38)
	incubator.assertconditions()

end
