# sudo apt install python3-flask
# esp32_rest_api_ref.py
# flask --app esp32_rest_api_ref run
import time
from flask import Flask, jsonify
from flask import request
from flask import Response
import json

app = Flask(__name__)
app.debug = True

html_content = """

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rest Api</title>
</head>
<body>
    <h1i>API REST de prueba</h1>
</body>
</html>

"""



@app.route("/")
def hello_world():
    return html_content

min_temperature = 33
max_temperature = 38
rotation_duration = 3500000
rotation_period = 5000
ssid = "mimimi"
passwd = "1234"
tray_one_date = 1000000
tray_two_date = 500000
tray_three_date = 0
incubation_period = 18
hash_value = 12345

config_dict = {
    "min_temperature": min_temperature,
    "max_temperature": max_temperature,
    "rotation_duration": rotation_duration,
    "rotation_period": rotation_period,
    "ssid": ssid,
    "passwd": passwd,
    "tray_one_date": tray_one_date,
    "tray_two_date": tray_two_date,
    "tray_three_date": tray_three_date,
    "incubation_period": incubation_period,
    "hash": hash_value,
}

a_temperature = 99.90
a_humidity = 99.90
a_pressure = 99.90

actual_dict = {
    "a_temperature": a_temperature,
    "a_humidity": a_humidity,
    "a_pressure": a_pressure,
}

config_json = json.dumps(config_dict)
actual_json = json.dumps(actual_dict)
print(config_json)
print(actual_json)


@app.route("/config", methods=["GET", "POST"])
def config_geter():

    if request.method == "GET":
        return jsonify(json.loads(config_json))

@app.route("/actual", methods=["GET", "POST"])
def actual_getter():
    if request.method == "GET":
        return jsonify(json.loads(actual_json))
