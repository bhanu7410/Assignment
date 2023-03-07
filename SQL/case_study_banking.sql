Create DATABASE BANKDB;

use bankdb;
SELECT * FROM BANK;
-- 1. GIVE THE MAXIMUM MEAN AND MINIMUM BALANCE OF THE TARGETED CUSTOMER
 alter table bank ADD COLUMN AGE_GROUP VARCHAR(20);   
UPDATE BANK 
SET AGE_GROUP = IF (AGE <= 25, '<25', IF (AGE>40,'40+', '25-40'));

SELECT MAX(SUCC_COUNT), MIN( SUCC_COUNT), AVG(SUCC_COUNT)
FROM (SELECT COUNT(Y) AS SUCC_COUNT 
	FROM BANK
    WHERE Y = 'YES'
    GROUP BY AGE_GROUP) AS BANKI;

-- 2. Check the quality of customers by checking averBALANCE balance, median balance of customers
SET @rowindex := -1;
SELECT AVG(BALANCE), (
					SELECT
					   AVG(d.BALANCE) as Median 
					FROM
					   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
							   BANK.BALANCE AS BALANCE
						FROM BANK
						ORDER BY BANK.BALANCE) AS d
					WHERE
					d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
) AS MEDIAN FROM BANK;
-- 3. Check if BALANCE matters in marketing subscrpition for deposit
SELECT Y, AVG(BALANCE) 
FROM BANK
GROUP BY Y;

-- 4. Check if marital status mattered for a subscription to deposit
SELECT MARITAL, COUNT(Y)
FROM bank
WHERE Y = 'YES'
GROUP BY MARITAL;

-- 5. Check if BALANCE and marital status together matterted for a subscription to deposit scheme.
SELECT MARITAL,AVG(BALANCE), COUNT(Y)
FROM bank
WHERE Y = 'YES'
GROUP BY MARITAL with rollup;

-- 6. Do feature engineering for the bank and find the right age effect on the campaign.
SELECT AGE_GROUP, COUNT(Y) AS SUCC_COUNT
FROM BANK
WHERE Y = 'YES'
GROUP BY AGE_GROUP
ORDER BY SUCC_COUNT DESC;
