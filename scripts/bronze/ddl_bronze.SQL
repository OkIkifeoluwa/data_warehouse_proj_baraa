// How to create a Warehouse
CREATE WAREHOUSE dwh_with_baraa
  WITH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

    
//Create a database and drop db incase its prexisting
DROP DATABASE IF EXISTS dwh_first_proj_baraa;

CREATE DATABASE dwh_first_proj_baraa;

// Using the specific db created
USE dwh_first_proj_baraa;

// DROP schema if it already exists
DROP SCHEMA IF EXISTS schema_name

// Creating the Schema
CREATE SCHEMA bronze
CREATE SCHEMA silver
CREATE SCHEMA gold


-- This drops the customers_info table in the bronze schema if it exists,
-- This creates the Customers table in the bronze schema.
-- It holds customer details including ID, name, country, and a score.
-- The CustomerID column is marked as the primary key.

DROP TABLE IF EXISTS bronze.customers_info;

CREATE OR REPLACE TABLE bronze.customers_info (
    CustomerID INT NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Country VARCHAR(50),
    Score INT,
    PRIMARY KEY (CustomerID)
);


-- This creates the Employees table in the bronze schema.However, I would rather do that with the bronze schema itself
-- It stores employee details including name, department, birth date, salary,
-- gender, and managerial reporting. EmployeeID is the primary key.


DROP TABLE IF EXISTS bronze.employees_info;

CREATE OR REPLACE TABLE bronze.employees_info (
    EmployeeID INT NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    BirthDate DATE,
    Gender CHAR(1),
    Salary INT,
    ManagerID INT,
    PRIMARY KEY (EmployeeID)
);


-- This creates the Products table in the bronze schema.
-- It stores product details such as product name, category, and price.
-- ProductID is defined as the primary key.

CREATE OR REPLACE TABLE bronze.products_info (
    ProductID INT NOT NULL,
    Product VARCHAR(50),
    Category VARCHAR(50),
    Price INT,
    PRIMARY KEY (ProductID)
);

-- This creates the Orders table in the bronze schema.
-- It stores sales order transactions including product, customer, sales person,
-- order dates, shipping/billing info, quantities, and sales amounts.
-- OrderID is defined as the primary key.

CREATE OR REPLACE TABLE bronze.orders (
    OrderID INT NOT NULL,
    ProductID INT,
    CustomerID INT,
    SalesPersonID INT,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(50),
    ShipAddress VARCHAR(255),
    BillAddress VARCHAR(255),
    Quantity INT,
    Sales INT,
    CreationTime TIMESTAMP,  -- DATETIME2 replaced with Snowflake's TIMESTAMP
    PRIMARY KEY (OrderID)
);

-- This creates the OrdersArchive table in the bronze schema.
-- It is intended to store historical or archived sales order records,
-- with similar structure to the active Orders table but without constraints.

CREATE OR REPLACE TABLE bronze.orders_archive (
    OrderID INT,
    ProductID INT,
    CustomerID INT,
    SalesPersonID INT,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(50),
    ShipAddress VARCHAR(255),
    BillAddress VARCHAR(255),
    Quantity INT,
    Sales INT,
    CreationTime TIMESTAMP  -- Replaces SQL Server's DATETIME2
);


// INSERT DATA INTO TABLES
// FULL LOAD AT THE BRONZE LAYER BY FIRST TRUNCATING THE CONTENT OF THE TABLE

-- This inserts sample customer data into the bronze.customers_info table.
TRUNCATE TABLE bronze.customers_info;

INSERT INTO bronze.customers_info (CustomerID, FirstName, LastName, Country, Score)
VALUES
    (1, 'Jossef', 'Goldberg', 'Germany', 350),
    (2, 'Kevin', 'Brown', 'USA', 900),
    (3, 'Mary', NULL, 'USA', 750),
    (4, 'Mark', 'Schwarz', 'Germany', 500),
    (5, 'Anna', 'Adams', 'USA', NULL);


-- Insert data into bronze.employees_info table
INSERT INTO bronze.employees_info
VALUES
    (1, 'Frank', 'Lee', 'Marketing', '1988-12-05', 'M', 55000, null),
    (2, 'Kevin', 'Brown', 'Marketing', '1972-11-25', 'M', 65000, 1),
    (3, 'Mary', null, 'Sales', '1986-01-05', 'F', 75000, 1),
    (4, 'Michael', 'Ray', 'Sales', '1977-02-10', 'M', 90000, 2),
    (5, 'Carol', 'Baker', 'Sales', '1982-02-11', 'F', 55000, 3);

    
-- Insert data into Products table
INSERT INTO bronze.products_info (ProductID, Product, Category, Price)
VALUES
    (101, 'Bottle', 'Accessories', 10),
    (102, 'Tire', 'Accessories', 15),
    (103, 'Socks', 'Clothing', 20),
    (104, 'Caps', 'Clothing', 25),
    (105, 'Gloves', 'Clothing', 30);
    

-- Insert data into bronze.orders table
INSERT INTO bronze.orders 
VALUES
    (1,  101, 2, 3, '2025-01-01', '2025-01-05', 'Delivered','9833 Mt. Dias Blv.', '1226 Shoe St.',  1, 10, '2025-01-           01T12:34:56'),
    (2,  102, 3, 3, '2025-01-05', '2025-01-10', 'Shipped','250 Race Court',NULL, 1, 15, '2025-01-05T23:22:04'),
    (3,  101, 1, 5, '2025-01-10', '2025-01-25', 'Delivered','8157 W. Book','8157 W. Book', 2, 20, '2025-01-10T18:24:08'),
    (4,  105, 1, 3, '2025-01-20', '2025-01-25', 'Shipped', '5724 Victory Lane', '', 2, 60, '2025-01-20T05:50:33'),
    (5,  104, 2, 5, '2025-02-01', '2025-02-05', 'Delivered',NULL, NULL, 1, 25, '2025-02-01T14:02:41'),
    (6,  104, 3, 5, '2025-02-05', '2025-02-10', 'Delivered','1792 Belmont Rd.',NULL, 2, 50, '2025-02-06T15:34:57'),
    (7,  102, 1, 1, '2025-02-15', '2025-02-27', 'Delivered','136 Balboa Court', '', 2, 30, '2025-02-16T06:22:01'),
    (8,  101, 4, 3, '2025-02-18', '2025-02-27', 'Shipped','2947 Vine Lane','4311 Clay Rd', 3, 90, '2025-02-18T10:45:22'),
    (9,  101, 2, 3, '2025-03-10', '2025-03-15', 'Shipped','3768 Door Way', '', 2, 20,'2025-03-10T12:59:04'),
    (10, 102, 3, 5, '2025-03-15', '2025-03-20', 'Shipped',NULL, NULL, 0, 60,'2025-03-16T23:25:15');



-- Insert data into bronze.orders_archive table
INSERT INTO bronze.orders_archive 
VALUES
    (1, 101,2 , 3, '2024-04-01', '2024-04-05', 'Shipped','123 Main St', '456 Billing St', 1, 10, '2024-04-01T12:34:56'),
    (2, 102,3 , 3, '2024-04-05', '2024-04-10', 'Shipped','456 Elm St', '789 Billing St', 1, 15, '2024-04-05T23:22:04'),
    (3, 101, 1, 4, '2024-04-10', '2024-04-25', 'Shipped','789 Maple St','789 Maple St', 2, 20, '2024-04-10T18:24:08'),
    (4, 105,1 , 3, '2024-04-20', '2024-04-25', 'Shipped',   '987 Victory Lane', '', 2, 60, '2024-04-20T05:50:33'),
    (4, 105,1 , 3, '2024-04-20', '2024-04-25', 'Delivered', '987 Victory Lane', '', 2, 60, '2024-04-20T14:50:33'),
    (5, 104,2 , 5, '2024-05-01', '2024-05-05', 'Shipped','345 Oak St', '678 Pine St', 1, 25, '2024-05-01T14:02:41'),
    (6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered','543 Belmont Rd.',NULL, 2, 50, '2024-05-06T15:34:57'),
    (6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered','543 Belmont Rd.','3768 Door Way', 2, 50, '2024-05-07T13:22:05'),
    (6, 101, 3, 5, '2024-05-05', '2024-05-10', 'Delivered','543 Belmont Rd.','3768 Door Way', 2, 50, '2024-05-12T20:36:55'),
	(7, 102,3 , 5, '2024-06-15', '2024-06-20', 'Shipped','111 Main St', '222 Billing St', 0, 60,'2024-06-16T23:25:15');


 select count(*) from bronze.orders_archive




 --I like to create a procedure and run it the way it would work real life
CREATE OR REPLACE PROCEDURE load_customers_info()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Step 1: Truncate the target table
    TRUNCATE TABLE bronze.customers_info;

    -- Step 2: Insert fresh records
    INSERT INTO bronze.customers_info (CustomerID, FirstName, LastName, Country, Score)
    VALUES
        (1, 'Jossef', 'Goldberg', 'Germany', 350),
        (2, 'Kevin', 'Brown', 'USA', 900),
        (3, 'Mary', NULL, 'USA', 750),
        (4, 'Mark', 'Schwarz', 'Germany', 500),
        (5, 'Anna', 'Adams', 'USA', NULL);

    RETURN 'Load successful';
END;
$$;

-- To see what happens after I call the proceduren
CALL load_customers_info();


--It is best to include a batch time when running the script as well
--I want to return the time into a table as well so i can call the table in future

CREATE OR REPLACE PROCEDURE load_customers_info()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
BEGIN
    -- Capture start time
    v_start_time := CURRENT_TIMESTAMP;

    -- Step 1: Truncate the target table
    TRUNCATE TABLE bronze.customers_info;

    -- Step 2: Insert fresh records
    INSERT INTO bronze.customers_info (CustomerID, FirstName, LastName, Country, Score)
    VALUES
        (1, 'Jossef', 'Goldberg', 'Germany', 350),
        (2, 'Kevin', 'Brown', 'USA', 900),
        (3, 'Mary', NULL, 'USA', 750),
        (4, 'Mark', 'Schwarz', 'Germany', 500),
        (5, 'Anna', 'Adams', 'USA', NULL);

    -- Capture end time
    v_end_time := CURRENT_TIMESTAMP;

    -- Optional: Log to a control table
    INSERT INTO etl_audit_log (layer_name, start_time, end_time, status)
    VALUES ('bronze.customers_info', v_start_time, v_end_time, 'SUCCESS');

    -- Return message
    RETURN 'Load completed at ' || TO_VARCHAR(v_end_time);
END;
$$;

-- ETL audit log table
CREATE TABLE IF NOT EXISTS etl_audit_log (
    layer_name STRING,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status STRING
);

select* from etl_audit_log
