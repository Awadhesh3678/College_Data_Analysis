USE college;

WITH city_max AS (
    SELECT `Hometown/City`, MAX(CTC_LPA) AS MaxCTC
    FROM placed_student_record
    GROUP BY `Hometown/City`
)
SELECT 
    p.`Hometown/City` AS CityName,
    p.Name AS TopperName,
    c.MaxCTC AS HighestCTC,
    city_offers.TotalOffers
FROM placed_student_record p
JOIN city_max c 
     ON p.`Hometown/City` = c.`Hometown/City`
    AND p.CTC_LPA = c.MaxCTC
JOIN (
    SELECT `Hometown/City`, SUM(TotalCompaniesCracked) AS TotalOffers
    FROM placed_student_record
    GROUP BY `Hometown/City`
) city_offers 
     ON p.`Hometown/City` = city_offers.`Hometown/City`
ORDER BY p.`Hometown/City`;
