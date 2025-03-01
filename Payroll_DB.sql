CREATE DATABASE Payroll_DB;

USE Payroll_DB;

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX)
);

CREATE TABLE Positions (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    PositionTitle NVARCHAR(100) NOT NULL,
    DepartmentID INT NULL,
    Description NVARCHAR(MAX),
    CONSTRAINT FK_Positions_Departments FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NULL,
    Address NVARCHAR(MAX) NULL,
    DepartmentID INT NULL,
    PositionID INT NULL,
    DateHired DATE NULL,
    Status NVARCHAR(10) NOT NULL DEFAULT 'Active',
    CONSTRAINT CK_Employees_Status CHECK (Status IN ('Active', 'Inactive')),
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Employees_Positions FOREIGN KEY (PositionID)
        REFERENCES Positions(PositionID)
        
);

CREATE TABLE Salaries (
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    PositionID INT NOT NULL,
    BaseSalary DECIMAL(15,2) NOT NULL,
    Currency NVARCHAR(10) NOT NULL DEFAULT 'USD',
    EffectiveFrom DATE NOT NULL,
    EffectiveTo DATE NULL,
    CONSTRAINT FK_Salaries_Positions FOREIGN KEY (PositionID)
        REFERENCES Positions(PositionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Benefits (
    BenefitID INT IDENTITY(1,1) PRIMARY KEY,
    BenefitName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Cost DECIMAL(10,2) NOT NULL
);

CREATE TABLE EmployeeBenefits (
    EmployeeBenefitID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    BenefitID INT NOT NULL,
    EnrollmentDate DATE NULL,
    CONSTRAINT FK_EmployeeBenefits_Employees FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_EmployeeBenefits_Benefits FOREIGN KEY (BenefitID)
        REFERENCES Benefits(BenefitID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Deductions (
    DeductionID INT IDENTITY(1,1) PRIMARY KEY,
    DeductionName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Rate DECIMAL(5,2) NOT NULL, 
    DeductionType NVARCHAR(10) NOT NULL DEFAULT 'Percentage',
    CONSTRAINT CK_Deductions_DeductionType CHECK (DeductionType IN ('Fixed', 'Percentage'))
);

CREATE TABLE Taxes (
    TaxID INT IDENTITY(1,1) PRIMARY KEY,
    TaxName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Rate DECIMAL(5,2) NOT NULL
);

CREATE TABLE Payrolls (
    PayrollID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    PayPeriodStart DATE NOT NULL,
    PayPeriodEnd DATE NOT NULL,
    GrossPay DECIMAL(15,2) NOT NULL,
    NetPay DECIMAL(15,2) NOT NULL,
    PaymentDate DATE NOT NULL,
    CONSTRAINT FK_Payrolls_Employees FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE PayrollDeductions (
    PayrollDeductionID INT IDENTITY(1,1) PRIMARY KEY,
    PayrollID INT NOT NULL,
    DeductionID INT NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    CONSTRAINT FK_PayrollDeductions_Payrolls FOREIGN KEY (PayrollID)
        REFERENCES Payrolls(PayrollID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_PayrollDeductions_Deductions FOREIGN KEY (DeductionID)
        REFERENCES Deductions(DeductionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE PayrollTaxes (
    PayrollTaxID INT IDENTITY(1,1) PRIMARY KEY,
    PayrollID INT NOT NULL,
    TaxID INT NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    CONSTRAINT FK_PayrollTaxes_Payrolls FOREIGN KEY (PayrollID)
        REFERENCES Payrolls(PayrollID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_PayrollTaxes_Taxes FOREIGN KEY (TaxID)
        REFERENCES Taxes(TaxID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    PayrollID INT NOT NULL,
    [Date] DATE NOT NULL,
    HoursWorked DECIMAL(4,2) NOT NULL,
    CONSTRAINT FK_Attendance_Employees FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Attendance_Payrolls FOREIGN KEY (PayrollID)
        REFERENCES Payrolls(PayrollID)
);

INSERT INTO Departments (DepartmentName, Description) VALUES
('Human Resources', 'Handles recruitment, training, and employee relations.'),
('Engineering', 'Responsible for product development and maintenance.'),
('Finance', 'Manages company finances, budgeting, and accounting.'),
('Marketing', 'Handles advertising, promotions, and market research.'),
('Sales', 'Responsible for selling products and services.');

INSERT INTO Positions (PositionTitle, DepartmentID, Description) VALUES
('HR Manager', 1, 'Manages HR team and processes.'),
('Recruiter', 1, 'Handles recruitment and hiring.'),
('Software Engineer', 2, 'Develops and maintains software applications.'),
('Senior Software Engineer', 2, 'Leads software development projects.'),
('Financial Analyst', 3, 'Analyzes financial data and trends.'),
('Accountant', 3, 'Manages financial records and transactions.'),
('Marketing Coordinator', 4, 'Coordinates marketing campaigns and activities.'),
('Sales Manager', 5, 'Leads the sales team and strategies.'),
('Sales Representative', 5, 'Handles client interactions and sales.'),
('Graphic Designer', 4, 'Creates visual content for marketing materials.');

INSERT INTO Employees (FirstName, LastName, DateOfBirth, Email, Phone, Address, DepartmentID, PositionID, DateHired, Status) VALUES
('John', 'Doe', '1985-06-15', 'john.doe@example.com', '555-1234', '123 Elm Street, City, Country', 1, 1, '2020-01-15', 'Active'),
('Jane', 'Smith', '1990-09-22', 'jane.smith@example.com', '555-5678', '456 Oak Avenue, City, Country', 2, 3, '2021-03-10', 'Active'),
('Alice', 'Johnson', '1988-12-05', 'alice.johnson@example.com', '555-9012', '789 Pine Road, City, Country', 3, 5, '2019-07-20', 'Active'),
('Bob', 'Lee', '1979-04-18', 'bob.lee@example.com', '555-3456', '321 Maple Lane, City, Country', 4, 7, '2018-11-25', 'Active'),
('Charlie', 'Brown', '1992-08-30', 'charlie.brown@example.com', '555-7890', '654 Cedar Blvd, City, Country', 5, 9, '2022-05-14', 'Active'),
('Diana', 'Prince', '1984-03-12', 'diana.prince@example.com', '555-2345', '987 Birch Street, City, Country', 2, 4, '2020-09-01', 'Active'),
('Ethan', 'Hunt', '1981-07-07', 'ethan.hunt@example.com', '555-6789', '159 Spruce Avenue, City, Country', 1, 2, '2017-02-28', 'Inactive'),
('Fiona', 'Gallagher', '1995-11-19', 'fiona.gallagher@example.com', '555-0123', '753 Walnut Drive, City, Country', 3, 6, '2021-06-17', 'Active'),
('George', 'Martin', '1983-05-23', 'george.martin@example.com', '555-4567', '852 Poplar Street, City, Country', 4, 10, '2016-10-05', 'Active'),
('Hannah', 'Montana', '1993-02-14', 'hannah.montana@example.com', '555-8901', '951 Cherry Road, City, Country', 5, 8, '2019-08-30', 'Active');

INSERT INTO Salaries (PositionID, BaseSalary, Currency, EffectiveFrom, EffectiveTo) VALUES
(1, 80000.00, 'USD', '2020-01-15', NULL), -- HR Manager
(2, 50000.00, 'USD', '2020-02-01', NULL), -- Recruiter
(3, 90000.00, 'USD', '2020-03-01', NULL), -- Software Engineer
(4, 120000.00, 'USD', '2020-04-01', NULL), -- Senior Software Engineer
(5, 70000.00, 'USD', '2020-05-01', NULL), -- Financial Analyst
(6, 60000.00, 'USD', '2020-06-01', NULL), -- Accountant
(7, 55000.00, 'USD', '2020-07-01', NULL), -- Marketing Coordinator
(8, 85000.00, 'USD', '2020-08-01', NULL), -- Sales Manager
(9, 50000.00, 'USD', '2020-09-01', NULL), -- Sales Representative
(10, 65000.00, 'USD', '2020-10-01', NULL); -- Graphic Designer

INSERT INTO Benefits (BenefitName, Description, Cost) VALUES
('Health Insurance', 'Comprehensive health coverage.', 200.00),
('Retirement Plan', '401(k) retirement savings plan.', 150.00),
('Dental Insurance', 'Dental care coverage.', 50.00),
('Vision Insurance', 'Vision care coverage.', 30.00),
('Life Insurance', 'Life coverage for employees.', 100.00),
('Gym Membership', 'Access to gym facilities.', 60.00),
('Paid Time Off', 'Paid vacation and sick days.', 0.00),
('Flexible Working Hours', 'Flexible scheduling options.', 0.00),
('Remote Work', 'Option to work from home.', 0.00),
('Employee Stock Options', 'Stock options as part of compensation.', 500.00);

INSERT INTO EmployeeBenefits (EmployeeID, BenefitID, EnrollmentDate) VALUES
(1, 1, '2020-01-20'),
(1, 2, '2020-01-20'),
(2, 1, '2021-03-15'),
(2, 3, '2021-03-15'),
(3, 2, '2019-07-25'),
(3, 4, '2019-07-25'),
(4, 1, '2018-11-30'),
(4, 5, '2018-11-30'),
(5, 1, '2022-05-20'),
(5, 2, '2022-05-20'),
(6, 3, '2020-09-05'),
(6, 6, '2020-09-05'),
(7, 1, '2017-03-01'),
(7, 2, '2017-03-01'),
(8, 4, '2016-12-15'),
(8, 5, '2016-12-15'),
(9, 1, '2016-10-10'),
(9, 2, '2016-10-10'),
(10, 1, '2019-09-01'),
(10, 7, '2019-09-01');

INSERT INTO Deductions (DeductionName, Description, Rate, DeductionType) VALUES
('Health Insurance Premium', 'Monthly health insurance cost.', 200.00, 'Fixed'),
('Retirement Contribution', 'Employee contribution to retirement plan.', 5.00, 'Percentage'),
('Dental Insurance Premium', 'Monthly dental insurance cost.', 50.00, 'Fixed'),
('Vision Insurance Premium', 'Monthly vision insurance cost.', 30.00, 'Fixed'),
('Life Insurance Premium', 'Monthly life insurance cost.', 100.00, 'Fixed');

INSERT INTO Taxes (TaxName, Description, Rate) VALUES
('Federal Income Tax', 'Federal government income tax.', 22.00),
('State Income Tax', 'State government income tax.', 5.00),
('Social Security Tax', 'Social security contributions.', 6.20),
('Medicare Tax', 'Medicare contributions.', 1.45),
('Local Income Tax', 'Local government income tax.', 3.00);

INSERT INTO Payrolls (EmployeeID, PayPeriodStart, PayPeriodEnd, GrossPay, NetPay, PaymentDate) VALUES
(1, '2024-09-01', '2024-09-15', 3076.92, 3076.92, '2024-09-20'), -- HR Manager
(2, '2024-09-01', '2024-09-15', 1923.08, 1923.08, '2024-09-20'), -- Recruiter
(3, '2024-09-01', '2024-09-15', 2692.31, 2692.31, '2024-09-20'), -- Financial Analyst
(4, '2024-09-01', '2024-09-15', 4230.77, 4230.77, '2024-09-20'), -- Marketing Coordinator
(5, '2024-09-01', '2024-09-15', 1923.08, 1923.08, '2024-09-20'), -- Sales Representative
(6, '2024-09-01', '2024-09-15', 2307.69, 2307.69, '2024-09-20'), -- Accountant
(7, '2024-09-01', '2024-09-15', 2115.38, 2115.38, '2024-09-20'), -- Graphic Designer
(8, '2024-09-01', '2024-09-15', 3269.23, 3269.23, '2024-09-20'), -- Sales Manager
(9, '2024-09-01', '2024-09-15', 1923.08, 1923.08, '2024-09-20'), -- Senior Software Engineer
(10, '2024-09-01', '2024-09-15', 2500.00, 2500.00, '2024-09-20'); -- Other Positions

INSERT INTO PayrollDeductions (PayrollID, DeductionID, Amount) VALUES
(1, 1, 200.00), -- Health Insurance Premium
(1, 2, 153.85), -- Retirement Contribution (5% of 3076.92)
(1, 3, 50.00),  -- Dental Insurance Premium
(1, 4, 30.00),  -- Vision Insurance Premium
(1, 5, 100.00), -- Life Insurance Premium

(2, 1, 200.00),
(2, 2, 96.15),
(2, 3, 50.00),
(2, 4, 30.00),
(2, 5, 100.00),

(3, 1, 200.00),
(3, 2, 134.62),
(3, 3, 50.00),
(3, 4, 30.00),
(3, 5, 100.00),

(4, 1, 200.00),
(4, 2, 105.77),
(4, 3, 50.00),
(4, 4, 30.00),
(4, 5, 100.00),

(5, 1, 200.00),
(5, 2, 96.15),
(5, 3, 50.00),
(5, 4, 30.00),
(5, 5, 100.00),

(6, 1, 200.00),
(6, 2, 115.38),
(6, 3, 50.00),
(6, 4, 30.00),
(6, 5, 100.00),

(7, 1, 200.00),
(7, 2, 105.77),
(7, 3, 50.00),
(7, 4, 30.00),
(7, 5, 100.00),

(8, 1, 200.00),
(8, 2, 163.46),
(8, 3, 50.00),
(8, 4, 30.00),
(8, 5, 100.00),

(9, 1, 200.00),
(9, 2, 96.15),
(9, 3, 50.00),
(9, 4, 30.00),
(9, 5, 100.00),

(10, 1, 200.00),
(10, 2, 125.00),
(10, 3, 50.00),
(10, 4, 30.00),
(10, 5, 100.00);

INSERT INTO PayrollTaxes (PayrollID, TaxID, Amount) VALUES
(1, 1, 675.38), -- Federal Income Tax (22% of 3076.92)
(1, 2, 153.85), -- State Income Tax (5% of 3076.92)
(1, 3, 190.77), -- Social Security Tax (6.20% of 3076.92)
(1, 4, 44.62),  -- Medicare Tax (1.45% of 3076.92)
(1, 5, 92.31),  -- Local Income Tax (3% of 3076.92)

(2, 1, 423.08),
(2, 2, 96.15),
(2, 3, 119.23),
(2, 4, 27.88),
(2, 5, 57.69),

(3, 1, 594.00),
(3, 2, 134.62),
(3, 3, 420.00),
(3, 4, 13.05),
(3, 5, 75.00),

(4, 1, 924.62),
(4, 2, 163.46),
(4, 3, 529.23),
(4, 4, 19.47),
(4, 5, 97.69),

(5, 1, 423.00),
(5, 2, 96.15),
(5, 3, 115.00),
(5, 4, 6.50),
(5, 5, 57.69),

(6, 1, 462.00),
(6, 2, 115.38),
(6, 3, 372.00),
(6, 4, 4.92),
(6, 5, 34.62),

(7, 1, 462.00),
(7, 2, 105.77),
(7, 3, 330.00),
(7, 4, 4.31),
(7, 5, 27.69),

(8, 1, 1870.77),
(8, 2, 326.92),
(8, 3, 527.69),
(8, 4, 13.12),
(8, 5, 92.31),

(9, 1, 423.00),
(9, 2, 96.15),
(9, 3, 115.00),
(9, 4, 4.62),
(9, 5, 57.69),

(10, 1, 550.00),
(10, 2, 125.00),
(10, 3, 130.00),
(10, 4, 3.63),
(10, 5, 75.00);

INSERT INTO Attendance (EmployeeID, PayrollID, [Date], HoursWorked) VALUES
(1, 1, '2024-09-02', 8.00),
(1, 1, '2024-09-03', 8.00),
(1, 1, '2024-09-04', 8.00),
(1, 1, '2024-09-05', 8.00),
(1, 1, '2024-09-06', 8.00),

(2, 2, '2024-09-02', 8.00),
(2, 2, '2024-09-03', 8.00),
(2, 2, '2024-09-04', 8.00),
(2, 2, '2024-09-05', 8.00),
(2, 2, '2024-09-06', 8.00),

(3, 3, '2024-09-02', 8.00),
(3, 3, '2024-09-03', 8.00),
(3, 3, '2024-09-04', 8.00),
(3, 3, '2024-09-05', 8.00),
(3, 3, '2024-09-06', 8.00),

(4, 4, '2024-09-02', 8.00),
(4, 4, '2024-09-03', 8.00),
(4, 4, '2024-09-04', 8.00),
(4, 4, '2024-09-05', 8.00),
(4, 4, '2024-09-06', 8.00),

(5, 5, '2024-09-02', 8.00),
(5, 5, '2024-09-03', 8.00),
(5, 5, '2024-09-04', 8.00),
(5, 5, '2024-09-05', 8.00),
(5, 5, '2024-09-06', 8.00),

(6, 6, '2024-09-02', 8.00),
(6, 6, '2024-09-03', 8.00),
(6, 6, '2024-09-04', 8.00),
(6, 6, '2024-09-05', 8.00),
(6, 6, '2024-09-06', 8.00),

(7, 7, '2024-09-02', 8.00),
(7, 7, '2024-09-03', 8.00),
(7, 7, '2024-09-04', 8.00),
(7, 7, '2024-09-05', 8.00),
(7, 7, '2024-09-06', 8.00),

(8, 8, '2024-09-02', 8.00),
(8, 8, '2024-09-03', 8.00),
(8, 8, '2024-09-04', 8.00),
(8, 8, '2024-09-05', 8.00),
(8, 8, '2024-09-06', 8.00),

(9, 9, '2024-09-02', 8.00),
(9, 9, '2024-09-03', 8.00),
(9, 9, '2024-09-04', 8.00),
(9, 9, '2024-09-05', 8.00),
(9, 9, '2024-09-06', 8.00),

(10, 10, '2024-09-02', 8.00),
(10, 10, '2024-09-03', 8.00),
(10, 10, '2024-09-04', 8.00),
(10, 10, '2024-09-05', 8.00),
(10, 10, '2024-09-06', 8.00);

SELECT * FROM Departments;

SELECT * FROM Positions;

SELECT * FROM Employees;

SELECT * FROM Salaries;

SELECT * FROM Benefits;

SELECT * FROM EmployeeBenefits;

SELECT * FROM Deductions;

SELECT * FROM Taxes;

SELECT * FROM Payrolls;

SELECT * FROM PayrollDeductions;

SELECT * FROM PayrollTaxes;

SELECT * FROM Attendance;

