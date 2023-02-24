--Crear un módulo mymath.lua que realice estas operaciones
mymathmodule = require("my_math")

print(mymathmodule.add(10,20))
assert(mymathmodule.add(10,20)==30)

print(mymathmodule.sub(30,20))
assert(mymathmodule.sub(30,20)==10)

print(mymathmodule.mul(10,20))
assert(mymathmodule.mul(10,20)==200)

print(mymathmodule.div(30,19))
-- Deberiía imprimir 1.5789473684211


-- crear otro módulo que implement la funcion máx, format y la función control 
---la funcion  max debe devolver el mayor de dos numeros 
my_module = require("my_module")

function my_module.max(num1,num2)
    if num1>num2 then 
        return num1 
    else
        return num2
    end
end


resutl = my_module.max(54,545)
print (resutl)
assert(resutl==545)

resutl = my_module.max(54,53)
print (resutl)
assert(resutl==54)

accion = my_module.humidity_control(10)
print (accion)
assert (accion=="aumentar superficie")

accion = my_module.humidity_control(99)
print (accion)
assert (accion=="reducir superficie")

accion = my_module.humidity_control(60)
print (accion)
assert (accion=="ok")



accion = my_module.temp_control(35)
print (accion)
assert (accion=="prender resistencia")


accion = my_module.temp_control(42)
print (accion)
assert (accion=="apagar resistencia")

accion = my_module.temp_control(38.5)
print (accion)
assert (accion=="ok")

accion = my_module.temp_control(10)
print (accion)
assert (accion=="prender resistencia")


