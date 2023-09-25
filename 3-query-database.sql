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
      Vehicles.[Owner],
      Repairs.LicensePlate,
      SUM(TotalCost) as SumCost
    FROM
      Vehicles
      JOIN Repairs ON Vehicles.LicensePlate = Repairs.LicensePlate
    WHERE
      Vehicles.Mileage < 50000
    GROUP BY
      Repairs.LicensePlate,
      Vehicles.[Owner]
    HAVING
      COUNT(Repairs.LicensePlate) > 1
  ) AS SubQuery ON CustomerID = SubQuery.[Owner];
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=