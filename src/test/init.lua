pin = 2

function printdht()
status, temp, humi, temp_dec, humi_dec = dht.read2x(pin)
if status == dht.OK then
    -- Integer firmware using this example

    print(string.format("DHT:    p=xxx\[hPa\];t:%d\[C\];h:%d\[%%\] \r\n",
          math.floor(temp),
          math.floor(humi)
    ))
    -- Float firmware using this example
    -- print("DHT Temperature:"..temp..";".."Humidity:"..humi)

elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
end
end

printdht()

sensor=require('bme280')
if sensor.init(14,15,false) then -- volatile module
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
mytimer3:register(4000, tmr.ALARM_AUTO, function()  print (sensor.read()) printdht() end)
mytimer3:start()
