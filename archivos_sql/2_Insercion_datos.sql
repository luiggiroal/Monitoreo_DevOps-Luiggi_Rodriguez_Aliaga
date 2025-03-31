-- ##############################
-- ##### Inserción de datos #####
-- ##############################


-- OJO: Las rutas de directorio para cada caso deben ser adaptadas en función
-- donde esté ubicado el archivo .csv en la máquina local donde se corre el 
-- script SQL. MySQL sólo acepta rutas absolutas.
-- Dependiendo el caso, quizás deba modificar la configuración local del MySQL
-- para cargar los archivos .csv desde cualquier directorio, de lo contrario, 
-- remover 'local' de los comandos de carga y ubicar los archivos .csv en el
-- directorio donde MySQL por defecto recupera tales archivos.

-- Cargando data desde 'equipo.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/archivos_sql/csv_files/equipo.csv'
into table equipo
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n' -- Se usa '\r\n' para finales de línea en archivos .csv creados en Windows. Usar '\n' para archivos .csv creados en Unix/Linux.
ignore 1 rows;

-- Cargando data desde 'pipeline.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/archivos_sql/csv_files/pipeline.csv'
into table pipeline
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'artefacto.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/archivos_sql/csv_files/artefacto.csv'
into table artefacto
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'entorno_despliegue.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/archivos_sql/csv_files/entorno_despliegue.csv'
into table entorno_despliegue
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'configuracion_entorno.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/archivos_sql/csv_files/configuracion_entorno.csv'
into table configuracion_entorno
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'despliegue.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/archivos_sql/csv_files/despliegue.csv'
into table despliegue
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'incidente.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/archivos_sql/csv_files/incidente.csv'
into table incidente
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
