import pandas as pd
from prettytable import PrettyTable

# Ruta de archivo CSV
df = pd.read_csv('/home/root/Ejemplo1.cvs')

# Calcular el promedio para cada sensor
promedio_sensor_fijo = df['FIJO-bme'].mean()
promedio_sensor_movil = df['Sensor-movil-Punto-5-bme'].mean()

# Crear una tabla para mostrar los promedios
tabla_promedios = PrettyTable()
tabla_promedios.field_names = ['Sensor', 'Promedio']
tabla_promedios.add_row(['FIJO-bme', f'{promedio_sensor_fijo:.2f}'])
tabla_promedios.add_row(['Sensor-movil-Punto-5-bme', f'{promedio_sensor_movil:.2f}'])

print("\n")
print("\n")
print("\n")


print('Promedios de humedad por sensor:')
print(tabla_promedios)

print("\n")
print("\n")
print("\n")
