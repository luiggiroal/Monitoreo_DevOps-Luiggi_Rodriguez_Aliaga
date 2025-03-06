-- #####################################
-- ##### Creación de base de datos #####
-- #####################################


DROP DATABASE IF EXISTS monitoreo_devops;
CREATE DATABASE IF NOT EXISTS monitoreo_devops;
USE monitoreo_devops;


-- ##############################
-- ##### Creación de tablas #####
-- ##############################


DROP TABLE IF EXISTS equipo;
CREATE TABLE IF NOT EXISTS equipo (
    id_equipo INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    canal_discord VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT pk_equipo PRIMARY KEY (id_equipo)
);

DROP TABLE IF EXISTS pipeline;
CREATE TABLE IF NOT EXISTS pipeline (
    id_pipeline INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    repositorio_url VARCHAR(200) NOT NULL UNIQUE,
    id_equipo INT NOT NULL,
    CONSTRAINT pk_pipeline PRIMARY KEY (id_pipeline),
    CONSTRAINT fk_pipeline_equipo FOREIGN KEY (id_equipo)
        REFERENCES equipo (id_equipo)
);

DROP TABLE IF EXISTS artefacto;
CREATE TABLE IF NOT EXISTS artefacto (
    id_artefacto INT AUTO_INCREMENT,
    version_artefacto VARCHAR(20) NOT NULL UNIQUE,
    fecha_generacion DATETIME NOT NULL,
    id_pipeline INT NOT NULL,
    CONSTRAINT pk_artefacto PRIMARY KEY (id_artefacto),
    CONSTRAINT fk_artefacto_pipeline FOREIGN KEY (id_pipeline)
        REFERENCES pipeline (id_pipeline)
);

DROP TABLE IF EXISTS entorno_despliegue;
CREATE TABLE IF NOT EXISTS entorno_despliegue (
    id_entorno INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    tipo ENUM('Prod', 'Staging', 'Test') NOT NULL,
    CONSTRAINT pk_entorno PRIMARY KEY (id_entorno)
);

DROP TABLE IF EXISTS configuracion_entorno;
CREATE TABLE IF NOT EXISTS configuracion_entorno (
    id_configuracion INT AUTO_INCREMENT,
    llave VARCHAR(50) NOT NULL,
    valor VARCHAR(200) NOT NULL,
    id_entorno INT NOT NULL,
    CONSTRAINT pk_configuracion PRIMARY KEY (id_configuracion),
    CONSTRAINT fk_configuracion_entorno FOREIGN KEY (id_entorno)
        REFERENCES entorno_despliegue (id_entorno)
);

DROP TABLE IF EXISTS despliegue;
CREATE TABLE IF NOT EXISTS despliegue (
    id_despliegue INT AUTO_INCREMENT,
    status_despliegue ENUM('Success', 'Failed', 'Pending') NOT NULL,
    fecha_despliegue DATETIME NOT NULL,
    id_pipeline INT NOT NULL,
    id_artefacto INT NOT NULL,
    id_entorno INT NOT NULL,
    CONSTRAINT pk_despliegue PRIMARY KEY (id_despliegue),
    CONSTRAINT fk_despliegue_pipeline FOREIGN KEY (id_pipeline)
        REFERENCES pipeline (id_pipeline),
    CONSTRAINT fk_despliegue_artefacto FOREIGN KEY (id_artefacto)
        REFERENCES artefacto (id_artefacto),
    CONSTRAINT fk_despliegue_entorno FOREIGN KEY (id_entorno)
        REFERENCES entorno_despliegue (id_entorno),
    INDEX idx_status (status_despliegue)
);

DROP TABLE IF EXISTS incidente;
CREATE TABLE IF NOT EXISTS incidente (
    id_incidente INT AUTO_INCREMENT,
    severidad ENUM('Low', 'Medium', 'High') NOT NULL,
    status_incidente ENUM('Open', 'Closed') NOT NULL,
    id_despliegue INT NOT NULL,
    CONSTRAINT pk_incidente PRIMARY KEY (id_incidente),
    CONSTRAINT fk_incidente_despliegue FOREIGN KEY (id_despliegue)
        REFERENCES despliegue (id_despliegue),
    INDEX idx_status (status_incidente)
);

-- Tabla de auditoría
drop table if exists log_auditoria;
create table if not exists log_auditoria (
	id_log int auto_increment,
    campoNuevo_campoAnterior varchar(255),
    accion varchar(40),
    tabla varchar(50),
    usuario varchar(100),
    fecha_modificacion datetime,
    constraint pk_incidente_log
		primary key (id_log)
);


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
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/csv_files/equipo.csv'
into table equipo
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n' -- Se usa '\r\n' para finales de línea en archivos .csv creados en Windows. Usar '\n' para archivos .csv creados en Unix/Linux.
ignore 1 rows;

-- Cargando data desde 'pipeline.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/csv_files/pipeline.csv'
into table pipeline
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'artefacto.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/csv_files/artefacto.csv'
into table artefacto
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'entorno_despliegue.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/csv_files/entorno_despliegue.csv'
into table entorno_despliegue
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'configuracion_entorno.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/csv_files/configuracion_entorno.csv'
into table configuracion_entorno
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'despliegue.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/csv_files/despliegue.csv'
into table despliegue
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Cargando data desde 'incidente.csv'
load data local infile 'C:/Users/Luigg/coderhouse/sql/4_[Primera_Entrega]/sistema_Monitoreo_Pipelines_DevOps/csv_files/incidente.csv'
into table incidente
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;


-- ##################
-- ##### Vistas #####
-- ##################


create or replace view vw_despliegue_panorama as
select d.id_despliegue 'ID Despliegue', p.nombre 'Pipeline',
	   p.repositorio_url 'Repositorio Pipeline',
	   a.version_artefacto 'Versión Artefacto',
       a.fecha_generacion 'Fecha Generación Artefacto',
       d.status_despliegue 'Estado Despliegue',
       d.fecha_despliegue 'Fecha Despliegue',
       e.nombre 'Entorno Despliegue',
       e.tipo 'Tipo Despliegue'
from despliegue d
	join pipeline p on d.id_pipeline = p.id_pipeline
    join artefacto a on d.id_artefacto = a.id_artefacto
    join entorno_despliegue e on d.id_entorno = e.id_entorno;

create or replace view vw_incidente_panorama as
select i.id_incidente 'ID Incidente', i.severidad 'Severidad Incidente',
	   i.status_incidente 'Estado Incidente',
       d.status_despliegue 'Estado Despliegue',
       d.fecha_despliegue 'Fecha Despliegue',
       p.nombre 'Pipeline',
       p.repositorio_url 'Repositorio Pipeline',
       e.nombre 'Entorno Despliegue',
       e.tipo 'Tipo Despliegue'
from incidente i
	join despliegue d on i.id_despliegue = d.id_despliegue
    join pipeline p on d.id_pipeline = p.id_pipeline
    join entorno_despliegue e on d.id_entorno = e.id_entorno;

create or replace view vw_equipo_configuracion_entorno as
select e.id_equipo 'ID Equipo', e.nombre 'Equipo',
	   e.canal_discord 'Canal Discord Equipo',
       c.llave 'Llave Configuración Entorno',
       c.valor 'Valor Configuración Entorno',
       ed.nombre 'Entorno Despliegue',
       ed.tipo 'Tipo Despliegue'
from equipo e
	join pipeline p on e.id_equipo = p.id_equipo
    join despliegue d on d.id_pipeline = p.id_pipeline
    join entorno_despliegue ed on d.id_entorno = ed.id_entorno
    join configuracion_entorno c on ed.id_entorno = c.id_entorno;


-- #####################
-- ##### Funciones #####
-- #####################


drop function if exists fn_getStatusDespliegue;
delimiter //
create function fn_getStatusDespliegue(p_id_despliegue int)
returns varchar(20)
deterministic
begin
	declare v_status_despliegue varchar(20);
    
    select status_despliegue
    into v_status_despliegue
    from despliegue
    where id_despliegue = p_id_despliegue;
    
    return v_status_despliegue;
end //
delimiter ;

drop function if exists fn_countIncidentes;
delimiter //
create function fn_countIncidentes(p_severidad varchar(20))
returns int
deterministic
begin
	declare v_count int;
    
	select count(*)
    into v_count
    from incidente
    where severidad = p_severidad;
    
    return v_count;
end //
delimiter ;


-- #############################
-- ##### Stored Procedures #####
-- #############################


drop procedure if exists sp_getDespliegues;
delimiter //
create procedure sp_getDespliegues(in p_status_despliegue varchar(20))
begin
	select d.id_despliegue 'ID Despliegue',
		   p.nombre 'Pipeline',
           p.repositorio_url 'Repositorio Pipeline',
           e.nombre 'Entorno Despliegue',
           e.tipo 'Tipo Entorno Despliegue',
           d.fecha_despliegue 'Fecha Despliegue'
    from despliegue d
		join pipeline p on d.id_pipeline = p.id_pipeline
        join entorno_despliegue e on d.id_entorno = e.id_entorno
	where d.status_despliegue = p_status_despliegue;
end //
delimiter ;

drop procedure if exists sp_agregarNuevoArtefacto;
delimiter //
create procedure sp_agregarNuevoArtefacto(in p_id_pipeline int,
										  in p_version_artefacto varchar(20),
										  in p_fecha_generacion datetime)
begin
	if exists (select 1 from pipeline p where p.id_pipeline = p_id_pipeline) then
		insert into artefacto(version_artefacto, fecha_generacion, id_pipeline)
        values
			(p_version_artefacto, p_fecha_generacion, p_id_pipeline);
	else
		signal sqlstate '45000'
        set message_text = 'id_pipeline inválido';
	end if;
end //
delimiter ;


-- ####################
-- ##### Triggers #####
-- ####################


drop trigger if exists tr_beforeInsertarDespliegue;
delimiter //
create trigger tr_beforeInsertarDespliegue
before insert on despliegue
for each row
begin
	if new.status_despliegue is null then
		set new.status_despliegue = 'Pending';
    end if;
end //
delimiter ;

drop trigger if exists tr_beforeUpdateIncidenteStatus;
delimiter //
create trigger tr_beforeUpdateIncidenteStatus
before update on incidente
for each row
begin
    -- Se loguea el cambio de 'status_incidente' en la tabla auditoria
    -- sólo si dicho campo es actualizado.
	if old.status_incidente <> new.status_incidente then
		insert into log_auditoria(campoNuevo_campoAnterior, accion, tabla,
								  usuario, fecha_modificacion)
        values
			(concat('STATUS_INCIDENTE NUEVO: ', new.status_incidente,
					', STATUS_INCIDENTE ANTERIOR: ', old.status_incidente),
            'UPDATE',
            'INCIDENTE',
            current_user(),
            now());
    end if;
end //
delimiter ;
