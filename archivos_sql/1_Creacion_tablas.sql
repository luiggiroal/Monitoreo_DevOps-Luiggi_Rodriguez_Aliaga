
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
