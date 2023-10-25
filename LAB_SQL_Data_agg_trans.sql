-- Lab | SQL Data Aggregation and Transformation -- Antonio Montilla
USE sakila;
-- Challenge 1
-- 1 You need to use SQL built-in functions to gain insights relating to the duration of movies:
-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT MAX(length) as 'max_duration', MIN(length) as 'min_duration'
FROM film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
SELECT concat(AVG(length) DIV 60, 'h and ', ROUND(AVG(length) % 60), 'min') as 'average_duration'
FROM film;

-- 2 You need to gain insights related to rental dates:

-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT DATEDIFF(CONVERT(MAX(rental_date), date), CONVERT(MIN(rental_date), date)) AS 'Number_days'
FROM rental;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT *, date_format(CONVERT(rental_date, date), '%M') AS 'month of rental', date_format(CONVERT(rental_date, date), '%W') AS 'day of week of rental'
FROM rental
LIMIT 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.
SELECT *, date_format(CONVERT(rental_date, date), '%W') AS 'day of the week',
CASE
WHEN date_format(CONVERT(rental_date, date), '%W') = 'Saturday' then 'weekend'
WHEN date_format(CONVERT(rental_date, date), '%W') = 'Sunday' then 'weekend'
ELSE 'workday'
END AS 'DAY_TYPE'
FROM rental;

-- 3- You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.
SELECT title, IFNULL(rental_duration, 'Not available') AS 'rental_duration'
FROM film
ORDER BY title ASC;

-- 4. Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.
SELECT *, concat(first_name, " ", last_name) as 'name for email', left(email, 3) as 'first 3 cha in email'
FROM customer
ORDER BY last_name ASC; 

-- Challenge 2

-- 1 Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.
SELECT COUNT(film_id)
FROM film;

-- 1.2 The number of films for each rating.
SELECT rating, COUNT(film_id) as 'number of films'
FROM film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
SELECT rating, COUNT(film_id) as 'number of films'
FROM film
GROUP BY rating
ORDER BY COUNT(film_id) DESC;

-- Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
SELECT rating, ROUND(AVG(length),2) as 'mean film duration'
FROM film
GROUP BY rating
ORDER BY ROUND(AVG(length),2) DESC;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
SELECT rating, ROUND(AVG(length),2) as 'mean film duration'
FROM film
GROUP BY rating
HAVING ROUND(AVG(length),2) > 120
ORDER BY ROUND(AVG(length),2) DESC;

-- Bonus: determine which last names are not repeated in the table actor.
SELECT first_name, COUNT(actor_id) AS 'number of repetitions'
FROM actor
GROUP BY first_name
HAVING COUNT(actor_id) = 1;
