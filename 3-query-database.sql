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
  -- /*
  -- Query 2:
  --     Find lowest-cost suppliers for the most frequently used part
  -- */
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
