--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
USE wheely_good_repairs;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/*
Query 1:
	Find customer names and phone numbers for customers having a relatively new car under 50000 km)
	that had more than one repair.
*/
SELECT
  FirstName,
  LastName,
  PhoneNumber,
  SubQuery.LicensePlate,
  SubQuery.SumCost
FROM
  Customers
  INNER JOIN (
    SELECT
      V.[Owner],
      R.LicensePlate,
      SUM(TotalCost) as SumCost
    FROM
      Vehicles AS V
      JOIN Repairs AS R ON V.LicensePlate = R.LicensePlate
    WHERE
      V.Mileage < 50000
    GROUP BY
      R.LicensePlate,
      V.[Owner]
    HAVING
      COUNT(R.LicensePlate) > 1
  ) AS SubQuery ON CustomerID = SubQuery.[Owner];
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/*
Query 2:
	Find lowest-cost suppliers for the most frequently used part
*/
SELECT
  SubQuery1.UsageFrequency,
  SubQuery1.PartID,
  SubQuery1.PartName,
  SubQuery2.MinPricePerUnit,
  SubQuery2.SupplierName,
  SubQuery2.SupplierPhoneNumber
FROM
  (
    SELECT
      P.PartID,
      P.PartName,
      COUNT(R.RepairID) AS UsageFrequency
    FROM
      Parts as P
      LEFT JOIN Repairs AS R ON P.PartID = R.PartID
    GROUP BY
      P.PartID,
      P.PartName
  ) AS SubQuery1
  JOIN (
    SELECT
      S.CompanyName AS SupplierName,
      S.PhoneNumber AS SupplierPhoneNumber,
      O.PartID,
      O.PricePerUnit AS MinPricePerUnit
    FROM
      Orders AS O
      JOIN Suppliers AS S ON O.SupplierID = S.SupplierID
      JOIN (
        SELECT
          PartID,
          MIN(PricePerUnit) AS MinPricePerUnit
        FROM
          Orders
        GROUP BY
          PartID
      ) AS MinPrices ON O.PartID = MinPrices.PartID
      AND O.PricePerUnit = MinPrices.MinPricePerUnit
  ) AS SubQuery2 ON SubQuery1.PartID = SubQuery2.PartID
ORDER BY
  UsageFrequency DESC;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/* 
Query 3: 
	Average accidents per model
*/
SELECT
  AVG(CAST(Accidents AS DECIMAL(10, 2))) AS AverageAccidents,
  ModelCode
FROM
  Vehicles
GROUP BY
  ModelCode;
SELECT
  Accidents,
  ModelCode
FROM
  Vehicles
SELECT
  *
FROM
  Repairs;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/* 
Query 4: 
	List repairs by their profit
*/
SELECT
  Repairs.RepairID,
  Repairs.TechnicianID,
  Vehicles.ModelCode,
  RepairDurationInHours,
  TotalCost / RepairDurationInHours - Parts.Cost AS ProfitPerHour
FROM
  Repairs
  JOIN (
    SELECT
      RepairID,
      DATEDIFF(MINUTE, StartRepairTime, EndRepairTime) / 60.0 AS RepairDurationInHours
    FROM
      Repairs
  ) AS SubQuery ON Repairs.RepairID = SubQuery.RepairID
  JOIN Parts ON Repairs.PartID = Parts.PartID
  JOIN Vehicles ON Repairs.LicensePlate = Vehicles.LicensePlate
ORDER BY
  ProfitPerHour DESC;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/*
Query 5:
	Customers joined in 2022
*/
SELECT
  *
FROM
  Customers AS C
  JOIN Vehicles AS V ON C.CustomerID = V.[Owner]
WHERE
  DATEPART(YEAR, C.JoinDate) = 2022;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/*
Query 6:
	Vehicle usage category, sorted by amount of accidents per year
*/
SELECT
  LicensePlate,
  Code,
  Age,
  AccidentsPerYear,
  CASE
    WHEN KmPerYear < 5000 THEN 'Very Low Usage'
    WHEN KmPerYear < 10000 THEN 'Low Usage'
    WHEN KmPerYear BETWEEN 10000
    AND 20000 THEN 'Medium Usage'
    ELSE 'High Usage'
  END AS UsageCategory
FROM
  (
    SELECT
      Vehicles.LicensePlate,
      Models.Code,
      SubQuery1.Age,
      Vehicles.Accidents / SubQuery1.Age AS AccidentsPerYear,
      Vehicles.Mileage / SubQuery1.Age AS KmPerYear
    FROM
      Vehicles
      JOIN Models ON Vehicles.ModelCode = Models.Code
      JOIN (
        SELECT
          Models.Code,
          DATEDIFF(YEAR, Models.[Year], CURRENT_TIMESTAMP) * 1.0 AS Age
        FROM
          Models
      ) AS SubQuery1 ON Models.Code = SubQuery1.Code
  ) AS SubQuery2
ORDER BY
  AccidentsPerYear DESC;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/*
Query 7:
	Between; Where; Like;
*/
SELECT
  Customers.FirstName,
  Customers.LastName,
  Customers.BirthDate,
  Customers.PhoneNumber,
  SubQuery1.TotalPayed,
  SubQuery1.NumRepairs
FROM
  Customers
  JOIN (
    SELECT
      C.CustomerID,
      SUM(AmountPaid) AS TotalPayed,
      COUNT(RepairID) as NumRepairs
    FROM
      Customers AS C
      INNER JOIN Payments AS P ON C.CustomerID = P.CustomerID
    WHERE
      C.BirthDate BETWEEN '1980-01-01'
      AND '1995-12-31'
      AND InsuranceCompany LIKE '%Harel%'
    GROUP BY
      C.CustomerID
  ) AS SubQuery1 ON Customers.CustomerID = SubQuery1.CustomerID;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
/*
Query 8:
	OUTER JOIN repair types (parts?) and types of cars getting those repair types. 
	How many times did each car had each repair? 
*/
SELECT
  Parts.PartName,
  Models.Code,
  COUNT(Repairs.RepairID) AS NumRepairs
FROM
  Repairs
  JOIN Vehicles on Repairs.LicensePlate = Vehicles.LicensePlate FULL
  OUTER JOIN Models on Vehicles.ModelCode = Models.Code
  JOIN Parts ON Repairs.PartID = Parts.PartID
WHERE
  Models.Gear LIKE '%automatic%'
GROUP BY
  Models.Code,
  Parts.PartName
ORDER BY
  PartName;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=