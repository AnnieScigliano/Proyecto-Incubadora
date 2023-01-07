local pin_sda = 14
local pin_scl = 15
local id = 0
local direccion_dispositivo = 0x77
local direccion_registro = 0xD0

-- bmpChipSignature ) = 0x60

-- 0x88: Direccion de escritura para configurar el sensor
-- 0xF7: Direccion de lectura para leer datos del sensor
-- 0xF8: Direccion de lectura para leer los datos del sensor
-- 0xE1: Registro de calibracion para humedad
-- 0xE3: Registro de calibracion para la temperatura
-- 0xE4: Registro de calibracion para la presion atmosferica


-- inicializa i2c
i2c.setup(id, pin_sda, pin_scl, i2c.SLOW)

-- Lee dos bytes de la direccion de registro 0xD0

function leer_registro(id, direccion_dispositivo, direccion_registro)
	i2c.start(id)
	i2c.address(id, direccion_dispositivo, i2c.TRANSMITTER)
	i2c.write(id, direccion_registro)
	i2c.stop(id)
	i2c.start(id)
	i2c.address(id, direccion_dispositivo, i2c.RECEIVER)
	c = i2c.read(id, 4) -- Se usan 4 bytes por que el bme280 usa un formato de datos de 32bits
	i2c.stop(id)
	return c
end

-- registro de  0xF7

reg1 = leer_registro(id, 0x76, 0xF7)

print('Registro 0xF7: ' .. string.byte(reg1, 1)) -- imprime byte 1, 2, 3, 4
print('Registro 0xE1: ' .. string.byte(reg1, 2))
print('Registro 0xE1: ' .. string.byte(reg1, 3))
print('Registro 0xE1: ' .. string.byte(reg1, 4))


--registro de 0xF8

reg2 = leer_registro(id, 0x76, 0xF8)
print('Registro 0xF8: ' .. string.byte(reg2))

-- registro de 0xE1 
reg3 = leer_registro(id, 0x76, 0xE1)
print('Registro 0xE1: ' .. string.byte(reg3))

-- registro de 0xE3 

reg4 = leer_registro(id, 0x76, 0xE3)
print('Registro 0xE3: ' .. string.byte(reg4))

-- registro de 0xE4
reg5 = leer_registro(id, 0x76, 0xE4)
print('Registro de 0xE4: ' .. string.byte(reg4))

-- registro de 0xD0
reg6 = leer_registro(id,0x76, 0xD0)
print('Registro de 0xD0: ' .. string.byte(reg6))
