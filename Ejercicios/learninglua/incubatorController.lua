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

end

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
	
	tempcontrol(temp, 36, 38)
end
