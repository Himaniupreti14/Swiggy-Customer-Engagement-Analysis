# Swiggy-Customer-Engagement-Analysis
Project Overview

This project explores customer behavior, product purchases, and membership signup data using SQL queries. The dataset involves customers, their product purchases, and gold membership signups. The main goal of this analysis is to derive insights related to customer spending, the impact of gold membership on purchasing behavior, and sales growth trends.

Dataset Description:
The project uses four tables: users, sales, product, and goldusers_signup.

Users Table (users): Contains user IDs and their signup dates.

Sales Table (sales): Contains transaction records, including user ID, product ID, and transaction dates.

Product Table (product): Contains product IDs, product names, and prices.

Gold Users Table (goldusers_signup): Contains user IDs and the date they signed up for the gold membership.

Key Business Insights

1.Total Amount Spent by Each Customer

Insight: By calculating the total amount spent by each customer, we can identify high-value customers. For instance, users who consistently spend on high-priced products may be targeted with personalized offers or loyalty rewards to encourage further engagement and retention.

2.Customer Visit Frequency

Insight: Tracking how frequently customers make purchases reveals patterns in their buying behavior. Customers with high visit frequency are prime candidates for upselling or cross-selling, while low-frequency customers may need re-engagement strategies like special promotions or targeted emails.

3.First Product Purchased by Each Customer

Insight: Identifying the first product each customer buys helps in understanding initial customer preferences. This can be used to optimize product recommendations for new users, enhance onboarding strategies, and increase conversion rates by showing popular or frequently chosen items upfront.

4.Most Purchased Product

Insight: Understanding which product is the most purchased provides valuable information for inventory management, pricing strategies, and promotional efforts. The most popular product could be highlighted in marketing campaigns or bundled with other items to boost sales.

5.First Purchase After Gold Membership

Insight: By analyzing the first purchase made after users become gold members, we can assess whether gold membership leads to a shift in customer behavior, such as buying higher-priced items or making more frequent purchases. This can inform decisions on how to promote gold membership benefits more effectively.

6.Last Purchase Before Gold Membership

Insight: Knowing what customers buy right before becoming gold members could help identify triggers that push customers to upgrade. For example, customers might upgrade after purchasing certain premium products or reaching a spending threshold, offering insights into refining membership sign-up prompts.

7.Customer Behavior Before Gold Membership

Insight: Tracking total orders and spending before customers become gold members shows us whether the membership is attracting already loyal customers or if it's bringing in newer, high-spending users. This could guide strategies to incentivize non-members to join earlier in their customer journey.

8.Rank of All Transactions

Insight: Ranking transactions helps in understanding the purchase flow of each customer. Customers making frequent and higher-value transactions may be approached for premium services or exclusive offerings, while those with sporadic purchases may need re-engagement efforts.

9.Top Active Users by Purchase Count

Insight: Identifying the most active users allows the business to focus on retaining its most loyal customers. This group could be segmented for special loyalty programs, VIP treatment, or early access to new products to strengthen their relationship with the brand.

10.Transaction Ranking for Non-Gold Members

Insight: Ranking transactions and marking non-gold member purchases as 'NA' allows for a quick view of potential gold membership candidates. This analysis can reveal customers who are close to becoming gold members, making them ideal for targeted marketing campaigns.

11.Month-over-Month Sales Growth for Each Product

Insight: Tracking sales growth on a monthly basis allows the business to identify which products are gaining popularity and which ones may need more promotion. This can also help detect seasonal trends and inform inventory management, pricing adjustments, or marketing strategies.

12.Gold vs Non-Gold Member Retention

Insight: Gold members typically exhibit higher retention rates due to loyalty programs and benefits. By comparing retention rates between gold and non-gold members, the business can evaluate the effectiveness of the membership program and identify strategies to convert more non-gold members.

13.Month-over-Month Revenue for Gold vs Non-Gold Members

Insight: Comparing revenue growth between gold and non-gold members provides insights into which customer segment contributes more to the business. If gold members show consistently higher revenue growth, the business can justify investing more in promoting the membership program.

14.Time to Purchase Gold Membership (75th Percentile)

Insight: The time it takes for 75% of customers to purchase a gold membership post-signup gives a clear idea of when to intensify marketing efforts for membership upgrades. This helps in timing targeted offers and reminders to potential gold members based on their lifecycle stage.
