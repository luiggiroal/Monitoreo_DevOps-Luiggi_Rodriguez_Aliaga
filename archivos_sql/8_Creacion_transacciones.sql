-- ########################
-- ##### Transacciones #####
-- ########################

-- OJO: Las transacciones son envueltas en stored procedures para permitir
--      una fácil reusabilidad del primero sin la necesidad de reescribir
--    	sentencias cada vez que se quiera llevar a cabo una transacción,
-- 		de esta	forma sólo es necesario llamar al stored procedure con 
-- 		sus parámetros para ejecutar dicha transacción.

-- Se deshabilita el autocommit
set @@autocommit = 0;
select @@autocommit;

-- Registrar un nuevo despliegue asegurandose que los ID del pipeline, artefacto,
-- y entorno de despliegue asociados al nuevo registro existan, además
-- se establece que el estado inicial del nuevo despliegue debe ser 'Pending'.
-- Si cualquier condición falla, todo cambio relacionado al 
-- registro del despliegue se deshace (rollback).
drop procedure if exists sp_registrarDespliegue;
delimiter //
create procedure sp_registrarDespliegue(in p_fecha_despliegue datetime,
										in p_id_pipeline int,
                                        in p_id_artefacto int,
                                        in p_id_entorno int)
	begin
		declare exit handler for sqlexception
			begin
				rollback;
                signal sqlstate '45000'
                set message_text = 'Error durante registro de despliegue';
            end;
		
        start transaction;
        
        if not exists(select 1 from pipeline p where p.id_pipeline = p_id_pipeline) then
			signal sqlstate '45000'
            set message_text = 'ID del pipeline inválido';
        end if;
        
        if not exists(select 1 from artefacto a where a.id_artefacto = p_id_artefacto) then
			signal sqlstate '45000'
            set message_text = 'ID del artefacto inválido';
        end if;
        
        if not exists(select 1 from entorno_despliegue e where e.id_entorno = p_id_entorno) then
			signal sqlstate '45000'
            set message_text = 'ID de entorno de despliegue inválido';
        end if;
        
        insert into despliegue(status_despliegue, fecha_despliegue, 
							   id_pipeline, id_artefacto,
                               id_entorno)
        values
			('Pending', p_fecha_despliegue, p_id_pipeline, p_id_artefacto, p_id_entorno);
        commit;
	end //

delimiter ;

-- Actualizar un incidente existente asegurándose que el ID del incidente
-- ingresado exista, además que valor del estado del incidente ingresado
-- sea distinto al existente. Cabe resaltar que en caso la actualización
-- sea exitosa, el trigger previamente creado 'tr_beforeUpdateIncidenteStatus'
-- se activará y creará un nuevo registro en la tabla de auditoría con los
-- datos actualizados.
-- Si cualquier condición falla, todo cambio relacionado a la actualización
-- del incidente se deshace (rollback).
drop procedure if exists sp_updateIncidenteStatus;
delimiter //
create procedure sp_updateIncidenteStatus(in p_id_incidente int,
										  in p_status_incidente enum('Open','Closed'))
	begin
		declare v_old_status_incidente enum('Open','Closed');
        
		declare exit handler for sqlexception
			begin
				rollback;
                signal sqlstate '45000'
                set message_text = 'Error al actualizar el estado del incidente';
            end;
		
        start transaction;
        
        if not exists(select 1 from incidente i where i.id_incidente = p_id_incidente) then
			signal sqlstate '45000'
            set message_text = 'ID del incidente inválido';
        end if;
        
        select i.status_incidente into v_old_status_incidente
        from incidente i
        where i.id_incidente = p_id_incidente; 
        
        if v_old_status_incidente = p_status_incidente then
			signal sqlstate '45000'
            set message_text = 'El nuevo estado del incidente es igual al antiguo';
        end if;
        
        update incidente i
        set i.status_incidente = p_status_incidente
        where i.id_incidente = p_id_incidente;
        
        commit;
    end //
delimiter ;

-- Se habilita el autocommit
set @@autocommit = 1;
select @@autocommit;
