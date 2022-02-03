
.open earthquake.db
.mode column

--SELECT * FROM earthquake;

--Outputs the number of earthquakes stored in our database
SELECT COUNT(*) FROM earthquake;

--Outputs firsts five lines of our db to better understand the data
SELECT * FROM earthquake LIMIT 5;

--Let's see how many earthquakes occurred in 2002 :o
SELECT COUNT(*) FROM earthquake 
WHERE occurred_on BETWEEN "2002-01-01" AND "2002-12-31";

--Selecting every earthquake that happened in PORTUGAL CARALHOOOO
SELECT * FROM earthquake 
WHERE place LIKE "%Portugal%";

--Selectiong the 10 strongests earthquakes
SELECT * From earthquake 
ORDER BY magnitude DESC 
LIMIT 10;

-- How many earthquakes Japan had in March 2003
SELECT COUNT(*) FROM earthquake 
WHERE occurred_on BETWEEN "2011-03-01" AND "2011-03-31";


--Seeing the many replicas that the 2011 Japan's earthquake had
SELECT occurred_on,magnitude,place FROM earthquake 
WHERE place LIKE "%Japan%" AND occurred_on BETWEEN "2011-03-09" AND "2011-03-20";

--This works as intended so  now we know that the latitude is being stored as a string ;:C
--in this method im forcing conversion of string into  float and it works as i intendend
SELECT latitude  FROM earthquake 
WHERE (latitude) <=40 AND (latitude*1) >= 8
ORDER BY latitude  DESC;


SELECT latitude  FROM earthquake 
WHERE latitude <="40" AND latitude >="5"
ORDER BY latitude  DESC;

--To alter the data type of the latitude i do something like  but this is no good 
UPDATE earthquake
SET latitude = latitude * 1;

