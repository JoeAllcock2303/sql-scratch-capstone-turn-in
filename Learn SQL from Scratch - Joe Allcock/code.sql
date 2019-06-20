--1. Select all columns from the first ten rows, what columns does the table have?
 SELECT * 
 FROM survey
 LIMIT 10;
 
 --2. What is the number of responses for each question?
 SELECT question AS 'Question', 
 COUNT(*) As 'Survey Funnel'
 FROM survey
 GROUP BY question;
 
 
 --4. Examine the first five rows of each table. What are the column names?
  
 SELECT *  
 FROM quiz
 LIMIT 5;
 
 SELECT * 
 FROM home_try_on
 LIMIT 5;
 
 SELECT * 
 FROM purchase
 LIMIT 5;
 
 --5. Examining the quiz to home try on to purchase funnel
 SELECT 
 quiz.user_id, 
 home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
 home_try_on.number_of_pairs, 
 purchase.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz
 LEFT JOIN home_try_on
 ON quiz.user_id = home_try_on.user_id
 LEFT JOIN purchase
 ON quiz.user_id = purchase.user_id 
 LIMIT 10;
 
 --6. Using the table from question 5 to calculate conversion rates
 WITH test AS(
   SELECT 
 quiz.user_id, 
 home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
 home_try_on.number_of_pairs, 
 purchase.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz
 LEFT JOIN home_try_on
 ON quiz.user_id = home_try_on.user_id
 LEFT JOIN purchase
 ON quiz.user_id = purchase.user_id)
 

SELECT number_of_pairs, 
COUNT(DISTINCT CASE
     WHEN number_of_pairs = '5 pairs'
     THEN user_id
    ELSE user_id
     END) AS 'Number of Purchases'
FROM test
WHERE is_purchase = 1
GROUP BY 1
ORDER BY 1;

  WITH test AS(
   SELECT DISTINCT
 quiz.user_id, 
 home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
 home_try_on.number_of_pairs, 
 purchase.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz
 LEFT JOIN home_try_on
 ON quiz.user_id = home_try_on.user_id
 LEFT JOIN purchase
 ON quiz.user_id = purchase.user_id)
 
 SELECT
 COUNT(user_id) AS 'Total Number',
1.0 * SUM(is_home_try_on)/COUNT(user_id) AS 'Quiz to home try on',
1.0 * SUM(is_purchase)/ SUM(is_home_try_on) AS 'Home try on to purchase'
FROM test;
 
 WITH test AS(
   SELECT DISTINCT
 quiz.user_id, 
 home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
 home_try_on.number_of_pairs, 
 purchase.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz
 LEFT JOIN home_try_on
 ON quiz.user_id = home_try_on.user_id
 LEFT JOIN purchase
 ON quiz.user_id = purchase.user_id)
 
 SELECT
 COUNT(user_id) AS 'Total Number',
1.0 * SUM(is_home_try_on)/COUNT(user_id) AS 'Home Try on Conversion',
1.0 * SUM(is_purchase)/ COUNT(user_id) AS 'Purchase Conversion'
FROM test;


