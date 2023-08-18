--Wheely-Good Repairs

-- use master;
-- alter database wheely_good_repairs set single_user with rollback immediate;
-- alter database wheely_good_repairs set multi_user;
-- DROP DATABASE IF EXISTS wheely_good_repairs;
-- CREATE DATABASE wheely_good_repairs;

-- Declarations

--- Database Declaration

-- CREATE DATABASE wheely_good_repairs;
USE wheely_good_repairs;

-- Tables Declaration

--- Entities

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    IdentificationNumber VARCHAR(8) NOT NULL,
    Birthdate DATE,
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
    IdentificationNumber VARCHAR(8) NOT NULL,
    BirthDate DATE NOT NULL,
    HireDate DATE NOT NULL,
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

-- Altering tables to referrence each other
ALTER TABLE Employees
ADD CONSTRAINT FK_DepartmentID
FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);

ALTER TABLE Departments
ADD CONSTRAINT FK_DepartmentHead
FOREIGN KEY (DepartmentHead) REFERENCES Employees(EmployeeNumber);


CREATE TABLE CustomerServices (
    EmployeeNumber INT PRIMARY KEY,
    CustomerSatisfactionScore DECIMAL(3,2),
    EnglishSpeaker BIT,

    FOREIGN KEY (EmployeeNumber) REFERENCES Employees(EmployeeNumber),
    
    CONSTRAINT CHK_SatisfactionScore CHECK (CustomerSatisfactionScore >= 0 AND CustomerSatisfactionScore <= 5)
);

CREATE TABLE Technicians (
    EmployeeNumber INT PRIMARY KEY,
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
    Year DATE
);

CREATE TABLE Vehicles (
    LicensePlate VARCHAR(20) PRIMARY KEY,
    ModelCode VARCHAR(20),
    Owner INT,
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


--- Relations
CREATE TABLE Repairs (
    RepairID INT IDENTITY(1,1) PRIMARY KEY,
    TechnicianID INT,
    LicensePlate VARCHAR(20),
    PartID INT,
    StartRepairTime DATETIME,
    EndRepairTime DATETIME,
    TotalCost DECIMAL(10, 2),
    
    FOREIGN KEY (TechnicianID) REFERENCES Technicians(EmployeeNumber),
    FOREIGN KEY (LicensePlate) REFERENCES Vehicles(LicensePlate),
    FOREIGN KEY (PartID) REFERENCES Parts(PartID)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    PartID INT,
    OrderDate DATETIME,
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
