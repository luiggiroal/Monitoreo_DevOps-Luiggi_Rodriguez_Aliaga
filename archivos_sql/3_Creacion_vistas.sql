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

create or replace view vw_incidente_anio_mes as
select i.severidad 'Severidad Incidente',
	   year(d.fecha_despliegue) 'Año',
       date_format(d.fecha_despliegue, '%M') 'Mes', 
       count(i.id_incidente) 'Número de incidentes' 
from incidente i
	join despliegue d on i.id_despliegue = d.id_despliegue
group by i.severidad, year(d.fecha_despliegue), DATE_FORMAT(d.fecha_despliegue, '%M')
order by year(d.fecha_despliegue), date_format(d.fecha_despliegue, '%M'), count(i.id_incidente) desc;

create or replace view vw_equipo_entorno_warning as
select e.nombre 'Equipo',
	   count(*) 'Cantidad de Entornos de Despliegue con aviso de advertencia'
from equipo e
	join pipeline p on e.id_equipo = p.id_equipo
    join despliegue d on d.id_pipeline = p.id_pipeline
    join entorno_despliegue ed on d.id_entorno = ed.id_entorno
    join configuracion_entorno c on ed.id_entorno = c.id_entorno
where c.llave like 'LOG_LEVEL' and c.valor like '%WARN%'
group by e.nombre
order by count(*) desc;
