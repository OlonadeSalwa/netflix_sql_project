-- NETFLIX PROJECT
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
 show_id VARCHAR(6),	
 type VARCHAR(10),	
 title VARCHAR(150),	
 director VARCHAR(208),	
 castS VARCHAR(1000),
 country VARCHAR(150),	
 date_added	VARCHAR(50),
 release_year INT,
 rating	VARCHAR(10),
 duration VARCHAR(15),	
 listed_in VARCHAR(100),	
 description VARCHAR(1000)
)
SELECT * FROM netflix;

SELECT
	COUNT(*) as total_content
	FROM netflix;
	
SELECT
	DISTINCT type
	FROM netflix;	
	
SELECT * FROM netflix;

-- 15 Business Problem
--1. Count the number of Movies vs TV Shows
SELECT 
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type

-- 2. Find the most common rating for movies and tv shows

SELECT
	type,
	rating
FROM
(
SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2
) as t1
WHERE ranking = 1

-- 3. List all movies released in a specific year, 2021

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	release_year = 2021
	
-- 4. Find the top 10 countries with the most content on netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--5. Identify the longest movie

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)
	
-- 6. Find content added in the last 5 years

SELECT
	*
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 years'
	
-- 7. Find all the movies/tv shows by director Rajiv Chilaka

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

-- 8. List all tv shows with more than 5 seasons
SELECT
	*
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5

-- 9. Count the number of Content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

-- 10. Find each year and the average numbers of content release by United State on netflix, return top5 years with highest avg content release
-- total content 333/972

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yealy_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'United States')::numeric * 100
		,2) as avg_content_per_year
FROM netflix
WHERE country = 'United States'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5

-- 11. list all movies that are documentries

SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries%'

-- 12.find all content with a director

SELECT * FROM netflix
WHERE 
	director IS NULL

-- 13. find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the 10 top actors who have appeared in the highest number of movies produced in United States

SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE Country ILIKE '%united state%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


-- 15. Categorize the content based on the presense of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
WITH new_table
AS
(
SELECT
*,
	CASE
	WHEN
		description ILIKE '%kill%' OR 
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good Content'
	END category
	FROM netflix
)
SELECT
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1








