-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It
--  implements part of the core functionality and has some incomplete comments.
--
--  Santiago Rodriguez Cetran
--
--  License:
-----------------------------------------------------------------------------


local my_module = {}

-------------------------------------
-- function shows the higher number
--
-- @param num1  any
-- @param num2  any
-- @return higher
-------------------------------------
function my_module.max(num1, num2)
  if num1 > num2 then
    return num1
  else
    return num2
  end
end

-------------------------------------
-- Controls temperature
--
-- @param temperature in celcius.
-- @return "prender resistencia" if temp is greater than 38,"apagar resistencia"
-- if temp is lower than 39. otherwise "ok"
-------------------------------------
function my_module.temp_control(temperature)
  if temperature > 38 then
    return ("apagar resistencia")
  elseif temperature < 38 then
    return ("prender resistencia")
  elseif temperature == 38 then
    return ("ok")
  end --end if
end --end function

-------------------------------------
-- Controls humidity
--
-- @param humidity  in air
-- @return 
-------------------------------------
function my_module.humidity_control(humidity)
  if humidity < 30 then
    return ("aumentar superficie")
  elseif humidity > 90 then
    return ("reducir superficie")
  end
  return "ok"
end

return my_module
