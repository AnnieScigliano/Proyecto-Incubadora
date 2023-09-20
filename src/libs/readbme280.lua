sensor = require('bme280')
if sensor.init(14,15,true) then 
    sensor.read()
    print(sensor.temperature)
    print(sensor.humidity)
end