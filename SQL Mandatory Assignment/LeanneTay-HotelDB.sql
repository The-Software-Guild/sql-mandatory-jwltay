drop database if exists hotelreservations;

create database hotelreservations;

use hotelreservations;

create table Amenities(amenity_id int primary key auto_increment, name varchar(20) not null, price decimal(6,2) not null);

create table Address(address_id int primary key auto_increment, address varchar(80) not null, city varchar(50) not null, state varchar(50) not null, zip varchar(5) not null);

create table Types(type_id int primary key auto_increment, name varchar(20) not null, base_price decimal(8,2) not null, standard_occupancy int not null, max_occupancy int not null, extra_person decimal(6,2));

create table Rooms(room_number int primary key not null, type_id int not null, ada_accessible varchar(3), foreign key (type_id) references Types(type_id));

create table Amenities_Rooms(amenities_rooms_id int primary key auto_increment, amenity_id int not null, room_number int not null, foreign key (amenity_id) references Amenities(amenity_id), foreign key (room_number) references Rooms(room_number));

create table Guests(guest_id int primary key auto_increment, name varchar(50) not null, address_id int not null, phone varchar(20) not null, foreign key (address_id) references Address(address_id));

create table ReservationsWithoutTotal(reservation_id int primary key auto_increment, room_number int not null, guest_id int not null, adults int not null, children int not null, start_date date not null, end_date date not null, foreign key (room_number) references Rooms(room_number), foreign key (guest_id) references Guests(guest_id));

delimiter //
create function getAmenitiesCost(roomNumber int) returns decimal(6,2) deterministic
begin
declare cost decimal(6,2);
select sum(amenities.price) into cost from Amenities_Rooms join Amenities using (amenity_id) where Amenities_Rooms.room_number = roomNumber;
return cost;
end; //
delimiter ;

create view Reservations as
select
    r.reservation_id,
    r.room_number,
    r.guest_id,
    r.adults,
    r.children,
    r.start_date,
    r.end_date,
    ((t.base_price + getAmenitiesCost(r.room_number) + greatest((r.adults - t.standard_occupancy), 0) * t.extra_person) * datediff(r.end_date, r.start_date)) as total
from ReservationsWithoutTotal r
join Rooms rm using (room_number)
join Types t using (type_id)
order by r.reservation_id;
