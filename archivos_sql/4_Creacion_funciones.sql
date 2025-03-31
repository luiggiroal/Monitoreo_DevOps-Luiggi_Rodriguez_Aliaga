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
