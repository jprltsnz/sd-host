#!/bin/bash

# Para ejecutar las pruebas

echo "Ejecución de pruebas"
echo "Seleccione una opción"
echo "1 - Deserializacion."
echo "2 - Serializacion"

read opt


if [ $opt -eq 1 ]
then
	(cd ../.. ; vvp bin/tests/cmd/test_deserializer)
fi

if [ $opt -eq 2 ]
then
	(cd ../.. ; vvp bin/tests/cmd/test_serializer)
fi

if [ $opt -gt 6 ] || [ $opt -lt 0 ]
then
	echo "No existe tal prueba."
fi