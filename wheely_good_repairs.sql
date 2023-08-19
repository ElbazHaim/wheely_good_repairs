-- Wheely-Good Repairs
-- Database Design & Analysis Project

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
-- Cleanup, do not run on first run. Run blocks separately when cleaning.
use master;
alter database wheely_good_repairs set single_user with rollback immediate;
alter database wheely_good_repairs set multi_user;

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
DROP DATABASE IF EXISTS wheely_good_repairs;

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
-- Declarations

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
--- Database Declaration
CREATE DATABASE wheely_good_repairs;

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
USE wheely_good_repairs;

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
-- Tables Declaration

--- Entities

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    IdentificationNumber VARCHAR(8) NOT NULL UNIQUE,
    BirthDate DATE,
    JoinDate DATE DEFAULT GETDATE(),
    InsuranceCompany VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(10) NOT NULL,
    Email VARCHAR(50),
    LicenceNumber VARCHAR(20)
);

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE,
    DepartmentHead INT,
    YearlyBudget DECIMAL(15, 2) NOT NULL,
    CONSTRAINT YearlyBudget CHECK (YearlyBudget > 0)
);

CREATE TABLE Employees (
    EmployeeNumber INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    IdentificationNumber VARCHAR(9) NOT NULL,
    BirthDate DATE NOT NULL,
    HireDate DATE NOT NULL DEFAULT GETDATE(),
    DepartmentID INT,
    ReportsTo INT,
    Email VARCHAR(100),
    City VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Education VARCHAR(100),
    BankAccount VARCHAR(30) NOT NULL,
    FOREIGN KEY (ReportsTo) REFERENCES Employees(EmployeeNumber)
);

-- Altering employees and departments tables so that they refer to each other
ALTER TABLE Employees
ADD CONSTRAINT FK_DepartmentID
FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);

ALTER TABLE Departments
ADD CONSTRAINT FK_DepartmentHead
FOREIGN KEY (DepartmentHead) REFERENCES Employees(EmployeeNumber);

CREATE TABLE CustomerServices (
    EmployeeNumber INT PRIMARY KEY FOREIGN KEY (EmployeeNumber) REFERENCES Employees(EmployeeNumber),
    CustomerSatisfactionScore DECIMAL(3,2),
    EnglishSpeaker BIT,
    CONSTRAINT CHK_SatisfactionScore CHECK (CustomerSatisfactionScore BETWEEN 0 AND 5)
);

CREATE TABLE Technicians (
    EmployeeNumber INT PRIMARY KEY FOREIGN KEY (EmployeeNumber) REFERENCES Employees(EmployeeNumber),
    Specialty VARCHAR(100),
    CertificationID VARCHAR(20),
    FOREIGN KEY (EmployeeNumber) REFERENCES Employees(EmployeeNumber)
);

CREATE TABLE Parts (
    PartID INT IDENTITY(1,1) PRIMARY KEY,
    PartName VARCHAR(30),
    Cost DECIMAL(10, 2),
    Size VARCHAR(20),
    Manufacturer VARCHAR(100)
);

CREATE TABLE Models (
    Code VARCHAR(20) PRIMARY KEY,
    Manufacturer VARCHAR(50),
    Type VARCHAR(10),
    FuelType VARCHAR(50),
    Gear VARCHAR(10),
    Year DATE,
    Seats INT,
    CHECK (Type IN ('car', 'motorcycle', 'truck', 'SUV', 'van')),
    CHECK (FuelType IN ('gasoline', 'diesel', 'electric', 'hybrid', 'natural gas')),
    CHECK (Gear IN ('manual', 'automatic', 'semi-automatic', 'CVT', 'DSG'))
);

CREATE TABLE Vehicles (
    LicensePlate VARCHAR(20) PRIMARY KEY,
    ModelCode VARCHAR(20) NOT NULL,
    Owner INT NOT NULL,
    Mileage INT,
    Accidents INT,
    InsurancePolicy VARCHAR(100),
    Color VARCHAR(50),
    FOREIGN KEY (ModelCode) REFERENCES Models(Code),
    FOREIGN KEY (Owner) REFERENCES Customers(CustomerID)
);

CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyNumber VARCHAR(20) UNIQUE,
    CompanyName VARCHAR(50),
    PhoneNumber VARCHAR(10),
    ContactName VARCHAR(50),
    Address VARCHAR(50),
    Email VARCHAR(50)
);

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
--- Relations

-- Technicians repair cars using parts
CREATE TABLE Repairs (
    RepairID INT IDENTITY(1,1) PRIMARY KEY,
    TechnicianID INT,
    LicensePlate VARCHAR(20),
    PartID INT,
    StartRepairTime DATETIME DEFAULT GETDATE(),
    EndRepairTime DATETIME,
    TotalCost DECIMAL(10, 2),
    FOREIGN KEY (TechnicianID) REFERENCES Technicians(EmployeeNumber),
    FOREIGN KEY (LicensePlate) REFERENCES Vehicles(LicensePlate),
    FOREIGN KEY (PartID) REFERENCES Parts(PartID)
);

-- Departments pay suppliers for parts
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    PartID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    ReceivedDate DATETIME,
    Quantity INT,
    PricePerUnit DECIMAL(10, 2),
    TotalPrice DECIMAL(10, 2),
    ReceiptNumber VARCHAR(50),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (PartID) REFERENCES Parts(PartID),
    CONSTRAINT CHK_Quantity CHECK (Quantity > 0),
    CONSTRAINT CHK_PricePerUnit CHECK (PricePerUnit > 0),
    CONSTRAINT CHK_TotalPrice CHECK (TotalPrice > 0),
    CONSTRAINT CHK_ReceiptNumber CHECK (ReceiptNumber IS NOT NULL)
);

-- Customers pay departments for repairs
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    DepartmentID INT,
    RepairID INT,
    TransactionDate DATETIME DEFAULT GETDATE(),
    AmountPaid DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (RepairID) REFERENCES Repairs(RepairID)
);
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
-- Inserts

INSERT INTO Customers
VALUES
    ('Avraham', 'Levi', '12345678', '1990-05-15', 'Harel Insurance', 'Tel Aviv', '123 Hertzl', 
        '1234567890', 'avraham@gmail.com', '12345678'),
    ('Sarah', 'Cohen', '87654321', '1985-10-20', 'IDII Insurance', 'Jerusalem', '456 Jaffa', 
        '9876543210', 'sara@yahoo.com', '87654321'),
    ('Yaakov', 'Ben-David', '23456789', '2000-02-01', 'Leumit Insurance', 'Haifa', '789 Harbor', 
        '5678901234', 'yaakov@gmail.com', '23456789'),
    ('Rachel', 'Shapira', '98765432', '1978-08-10', 'Poalim Insurance', 'Beersheba', '567 Ben-Gurion', 
        '8765432109', 'rachel@yahoo.com', '98765432'),
    ('Daniel', 'Almog', '34567890', '1995-03-25', 'Harel Insurance', 'Eilat', '901 Hatamar', 
        '2345678901', 'daniel@gmail.com', '34567890');


-- Departments and employees foreign keys are circular - I Will disable the constraints just so that I can insert the departments
ALTER TABLE Employees NOCHECK CONSTRAINT FK_DepartmentID;
ALTER TABLE Departments NOCHECK CONSTRAINT FK_DepartmentHead;

INSERT INTO Employees VALUES 
    ('Avi', 'Cohen', '123456789', '1985-05-15', '2010-01-15', 1, NULL, -- Owner & General Manager
            'avi@example.com', 'Tel Aviv', '123 Main', 60000.00, 'MSc. Business Management', '1234567890123');


INSERT INTO Employees
VALUES
    -- Management
    ('Rachel', 'Levi', '234567894', '1990-03-20', '2021-02-10', 1, 1, 
            'rachel@example.com', 'Tel Aviv', '456 Elm', 55000.00, 'BSc. Accounting', '2345678901234'),
    ('Eyal', 'Sela', '345678902', '1988-08-01', '2019-05-05', 2, 1, 
            'eyal@example.com', 'Tel Aviv', '789 Oak', 58000.00, 'MSc. Business Management', '3456789012345'),
    ('Tamar', 'Ben-David', '456784901', '1992-10-10', '2022-03-20', 3, 1, 
            'tamar@example.com', 'Tel Aviv', '101 Pine', 52000.00, 'Diploma in Automotive Technology', '4567890123456'),
    ('Yaniv', 'Alon', '567890512', '1987-12-05', '2020-09-18', 4, 1, 
            'yaniv@example.com', 'Tel Aviv', '202 Cedar', 59000.00, 'Practical Engineering in Electronics', '5678901234567'),
    ('Maya', 'Carmel', '678901123', '1995-06-25', '2023-01-10', 5, 1, 
            'maya@example.com', 'Tel Aviv', '303 Walnut', 54000.00, 'BSc in Automotive Technology', '6789012345678');


INSERT INTO Departments
VALUES
    ('Accounting', 2, 21966.75),
    ('Customer Service', 3, 91234.56),
    ('Mechanical', 4, 105678.90),
    ('Electrical', 5, 83210.54),
    ('Paint Shop', 6, 64567.89);

-- Enable constraints
ALTER TABLE Departments WITH CHECK CHECK CONSTRAINT FK_DepartmentHead;
ALTER TABLE Employees WITH CHECK CHECK CONSTRAINT FK_DepartmentID;


    -- Accounting
    

    -- Customer Service
INSERT INTO Employees
VALUES
    ('Inbar', 'Sapir', '890112345', '1993-02-28', '2021-12-01', 3, NULL, 
            'inbar@example.com', 'Jerusalem', '505 Birch', 62000.00, 'Diploma in Auto Mechanics', '8901234567890'),
    ('Yoni', 'Lazarus', '901232456', '1989-11-15', '2018-10-20', 3, 8, 
            'yoni@example.com', 'Jerusalem', '606 Oak', 58000.00, 'BSc. English Literature', '9012345678901'),
    ('Lior', 'Golan', '012343567', '1991-07-30', '2022-04-05', 3, 8, 
            'lior@example.com', 'Jerusalem', '707 Pine', 54000.00, Null, '0123456789012'),
    ('Noga', 'Cohen', '987654432', '1994-04-22', '2019-08-18', 3, 8, 
            'noga@example.com', 'Jerusalem', '808 Walnut', 56000.00, 'Student', '9876543210987'),
    ('Eli', 'Eisenberg', '876554321', '1986-01-18', '2020-03-10', 3, NULL, 
            'eli@example.com', 'Haifa', '909 Cedar', 53000.00, 'Student', '8765432109876');

INSERT INTO CustomerServices
VALUES
    (7, 4.56, 1),
    (8, 3.50, 1),
    (9, 4.94, 0),
    (10, 3.07, 1),
    (11, 3.95, 0);

    -- Technicians
INSERT INTO Employees
VALUES
    ('Oren', 'Dagan', '789061234', '1990-09-12', '2022-07-05', 4, 1, 
            'oren@example.com', 'Tel Aviv', '404 Maple', 57000.00, 'Practical Engineering in Mechanics', '7890123456789'),
    ('Noa', 'Gavriel', '766543210', '1993-08-09', '2022-06-15', 4, 12, 
            'noa@example.com', 'Haifa', '1010 Elm', 57000.00, 'Diploma in Automotive Technology', '7654321098765'),
    ('Eitan', 'Adler', '654832109', '1988-05-07', '2019-12-05', 5, NULL, 
            'eitan@example.com', 'Tel Aviv', '1111 Oak', 55000.00, 'Practical Engineering in Auto Electronics', '6543210987654'),
    ('Talia', 'Levy', '543213098', '1997-03-02', '2023-02-20', 5, 14, 
            'talia@example.com', 'Tel Aviv', '1212 Pine', 59000.00, 'BSc. in Mechanical Engineering', '5432109876543'),
    ('Ronen', 'Cohen', '432104987', '1991-12-12', '2018-07-01', 6, NULL, 
            'ronen@example.com', 'Eilat', '1313 Elm', 51000.00, 'BSc. Electrical Engineering', '4321098765432'),
    ('Eli', 'Luzon', '953468725', '1990-05-06', '2019-02-02', 6, NULL, 
    'Luzon@gmail.com', 'Holon', '1234 Sokolov', 75000.00, NULL, '3462587295643');

INSERT INTO Technicians
VALUES
    (12, 'Motorcycles', 'Kf9Gt7DpL1'),
    (13, 'Old Models', 'XeR5jYqWu8'),
    (14, 'Electrical Engines', 'PmZ2vNcHs4'),
    (15, 'Hybrid Cars', 'Tl7KbFmRi3'),
    (16, 'Paint Renewal', 'Qw1XnZtYv4'),
    (17, 'Paint Renewal', 'Eg3HkMlPq5');

INSERT INTO Parts
VALUES
    ('Engine Oil', 25.99, '1 Quart', 'ACME Motors'),
    ('Brake Pads', 39.95, 'Standard', 'BrakeTech'),
    ('Air Filter', 12.50, 'Standard', 'FilterMaster'),
    ('Spark Plugs', 8.99, 'Set of 4', 'SparkTech'),
    ('Radiator Hose', 18.75, '18 inches', 'CoolantCo'),
    ('Fuel Pump', 65.00, 'Standard', 'Fueltronics'),
    ('Transmission Fluid', 19.50, '1 Quart', 'GearLube'),
    ('Alternator', 120.75, 'Standard', 'PowerGen'),
    ('Thermostat', 14.25, 'Standard', 'TempControl'),
    ('Serpentine Belt', 23.50, 'Accessory', 'BeltMaster');

INSERT INTO Models
VALUES
    ('CAMRY21', 'Toyota', 'car', 'gasoline', 'automatic', '2021', 5),
    ('CIVIC19', 'Honda', 'car', 'gasoline', 'manual', '2019', 5),
    ('GOLF20', 'Volkswagen', 'car', 'diesel', 'semi-automatic', '2020', 5),
    ('MODEL322', 'Tesla', 'car', 'electric', 'automatic', '2022', 5),
    ('F15020', 'Ford', 'truck', 'gasoline', 'automatic', '2020', 3),
    ('R1K20', 'Yamaha', 'motorcycle', 'gasoline', 'manual', '2020', 2),
    ('XC9019', 'Volvo', 'SUV', 'hybrid', 'automatic', '2019', 7),
    ('TRANSIT20', 'Ford', 'van', 'diesel', 'automatic', '2020', 9),
    ('WRANGLER20', 'Jeep', 'SUV', 'gasoline', 'manual', '2020', 4),
    ('JETTA18', 'Volkswagen', 'car', 'gasoline', 'DSG', '2018', 5),
    ('NINJA21', 'Kawasaki', 'motorcycle', 'gasoline', 'manual', '2021', 1);

INSERT INTO Suppliers
VALUES
    ('123456', 'AutoParts Co.', '1234567890', 'David Cohen', '123 Hayarkon St', 'david.cohen@gmail.com'),
    ('789012', 'MotoSpares', '9876543210', 'Sarah Levi', '456 Hess Ave', 'sarah.levi@gmail.com'),
    ('345678', 'VehicleComponents', '5551234567', 'Daniel Goldstein', '789 Hapartizanim Rd', 'daniel.goldstein@gmail.com'),
    ('901234', 'CarCare Supplies', '2223334444', 'Liat Rosenberg', '101 Kibutz-Galuyot Ln', 'liat.rosenberg@gmail.com'),
    ('567890', 'TruckParts Ltd.', '7778889999', 'Jonathan Ben-David', '202 Hahagana Blvd', 'jonathan.bendavid@gmail.com');

INSERT INTO Repairs
VALUES
    (12, '1234567', 1, '2023-01-15 09:00:00', '2023-01-15 11:00:00', 275.00),
    (13, '9876543', 3, '2023-02-20 13:30:00', '2023-02-20 16:30:00', 198.55),
    (14, '2345678', 2, '2023-03-10 10:00:00', '2023-03-10 14:00:00', 413.32),
    (15, '7654321', 5, '2023-04-05 12:45:00', '2023-04-05 17:00:00', 264.28),
    (16, '3456789', 4, '2023-05-18 14:00:00', '2023-05-18 20:00:00', 605.00),
    (17, '8765432', 6, '2023-06-07 16:30:00', '2023-06-07 19:30:00', 319.55),
    (12, '4567890', 7, '2023-07-10 15:45:00', '2023-07-10 20:00:00', 385.00),
    (13, '7890123', 1, '2023-03-28 09:30:00', '2023-03-28 12:30:00', 308.28),
    (14, '2345678', 3, '2023-02-10 14:00:00', '2023-02-10 18:00:00', 297.00),
    (15, '5678901', 5, '2023-06-30 10:00:00', '2023-06-30 13:30:00', 247.50);

INSERT INTO Orders (SupplierID, PartID, OrderDate, ReceivedDate, Quantity, PricePerUnit, TotalPrice, ReceiptNumber)
VALUES
    (1, 2, '2023-07-05 09:00:00', '2023-07-10 14:00:00', 100, 15.75, 1575.00, '12345'),
    (3, 5, '2023-06-20 10:30:00', '2023-06-25 11:45:00', 50, 30.50, 1525.00, '67890'),
    (2, 3, '2023-04-15 11:15:00', '2023-04-20 13:30:00', 200, 8.25, 1650.00, '23456'),
    (4, 1, '2023-08-05 12:45:00', '2023-08-10 16:00:00', 75, 22.00, 1650.00, '78901'),
    (1, 7, '2023-05-10 14:30:00', '2023-05-15 17:15:00', 120, 10.00, 1200.00, '34567'),
    (3, 4, '2023-03-25 15:00:00', '2023-03-30 18:30:00', 90, 40.25, 3615.00, '89012'),
    (2, 6, '2023-02-15 16:30:00', '2023-02-20 19:45:00', 40, 18.75, 750.00, '45678'),
    (4, 2, '2023-01-10 17:45:00', '2023-01-15 20:00:00', 150, 25.50, 3825.00, '90123'),
    (1, 5, '2023-08-10 09:15:00', '2023-08-15 12:30:00', 80, 35.00, 2800.00, '56789'),
    (3, 7, '2023-07-05 10:45:00', '2023-07-10 14:00:00', 60, 12.00, 720.00, '23456');

--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=