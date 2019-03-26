-- 1. Welcome to GalaXQL 3.0
-- 2. SELECT

SELECT 3

SELECT (60 * 60 * 24);

-- 3. SELECT  FROM

SELECT * FROM stars;  --Omitted SELECT * FROM loans;

SELECT name, class FROM stars;

SELECT name, class AS starcolor FROM stars;

SELECT name, ((class+7)*intensity)*1000000 AS temperature FROM stars;

SELECT x, y, z FROM stars;

-- 4. SELECT  FROM  WHERE  ORDER BY  DESC

SELECT * FROM stars
WHERE starid=2348;

SELECT * FROM stars
WHERE starid>1000
AND starid<2000
AND class=0;

SELECT * FROM stars
WHERE starid>1000
AND starid<2000
AND class=0
ORDER BY intensity;

SELECT * FROM stars
WHERE starid>1000
AND starid<2000
AND class=0
ORDER BY intensity DESC;

SELECT * FROM stars
WHERE starid>1000
AND starid<2000
AND class=0
ORDER BY intensity DESC, z;

SELECT starid, x,y,z FROM stars
WHERE x>0
AND starid<100
ORDER BY y;

-- 5. MAX() MIN() COUNT() AVG() SUM() NULL

SELECT COUNT() FROM stars;  -- 25000

SELECT MAX(x) FROM stars;   -- 1.24898012393092

SELECT AVG(x*x+y*y+z*z) FROM stars; -- 0.522065010420078

SELECT SUM(y/x) FROM stars;  -- -2652.2560393692

-- 6. INSERT INTO  VALUES

INSERT INTO hilight VALUES (12340); -- New visual!

DELETE FROM hilight;  -- DELETES ENTIRE TABLE!!

-- Step 1
SELECT * FROM stars
WHERE starid BETWEEN 5000 AND 15000
AND class = 7;
-- Collects requested stars from galaxy  (5050, 5099, 5195, 5209, 5241)

-- star #1
INSERT INTO hilight VALUES (5099);

-- star #2
INSERT INTO hilight VALUES (5050);

-- star #3
INSERT INTO hilight VALUES (5195);

-- star #4
INSERT INTO hilight VALUES (5209);

-- star #5
INSERT INTO hilight VALUES (5241);

-- 7. INSERT INTO  SELECT
-- Clear the hilight table
DELETE FROM hilight;

INSERT INTO hilight SELECT starid FROM stars WHERE x>0;

-- Clear the hilight table
DELETE FROM hilight;

INSERT INTO hilight SELECT starid FROM stars WHERE starid >10000
AND starid <11000;

-- 8. Transactions, DELETE FROM  WHERE
BEGIN;
DELETE FROM stars WHERE x>0 AND y>0;
INSERT INTO hilight SELECT starid FROM stars
WHERE ((x-0.5)*(x-0.5)+(y+0.5)*(y+0.5)) < 0.02;

-- To undo changes
ROLLBACK

-- To make changes permanent
COMMIT
-- OR
END

BEGIN;
DELETE FROM stars WHERE starid < 10000;

-- 9. UPDATE  SET  WHERE

BEGIN;
UPDATE stars SET x=COALESCE(0.1/x,x), y=COALESCE(0.1/y,y);

ROLLBACK

BEGIN;
UPDATE stars SET z=z+(starid-12500)*0.00005;

ROLLBACK

BEGIN;
UPDATE stars SET x = z, z = x
WHERE starid BETWEEN 10000 AND 15000;
-- This also works
BEGIN;
UPDATE stars
SET x=z, z=x
WHERE starid > 10000
AND starid < 15000;

-- 10. SELECT FROM table1, table2  DISTINCT

SELECT * fROM planets;

SELECT stars.starid FROM planets, stars WHERE planets.starid=stars.starid;

SELECT s.starid FROM planets AS p, stars AS s WHERE p.starid=s.starid;

SELECT DISTINCT s.starid FROM planets AS p, stars AS s
WHERE p.starid=s.starid;

SELECT DISTINCT p.planetid FROM planets as p, moons AS m
WHERE p.planetid=m.planetid;

SELECT DISTINCT p.starid FROM planets as p, moons AS m
WHERE p.planetid=m.planetid;

DELETE FROM hilight;

BEGIN;
INSERT INTO hilight
SELECT DISTINCT(s.starid) FROM stars AS s, planets AS p, moons AS m
WHERE p.starid=s.starid
AND p.planetid=m.planetid
AND s.starid>=20000
AND m.orbitdistance>=3000;  -- Key is to remember hilight only contains 1 column.

-- 11. SELECT  FROM (SELECT  FROM  )

SELECT AVG(intensity) FROM stars;  -- 0.100360355555558

SELECT COUNT() FROM stars, (SELECT AVG(intensity) AS ai FROM stars)
WHERE intensity > ai;  -- 12603

SELECT COUNT() FROM stars, (SELECT AVG(intensity) AS ai2 FROM stars,
                           (SELECT AVG(intensity) AS ai FROM stars)
                            WHERE intensity > ai)
WHERE intensity > ai2;  -- 6124

BEGIN;
INSERT INTO hilight
SELECT DISTINCT(s.starid) FROM stars AS s, planets AS p
WHERE orbitdistance = (SELECT MAX(orbitdistance) FROM planets AS p);

BEGIN;
INSERT INTO hilight
SELECT DISTINCT(s.starid) FROM stars AS s
WHERE s.starid = (SELECT p.starid FROM planets AS p
WHERE p.orbitdistance = (SELECT MAX(p.orbitdistance) FROM planets AS p));

-- 12. SELECT FROM  JOIN

SELECT stars.name AS sn, planets.name AS pn FROM stars
LEFT OUTER JOIN planets ON stars.starid=planets.starid;

SELECT stars.name AS sn, planets.name AS pn, moons.name AS mn  FROM stars
LEFT OUTER JOIN planets ON stars.starid=planets.starid
LEFT OUTER JOIN moons ON planets.planetid=moons.planetid;

SELECT a.name AS starname,
     ((a.class+7)*a.intensity)*1000000 AS startemp,
       b.name AS planetname,
    (((a.class+7)*a.intensity)*1000000) - (50*b.orbitdistance) AS planettemp
FROM stars a
LEFT OUTER JOIN planets b ON (a.starid=b.starid)
WHERE a.starid > 500
AND a.starid <600;  -- Careful to use name not id.

-- 13. Create VIEW, DROP VIEW

CREATE VIEW relations AS SELECT stars.starid AS star,
planets.planetid AS planet,
moons.moonid AS moon
FROM stars
LEFT OUTER JOIN planets ON stars.starid=planets.starid
LEFT OUTER JOIN moons ON planets.planetid=moons.planetid;

SELECT * FROM relations

DROP VIEW relations

CREATE VIEW numbers
AS SELECT 3 AS three, stars.intensity, stars.x
FROM stars
ORDER BY stars.x;

-- 14. CREATE TABLE, DROP TABLE

CREATE TABLE persons (personid INTEGER PRIMARY KEY, name TEXT, hats INTEGER);

INSERT INTO persons (name, hats) VALUES ('John', 3);
INSERT INTO persons (name, hats) VALUES ('Mary', 2);

SELECT * FROM persons;  -- verify data is in table.

DROP table persons; -- deletes ENTIRE table!

-- Table Colors --
CREATE TABLE colors (color INTEGER, description TEXT);

INSERT INTO colors (color, description) VALUES (-3, "violet");
INSERT INTO colors (color, description) VALUES (-2, "purple");
INSERT INTO colors (color, description) VALUES (-1, "indigo");
INSERT INTO colors (color, description) VALUES (0, "dark blue");
INSERT INTO colors (color, description) VALUES (1, "blue");
INSERT INTO colors (color, description) VALUES (2, "blue-green");
INSERT INTO colors (color, description) VALUES (3, "green");
INSERT INTO colors (color, description) VALUES (4, "green-yellow");
INSERT INTO colors (color, description) VALUES (5, "yellow");
INSERT INTO colors (color, description) VALUES (6, "yellow-orange");
INSERT INTO colors (color, description) VALUES (7, "orange");
INSERT INTO colors (color, description) VALUES (8, "orange-red");
INSERT INTO colors (color, description) VALUES (9, "red-orange");
INSERT INTO colors (color, description) VALUES (10, "red");

-- 15. Constraints
-- Table quotes
CREATE TABLE quotes (id INTEGER PRIMARY KEY, quote TEXT NOT NULL);

INSERT INTO quotes (quote) VALUES ("Now is the time for all good men to come to the aid of their country!");
INSERT INTO quotes (quote) VALUES ("The quick brown fox jumped over the lazy dog!");
INSERT INTO quotes (quote) VALUES ("Red sky at night sailor's delight!");

-- 16. ALTER TABLE
ALTER TABLE stars RENAME TO bright_objects;

ALTER TABLE colors ADD COLUMN notes TEXT;

ALTER TABLE hilight RENAME COLUMN notes TO remarks; -- error.  Error persists with copy/paste query direct from Guru notes.

ALTER TABLE hilight MODIFY COLUMN remarks CHAR(200) NOT NULL; -- error.  Error persists with copy/paste query direct from Guru notes.

ALTER TABLE hilight DROP COLUMN remarks;-- error.  Error persists with copy/paste query direct from Guru notes.

CREATE TABLE foods (id INTEGER PRIMARY KEY, name TEXT, color TEXT);

INSERT INTO foods (name, color) VALUES ("kiwi", "green");
INSERT INTO foods (name, color) VALUES ("orange", "orange");
INSERT INTO foods (name, color) VALUES ("apple", "red");
INSERT INTO foods (name, color) VALUES ("blueberry", "blue");

ALTER TABLE foods RENAME TO my_table;

ALTER TABLE my_table ADD COLUMN moredata;

INSERT INTO my_table (name, color, moredata) VALUES ("grapes", "wine", "Sweet");

SELECT * FROM my_table;

UPDATE my_table SET moredata="Sweet" WHERE id=2 OR id=4;

UPDATE my_table SET moredata="Sour" WHERE id=3 OR id=1;  -- no NULLS in noredata column...

-- 17. SELECT  GROUP BY  HAVING

SELECT class, MAX(intensity)AS brightness FROM stars
GROUP BY class
ORDER BY brightness DESC;

SELECT class, SUM(intensity) AS brightness FROM stars
GROUP BY class HAVING brightness <=150
ORDER BY brightness DESC;

SELECT class FROM stars
GROUP BY class HAVING SUM(intensity) <= 150
ORDER BY SUM(intensity) DESC;

SELECT stars.starid AS starid, COUNT(planets.planetid)AS planet_count
FROM stars
LEFT OUTER JOIN planets ON stars.starid=planets.starid
GROUP BY stars.starid;

DELETE from hilight;

SELECT a.starid, (COUNT(b.planetid) + COUNT(c.planetid)) AS orbitals FROM stars a
JOIN planets b ON (a.starid=b.starid)
JOIN moons c ON (b.planetid = c.planetid)
GROUP BY a.starid
ORDER BY orbitals DESC;

INSERT INTO hilight VALUES (22336);

--18. UNION, UNION ALL, INTERSECT, EXCEPT

SELECT 1 UNION SELECT 1 UNION SELECT 3;  -- title, 2 rows

SELECT COUNT() FROM (SELECT starid FROM stars UNION SELECT starid FROM planets) -- 25000  all stars

SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 3; -- title, 3 rows

SELECT COUNT() FROM (SELECT starid FROM stars UNION ALL SELECT starid FROM planets); -- 56057  sum of all stars and all planets

SELECT COUNT() FROM (SELECT starid FROM stars INTERSECT SELECT starid FROM planets); -- 3927 stars with planets

SELECT COUNT() FROM (SELECT starid FROM stars EXCEPT SELECT starid FROM planets); -- 21073 stars without planets

SELECT starid FROM planets
INTERSECT
SELECT 3*starid FROM planets
INTERSECT
SELECT starid FROM planets
EXCEPT
SELECT 2*starid FROM planets;

-- 19. Triggers

CREATE TRIGGER stardeleted BEFORE DELETE ON stars FOR EACH ROW BEGIN DELETE FROM planets WHERE planets.starid=OLD.starid; END

CREATE TRIGGER planetdeleted BEFORE DELETE ON planets FOR EACH ROW BEGIN DELETE FROM moons WHERE OLD.planetid=moons.planetid; END

BEGIN; DELETE FROM stars;

SELECT * FROM moons;

ROLLBACK;

DROP TRIGGER stardeleted;

DROP TRIGGER planetdeleted;
--------------------------------------------------------------------------------
--                       This section is not solid.                           --
--------------------------------------------------------------------------------
DELETE FROM hilight
INSERT INTO hilight NEW.starid
NEW.starid=star.starid

WHERE OLD.starid=star.starid

DROP TRIGGER hinewstar;

CREATE TRIGGER hinewstar
AFTER INSERT ON stars
FOR EACH ROW
BEGIN DELETE FROM hilight
WHERE OLD.starid=stars.starid; END

CREATE TRIGGER hinewstar
BEFORE INSERT ON stars
BEGIN DELETE FROM hilight
WHERE NEW.starid=stars.starid; END

CREATE TRIGGER hinewstar
BEFORE INSERT ON stars
DELETE FROM hilight
AFTER INSERT ON stars
FOR EACH NEW.starid
BEGIN NEW.starid = hilight.starid;
END

CREATE TRIGGER hinewstar
BEFORE INSERT ON stars
DELETE FROM hilight
AFTER INSERT ON stars
FOR EACH NEW.starid
BEGIN INSERT INTO hilight VALUES (NEW.starid);
END

CREATE TRIGGER hinewstar
AFTER INSERT ON stars
BEGIN INSERT INTO hilight
VALUES (NEW.starid); END

CREATE TRIGGER hinewstar
AFTER INSERT ON stars
BEGIN
INSERT INTO hilight VALUES (NEW.starid); END
--------------------------------------------------------------------------------
-- 20. Indexes

CREATE TABLE gateway (star1 INTEGER PRIMARY KEY, star2 INTEGER);

INSERT INTO gateway SELECT starid, RANDOM()%12500+12500 FROM stars WHERE starid%100=0;

SELECT starid FROM stars, gateway WHERE star2=starid;

CREATE INDEX gateways_star2 ON gateway (star2);

-- Repeat
SELECT starid FROM stars, gateway WHERE star2=starid;

ALTER TABLE gateway RENAME TO gateways;
