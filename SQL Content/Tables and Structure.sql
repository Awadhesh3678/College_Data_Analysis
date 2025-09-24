-- ==========================================
-- MASTER TABLE: student_records
-- ==========================================
CREATE TABLE student_records (
    StudentID       VARCHAR(20) PRIMARY KEY,
    StudentName     TEXT NOT NULL,
    FatherName      TEXT NOT NULL,
    Email           TEXT NOT NULL UNIQUE,
    DOB             DATE NOT NULL,
    Gender          VARCHAR(10) CHECK (Gender IN ('Male','Female','Other')),
    ProgramIntake   TEXT,
    Branch          TEXT NOT NULL,
    10thMarks       INT CHECK (10thMarks BETWEEN 0 AND 100),
    12thMarks       INT CHECK (12thMarks BETWEEN 0 AND 100),
    AdmissionType   TEXT,
    EntranceExam    TEXT,
    City            TEXT,
    Pincode         INT CHECK (Pincode BETWEEN 100000 AND 999999),
    ResidentialStatus TEXT
);

-- ==========================================
-- Company Details
-- ==========================================
CREATE TABLE company_detail (
    company_id              VARCHAR(20) PRIMARY KEY,
    company_name            VARCHAR(150) UNIQUE NOT NULL,
    location                VARCHAR(100) NOT NULL,
    domain                  VARCHAR(50) NOT NULL,
    eligibility_branch_wise VARCHAR(200),
    eligibility_criteria    VARCHAR(20),
    profile                 VARCHAR(100) NOT NULL,
    skills_required         TEXT,
    ctc_lpa                 DECIMAL(5,2) CHECK (ctc_lpa > 0),
    no_of_openings          INT CHECK (no_of_openings >= 0),
    no_of_students_placed   INT DEFAULT 0 CHECK (no_of_students_placed >= 0),
    total_eligible_student  INT DEFAULT 0 CHECK (total_eligible_student >= 0),
    no_of_rounds_company_took INT CHECK (no_of_rounds_company_took >= 0),
    rounds_names            VARCHAR(255),
    highest_elim_round      VARCHAR(100),
    highest_elim_count      INT CHECK (highest_elim_count >= 0),
    conversion_percent      DECIMAL(5,2) CHECK (conversion_percent BETWEEN 0 AND 100)
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
    Training     TEXT,
    Status       TEXT,
    Criteria     INT,
    CONSTRAINT fk_student_academics FOREIGN KEY (StudentID) 
        REFERENCES student_records(StudentID) ON DELETE CASCADE
);

-- ==========================================
-- Student Applicable (Eligibility)
-- ==========================================
CREATE TABLE student_applicable (
    StudentID                          VARCHAR(20) PRIMARY KEY,
    StudentName                        TEXT,
    Branch                             TEXT,
    Criteria                           TEXT,
    is_academic_eligible               TEXT,
    not_eligible_reason                TEXT,
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
    Name                  TEXT NOT NULL,
    Branch                TEXT NOT NULL,
    Hometown_City         TEXT,
    SkillsHad             TEXT,
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
