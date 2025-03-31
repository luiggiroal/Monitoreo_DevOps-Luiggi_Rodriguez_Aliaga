-- #############################
-- ##### Stored Procedures #####
-- #############################


drop procedure if exists sp_getDespliegues;
delimiter //
create procedure sp_getDespliegues(in p_status_despliegue varchar(20),
								   out p_total_despliegues int)
begin
    -- Salida -> total de despliegues según un estado de despliegue (Entrada)
	select count(*) into p_total_despliegues
    from despliegue d
    where d.status_despliegue = p_status_despliegue;

	-- Muestra lista de despliegues según un estado de despliegue (Entrada)
	select d.id_despliegue 'ID Despliegue',
		   d.status_despliegue 'Estado Despliegue',	
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
										  in p_fecha_generacion datetime,
                                          out p_id_artefacto int)
begin
	if exists (select 1 from pipeline p where p.id_pipeline = p_id_pipeline) then
		insert into artefacto(version_artefacto, fecha_generacion, id_pipeline)
        values
			(p_version_artefacto, p_fecha_generacion, p_id_pipeline);
        
        -- Salida -> ID del artefacto creado
        set p_id_artefacto = last_insert_id(); 
	else
		signal sqlstate '45000'
        set message_text = 'id_pipeline inválido';
	end if;
end //
delimiter ;
