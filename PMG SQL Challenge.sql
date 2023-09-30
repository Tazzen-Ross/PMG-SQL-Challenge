-- PMG SQL Challenge

/*

As setup for this problem, I took the three CSV files and their correlated table schemas 
and created a MYSQL database in MYSQL Workbench so that I could query the data using the
MYSQL extension in VSCODE. The queries below are all done using that database, but they 
follow the same structure outlined in the problem statement and thus should work on any
database created with the same schema. 


/* Question 1

1. Write a query to get the sum of impressions by day.

To get the sum of impressions by day, we need to pull both the date and 
impressions summed from the "marketing_data" table. We then need to group 
by date in order to get the total impressions for each day.
*/

SELECT 
    date, 
    SUM(impressions) AS total_impressions
FROM marketing_data
GROUP BY date
ORDER BY date;


/* Question 2

2. Write a query to get the top three revenue-generating states in order
of best to worst. How much revenue did the third best state generate?

To get the three highest revenue states from best to worst, we first need 
to select state and the sum of revenue from "website_revenue". We then need
to group by state to get the sum of revenue by state and then order the 
results by total revenue in descending order to get the results from best to
worst. The third best state is Ohio and it generated $37,577 in revenue.
*/

SELECT 
    state, 
    SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 3;

/* Question 3

3. Write a query that shows total cost, impressions, clicks, and revenue 
of each campaign. Make sure to include the campaign name in the output.

To get all these features in one table, we need to join together multiple 
tables. We will pull the name from "campaign_info" aliased as ci, cost, 
impressions, and clicks from "marketing_data" aliased as md, and revenue
from website_revenue aliased as wr. We also sum each of the metrics to get 
their totals. To join all of these tables together we will use the commonly
shared ID columns from each table. We then join marketing_data and 
website_revenue using a left join. I chose to use a left join here simply 
to ensure that if there are campaigns that do not have matching records in
either table they are not dropped.
*/

SELECT 
    ci.name AS campaign_name,
    SUM(md.cost) AS total_cost,
    SUM(md.impressions) AS total_impressions,
    SUM(md.clicks) AS total_clicks,
    SUM(wr.revenue) AS total_revenue
FROM campaign_info ci
LEFT JOIN marketing_data md ON ci.id = md.campaign_id
LEFT JOIN website_revenue wr ON ci.id = wr.campaign_id
GROUP BY ci.name
ORDER BY ci.name;

/* Question 4

4. Write a query to get the number of conversions of Campaign5 by state. 
Which state generated the most conversions for this campaign?

To get the sum of conversions by state for Campaign5 we need to join 
together each table once again on ID and then filter results using a WHERE
clause in which the name column is equal to "Campaign5". To finish this 
query we then need to group by state and order by the sum of conversions in
descending order. After doing this we see that Georgia generated the most
conversion for Campaign5 with 3342 conversions.
*/

SELECT 
    wr.state,
    SUM(md.conversions) AS total_conversions
FROM campaign_info ci
JOIN marketing_data md ON ci.id = md.campaign_id
JOIN website_revenue wr ON ci.id = wr.campaign_id
WHERE ci.name = 'Campaign5'
GROUP BY wr.state
ORDER BY total_conversions DESC;

/* Question 5

5. In your opinion, which campaign was the most efficient, and why?

This is an interesting question because there ar multiple different 
criteria with which we could evaluate the effectiveness of these campaigns.
It depends on what the company/stakeholder values the most. If the main 
goal of these campaigns is to drive conversions then we could use a metric
like Cost per Conversion or Revenue per Conversion. However without knowing
what metric is most important it's safest to assume that monetary benefit
of each campaign is what matters most. Thus using a metric like ROI can 
help us determine which is the best campaign. ROI is calculated by 
(Revenue -Cost) / Cost. After creating this column in the data we see that
Campaign4 has the highest ROI of 40.15. Thus from a monetary perspective
Campaign4 is objectively the most efficient.

*/

SELECT 
    ci.name AS campaign_name,
    SUM(md.cost) AS total_cost,
    SUM(wr.revenue) AS total_revenue,
    (SUM(wr.revenue) - SUM(md.cost)) / SUM(md.cost) AS ROI
FROM campaign_info ci
LEFT JOIN marketing_data md ON ci.id = md.campaign_id
LEFT JOIN website_revenue wr ON ci.id = wr.campaign_id
GROUP BY ci.name
ORDER BY ROI DESC;

/* Question 6

6. Write a query that showcases the best day of the week (e.g., Sunday, 
Monday, Tuesday, etc.) to run ads.

When looking at the best day to run ads, we are most likely looking at 
the engagement with the ads each day. By querying to find the
total impressions and conversions on each day, we see that 
Friday would be objectively be the best days to run ads based
on those metrics. Taking it a step further, if we look at the
rate of Conversions per Impressions, we see that Friday has
the second best CPI(Conversion per Impression) Rate of 25%.
While Wednesday's CPI rate i higher at 28% there over 10k less
impressions on Wednesdays, meaning that despite its high 
conversion rate there are relatively few people seeing our ad
that day. Thus it is my conclusion that because of the high
impressions and relatively high CPI rate Friday is the best
day to run our ads.

*/

SELECT 
    DAYNAME(date) AS day_of_week_name,
    SUM(impressions) AS total_impressions,
    SUM(conversions) AS total_conversions,
    SUM(conversions) / SUM(impressions) AS CperI
FROM marketing_data
GROUP BY day_of_week_name
ORDER BY total_impressions DESC;