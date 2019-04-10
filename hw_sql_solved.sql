-- Opens the sakila database
use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters.
select concat(first_name, ' ', last_name) as actor_name from actor;

-- 2a. Find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe.".
select actor_id, first_name, last_name from actor where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like '%li%'
order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country in('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor add column description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, 
count(last_name) AS count 
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) AS count from actor
group by last_name
having count >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from actor where last_name = "williams";
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "groucho" and last_name = "williams";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "harpo";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff INNER JOIN address ON
staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT concat(staff.first_name, ' ', staff.last_name) as full_name, sum(payment.amount) as total_payment
FROM staff inner JOIN payment ON
staff.staff_id = payment.staff_id
where payment.payment_date BETWEEN '2005-08-01' and '2005-08-31'
group by full_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, count(film.film_id) as total_actors
FROM film_actor 
inner JOIN film ON film_actor.film_id = film.film_id
inner JOIN actor ON actor.actor_id = film_actor.actor_id
group by film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title, count(inventory.film_id) as inventory_count
FROM inventory 
left JOIN film ON inventory.film_id = film.film_id
where film.title = "Hunchback Impossible"
group by film.title;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT concat(customer.last_name, ', ', customer.first_name) as full_name, sum(payment.amount) as total_payment
FROM payment inner JOIN customer ON
customer.customer_id = payment.customer_id
group by full_name;