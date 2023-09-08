# Libs

import requests
import time
import board
from adafruit_bme280 import basic as adafruit_bme280


# Sensor Init
i2c = board.I2C()
bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)
bme280.sea_level_pressure = 389

# global variables
url = "http://grafana.altermundi.net:8086/write?db=cto"
initials = "sensor_fijo"
token_grafana = "token:e98697797a6a592e6c886277041e6b95"



#   -----------------------------------------------------------------------------------
#   @function send_message              to read the data from the bme sensor 
#                                       and send it by post request 
                                                
#   @var temperature                    stores the temperature returned by the internal
#                                       function of sensor
 
#   @var humidity                       stores the humidity returned by the internal 
#                                       function of sensor
 
#   @var pressure                       stores the pressure returned by the internal
#                                        function of sensor
 
#   @var initials                       user's initials, brought from credential.lua  
 
#   var current_time					time in nanosecconds since 1970
#   ----------------------------------------------------------------------------------


 
def send_message():
    temperature = bme280.temperature
    humidity = bme280.relative_humidity
    pressure = bme280.pressure

    current_time = int((time.time() - 120) * 1000000000)

    

    data = "mediciones,device=" + initials + " temp=" + str(temperature) + ",hum=" + str(humidity) + ",press=" + str(pressure) +" " + str(current_time)
    
    headers = {
        "Content-Type": "text/plain",
        "Authorization": "Basic " + token_grafana,
    }

    response = (requests.post(url=url, headers=headers, data=data))

    print("codigo de respuesta: ", response.status_code)



while True:
    print("\nTemperature: %0.1f C" % bme280.temperature)
    print("Humidity: %0.1f %%" % bme280.relative_humidity)
    print("Pressure: %0.1f hPa" % bme280.pressure)
    print("Altitude = %0.2f meters" % bme280.altitude)
    send_message()
    time.sleep(10)
