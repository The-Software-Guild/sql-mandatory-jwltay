
delete from ReservationsWithoutTotal where guest_id = (select guest_id from Guests where name = "Jeremiah Pendergrass");

delete from Guests where name = "Jeremiah Pendergrass";

delete from Address where Address.address_id = (select address_id from Guests where name = "Jeremiah Pendergrass");