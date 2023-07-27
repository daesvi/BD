delimiter //
create function suma_id (id int) returns double
begin
	declare suma double;
    select sum(total) into suma
    from pedido
    where pedido.id_cliente = id;
    return suma;
end//
delimiter ;
select suma_id(4);