#!/bin/bash

# Para ejecutar las pruebas

echo "Ejecución de pruebas"
echo "Seleccione una opción"
echo "1 - Deserializacion."
echo "2 - Serializacion."
echo "3 - Pad bidireccional."

read opt


if [ $opt -eq 1 ]
then
	(cd ../.. ; vvp bin/tests/cmd/test_deserializer)
fi

if [ $opt -eq 2 ]
then
	(cd ../.. ; vvp bin/tests/cmd/test_serializer)
fi

if [ $opt -eq 3 ]
then
	(cd ../.. ; vvp bin/tests/cmd/test_bidir_pad)
fi

if [ $opt -gt 3 ] || [ $opt -lt 0 ]
then
	echo "No existe tal prueba."
fi