#1 Find all films with maximum length or minimum rental duration (compared to all other films). 
#In other words let L be the maximum film length, and let R be the minimum rental duration in the table film. You need to find all films that have length L or duration R or both length L and duration R.
#You just need to return attribute film id for this query. 

--SELECT film_id, length, rental_duration FROM film 


SELECT film_id FROM film 
WHERE 
length = (
	SELECT MAX(length) FROM film AS max_len
)
AND
rental_duration=(
    SELECT MIN(rental_duration) FROM film AS min_rent
);


#2 We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
#of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).


SELECT cate.name, COUNT(act.actor_id) FROM category cate
    LEFT JOIN film_category AS fc ON cate.category_id=fc.category_id
    LEFT JOIN film AS f ON fc.film_id=f.film_id
    LEFT JOIN film_actor AS fa ON f.film_id=fa.film_id 
    LEFT JOIN actor AS act ON 
        (fa.actor_id=act.actor_id) AND 
        (act.first_name='ED' AND act.last_name='CHASE')
GROUP BY cate.category_id
ORDER BY cate.name


#3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
#That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

-- ONLY sums of categorys with sci-fi
-- (SELECT act.actor_id AS actor_id, SUM(f.length) AS sum FROM actor act
--     INNER JOIN film_actor fa ON act.actor_id=fa.actor_id
--     INNER JOIN film f ON fa.film_id=f.film_id
--     INNER JOIN film_category fc ON f.film_id=fc.film_id
--     INNER JOIN category cate ON fc.category_id=cate.category_id
-- WHERE cate.name='Sci-Fi'
-- GROUP BY act.actor_id
-- ORDER BY sci_fi.sum ASC)


SELECT act.first_name,act.last_name, sci_fi.sum FROM actor act
LEFT JOIN
    (SELECT act.actor_id AS actor_id, SUM(f.length) AS sum FROM actor act
        INNER JOIN film_actor fa ON act.actor_id=fa.actor_id
        INNER JOIN film f ON fa.film_id=f.film_id
        INNER JOIN film_category fc ON f.film_id=fc.film_id
        INNER JOIN category cate ON fc.category_id=cate.category_id
    WHERE cate.name='Sci-Fi'
    GROUP BY act.actor_id
    ORDER BY sum ASC) AS sci_fi ON act.actor_id=sci_fi.actor_id
ORDER BY sci_fi.sum ASC;


#4 Find the first name and last name of all actors who have never been in a Sci-Fi film

SELECT act.first_name, act.last_name FROM actor act
    INNER JOIN film_actor fa ON act.actor_id = fa.actor_id
    INNER JOIN film f ON fa.actor_id = f.film_id
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category cate ON fc.category_id = cate.category_id
WHERE act.actor_id NOT IN 
    (SELECT act.actor_id FROM actor act
        INNER JOIN film_actor fa ON  act.actor_id=fa.actor_id
        INNER JOIN film f ON fa.film_id=f.film_id
        INNER JOIN film_category fc ON f.film_id=fc.film_id
        INNER JOIN category cate ON fc.category_id=cate.category_id
	WHERE cate.name='Sci-Fi'
    GROUP BY act.actor_id)
GROUP BY act.actor_id;

#5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies

--https://stackoverflow.com/questions/3201359/joining-the-same-table-twice-on-different-columns

(SELECT f.title FROM film f
    INNER JOIN film_actor fa1 ON f.film_id=fa1.film_id
    INNER JOIN actor act1 ON fa1.actor_id=act1.actor_id
    INNER JOIN film_actor fa ON f.film_id=fa.film_id
    INNER JOIN actor act ON fa.actor_id=act.actor_id
WHERE (act.first_name='WARREN' AND act.last_name='NOLTE')
    AND (act1.first_name='KIRSTEN' AND act1.last_name='PALTROW'))
ORDER BY f.title DESC;
