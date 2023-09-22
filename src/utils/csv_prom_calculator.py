# libreria para analisis de datos en python
import pandas as pd

# Este Script analiza dos columnas de datos en un archivo .csv
# y calcula el promedio entre ellas
# Es util para ver el promedio entre las lecturas de dos sensores

# ruta del archivo 
archivo_csv = "/home/root/ejemplo1.csv"
nombre_de_primer_columna = "FIJO-bme"
nombre_de_segunda_columna = "Sensor-movil-Punto-5-bme"



# Lee el archivo y crea un dataframe
df = pd.read_csv(archivo_csv)



# selecciona las columnas y calcula el promedio de cada fila (axis=1)
df["Promedio de X"] = df[[nombre_de_primer_columna,nombre_de_segunda_columna ]].mean(axis=1)

#reemplazar X por lo que sea que se esté comparando

# imprime una tabla con el tiempo, c
print("\n")
print("\n")

print(df)

print("\n")
print("\n")

