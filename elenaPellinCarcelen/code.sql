1.1)
SELECT COUNT(DISTINCT utm_campaign) AS 'Number of campaigns'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'Number of sources'
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;


1.2)
SELECT DISTINCT page_name
FROM page_visits;


2.1)
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
    
SELECT pv.utm_campaign, COUNT(ft.first_touch_at) AS 'Number of first-touch'
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;


2.2)
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
    
SELECT pv.utm_campaign, COUNT(lt.last_touch_at) AS 'Number of last-touch'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;


2.3)
SELECT COUNT(DISTINCT user_id) AS 'Purchases'
FROM page_visits
WHERE page_name = '4 - purchase';


2.4)
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id)
    
SELECT pv.utm_campaign, COUNT(lt.last_touch_at) AS 'Last-touch on Purchase'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;


2.5)
SELECT page_name, COUNT(DISTINCT user_id) AS 'Number of users'
FROM page_visits
GROUP BY 1;


3.1)
WITH first_touch AS 
(
  SELECT user_id, MIN(timestamp) AS first_touch_at
  FROM page_visits
  GROUP BY user_id
), 
last_touch AS 
(
  SELECT user_id, MAX(timestamp) as last_touch_at
  FROM page_visits
  GROUP BY user_id
)

SELECT pv.utm_campaign, (IFNULL(COUNT(ft.first_touch_at), 0) + COUNT(lt.last_touch_at)) AS 'Sum of users'
FROM page_visits pv
LEFT JOIN first_touch ft
	ON pv.user_id = ft.user_id
	AND pv.timestamp = ft.first_touch_at
LEFT JOIN last_touch lt
	ON pv.user_id = lt.user_id
	AND pv.timestamp = lt.last_touch_at             
GROUP BY 1                                
ORDER BY 2 DESC
LIMIT 5;