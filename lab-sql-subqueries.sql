--  How many copies of the film Hunchback Impossible exist in the inventory system?

select title, sum(film.film_id) as total_copies
from inventory
join film
on film.film_id = inventory.film_id
group by title
having title = 'Hunchback Impossible';

-- List all films whose length is longer than the average of all the films

select title, length
from film
where length > (select round(avg(length), 0) from film);

-- Use subqueries to display all actors who appear in the film Alone Trip.

select first_name, last_name
from actor
where actor.actor_id in (
select film_actor.actor_id 
from film_actor 
join film
on film_actor.film_id = film.film_id
where film.title = 'Alone trip'
);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films

select *
from category;

select title 
from film
where film.film_id in (
select film_category.film_id
from film_category
join category
on category.category_id = film_category.category_id
where category.name = 'Family'
);

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify 
-- the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select *
from country;

select first_name, last_name, email
from customer
where address_id in(
select address.city_id
from address
join city 
on address.city_id = city.city_id
join country
on country.country_id = city.country_id
where country = 'Canada'
);

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select actor_id, first_name, last_name 
from actor
where actor_id in (
select film_actor.actor_id
from film_actor
join film
on film_actor.film_id = film.film_id
group by film_actor.actor_id
having count(*) = (
select max(film_count)
from (
select count(*) as film_count
from film_actor
group by actor_id
) as counts
)
);

-- Part 2

select title, actor_id
from film
join film_actor
on film_actor.film_id = film.film_id
where actor_id = '107';

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select film.title
from film
join inventory 
on film.film_id = inventory.film_id
join rental 
on rental.inventory_id = inventory.inventory_id
join payment 
on payment.rental_id = rental.rental_id
join customer 
on customer.customer_id = payment.customer_id
where customer.customer_id = (
    select customer_id
    from payment
    group by customer_id
    order by SUM(amount) desc
    limit 1
);

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client

select customer_id, SUM(amount) as total_amount
from payment
group by customer_id
HAVING SUM(amount) > 
(
select avg(amount)
from payment
);
