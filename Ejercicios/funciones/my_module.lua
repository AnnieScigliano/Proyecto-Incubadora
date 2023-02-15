-----------------------------------------------------------------------------
--  This is the reference implementation to train lua fucntions. It 
--  implements part of the core functionality and has some incomplete comments.
--
--  javier jorge
--
--  License: 
-----------------------------------------------------------------------------


local my_module =  {}

-------------------------------------
-- What is this funciton doing ?
--
-- @param num1  ??
-- @param num2  ??
-- @return ??
-------------------------------------
function my_module.max(num1, num2)
  return num1
end


-------------------------------------
-- Controls temperature
--
-- @param temperature in celcius.
-- @return "prender resistencia" if temp is grater than 38,"apagar resistencia"
-- if temp is lower than 39. otherwise "ok"
-------------------------------------
function my_module.temp_control(temperature)
  return nil
end


-------------------------------------
-- What is this funciton doing ?
--
-- @param humidity  ??
-- @return ??
-------------------------------------
function my_module.humidity_control(humidity)
  if humidity<30 then
    return ("aumentar superficie")
  elseif humidity>90 then
    return ("reducir superficie")
  end
  return "ok"
end

return my_module	


