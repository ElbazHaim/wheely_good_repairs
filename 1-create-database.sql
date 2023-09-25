-- Wheely-Good Repairs
-- Database Design & Analysis Project
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
-- Cleanup, do not run on first run. Run blocks separately when cleaning.
use master;
alter database wheely_good_repairs
set
  single_user with rollback immediate;
alter database wheely_good_repairs
set
  multi_user;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  DROP DATABASE IF EXISTS wheely_good_repairs;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  --- Database Declaration
  CREATE DATABASE wheely_good_repairs;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  USE wheely_good_repairs;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  -- Tables Declaration
  --- Entities
  CREATE TABLE Customers (
    CustomerID INT IDENTITY(1, 1) PRIMARY KEY,
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
    LicenseNumber VARCHAR(20)
  );
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1, 1) PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE,
    DepartmentHead INT,
    YearlyBudget DECIMAL(15, 2) NOT NULL,
    CONSTRAINT YearlyBudget CHECK (YearlyBudget > 0)
  );
CREATE TABLE Employees (
    EmployeeNumber INT IDENTITY(1, 1) PRIMARY KEY,
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
ALTER TABLE
  Employees
ADD
  CONSTRAINT FK_DepartmentID FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);
ALTER TABLE
  Departments
ADD
  CONSTRAINT FK_DepartmentHead FOREIGN KEY (DepartmentHead) REFERENCES Employees(EmployeeNumber);
CREATE TABLE CustomerServices (
    EmployeeNumber INT PRIMARY KEY FOREIGN KEY (EmployeeNumber) REFERENCES Employees(EmployeeNumber),
    CustomerSatisfactionScore DECIMAL(3, 2),
    EnglishSpeaker BIT,
    CONSTRAINT CHK_SatisfactionScore CHECK (
      CustomerSatisfactionScore BETWEEN 0
      AND 5
    )
  );
CREATE TABLE Technicians (
    EmployeeNumber INT PRIMARY KEY FOREIGN KEY (EmployeeNumber) REFERENCES Employees(EmployeeNumber),
    Specialty VARCHAR(100),
    CertificationID VARCHAR(20),
    FOREIGN KEY (EmployeeNumber) REFERENCES Employees(EmployeeNumber)
  );
CREATE TABLE Parts (
    PartID INT IDENTITY(1, 1) PRIMARY KEY,
    PartName VARCHAR(30),
    Units INT,
    Cost DECIMAL(10, 2),
    Size VARCHAR(20),
    Manufacturer VARCHAR(100)
  );
CREATE TABLE Models (
    Code VARCHAR(20) PRIMARY KEY,
    Manufacturer VARCHAR(50),
    Type VARCHAR(10),
    FuelType VARCHAR(50),
    Gear VARCHAR(20),
    Year DATE,
    Seats INT,
    CHECK (
      Type IN ('car', 'motorcycle', 'truck', 'SUV', 'van')
    ),
    CHECK (
      FuelType IN (
        'gasoline',
        'diesel',
        'electric',
        'hybrid',
        'natural gas'
      )
    ),
    CHECK (
      Gear IN (
        'manual',
        'automatic',
        'semi-automatic',
        'CVT',
        'DSG'
      )
    )
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
    SupplierID INT IDENTITY(1, 1) PRIMARY KEY,
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
    RepairID INT IDENTITY(1, 1) PRIMARY KEY,
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
    OrderID INT IDENTITY(1, 1) PRIMARY KEY,
    SupplierID INT,
    PartID INT,
    DepartmentID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    ReceivedDate DATETIME,
    Quantity INT,
    PricePerUnit DECIMAL(10, 2),
    TotalPrice DECIMAL(10, 2),
    ReceiptNumber VARCHAR(50) NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (PartID) REFERENCES Parts(PartID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    CONSTRAINT CHK_Quantity CHECK (Quantity > 0),
    CONSTRAINT CHK_PricePerUnit CHECK (PricePerUnit > 0),
    CONSTRAINT CHK_TotalPrice CHECK (TotalPrice > 0)
  );
-- Customers pay departments for repairs
  CREATE TABLE Payments (
    PaymentID INT IDENTITY(1, 1) PRIMARY KEY,
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