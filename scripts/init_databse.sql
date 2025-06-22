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


// Creating the Schema
CREATE SCHEMA bronze
CREATE SCHEMA silver
CREATE SCHEMA gold

