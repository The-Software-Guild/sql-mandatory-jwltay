-- 1. Write a query that returns a list of reservations that end in July 2023, including the name of the guest, the room number(s), and the reservation dates.

select Guests.name, r.room_number, r.start_date, r.end_date from ReservationsWithoutTotal r
join Guests using (guest_id)
where month(r.end_date) = 7;


-- 2. Write a query that returns a list of all reservations for rooms with a jacuzzi, displaying the guest's name, the room number, and the dates of the reservation.

select * from ReservationsWithoutTotal
join Rooms using (room_number)
join Amenities_Rooms ar using (room_number)
where ar.amenity_id = (select amenity_id from Amenities where name = "Jaccuzzi");


-- 3. Write a query that returns all the rooms reserved for a specific guest, including the guest's name, the room(s) reserved, the starting date of the reservation, and how many people were included in the reservation. (Choose a guest's name from the existing data.)

select Guests.name, r.room_number, r.start_date, (r.adults + r.children) as people_included
from ReservationsWithoutTotal r
join Guests using (guest_id)
where Guests.name = "Walter Holaway";


-- 4. Write a query that returns a list of rooms, reservation ID, and per-room cost for each reservation. The results should include all rooms, whether or not there is a reservation associated with the room.

select Rooms.room_number, res.reservation_id, total
from Reservations res
left outer join Rooms using (room_number);


-- 5. Write a query that returns all the rooms accommodating at least three guests and that are reserved on any date in April 2023.

select room_number 
from Reservations r
where (r.adults + r.children >= 3) and (month(r.start_date) = 4) or (month(r.end_date) = 4);


-- 6. Write a query that returns a list of all guest names and the number of reservations per guest, sorted starting with the guest with the most reservations and then by the guest's last name.

select Guests.name, count(*) as number_of_reservations
from Guests
join Reservations using (guest_id)
group by Guests.guest_id
order by number_of_reservations desc, Guests.name;


-- 7. Write a query that displays the name, address, and phone number of a guest based on their phone number. (Choose a phone number from the existing data.)

select Guests.name, Address.address, Guests.phone
from Guests join Address using (address_id)
where Guests.phone = "(291) 553-0508";
