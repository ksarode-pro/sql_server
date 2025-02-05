--database creation
create DATABASE employee;

--database selected
use employee;

--table creation with PK, identity and not null constraint
CREATE TABLE country
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(250) NOT NULL
);

-- table creation with FK constraint
CREATE TABLE state
(
    id INT PRIMARY KEY IDENTITY,
    region_name NVARCHAR(250) NOT NULL,
    country_id INT,
    CONSTRAINT fk_state_country FOREIGN KEY (country_id) REFERENCES country(id)
);

-- rename columns name from region_name to name
EXEC sp_rename 'state.[region_name]', 'name', 'COLUMN' ;

-- table creation with wron FK reference
CREATE TABLE city
(
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(250) NOT NULL,
    state_id INT,
    CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES country(id)
);

--correction of FK reference by modifying city table
ALTER TABLE city
DROP CONSTRAINT fk_city_state;

ALTER TABLE city
ADD CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES state(id);

-- create table address
CREATE TABLE address
(
    id int PRIMARY KEY IDENTITY,
    line1 NVARCHAR(250) NOT NULL,
    line2 NVARCHAR(250) NULL,
    city_id INT,
    CONSTRAINT FK_address_city FOREIGN KEY (city_id) REFERENCES city(id)
)

-- create user table with default and FK constraint
CREATE TABLE [user] 
(
    id int PRIMARY KEY IDENTITY, 
    fname NVARCHAR(150) NOT NULL,
    lname NVARCHAR(150) NOT NULL,
    gender SMALLINT DEFAULT 1,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(12) NOT NULL,
    address_id int,
    CONSTRAINT fk_user_address FOREIGN KEY (address_id) REFERENCES address(id)
)

--data insertion
