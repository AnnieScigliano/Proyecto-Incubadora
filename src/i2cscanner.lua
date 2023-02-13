-- Based on work by sancho and zeroday among many other open source authors
-- This code is public domain, attribution to gareth@l0l.org.uk appreciated.

id=0  -- need this to identify (software) IC2 bus?
gpio_pin= {5,4,0,2,14,12,13} -- this array maps internal IO references to GPIO numbers

-- user defined function: see if device responds with ACK to i2c start
function find_dev(i2c_id, dev_addr)
     i2c.start(i2c_id)
     c=i2c.address(i2c_id, dev_addr ,i2c.TRANSMITTER)
     i2c.stop(i2c_id)
     return c
end

print("Scanning all pins for I2C Bus device")
scl=0 
sda=16
          ---tmr.wdclr() -- call this to pat the (watch)dog!

       i2c.setup(id,sda,scl,i2c.SLOW) -- initialize i2c with our id and current pins in slow mode :-)
       for i=0,127 do -- TODO - skip invalid addresses
            if find_dev(id, i)==true then
            print("Device found at address 0x"..string.format("%02X",i))

            end
       end
