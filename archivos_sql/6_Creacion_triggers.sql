-- ####################
-- ##### Triggers #####
-- ####################

-- Creación de Tabla de auditoría
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
