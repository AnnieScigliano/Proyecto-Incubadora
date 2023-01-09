sensor=require('bme280')
if sensor.init(14,15,true) then -- volatile module
  print (sensor.read()) -- default sampling
end
carlos = 4
gpio.config( { gpio={carlos}, dir=gpio.OUT })
mytimer = tmr.create()
mytimer:register(500, tmr.ALARM_AUTO, function() gpio.write(carlos, 0)  end)
--mytimer:start()
mytimer2 = tmr.create()
mytimer2:register(600, tmr.ALARM_AUTO, function() gpio.write(carlos, 1)  end)
--mytimer2:start()

mytimer3 = tmr.create()
mytimer3:register(1000, tmr.ALARM_AUTO, function() print (sensor.read()) end)
mytimer3:start()