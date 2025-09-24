-- =====================================
-- 🎯 Academic Perspective SQL Queries
-- =====================================

SELECT 
    Branch, ROUND(AVG(FinalCGPA), 2) AS Avg_CGPA
FROM
    student_academics
GROUP BY Branch
ORDER BY Avg_CGPA DESC

-- Q. Average attendance per branch
SELECT 
    sa.Branch,
    sa.StudentName,
    sa.FinalCGPA AS Topper_CGPA,
    CASE 
        WHEN p.StudentID IS NOT NULL THEN 'Placed' 
        ELSE 'Not Placed' 
    END AS Placement_Status
FROM student_academics sa
LEFT JOIN placed_student_record p 
    ON sa.StudentID = p.StudentID
WHERE (sa.Branch, sa.FinalCGPA) IN (
    SELECT Branch, MAX(FinalCGPA)
    FROM student_academics
    GROUP BY Branch
)
ORDER BY sa.Branch;



-- Q. Holistic branch analysis (CGPA + Attendance + Placement Ratio)
SELECT 
    sa.Branch,
    ROUND(AVG(sa.FinalCGPA), 2) AS Avg_CGPA,
    ROUND(AVG(a.Average_Attendance), 2) AS Avg_Attendance,
    ROUND(COUNT(DISTINCT p.StudentID) * 100.0 / COUNT(DISTINCT sa.StudentID),
            2) AS Placement_Ratio
FROM
    student_academics sa
        JOIN
    student_attendance a ON sa.StudentID = a.StudentID
        LEFT JOIN
    placed_student_record p ON sa.StudentID = p.StudentID
GROUP BY sa.Branch
ORDER BY Placement_Ratio DESC , Avg_CGPA DESC

