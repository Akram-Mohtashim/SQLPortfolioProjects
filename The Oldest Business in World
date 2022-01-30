-- 1. The oldest business in the world

SELECT
    MIN(year_founded),
    MAX(year_founded)
FROM businesses;

-- 2. How many businesses were founded before 1000?

SELECT COUNT (business)
FROM businesses
WHERE year_founded < 1000;
  
-- 3. Which businesses were founded before 1000?

SELECT *
FROM businesses
WHERE year_founded <1000
ORDER BY year_founded;

-- 4. Exploring the categories where the founding year was before 1000 

SELECT b.business, 
       b.year_founded, 
       b.country_code,
       c.category
FROM businesses b
JOIN categories c
ON c.category_code = b.category_code
WHERE b.year_founded < 1000
ORDER BY b.year_founded;

-- 5. Counting the categories

SELECT
    c.category,
    COUNT(1) AS n
FROM categories c
JOIN businesses b ON c.category_code = b.category_code
GROUP BY c.category
ORDER BY COUNT(1) DESC
LIMIT 10;

-- 6. Oldest business by continent 

SELECT MIN(b.year_founded) AS oldest,
       c.continent
FROM businesses b
JOIN countries c
ON c.country_code = b.country_code
GROUP BY c.continent
ORDER BY MIN(b.year_founded);

-- 7. Joining everything for further analysis 

SELECT b.business, b.year_founded, 
       ca.category,
       co.country,
       co.continent
FROM businesses b
JOIN countries co ON b.country_code = co.country_code
JOIN categories ca ON b.category_code = ca.category_code;

-- 8. Counting categories by continent

SELECT co.continent, ca.category,
       COUNT(business) AS n
FROM businesses b
JOIN categories ca ON b.category_code = ca.category_code
JOIN countries co ON b.country_code = co.country_code
GROUP BY co.continent, ca.category;

-- 9. Filtering counts by continent and category

SELECT co.continent, ca.category,
       COUNT(business) AS n
FROM businesses b
JOIN categories ca ON b.category_code = ca.category_code
JOIN countries co ON b.country_code = co.country_code
GROUP BY co.continent, ca.category
HAVING COUNT(business) > 5
ORDER BY COUNT(business) DESC;
