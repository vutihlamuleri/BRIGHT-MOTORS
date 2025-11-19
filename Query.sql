SELECT
    MAKE,
    MODEL,
    TRANSMISSION,
    COLOR,
    YEAR,
    STATE,
    COUNT(*) as units_sold,
    SUM(sellingprice) as total_revenue,
    AVG(sellingprice) as avg_selling_price,
    AVG(CASE WHEN sellingprice > 0 THEN (sellingprice - mmr) / sellingprice * 100 END) as profit_margin_pct,
    DATE_PART('year', parsed_date) as sale_year,
    DATE_PART('month', parsed_date) as sale_month,
    AVG(odometer) as avg_odometer,
    AVG(condition) as avg_condition,
    COUNT(DISTINCT color) as color_varieties,
    CASE 
    WHEN odometer <= 36000 THEN '0-36k: Like New (3yr avg)'
    WHEN odometer <= 60000 THEN '36k-60k: Low (3-5yr avg)'
    WHEN odometer <= 84000 THEN '60k-84k: Average (5-7yr avg)'
    WHEN odometer <= 120000 THEN '84k-120k: High (7-10yr avg)'
    ELSE '120k+: Very High (10+ yr avg)'
END as odometer_class, 
FROM (
    SELECT *,
        TRY_TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS') as parsed_date
    FROM "BRIGHTMOTORS"."CARSALES"."CARSALES"
    WHERE sellingprice > 0 AND mmr > 0
)
WHERE parsed_date IS NOT NULL
GROUP BY 
    make, 
    model, 
    transmission,
    color,
    YEAR,
    STATE,
    DATE_PART('year', parsed_date),
    DATE_PART('month', parsed_date),
    odometer_class
ORDER BY 
    total_revenue DESC,
     sale_year DESC,
    sale_month DESC;


    