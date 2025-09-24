-- ==========================================
-- MASTER TABLE: student_records
-- ==========================================
CREATE TABLE student_records (
    StudentID       VARCHAR(20) PRIMARY KEY,
    StudentName     varchar(50)  NOT NULL,
    FatherName      varchar(20)  NOT NULL,
    Email           varchar(20)  NOT NULL UNIQUE,
    DOB             DATE NOT NULL,
    Gender          VARCHAR(10) CHECK (Gender IN ('Male','Female','Other')),
    ProgramIntake   varchar(20) ,
    Branch          varchar(20)  NOT NULL,
    10thMarks       INT CHECK (10thMarks BETWEEN 0 AND 100),
    12thMarks       INT CHECK (12thMarks BETWEEN 0 AND 100),
    AdmissionType   varchar(20) ,
    EntranceExam    varchar(20) ,
    City            varchar(20) ,
    Pincode         INT CHECK (Pincode BETWEEN 100000 AND 999999),
    ResidentialStatus varchar(20) 
);

-- ==========================================
-- Company Details
-- ==========================================
CREATE TABLE company_detail (
company_id                   varchar(20) PK 
company_name                 varchar(150) 
location                     varchar(100) 
domain                       varchar(50) 
eligibility_branch_wise      varchar(200) 
eligibility_criteria         varchar(20) 
profile                      varchar(100) 
skills_required              varchar(100) 
ctc_lpa                      decimal(5,2) 
no_of_openings               int 
no_of_students_placed        int 
total_eligible_student       int 
no_of_rounds_company_took    int 
rounds_names                 varchar(255) 
highest_elim_round           varchar(100) 
highest_elim_count           int 
conversion_percent           decimal(5,2)
);

-- ==========================================
-- Student Academics
-- ==========================================
CREATE TABLE student_academics (
    StudentID    VARCHAR(20) PRIMARY KEY,
    10thMarks    INT CHECK (10thMarks BETWEEN 0 AND 100),
    12thMarks    INT CHECK (12thMarks BETWEEN 0 AND 100),
    Sem1GPA      DOUBLE,
    Sem2GPA      DOUBLE,
    Sem3GPA      DOUBLE,
    Sem4GPA      DOUBLE,
    Sem5GPA      DOUBLE,
    Sem6GPA      DOUBLE,
    Sem7GPA      DOUBLE,
    Sem8GPA      DOUBLE,
    FinalCGPA    DOUBLE CHECK (FinalCGPA BETWEEN 0 AND 10),
    ActiveBacklog INT DEFAULT 0 CHECK (ActiveBacklog >= 0),
    Training     varchar(20) ,
    Status       varchar(20) ,
    Criteria     INT,
    CONSTRAINT fk_student_academics FOREIGN KEY (StudentID) 
        REFERENCES student_records(StudentID) ON DELETE CASCADE
);

-- ==========================================
-- Student Applicable (Eligibility)
-- ==========================================
CREATE TABLE student_applicable (
    StudentID                          VARCHAR(20) PRIMARY KEY,
    StudentName                        varchar(50) ,
    Branch                             varchar(20) ,
    Criteria                           varchar(20) ,
    is_academic_eligible               varchar(20) ,
    not_eligible_reason                varchar(20) ,
    total_companies_for_him            INT DEFAULT 0,
    same_domain_company_count          INT DEFAULT 0,
    remaining_companies                INT DEFAULT 0,
    total_companies_he_is_eligible_for INT DEFAULT 0,
    no_of_companies_applied_for        INT DEFAULT 0,
    no_of_companies_sat                INT DEFAULT 0,
    no_of_companies_cracked            INT DEFAULT 0,
    no_of_same_domain_company_cracked  INT DEFAULT 0,
    no_of_other_domain_company_cracked INT DEFAULT 0,
    CONSTRAINT fk_student_applicable FOREIGN KEY (StudentID) 
        REFERENCES student_records(StudentID) ON DELETE CASCADE
);

-- ==========================================
-- Student Attendance
-- ==========================================
CREATE TABLE student_attendance (
    StudentID          VARCHAR(20) PRIMARY KEY,
    Sem1               INT,
    Sem2               INT,
    Sem3               INT,
    Sem4               INT,
    Sem5               INT,
    Sem6               INT,
    Sem7               INT,
    Sem8               INT,
    Average_Attendance DOUBLE CHECK (Average_Attendance BETWEEN 0 AND 100),
    student_attendancecol VARCHAR(45),
    CONSTRAINT fk_student_attendance FOREIGN KEY (StudentID) 
        REFERENCES student_records(StudentID) ON DELETE CASCADE
);

-- ==========================================
-- Placed Student Record
-- ==========================================
CREATE TABLE placed_student_record (
    StudentID             VARCHAR(20),
    Name                  varchar(50)  NOT NULL,
    Branch                varchar(20)  NOT NULL,
    Hometown_City         varchar(20) ,
    SkillsHad             varchar(20) ,
    ProfileSelected       TEXT NOT NULL,
    company_id            VARCHAR(20) NOT NULL,
    CTC_LPA               DOUBLE CHECK (CTC_LPA > 0),
    TotalCompaniesCracked INT DEFAULT 0,
    PRIMARY KEY (StudentID, company_id),
    CONSTRAINT fk_placed_student FOREIGN KEY (StudentID) 
        REFERENCES student_records(StudentID) ON DELETE CASCADE,
    CONSTRAINT fk_placed_company FOREIGN KEY (company_id) 
        REFERENCES company_detail(company_id)
);
