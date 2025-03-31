-- ##########################################
-- ##### Creación y Gestión de Usuarios #####
-- ##########################################

-- Creación de usuarios

-- Creación de usuario 'manager' que se puede conectarse desde cualquier IP.
drop user if exists 'manager'@'%';
create user if not exists 'manager'@'%'
identified by 'strongPass';
-- 'manager' tiene permisos absolutos sobre la base de datos 'monitoreo_devops'.
grant all privileges on monitoreo_devops.* to 'manager'@'%';

-- Creación de usuario 'miembro_equipo' que puede conectarse sólo desde máquina local.
drop user if exists 'miembro_equipo'@'localhost';
create user if not exists 'miembro_equipo'@'localhost'
identified by 'teamPass';
-- 'miembro_equipo' tiene permisos absolutos solamente sobre la tabla 'equipo'. 
-- 'miembro_equipo' tiene permiso de consulta en todas las tablas.
grant select on monitoreo_devops.* to 'miembro_equipo'@'localhost';
grant all privileges on monitoreo_devops.equipo to 'miembro_equipo'@'localhost';

-- Creación de usuario 'auditor' que puede conectarse sólo desde máquina local.
drop user if exists 'auditor'@'localhost';
create user if not exists 'auditor'@'localhost'
identified by 'auditorPass';
-- 'auditor' tiene permisos absolutos solamente sobre la tabla 'log_auditoria'. 
-- 'auditor' tiene permiso de consulta en todas las tablas.
grant all privileges on monitoreo_devops.log_auditoria to 'auditor'@'localhost';
grant select on monitoreo_devops.* to 'auditor'@'localhost';

-- Listar usuarios y sus permisos concedidos
SELECT 
    d.user 'Usuario', 
    IF(d.host = '%', '[Cualquier Host]', d.host) 'Host',
    d.db 'Base de Datos', 
    IFNULL(t.table_name, '[Todas las Tablas]') 'Tabla',
    IFNULL(t.Table_priv, '[Todos los Privilegios]') AS 'Privilegios'
FROM mysql.db AS d
LEFT JOIN mysql.tables_priv AS t 
    ON d.user = t.user 
    AND d.host = t.host 
    AND d.db = t.db
ORDER BY d.user, d.db, t.table_name;
