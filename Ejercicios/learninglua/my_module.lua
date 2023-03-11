local my_module =  {}

-------------------------------------
-- What is this funciton doing ?
-- @param num1  ??
-- @param num2  ??
-- @return ??
-------------------------------------
function my_module.max(num1, num2)

   if (num1 > num2) then
      result = num1;
   else
      result = num2;
   end

   return result; 
end


-------------------------------------
-- Controls temperature
-- @param temperature in celcius.
-- @return "prender resistencia" if temp is grater than 38,"apagar resistencia"
-- if temp is lower than 39. otherwise "ok"
-------------------------------------
function my_module.temp_control(temperature)
  if temperature<38 then
    return ("prender resistencia")
  elseif temperature>39 then
    return ("apagar resistencia")
  end
  return "ok"
end


-------------------------------------
-- What is this funciton doing ?
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


my_module.reaction = {
  [1] = function (x) print(1) end,
  [2] = function (x) z = 5 end,
  ["nop"] = function (x) print(math.random()) end,
  ["my name"] = function (x) print("fred") end,
}





return my_module	


