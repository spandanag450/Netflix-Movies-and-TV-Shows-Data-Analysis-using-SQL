-- SCHEMAS of Netflix

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	content_type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	contet_description VARCHAR(550)
);

SELECT * FROM netflix;



-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems
-- 1. Count the number of Movies vs TV Shows

SELECT 
	content_type,
	COUNT(*)
FROM netflix
GROUP BY content_type;

-- 2. Find the most common rating for movies and TV shows


SELECT content_type, COUNT(*) AS rating_count
FROM netflix
GROUP BY content_type
ORDER BY rating_count DESC;




-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = '2020';


-- 4. Find the top 5 countries with the most content on Netflix

SELECT country, COUNT(*) AS content_count
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count DESC
LIMIT 5;



-- 5. Identify the longest movie

SELECT title, duration
FROM netflix
WHERE content_type = 'Movie'
ORDER BY cast(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;


-- 6. Find content added in the last 5 years
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!


SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';



-- 8. List all TV shows with more than 5 seasons

SELECT title, duration
FROM netflix
WHERE content_type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;


-- 9. Count the number of content items in each genre

SELECT genre, COUNT(*) AS genre_count
FROM (
    SELECT TRIM(genre) AS genre
    FROM netflix,
    JSON_TABLE(
        CONCAT('["', REPLACE(listed_in, ', ', '","'), '"]'),
        '$[*]' COLUMNS (genre VARCHAR(255) PATH '$')
    ) AS genre_list
) AS all_genres
GROUP BY genre
ORDER BY genre_count DESC;


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


SELECT 
    release_year,
    ROUND(COUNT(*) / 12.0, 2) AS avg_monthly_releases
FROM netflix
WHERE country LIKE '%India%'
  AND release_year IS NOT NULL
GROUP BY release_year
ORDER BY avg_monthly_releases DESC
LIMIT 5;


-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries';



-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL OR director = '';


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT *
FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.



SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2




-- End of reports