use jardineriamakaia;

-- Devuelve un listado con el código de oficina y 
-- la ciudad donde hay oficinas.

select idoficina, ciudad
from oficina
inner join ubicacion on oficina.idoficina = ubicacion.idubicacion;

-- Devuelve un listado con la ciudad y el teléfono 
-- de las oficinas de España

select ciudad, telefono
from ubicacion
inner join oficina on oficina.idoficina = ubicacion.idubicacion
where pais = 'Spain';

-- Devuelve un listado con el nombre, apellidos y email de los
-- empleados cuyo jefe tiene un código de jefe igual a 7.

select nombre, apellido, email
from empleados
where idjefe = 7;

-- Devuelve un listado con el código de cliente de aquellos clientes que 
-- realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar 
-- aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta: 
-- Utilizando la función YEAR de MySQL. 
-- Utilizando la función DATE_FORMAT de MySQL.

SELECT distinct clientes.idclientes, nombre, apellido, fechapedido, DATE_FORMAT(fechapedido, '%d/%m/%Y') as fecha_formateada
FROM factura 
inner join pedidos on factura.idpedidos = pedidos.idpedidos
inner join clientes on factura.idclientes = clientes.idclientes
WHERE YEAR(fechapedido) = 2008;

-- ¿Cuántos empleados hay en la compañía? 

SELECT 'Empleados' AS tipo, COUNT(*) AS total
FROM empleados
UNION ALL
SELECT 'Jefes' AS tipo, COUNT(*) AS total
FROM jefe;

-- ¿Cuántos clientes tiene cada país? 

SELECT u.pais AS pais, COUNT(c.idclientes) AS total_clientes
FROM clientes c
INNER JOIN ubicacion u ON c.idubicacion = u.idubicacion
GROUP BY u.pais;

-- ¿Cuál fue el pago medio en 2009?

select round(avg(total),2) as pago_medio 
from factura
inner join pedidos on factura.idpedidos = pedidos.idpedidos
WHERE YEAR(fechapedido) = 2009;

-- ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma 
-- descendente por el número de pedidos.

SELECT p.estado AS estado, COUNT(p.idpedidos) AS total_estado
FROM pedidos p
GROUP BY p.estado
order by total_estado desc;

-- Calcula el precio de venta del producto más caro y barato en una misma 
-- consulta.

select 'precio_maximo' as tipo,max(precioventa) as precio 
from productos
UNION ALL
select 'precio_minimo' as tipo,min(precioventa) as precio 
from productos;

-- Devuelve el nombre del cliente con mayor límite de crédito.

select idclientes, nombre, apellido, credito
from clientes
order by credito desc
limit 1;

-- Devuelve el nombre del producto que tenga el precio de venta más caro.

select idproductos, nombre, descripcion, precioventa
from productos
order by precioventa desc
limit 1;

-- Devuelve el nombre del producto del que se han vendido más unidades. 
-- (Tenga en cuenta que tendrá que calcular cuál es el número total de 
-- unidades que se han vendido de cada producto a partir de los datos de la 
-- tabla detalle_pedido)

SELECT p.nombre AS nombre, COUNT(f.idproductos) AS total_producto
FROM productos p
INNER JOIN factura f ON f.idproductos = p.idproductos
GROUP BY p.nombre
order by total_producto desc
limit 1;

-- Los clientes cuyo límite de crédito sea mayor que los pagos que haya 
-- realizado. (Sin utilizar INNER JOIN)

select c.idclientes, c.nombre, c.apellido, c.credito
from clientes c
where c.credito > (
  select SUM(f.total)
  from factura f
  where f.idclientes = c.idclientes
);

-- Devuelve el listado de clientes indicando el nombre del cliente y 
-- cuantos pedidos ha realizado. Tenga en cuenta que pueden existir 
-- clientes que no han realizado ningún pedido

select c.nombre as nombre, COUNT(f.idclientes) as total_producto
from clientes c
inner join factura f on f.idclientes = c.idclientes
group by c.nombre;

-- Devuelve el nombre, apellidos, puesto y teléfono de la oficina de 
-- aquellos empleados que no sean representante de ventas de ningún cliente.

SELECT e.idempleados, e.nombre as nombre_empleado, e.apellido as apellido_empleado, e.puesto
FROM empleados e
LEFT JOIN clientes c ON c.idempleados = e.idempleados
WHERE c.idempleados IS NULL;


-- Devuelve las oficinas donde no trabajan ninguno de los empleados que 
-- hayan sido los representantes de ventas de algún cliente que haya realizado 
-- la compra de algún producto de la gama Orquideas

-- como no existen registros nulos, se trae vacia la respuesta de la consulta

SELECT distinct o.idoficina, o.nombre, o.idempleado
FROM oficina o
LEFT JOIN empleados e ON o.idempleado = e.idempleados
LEFT JOIN clientes c ON c.idempleados = e.idempleados
LEFT JOIN factura f ON f.idclientes = c.idclientes
LEFT JOIN productos p ON p.idproductos = f.idproductos
LEFT JOIN gama g ON g.idgama = p.idgama
WHERE g.gama <> 'Orquideas' AND e.idempleados IS NULL;


-- Devuelve el listado de clientes indicando el nombre del cliente y cuantos 
-- pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no 
-- han realizado ningún pedido.

select c.nombre as nombre, COUNT(f.idclientes) as total_producto
from clientes c
inner join factura f on f.idclientes = c.idclientes
group by c.nombre;

-- Devuelve un listado con los nombres de los clientes y el total pagado por 
-- cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han 
-- realizado ningún pago.

select c.idclientes as id, c.nombre as nombre, c.apellido as apellido, f.total as total_pagado
from clientes c
inner join factura f on f.idclientes = c.idclientes;
