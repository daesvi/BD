DROP PROCEDURE IF EXISTS clientes_con_letra;
delimiter //
create procedure clientes_con_letra (in letra char)
begin 
select *
from cliente
where nombre like concat('%',letra,'%');
end//
delimiter ;