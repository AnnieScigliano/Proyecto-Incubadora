--gpio.config( {gpio = {2}, dir= gpio.INPUT})

--print(dht.OK) 
--print(dht.ERROR_CHECKSUM) 
--print(dht.ERROR_TIMEOUT)

pin = 2
status, temp, humi, temp_dec, humi_dec = dht.read2x(pin)
if status == dht.OK then
    -- Integer firmware using this example
    print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
          math.floor(temp),
          temp_dec,
          math.floor(humi),
          humi_dec
    ))

    -- Float firmware using this example
    print("DHT Temperature:"..temp..";".."Humidity:"..humi)

elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
end
