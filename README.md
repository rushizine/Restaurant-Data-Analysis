# Restaurant Data Analysis

**Python | SQL | Power BI**

I analysed **9,551 restaurants from 15 countries** to find trends in cuisines, cities, prices, ratings, votes and services (online delivery and table booking).

## What I Did

1. **Cleaned the data** with Pandas (missing values, duplicates, unrated restaurants).
2. **Explored the data** with Pandas and made charts with Matplotlib and Seaborn.
3. **Wrote SQL queries** for the same questions (GROUP BY, HAVING, CASE, subqueries).
4. **Planned a Power BI dashboard** with DAX measures, KPIs and slicers.

## Project Files

```
restaurant-data-analysis/
├── data/
│   ├── restaurants.csv            # original data
│   └── restaurants_clean.csv      # cleaned data (for SQL and Power BI)
├── notebooks/restaurant_analysis.ipynb   # all analysis, charts and insights
├── sql/restaurant_queries.sql     # table + all queries
├── powerbi/dax_measures.md        # DAX measures and dashboard steps
├── images/                        # charts
├── requirements.txt
└── README.md
```

## Main Results

| Question | Answer |
|---|---|
| Top 3 cuisines | North Indian (41.5%), Chinese (28.6%), Fast Food (20.8%) |
| City with most restaurants | New Delhi (5,473) |
| Best rated city (20+ rated restaurants) | London (4.54) |
| Price range | 79% of restaurants are in range 1 and 2 |
| Online delivery | 25.7% offer it. Rating with delivery 3.38, without 3.47 |
| Most common rating range | 3.0 - 3.5 (average rating 3.44) |
| Most common cuisine combination | North Indian, Chinese (511 restaurants) |
| Restaurant chains | 112 names have 5+ outlets. Biggest: Cafe Coffee Day (83) |
| Votes vs rating | More votes = higher rating (correlation 0.41) |
| Table booking | 0.02% in price range 1, up to 46.8% in price range 4 |
| Online delivery by price | Highest in price range 2 (41.3%), lowest in range 4 (9.0%) |


## How to Run

```bash
pip install -r requirements.txt
jupyter notebook notebooks/restaurant_analysis.ipynb
```

Run all cells. For SQL, open `sql/restaurant_queries.sql` in MySQL Workbench, create the table, import `data/restaurants_clean.csv` and run the queries.
For Power BI, follow `powerbi/dax_measures.md`.

## Important Decisions (easy to explain)

- **Rating = 0 means "not rated".** 2,148 restaurants have no rating. I removed them only when calculating average ratings, because they are not bad restaurants.
- **Small cities:** a city with 2 restaurants can show a 4.9 average. So I only compare cities with 20 or more rated restaurants.
- **Online delivery vs rating:** overall the delivery group looks lower (3.38 vs 3.47). But almost all delivery restaurants are in India, where ratings are lower. Inside India only, the two groups are almost equal (3.37 vs 3.34).
- **Chain:** a restaurant name used 5 or more times.
- **Wrong map points:** rows with longitude or latitude = 0 were removed from the map.

## Limits

- The data has **no reviews**, so the review task was skipped. No fake data was used.
- 91% of the restaurants are in India, so results mostly show India (New Delhi).
- A link between two things (for example votes and rating) does not prove one causes the other.

## Interview Quick Notes

- **What is the project?** Analysis of 9,551 restaurants to find trends in cuisine, price, rating, votes and services.
- **How did you clean the data?** Filled 9 missing cuisines, checked duplicates (none), and treated rating 0 as "not rated".
- **Which Pandas functions did you use?** `read_csv`, `isnull`, `groupby`, `value_counts`, `str.split` + `explode`, `crosstab`, `cut`, `corr`, `nlargest`.
- **What is one insight?** Costly restaurants offer table booking much more (0.02% to 46.8%), but they offer delivery less.
- **Why remove unrated restaurants?** Rating 0 is "no rating yet". Keeping it would pull averages down.
- **What SQL did you use?** `GROUP BY`, `HAVING`, `CASE WHEN`, `LIKE`, `UNION ALL`, subquery for percentage.
- **What is DAX?** The formula language of Power BI. I used `CALCULATE`, `COUNTROWS`, `DIVIDE`.

## Author

**Rushikesh Zine** - B.Sc. Data Science, Savitribai Phule Pune University
