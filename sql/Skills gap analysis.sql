-- Remove duplicates, standardize skill names, and select final columns
use college;
select * from skill_table;
-- over view of table
SELECT 
    Domain,
    TRIM(Skill) AS SkillName, 
    SUM(no_of_students) AS Student_Count, 
    SUM(company_count) AS Company_Count,
    (SUM(company_count) - SUM(no_of_students)) AS Skill_Gap
FROM Skill_table
GROUP BY Domain, TRIM(Skill)
ORDER BY SkillName, Domain;


--  most demanding skill
SELECT 
    Domain,
    TRIM(Skill) AS SkillName, 
    SUM(company_count) AS Company_Count
FROM Skill_table
GROUP BY Domain, TRIM(Skill)
ORDER BY Company_Count DESC;

-- Student has skills brakage
SELECT 
    Domain,
    TRIM(Skill) AS SkillName, 
    SUM(no_of_students) AS Student_Count
FROM Skill_table
GROUP BY Domain, TRIM(Skill)
ORDER BY Student_Count DESC;


--  skills gsp
SELECT 
    Domain,
    TRIM(Skill) AS SkillName, 
    SUM(no_of_students) AS Student_Count, 
    SUM(company_count) AS Company_Count,
    (SUM(company_count) - SUM(no_of_students)) AS Skill_Gap
FROM Skill_table
GROUP BY Domain, TRIM(Skill)
HAVING Skill_Gap > 0
ORDER BY Skill_Gap DESC;



SELECT 
    Domain,
    TRIM(Skill) AS SkillName,
    SUM(no_of_students) AS Student_Count,
    SUM(company_count) AS Company_Count
FROM Skill_table
GROUP BY Domain, TRIM(Skill)
HAVING SUM(no_of_students) > 50    
   AND SUM(company_count) > 10     
ORDER BY Student_Count DESC, Company_Count DESC;
