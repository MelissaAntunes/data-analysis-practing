-- add new columns from existing ones to help answer some questions
-- ---------- time_of_day ----------
SELECT
	time,
    (CASE
		WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN Time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM salesdatawalmart.`walmartsalesdata.csv`;

ALTER TABLE salesdatawalmart.`walmartsalesdata.csv`
ADD COLUMN time_of_day VARCHAR(20);

-- updated using command line client
UPDATE salesdatawalmart.`walmartsalesdata.csv`
SET time_of_day = 
	(CASE
		WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN Time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening" 
	END);
    
-- ---------- week_day ----------
SELECT
	Date,
    DAYNAME(Date)
FROM salesdatawalmart.`walmartsalesdata.csv`;

ALTER TABLE salesdatawalmart.`walmartsalesdata.csv`
ADD COLUMN week_day VARCHAR(20);

-- updated using command line client
UPDATE salesdatawalmart.`walmartsalesdata.csv`
SET week_day = DAYNAME(Date);

-- ---------- month_name ----------
SELECT
	Date,
    MONTHNAME(Date)
FROM salesdatawalmart.`walmartsalesdata.csv`;

ALTER TABLE salesdatawalmart.`walmartsalesdata.csv`
ADD COLUMN month_name VARCHAR(20);

-- updated using command line client
UPDATE salesdatawalmart.`walmartsalesdata.csv`
SET month_name = MONTHNAME(Date);
