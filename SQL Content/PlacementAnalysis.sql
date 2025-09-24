-- =====================================
-- 🎯 Placement Perspective SQL Queries
-- =====================================
USE college;

-- 1. Total student in a college
select count(*) from student_records;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- 2. Total placed students
select count(*) from placed_student_record;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- 3. Placement brnach wise 
SELECT 
    Branch, COUNT(StudentID) AS Total_Placed
FROM placed_student_record
GROUP BY Branch
ORDER BY Total_Placed DESC;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- 4. Branch with highest placement ratio
SELECT e.Branch,
       COUNT(e.StudentID) AS Total_Students,
       COUNT(DISTINCT p.StudentID) AS Placed_Students,
       ROUND(COUNT(DISTINCT p.StudentID) * 100.0 / COUNT(e.StudentID), 2) AS Placement_Ratio
FROM student_applicable e
LEFT JOIN placed_student_record p ON e.StudentID = p.StudentID
GROUP BY e.Branch
ORDER BY Placement_Ratio DESC;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- Q5. Total Companies came to college
select count(company_id) from company_detail;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- Q6. companies for each branch and its palcement percentage
SELECT 
    psr.Branch,
    COUNT(DISTINCT cd.company_id) AS total_companies_came,
    COUNT(psr.StudentID) AS total_students_placed,
    round((COUNT(DISTINCT cd.company_id)/COUNT(psr.StudentID)  ) * 100,2) AS placement_per
FROM placed_student_record psr
JOIN company_detail cd 
    ON psr.company_id = cd.company_id
GROUP BY psr.Branch
ORDER BY  placement_per DESC;



-- --------------------------------------------------------------------------------------------------------------------------------------
-- Q6. Skills most demanded by companies (gap analysis)
SELECT 
    c.domain,
    c.skills_required,
    c.Company_Demand,
    s.Students_Having_Skill
FROM
    (SELECT 
        domain, skills_required, COUNT(*) AS Company_Demand
    FROM
        company_detail
    GROUP BY domain , skills_required) c
        LEFT JOIN
    (SELECT 
        skills_required, COUNT(*) AS Students_Having_Skill
    FROM
        (SELECT 
        studentid,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(s.Skills, ';', numbers.n), ';', - 1)) AS skills_required
    FROM
        student_academics s
    JOIN (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers ON CHAR_LENGTH(s.Skills) - CHAR_LENGTH(REPLACE(s.Skills, ';', '')) >= numbers.n - 1) t
    GROUP BY skills_required) s ON c.skills_required = s.skills_required
ORDER BY c.Company_Demand DESC



-- --------------------------------------------------------------------------------------------------------------------------------------
-- Q7. Top recruiters and branch-wise hires
SELECT 
    Branch, CompanyName, COUNT(StudentID) AS Placed_Count
FROM
    placed_student_record
GROUP BY Branch , CompanyName
ORDER BY Branch , Placed_Count DESC

-- --------------------------------------------------------------------------------------------------------------------------------------
-- Q8. No of student did trining
SELECT COUNT(sa.StudentID) AS Total_Trained
FROM student_academics sa
WHERE sa.Training = 'Yes';
  -- AND sa.StudentID  IN (SELECT StudentID FROM placed_student_record);

SELECT 
    COUNT(sa.StudentID) AS Trained_Not_Placed
FROM
    student_academics sa
WHERE
    sa.Training = 'Yes'
        AND sa.StudentID NOT IN (SELECT 
            StudentID
        FROM
            placed_student_record)

-- Q9. Highest package per branch
SELECT Branch, StudentID, Name, CTC_LPA AS Highest_Package
FROM ( SELECT 
        Branch,
        StudentID,
        Name,
        CTC_LPA,
        RANK() OVER (PARTITION BY Branch ORDER BY CTC_LPA DESC) AS rnk
    FROM placed_student_record
) t
WHERE rnk = 1student_academics
ORDER BY Branch;

-- -----------------------------------------------------------------------------------------------------------------------
-- Q10. Average package per company
SELECT CompanyName, ROUND(AVG(CTC_LPA),2) AS Avg_Package
FROM placed_student_record
GROUP BY CompanyName
ORDER BY Avg_Package DESC;

-- ------------------------------------------------------------------------------------------------------------------------
-- Q11. Students with multiple offers (1+, 2+, etc.)
SELECT no_of_companies_cracked, COUNT(StudentID) AS Student_Count
FROM student_applicable
WHERE no_of_companies_cracked > 1
GROUP BY no_of_companies_cracked
ORDER BY no_of_companies_cracked DESC;

-- ---------------------------------------------------------------------------------------------------------------------------
-- Q12. Student with highest CTC
SELECT psr.StudentID, psr.Name, psr.Branch, psr.CTC_LPA AS Highest_CTC
FROM placed_student_record psr
JOIN (
    SELECT Branch, MAX(CTC_LPA) AS Highest_CTC
    FROM placed_student_record
    GROUP BY Branch
) t
ON psr.Branch = t.Branch AND psr.CTC_LPA = t.Highest_CTC
ORDER BY Highest_CTC;

-- ---------------------------------------------------------------------------------------------------------------------------------

-- Q13. Gender ratio in placements
SELECT 
    r.Gender, COUNT(DISTINCT p.StudentID) AS Placed_Count
FROM
    student_records r
        JOIN
    placed_student_record p ON r.StudentID = p.StudentID
GROUP BY r.Gender
