use tokyo_olympics;

-- Tokyo Olympics Data Exploration 

-- I Firstly did reverse engineering to establish a relational connection between the tables for the database-- 
-- Discipline is the primary key and country / team is the foreign key--

select * from athletes limit 10;
select * from coaches limit 10;
select * from entriesgender limit 10;
select * from medals limit 10;
select * from teams limit 10;


-- Check for null values 

SELECT Name, NOC, Discipline
from athletes
where Discipline is null;

-- Null Values Teams--

SELECT Name, NOC, Discipline, Event
from teams
where Event is null;


-- check for duplicates -- 

SELECT Discipline, COUNT(*) FROM entriesgender GROUP BY Discipline HAVING COUNT(*) > 1;

-- Data Distribution-- 

SELECT Gold, COUNT(*) FROM medals GROUP BY Gold;

-- Correlation and Relationships--

SELECT Discpline.*, Discpline.* FROM athletes Discpline JOIN coaches Discpline ON Discpline.key = Discpline.key;




-- summary statistics-- 

SELECT discipline, COUNT(*) AS frequency
FROM athletes
GROUP BY discipline
ORDER BY frequency DESC
LIMIT 10;

SELECT MIN(discipline) AS first_category, MAX(discipline) AS last_category
FROM athletes;

-- Frequency Distribution

SELECT discipline, COUNT(*) as frequency
FROM athletes
GROUP BY discipline
ORDER BY frequency DESC;

-- Date and Time Analysis 
-- Na here 

-- Correlations (for numerical columns) between two columns 

SELECT CORR(Male, Female) FROM entriesgender;


-- standardize Values 


-- Analysis Insights 

-- Top Performing Countries

SELECT `Team/NOC`, Gold, Silver, Bronze, Total 
FROM Medals 
ORDER BY Total DESC 
LIMIT 1;

-- Discipline Dominance

SELECT discipline, COUNT(*) as frequency
FROM
(
    SELECT discipline FROM entriesgender
    UNION ALL
    SELECT discipline FROM athletes
    UNION ALL
    SELECT discipline FROM coaches
    UNION ALL
    SELECT discipline FROM teams
) AS combined
GROUP BY discipline
ORDER BY frequency DESC;


-- Gender Participation

SELECT Discipline, ABS(female - male) as gender_difference 
FROM Entries_Gender 
ORDER BY gender_difference DESC 
LIMIT 1;


-- Coach Influence 

SELECT Discipline, COUNT(DISTINCT Name) as number_of_coaches 
FROM Coaches 
WHERE country = 'specific_country' 
GROUP BY Discipline;


-- Most Common Discipline

-- (This is a basic approximation; ideally, you'd join with Athletes table to get the exact number of participants.)
SELECT Discipline 
FROM Entries_Gender 
ORDER BY total DESC 
LIMIT 1;

-- Team Events v Individual Events

SELECT Discipline, COUNT(Name) as number_of_teams 
FROM Teams 
GROUP BY Discipline 
ORDER BY number_of_teams DESC;

-- Top Performing Athletes:
-- As mentioned, this would likely require additional data to answer fully, but if we make assumptions based on disciplines and countries:


-- (This is a basic approximation; ideally, you'd have more specific data.)
SELECT Name, country, COUNT(DISTINCT Discipline) as number_of_medal_disciplines 
FROM Athletes 
WHERE country IN (SELECT `TEam country` FROM Medals WHERE Total > 1) 
GROUP BY Name, country 
HAVING number_of_medal_disciplines > 1;


-- Gender Equal Disciplines

SELECT Discipline 
FROM Entries_Gender 
WHERE ABS(female - male) <= 5  -- This is to get disciplines where the difference is 5 or less; adjust as necessary.
ORDER BY ABS(female - male);

-- Coaches with Most Golds
-- Again, making assumptions about the relationship:


-- (This is a basic approximation; ideally, you'd have more specific data.)
SELECT c.Name, c.Discipline 
FROM Coaches c 
JOIN Medals m ON c.country = m.`TEam country` 
WHERE m.Gold > 1 
GROUP BY c.Name, c.Discipline 
ORDER BY m.Gold DESC;


-- Most Competative Disciplines

SELECT Discipline 
FROM Medals 
ORDER BY Total_by_rank 
LIMIT 1;










