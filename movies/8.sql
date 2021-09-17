--SELECT name FROM people
--JOIN stars ON people.id = person_id
--JOIN movies ON movies.id = movie_id
--WHERE title = "Toy Story";
SELECT name from people WHERE id IN (SELECT person_id FROM stars WHERE movie_id = (SELECT id from movies WHERE title = "Toy Story"));