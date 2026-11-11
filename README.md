## Descripcion
En el siguiente proyecto se realiza la limpieza, carga y consultas del Sample - Superstore.csv para analizar su información y llegar a conclusiones.

## Requisitos

- Docker Desktop con integración WSL 2 habilitada.
- Ubuntu en WSL 2.
- Ejecutar los comandos desde la carpeta del proyecto.

## Procedimiento
- Inicialización de entorno
- Carga de csv y creacion de tablas
- Consultas Hive

## Archivos principales

- `docker-compose-hive.yml`: servicios NameNode, DataNode y Hive.
- `hive/Dockerfile`: instalación de Hive y metastore Derby.
- `sql/`: consultas del examen.
- `docs/diccionario.docx`: diccionario de las 21 columnas.
- `scripts/`: iniciar, detener, cargar datos, ejecutar análisis y abrir Hive.