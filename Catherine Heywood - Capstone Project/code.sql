------ Count Total Sources ------
SELECT COUNT(DISTINCT utm_source) AS ‘Total_Source’
FROM page_visits;


------ Count Total Campaigns ------
SELECT COUNT(DISTINCT utm_campaign) AS ‘Total_Campaign’
FROM page_visits;


------ How They are Related ------
SELECT DISTINCT utm_source AS ‘Sources’, 
	utm_campaign AS ‘Campaigns’
FROM page_visits;


------ Distinct Page Names ------
SELECT DISTINCT page_name AS ‘Page Names’
FROM page_visits;


------ First Touch ------
WITH first_touch AS (
  SELECT user_id,
  	MIN(timestamp) as first_touch_at
  FROM page_visits
  GROUP BY user_id), 
ft_attr AS (
  SELECT ft.user_id,
  	ft.first_touch_at,
  	pv.utm_source,
  	pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT ft_attr.utm_source AS 'Source',
	ft_attr.utm_campaign AS 'Campaign',
  COUNT(*) AS 'First Touch Count'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


------ Last Touch ------
WITH last_touch AS (
	SELECT user_id,
  	MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
  	lt.last_touch_at,
  	pv.utm_source,
  	pv.utm_campaign,
  	pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source as source,
	lt_attr.utm_campaign as campaign,
  COUNT(*) as count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


---- Number of visitors that made a purchase ----
SELECT page_name as page, 
   COUNT(*) as count
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY page;

---- Number of visitors per page ----
SELECT page_name as page, 
   COUNT(*) as count
FROM page_visits
GROUP BY page;


------ Sources & Campaigns that generated purchases ------
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) AS 'last_touch_at'
	FROM page_visits
	WHERE page_name = '4 - purchase'
	GROUP BY user_id),
lt_attr AS (
	SELECT lt.user_id,
		lt.last_touch_at,
		pv.utm_source,
		pv.utm_campaign,
		pv.page_name
	FROM last_touch lt
	JOIN page_visits pv
		ON lt.user_id = pv.user_id
		AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source as source,
	lt_attr.utm_campaign as campaign,
	COUNT(*) as count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


------ Last touch on purchase page for each campaign------
WITH last_touch AS (
SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source as source,
       lt_attr.utm_campaign as campaign,
       COUNT(*) as count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


---- Snapshot of typical user journey ----
SELECT *
FROM page_visits
ORDER BY user_id ASC
LIMIT 75;

