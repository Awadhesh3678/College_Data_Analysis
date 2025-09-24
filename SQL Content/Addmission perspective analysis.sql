-- =====================================
-- 🎯 Admission Perspective SQL Queries
-- =====================================

USE college;

-- Q1. City-wise intake (Top Cities by Admissions)
SELECT City, COUNT(StudentID) AS Total_Admissions
FROM student_records
GROUP BY City
ORDER BY Total_Admissions DESC
limit 10;
-- -------------------------------------------------------------------------------------------------------------------------------
-- Q2. City-wise admission distribution over branches
SELECT 
    City,
    SUM(CASE WHEN Branch = 'CSE' THEN 1 ELSE 0 END) AS CSE,
    SUM(CASE WHEN Branch = 'CSD' THEN 1 ELSE 0 END) AS CSD,
    SUM(CASE WHEN Branch = 'CSE-AIML' THEN 1 ELSE 0 END) AS CSE_AIML,
    SUM(CASE WHEN Branch = 'EE' THEN 1 ELSE 0 END) AS EEE,
    SUM(CASE WHEN Branch = 'ECE' THEN 1 ELSE 0 END) AS ECE,
    SUM(CASE WHEN Branch = 'MECH' THEN 1 ELSE 0 END) AS MECH,
    SUM(CASE WHEN Branch = 'CIVIL' THEN 1 ELSE 0 END) AS CIVIL,
    SUM(CASE WHEN Branch = 'IT' THEN 1 ELSE 0 END) AS IT,
    COUNT(StudentID) AS Total_Admissions
FROM student_records
GROUP BY City
ORDER BY Total_Admissions DESC;

-- ---------------------------------------------------------------------------------------------------------------------
-- Q3. City with the highest placements
SELECT r.City, COUNT(DISTINCT p.StudentID) AS Total_Placed
FROM student_records r
JOIN placed_student_record p ON r.StudentID = p.StudentID
GROUP BY r.City
ORDER BY Total_Placed DESC
LIMIT 5;

-- -----------------------------------------------------------------------------------------------------------------
-- Q4. Branch distribution & placement ratio in the top city 
SELECT r.Branch,
       COUNT(r.StudentID) AS Total_Students,
       COUNT(DISTINCT p.StudentID) AS Placed_Students,
       ROUND(COUNT(DISTINCT p.StudentID) * 100.0 / COUNT(r.StudentID), 2) AS Placement_Ratio
FROM student_records r
LEFT JOIN placed_student_record p ON r.StudentID = p.StudentID
WHERE r.City = 'Sultanpur'
GROUP BY r.Branch
ORDER BY Placement_Ratio DESC;


-- ---------------------------------------------------------------------------------------------------------------
-- Q5. Placement ratio for top 10  city
SELECT r.City,
       COUNT(r.StudentID) AS Total_Students,
       COUNT(DISTINCT p.StudentID) AS Placed_Students,
       ROUND(COUNT(DISTINCT p.StudentID) * 100.0 / COUNT(r.StudentID), 2) AS Placement_Ratio
FROM student_records r
LEFT JOIN placed_student_record p ON r.StudentID = p.StudentID
GROUP BY r.City
ORDER BY Placement_Ratio DESC
Limit 10;

-- -------------------------------------------------------------------------------------------------------------------------------
-- Q6. Lowest intake city and its placement ratio
SELECT r.City,
       COUNT(r.StudentID) AS Total_Intake,
       COUNT(DISTINCT p.StudentID) AS Placed_Students,
       ROUND(COUNT(DISTINCT p.StudentID) * 100.0 / COUNT(r.StudentID), 2) AS Placement_Ratio
FROM student_records r
LEFT JOIN placed_student_record p ON r.StudentID = p.StudentID
GROUP BY r.City
ORDER BY Total_Intake ASC
LIMIT 5;

-- -------------------------------------------------------------------------------------------------------------------
-- Q7. Gender intake ratio
SELECT Gender, COUNT(StudentID) AS Intake
FROM student_records
GROUP BY Gender;

-- -------------------------------------------------------------------------------------------------------------
-- Q7. Gender intake ratio from each city
SELECT
    City,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Male,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Female,
    COUNT(StudentID) AS Total
FROM student_records
GROUP BY City
ORDER BY Total DESC;


-- ------------------------------------------------------------------------------------------------------
-- Q8. Branch–City advertisement strategy (Which branch to promote in which city)
SELECT r.City, r.Branch,
       COUNT(r.StudentID) AS Total_Admissions,
       COUNT(DISTINCT p.StudentID) AS Placed_Students,
       ROUND(COUNT(DISTINCT p.StudentID) * 100.0 / COUNT(r.StudentID), 2) AS Placement_Ratio
FROM student_records r
LEFT JOIN placed_student_record p ON r.StudentID = p.StudentID
GROUP BY r.City, r.Branch
ORDER BY Placement_Ratio DESC, Total_Admissions DESC;
