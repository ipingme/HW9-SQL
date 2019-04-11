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
inner JOIN film ON inventory.film_id = film.film_id
where film.title = "Hunchback Impossible"
group by film.title;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT concat(customer.last_name, ', ', customer.first_name) as full_name, sum(payment.amount) as total_payment
FROM payment inner JOIN customer ON
customer.customer_id = payment.customer_id
group by full_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from film;
select * from language;
SELECT film.title, language.name
FROM film 
inner JOIN language ON film.language_id = language.language_id
where film.title like "Q%" or film.title like "K%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film;
select * from film_actor;
select * from actor;
SELECT film.title, actor.first_name, actor.last_name
FROM film 
inner JOIN film_actor ON film.film_id = film_actor.film_id
inner JOIN actor ON film_actor.actor_id = actor.actor_id
where film.title = "Alone Trip";

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from country;
select * from city;
select * from address;
select * from customer;
SELECT country.country, customer.first_name, customer.last_name, customer.email
FROM customer 
inner JOIN address ON customer.address_id = address.address_id
inner JOIN city ON address.city_id = city.city_id
inner JOIN country ON city.country_id = country.country_id
where country.country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from film;
select * from film_category;
select * from category;
SELECT film.title, category.name
FROM film 
inner JOIN film_category ON film.film_id = film_category.film_id
inner JOIN category ON film_category.category_id = category.category_id
where category.name = "Family";

-- 7e. Display the most frequently rented movies in descending order.
select * from film;
select * from inventory;
select * from rental;
select * from payment;
SELECT film.title, count(film.title) AS count 
FROM rental 
left JOIN payment ON payment.rental_id = rental.rental_id
left JOIN inventory ON rental.inventory_id = inventory.inventory_id
left JOIN film ON inventory.film_id = film.film_id
group by film.title
ORDER BY count DESC 
LIMIT 1;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from payment;
select * from staff;
select * from store;
SELECT store.store_id, sum(payment.amount) AS total 
FROM payment 
left JOIN staff ON payment.staff_id = staff.staff_id
left JOIN store ON staff.store_id = store.store_id
group by store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select * from store;
select * from address;
select * from city;
select * from country;
SELECT store.store_id, city.city, country.country
FROM store 
left JOIN address ON store.address_id = address.address_id
left JOIN city ON address.city_id = city.city_id
left JOIN country ON city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;
select * from film_category;
select * from inventory;
select * from rental;
select * from payment;
SELECT category.name, sum(payment.amount) AS total 
FROM payment 
left JOIN rental ON payment.rental_id = rental.rental_id
left JOIN inventory ON rental.inventory_id = inventory.inventory_id
left JOIN film_category ON inventory.film_id = film_category.film_id
left JOIN category ON film_category.category_id = category.category_id
group by category.name
ORDER BY total DESC 
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_genres AS 
SELECT category.name, sum(payment.amount) AS total 
FROM payment 
left JOIN rental ON payment.rental_id = rental.rental_id
left JOIN inventory ON rental.inventory_id = inventory.inventory_id
left JOIN film_category ON inventory.film_id = film_category.film_id
left JOIN category ON film_category.category_id = category.category_id
group by category.name
ORDER BY total DESC 
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_5_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW IF EXISTS top_5_genres;