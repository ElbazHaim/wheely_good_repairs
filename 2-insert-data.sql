USE wheely_good_repairs;
-- Inserts
INSERT INTO
  Customers
VALUES
  (
    'Avraham',
    'Levi',
    '12345678',
    '1990-05-15',
    '2022-04-08',
    'Harel Insurance',
    'Tel Aviv',
    '123 Hertzl',
    '1234567890',
    'avraham@gmail.com',
    '12345678'
  ),
  (
    'Sarah',
    'Cohen',
    '87654321',
    '1985-10-20',
    '2020-11-17',
    'IDII Insurance',
    'Jerusalem',
    '456 Jaffa',
    '9876543210',
    'sara@yahoo.com',
    '87654321'
  ),
  (
    'Yaakov',
    'Ben-David',
    '23456789',
    '2000-02-01',
    '2021-09-25',
    'Leumit Insurance',
    'Haifa',
    '789 Harbor',
    '5678901234',
    'yaakov@gmail.com',
    '23456789'
  ),
  (
    'Rachel',
    'Shapira',
    '98765432',
    '1978-08-10',
    '2019-07-02',
    'Poalim Insurance',
    'Beersheba',
    '567 Ben-Gurion',
    '8765432109',
    'rachel@yahoo.com',
    '98765432'
  ),
  (
    'Daniel',
    'Almog',
    '34567890',
    '1995-03-25',
    '2022-01-20',
    'Harel Insurance',
    'Eilat',
    '901 Hatamar',
    '2345678901',
    'daniel@gmail.com',
    '34567890'
  );
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  -- Departments and employees foreign keys are circular - I Will disable the constraints just so that I can insert the departments
ALTER TABLE
  Employees NOCHECK CONSTRAINT FK_DepartmentID;
ALTER TABLE
  Departments NOCHECK CONSTRAINT FK_DepartmentHead;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
INSERT INTO
  Employees
VALUES
  (
    'Avi',
    'Cohen',
    '123456789',
    '1985-05-15',
    '2010-01-15',
    1,
    NULL,
    -- Owner & General Manager
    'avi@example.com',
    'Tel Aviv',
    '123 Main',
    60000.00,
    'MSc. Business Management',
    '1234567890123'
  );
INSERT INTO
  Employees
VALUES
  -- Management
  (
    'Rachel',
    'Levi',
    '234567894',
    '1990-03-20',
    '2021-02-10',
    1,
    1,
    'rachel@example.com',
    'Tel Aviv',
    '456 Elm',
    55000.00,
    'BSc. Accounting',
    '2345678901234'
  ),
  (
    'Eyal',
    'Sela',
    '345678902',
    '1988-08-01',
    '2019-05-05',
    2,
    1,
    'eyal@example.com',
    'Tel Aviv',
    '789 Oak',
    58000.00,
    'MSc. Business Management',
    '3456789012345'
  ),
  (
    'Tamar',
    'Ben-David',
    '456784901',
    '1992-10-10',
    '2022-03-20',
    3,
    1,
    'tamar@example.com',
    'Tel Aviv',
    '101 Pine',
    52000.00,
    'Diploma in Automotive Technology',
    '4567890123456'
  ),
  (
    'Yaniv',
    'Alon',
    '567890512',
    '1987-12-05',
    '2020-09-18',
    4,
    1,
    'yaniv@example.com',
    'Tel Aviv',
    '202 Cedar',
    59000.00,
    'Practical Engineering in Electronics',
    '5678901234567'
  ),
  (
    'Maya',
    'Carmel',
    '678901123',
    '1995-06-25',
    '2023-01-10',
    5,
    1,
    'maya@example.com',
    'Tel Aviv',
    '303 Walnut',
    54000.00,
    'BSc in Automotive Technology',
    '6789012345678'
  );
INSERT INTO
  Departments
VALUES
  ('Accounting', 2, 21966.75),
  ('Customer Service', 3, 91234.56),
  ('Mechanical', 4, 105678.90),
  ('Electrical', 5, 83210.54),
  ('Paint Shop', 6, 64567.89);
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  -- Enable constraints
ALTER TABLE
  Departments WITH CHECK CHECK CONSTRAINT FK_DepartmentHead;
ALTER TABLE
  Employees WITH CHECK CHECK CONSTRAINT FK_DepartmentID;
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  -- Accounting
INSERT INTO
  Employees
VALUES
  (
    'Maya',
    'Cohen',
    '987654321',
    '1995-09-20',
    '2020-03-10',
    1,
    2,
    'maya@gmail.com',
    'Jerusalem',
    '456 King David St',
    55000.00,
    'Student',
    '9876543210'
  ),
  (
    'Noam',
    'Katz',
    '555555555',
    '1992-11-10',
    '2019-07-15',
    1,
    2,
    'noam@gmail.com',
    'Haifa',
    '789 Carmel Ave',
    58000.00,
    'BSc. Accounting',
    '5555555555'
  ),
  (
    'May',
    'Avraham',
    '333333333',
    '1989-07-02',
    '2023-06-01',
    1,
    2,
    'may@gmail.com',
    'Haifa',
    '567 Herzl St',
    57000.00,
    'Student in Accounting',
    '3333333333'
  );
-- Customer Service
INSERT INTO
  Employees
VALUES
  (
    'Inbar',
    'Sapir',
    '890112345',
    '1993-02-28',
    '2021-12-01',
    2,
    3,
    'inbar@example.com',
    'Jerusalem',
    '505 Birch',
    62000.00,
    'Diploma in Auto Mechanics',
    '8901234567890'
  ),
  (
    'Yoni',
    'Lazarus',
    '901232456',
    '1989-11-15',
    '2018-10-20',
    2,
    3,
    'yoni@example.com',
    'Jerusalem',
    '606 Oak',
    58000.00,
    'BSc. English Literature',
    '9012345678901'
  ),
  (
    'Lior',
    'Golan',
    '012343567',
    '1991-07-30',
    '2022-04-05',
    2,
    3,
    'lior@example.com',
    'Jerusalem',
    '707 Pine',
    54000.00,
    Null,
    '0123456789012'
  ),
  (
    'Noga',
    'Cohen',
    '987654432',
    '1994-04-22',
    '2019-08-18',
    2,
    3,
    'noga@example.com',
    'Jerusalem',
    '808 Walnut',
    56000.00,
    'Student',
    '9876543210987'
  ),
  (
    'Eli',
    'Eisenberg',
    '876554321',
    '1986-01-18',
    '2020-03-10',
    3,
    NULL,
    'eli@example.com',
    'Haifa',
    '909 Cedar',
    53000.00,
    'Student',
    '8765432109876'
  );
INSERT INTO
  CustomerServices
VALUES
  (7, 4.56, 1),
  (8, 3.50, 1),
  (9, 4.94, 0),
  (10, 3.07, 1),
  (11, 3.95, 0);
-- Technicians
INSERT INTO
  Employees
VALUES
  (
    'Oren',
    'Dagan',
    '789061234',
    '1990-09-12',
    '2022-07-05',
    3,
    4,
    'oren@example.com',
    'Tel Aviv',
    '404 Maple',
    57000.00,
    'Practical Engineering in Mechanics',
    '7890123456789'
  ),
  (
    'Noa',
    'Gavriel',
    '766543210',
    '1993-08-09',
    '2022-06-15',
    3,
    4,
    'noa@example.com',
    'Haifa',
    '1010 Elm',
    57000.00,
    'Diploma in Automotive Technology',
    '7654321098765'
  ),
  (
    'Eitan',
    'Adler',
    '654832109',
    '1988-05-07',
    '2019-12-05',
    4,
    5,
    'eitan@example.com',
    'Tel Aviv',
    '1111 Oak',
    55000.00,
    'Practical Engineering in Auto Electronics',
    '6543210987654'
  ),
  (
    'Talia',
    'Levy',
    '543213098',
    '1997-03-02',
    '2023-02-20',
    4,
    5,
    'talia@example.com',
    'Tel Aviv',
    '1212 Pine',
    59000.00,
    'BSc. in Mechanical Engineering',
    '5432109876543'
  ),
  (
    'Ronen',
    'Cohen',
    '432104987',
    '1991-12-12',
    '2018-07-01',
    5,
    6,
    'ronen@example.com',
    'Eilat',
    '1313 Elm',
    51000.00,
    'BSc. Electrical Engineering',
    '4321098765432'
  ),
  (
    'Eli',
    'Luzon',
    '953468725',
    '1990-05-06',
    '2019-02-02',
    5,
    6,
    'Luzon@gmail.com',
    'Holon',
    '1234 Sokolov',
    75000.00,
    NULL,
    '3462587295643'
  );
INSERT INTO
  Technicians
VALUES
  (12, 'Motorcycles', 'Kf9Gt7DpL1'),
  (13, 'Old Models', 'XeR5jYqWu8'),
  (14, 'Electrical Engines', 'PmZ2vNcHs4'),
  (15, 'Hybrid Cars', 'Tl7KbFmRi3'),
  (16, 'Paint Renewal', 'Qw1XnZtYv4'),
  (17, 'Paint Renewal', 'Eg3HkMlPq5');
INSERT INTO
  Parts
VALUES
  (
    'Engine Oil',
    30,
    25.99,
    '1 Quart',
    'ACME Motors'
  ),
  ('Brake Pads', 25, 39.95, 'Standard', 'BrakeTech'),
  (
    'Air Filter',
    5,
    12.50,
    'Standard',
    'FilterMaster'
  ),
  ('Spark Plugs', 13, 8.99, 'Set of 4', 'SparkTech'),
  (
    'Radiator Hose',
    3,
    18.75,
    '18 inches',
    'CoolantCo'
  ),
  (
    'Fuel Pump',
    32,
    65.00,
    'Standard',
    'Fueltronics'
  ),
  (
    'Transmission Fluid',
    9,
    19.50,
    '1 Quart',
    'GearLube'
  ),
  ('Alternator', 11, 120.75, 'Standard', 'PowerGen'),
  (
    'Thermostat',
    20,
    14.25,
    'Standard',
    'TempControl'
  ),
  (
    'Serpentine Belt',
    28,
    23.50,
    'Accessory',
    'BeltMaster'
  );
INSERT INTO
  Models
VALUES
  (
    'CAMRY21',
    'Toyota',
    'car',
    'gasoline',
    'automatic',
    '2021',
    5
  ),
  (
    'CIVIC19',
    'Honda',
    'car',
    'gasoline',
    'manual',
    '2019',
    5
  ),
  (
    'GOLF20',
    'Volkswagen',
    'car',
    'diesel',
    'semi-automatic',
    '2020',
    5
  ),
  (
    'MODEL322',
    'Tesla',
    'car',
    'electric',
    'automatic',
    '2022',
    5
  ),
  (
    'F15020',
    'Ford',
    'truck',
    'gasoline',
    'automatic',
    '2020',
    3
  ),
  (
    'R1K20',
    'Yamaha',
    'motorcycle',
    'gasoline',
    'manual',
    '2020',
    2
  ),
  (
    'XC9019',
    'Volvo',
    'SUV',
    'hybrid',
    'automatic',
    '2019',
    7
  ),
  (
    'TRANSIT20',
    'Ford',
    'van',
    'diesel',
    'automatic',
    '2020',
    9
  ),
  (
    'WRANGLER20',
    'Jeep',
    'SUV',
    'gasoline',
    'manual',
    '2020',
    4
  ),
  (
    'JETTA18',
    'Volkswagen',
    'car',
    'gasoline',
    'DSG',
    '2018',
    5
  ),
  (
    'NINJA21',
    'Kawasaki',
    'motorcycle',
    'gasoline',
    'manual',
    '2021',
    1
  );
INSERT INTO
  Suppliers
VALUES
  (
    '123456',
    'AutoParts Co.',
    '1234567890',
    'David Cohen',
    '123 Hayarkon St',
    'david.cohen@gmail.com'
  ),
  (
    '789012',
    'MotoSpares',
    '9876543210',
    'Sarah Levi',
    '456 Hess Ave',
    'sarah.levi@gmail.com'
  ),
  (
    '345678',
    'VehicleComponents',
    '5551234567',
    'Daniel Goldstein',
    '789 Hapartizanim Rd',
    'daniel.goldstein@gmail.com'
  ),
  (
    '901234',
    'CarCare Supplies',
    '2223334444',
    'Liat Rosenberg',
    '101 Kibutz-Galuyot Ln',
    'liat.rosenberg@gmail.com'
  ),
  (
    '567890',
    'TruckParts Ltd.',
    '7778889999',
    'Jonathan Ben-David',
    '202 Hahagana Blvd',
    'jonathan.bendavid@gmail.com'
  );
INSERT INTO
  Vehicles
VALUES
  (
    '12345678',
    'GOLF20',
    1,
    50000,
    2,
    'ABC123456',
    'Red'
  ),
  (
    '23456789',
    'CIVIC19',
    2,
    75000,
    1,
    'DEF456789',
    'Blue'
  ),
  (
    '34567890',
    'NINJA21',
    3,
    30000,
    0,
    'GHI789012',
    'Green'
  ),
  (
    '45678901',
    'JETTA18',
    4,
    60000,
    3,
    'JKL012345',
    'Silver'
  ),
  (
    '56789012',
    'MODEL322',
    5,
    45000,
    1,
    'MNO345678',
    'Black'
  ),
  (
    '67890123',
    'F15020',
    1,
    80000,
    2,
    'PQR678901',
    'White'
  ),
  (
    '78901234',
    'MODEL322',
    4,
    25000,
    0,
    'STU901234',
    'Gray'
  );
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
  -- Inserts for relation tables
INSERT INTO
  Repairs
VALUES
  (
    12,
    '12345678',
    1,
    '2023-01-15 09:00:00',
    '2023-01-15 11:00:00',
    275.00
  ),
  (
    13,
    '34567890',
    3,
    '2023-02-20 13:30:00',
    '2023-02-20 16:30:00',
    198.55
  ),
  (
    14,
    '56789012',
    2,
    '2023-03-10 10:00:00',
    '2023-03-10 14:00:00',
    413.32
  ),
  (
    15,
    '12345678',
    5,
    '2023-04-05 12:45:00',
    '2023-04-05 17:00:00',
    264.28
  ),
  (
    16,
    '23456789',
    4,
    '2023-05-18 14:00:00',
    '2023-05-18 20:00:00',
    605.00
  ),
  (
    17,
    '45678901',
    6,
    '2023-06-07 16:30:00',
    '2023-06-07 19:30:00',
    319.55
  ),
  (
    12,
    '45678901',
    7,
    '2023-07-10 15:45:00',
    '2023-07-10 20:00:00',
    385.00
  ),
  (
    13,
    '67890123',
    10,
    '2023-03-28 09:30:00',
    '2023-03-28 12:30:00',
    308.28
  ),
  (
    14,
    '56789012',
    8,
    '2023-02-10 14:00:00',
    '2023-02-10 18:00:00',
    297.00
  ),
  (
    15,
    '78901234',
    5,
    '2023-06-30 10:00:00',
    '2023-06-30 13:30:00',
    247.50
  );
INSERT INTO
  Orders
VALUES
  (
    1,
    2,
    3,
    '2023-07-05 09:00:00',
    '2023-07-10 14:00:00',
    100,
    15.75,
    1575.00,
    '12345'
  ),
  (
    3,
    5,
    3,
    '2023-06-20 10:30:00',
    '2023-06-25 11:45:00',
    50,
    30.50,
    1525.00,
    '67890'
  ),
  (
    2,
    3,
    4,
    '2023-04-15 11:15:00',
    '2023-04-20 13:30:00',
    200,
    8.25,
    1650.00,
    '23456'
  ),
  (
    4,
    1,
    4,
    '2023-08-05 12:45:00',
    '2023-08-10 16:00:00',
    75,
    22.00,
    1650.00,
    '78901'
  ),
  (
    1,
    7,
    3,
    '2023-05-10 14:30:00',
    '2023-05-15 17:15:00',
    120,
    10.00,
    1200.00,
    '34567'
  ),
  (
    3,
    4,
    3,
    '2023-03-25 15:00:00',
    '2023-03-30 18:30:00',
    90,
    40.25,
    3615.00,
    '89012'
  ),
  (
    2,
    6,
    4,
    '2023-02-15 16:30:00',
    '2023-02-20 19:45:00',
    40,
    18.75,
    750.00,
    '45678'
  ),
  (
    4,
    2,
    4,
    '2023-01-10 17:45:00',
    '2023-01-15 20:00:00',
    150,
    25.50,
    3825.00,
    '90123'
  ),
  (
    1,
    5,
    5,
    '2023-08-10 09:15:00',
    '2023-08-15 12:30:00',
    80,
    35.00,
    2800.00,
    '56789'
  ),
  (
    3,
    7,
    4,
    '2023-07-05 10:45:00',
    '2023-07-10 14:00:00',
    60,
    12.00,
    720.00,
    '23456'
  );
INSERT INTO
  Payments
VALUES
  (1, 3, 3, '2023-07-05 10:00:00', 200.00),
  (2, 5, 5, '2023-06-20 11:30:00', 150.50),
  (3, 3, 2, '2023-04-15 12:45:00', 100.25),
  (4, 3, 4, '2023-08-05 13:30:00', 75.00),
  (5, 4, 1, '2023-05-10 14:45:00', 120.00),
  (1, 5, 7, '2023-03-25 15:45:00', 90.75),
  (2, 3, 6, '2023-02-15 16:00:00', 40.50),
  (3, 4, 8, '2023-01-10 17:15:00', 150.00),
  (4, 3, 9, '2023-08-10 18:30:00', 80.25),
  (5, 5, 10, '2023-07-05 19:00:00', 60.00);
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=