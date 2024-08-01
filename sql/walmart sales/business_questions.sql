-- Business Questions To Answer --
-- Generic Questions ----------------------------------------
-- 1. How many unique cities does the data have?
SELECT 
	COUNT(DISTINCT `City`) AS unique_cities
FROM salesdatawalmart.`walmartsalesdata.csv`;

-- 2. In which city is each branch?
SELECT
	DISTINCT `City`,
	`Branch`
FROM salesdatawalmart.`walmartsalesdata.csv`
ORDER BY 2, 1 DESC;

-- Product -----------------------------------------------
-- 1. How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT `Product Line`) AS unique_product
FROM salesdatawalmart.`walmartsalesdata.csv`;

-- 2. What is the most common payment method?
SELECT
	`Payment`,
    COUNT(`Payment`) AS count_pay
FROM  salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `Payment`
ORDER BY count_pay DESC
LIMIT 1;

-- OR --

WITH PaymentCounts AS (
	SELECT
		`Payment`,
        COUNT(`Payment`) AS most_common_pay
	FROM salesdatawalmart.`walmartsalesdata.csv`
    GROUP BY `Payment`
),
MaxCount AS (
	SELECT
		MAX(most_common_pay) AS max_pay
	FROM PaymentCounts
)

SELECT
	`Payment`,
    most_common_pay
FROM PaymentCounts
WHERE most_common_pay = (SELECT max_pay FROM MaxCount)
ORDER BY `Payment` DESC;

-- 3. What is the most selling product line?
SELECT
	`Product Line`,
    COUNT(`Product Line`) AS count_pro
FROM  salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `Product Line`
ORDER BY count_pro DESC
LIMIT 1;

-- OR --

WITH ProductCounts AS (
	SELECT
		`Product Line`,
        COUNT(`Product Line`) AS most_sell_prod
	FROM salesdatawalmart.`walmartsalesdata.csv`
    GROUP BY `Product Line`
),
MaxCount AS (
	SELECT
		MAX(most_sell_prod) AS max_sell
	FROM ProductCounts
)

SELECT
	`Product Line`,
    most_sell_prod
FROM ProductCounts
WHERE most_sell_prod = (SELECT max_sell FROM MaxCount)
ORDER BY `Product Line` DESC;

-- 4. What is the total revenue by month?
SELECT
	ROUND(SUM(`Total`), 2) AS total_revenue,
    `month_name`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY  2
ORDER BY 1 DESC;

-- 5. What month had the largest COGS?
SELECT
	SUM(`cogs`) AS largest_cogs,
    `month_name`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY  2
ORDER BY 1 DESC
LIMIT 1;

-- 6. What product line had the largest revenue?
SELECT
	SUM(`Total`) AS largest_revenue,
    `Product Line`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY  2
ORDER BY 1 DESC
LIMIT 1;

-- 7. What is the city with the largest revenue?
SELECT
	SUM(`Total`) AS largest_revenue,
    `City`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY  2
ORDER BY 1 DESC
LIMIT 1;

-- 8. What product line had the largest VAT?
SELECT
	SUM(`Tax 5%`) AS largest_revenue,
    `Product Line`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY  2
ORDER BY 1 DESC
LIMIT 1;

-- 9. Which branch sold more products than average product sold?
SELECT
	`Branch`,
    SUM(`Quantity`) AS qty
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `Branch`
HAVING SUM(`Quantity`) > (SELECT AVG(`Quantity`) FROM salesdatawalmart.`walmartsalesdata.csv`)
ORDER BY 1, 2;

-- 10. What is the most common product line by gender?
SELECT 
	`Gender`,
    `Product Line`,
    COUNT(`Product Line`) AS most_common
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1, 2
ORDER BY 3 DESC;

WITH ProductCounts AS (
	SELECT
		`Gender`,
		`Product Line`,
        COUNT(`Product Line`) AS pro_count
	FROM salesdatawalmart.`walmartsalesdata.csv`
    GROUP BY `Gender`, `Product Line`
),
rankCount AS (
	SELECT
		`Gender`,
        `Product Line`,
        pro_count,
		RANK() OVER(PARTITION BY `Gender` ORDER BY pro_count DESC) AS most_common_pro
	FROM ProductCounts
)
SELECT
	`Gender`,
	`Product Line`,
    pro_count
FROM rankCount
WHERE most_common_pro = 1
ORDER BY `Gender`, `Product Line` DESC;

-- 11. What is the average rating of each product line?
SELECT
	`Product Line`,
    ROUND(AVG(`Rating`), 2) AS avg_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1
ORDER BY 2 DESC;

-- Sales --------------------------------------
-- 1. Number of sales made in each time of the day per weekday
SELECT
	COUNT(*) AS number_sales,
    `time_of_day`,
    `week_day`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 2, 3
ORDER BY 1;
-- 2. Which of the customer types brings the most revenue?
SELECT
	ROUND(SUM(`Total`), 2) AS revenue,
    `Customer Type`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 2
ORDER BY 1 DESC
LIMIT 1;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	`City`,
    `Tax 5%` AS largest_tax
FROM salesdatawalmart.`walmartsalesdata.csv`
ORDER BY 2 DESC
LIMIT 1;

-- 4. Which customer type pays the most in VAT?
SELECT
	`Customer Type`,
    `Tax 5%` AS largest_tax
FROM salesdatawalmart.`walmartsalesdata.csv`
ORDER BY 2 DESC
LIMIT 1;

-- Customer ---------------------------------------
-- 1. How many unique customer types does the data have?
SELECT
	DISTINCT `Customer type`
FROM salesdatawalmart.`walmartsalesdata.csv`;

-- 2. How many unique payment methods does the data have?
SELECT
	DISTINCT `Payment`
FROM salesdatawalmart.`walmartsalesdata.csv`;

-- 3. What is the most common customer type?
SELECT
	`Customer type`,
	COUNT(`Customer type`) AS most_common_cus
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 4. Which customer type buys the most?
SELECT
	`Customer type`,
	COUNT(*) AS most_buy
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 5. What is the gender of most of the customers?
SELECT
	`Gender`,
    COUNT(`Gender`) AS most_gender
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1
ORDER BY 2 DESC;

-- 6. What is the gender distribution per branch?
SELECT
	`Branch`,
	`Gender`,
    COUNT(`Gender`) AS most_gender
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1, 2
ORDER BY 1, 2 DESC;

-- 7. Which time of the day do customers give most ratings?
SELECT
    `time_of_day`,
    COUNT(`rating`) AS most_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT
	`Branch`,
    `time_of_day`,
    COUNT(`rating`) AS most_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- 9. Which day of the week has the best avg ratings?
SELECT
    `week_day`,
    ROUND(AVG(`rating`), 2) AS best_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1
ORDER BY 1, 2 DESC
LIMIT 1;

-- 10. Which day of the week has the best average ratings per branch?
SELECT
	`Branch`,
    `week_day`,
    ROUND(AVG(`rating`), 2) AS best_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
