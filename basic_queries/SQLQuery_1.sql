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
INSERT INTO country 
VALUES('India')

SELECT * FROM country

--Apply unique constraint on country
ALTER TABLE country
ADD CONSTRAINT uk_country_name UNIQUE (name)

INSERT INTO country 
VALUES('India') --Violation of UNIQUE KEY constraint 'uk_country_name'. Cannot insert duplicate key in object 'dbo.country'. The duplicate key value is (India).

--multi data insertion
INSERT INTO country 
VALUES 
('India'),
('Brazil'),
('Russia'),
('China'),
('South Africa')

SELECT * FROM country

-- state insertion
INSERT INTO STATE 
VALUES ('Maharashtra', 1),
('Goa', 1),
('Kerala', 1),
('Delhi', 1),
('Hariyana', 1),
('Uttar Pradesh', 1),
('Uttarakhand', 1),
('Andra Pradesh', 1),
('Telangana', 1),
('Madhya Pradesh', 1),
('Jharkhand', 1),
('Bihar', 1),
('Beijing', 5),
('Shanghai', 5),
('Chengdu', 5),
('Moskow', 4),
('St. Petersburg', 4),
('Sao Paulo', 3);

--adding multi column unique key; also called composite unique constraint/key
ALTER TABLE state
ADD CONSTRAINT uk_state UNIQUE ([name], country_id) 

SELECT * FROM STATE;

-- city insertion
INSERT INTO city
VALUES
('Mumbai', 1),
('Thane', 1),
('Panajim', 2),
('Delhi', 4),
('Bhopal', 10),
('Hyderabad', 9);

--adding multi column unique key; also called composite unique constraint/key
ALTER TABLE city
ADD CONSTRAINT uk_city UNIQUE ([name], state_id) 

INSERT INTO city
VALUES
('Mumbai', 1) -- Violation of UNIQUE KEY constraint 'uk_city'. Cannot insert duplicate key in object 'dbo.city'. The duplicate key value is (Mumbai, 1).

--inserting address

INSERT INTO address 
VALUES('address line 11', 'address line 12',  1),
('address line 21', 'address line 22', 2),
('address line 31', 'address line 32', 3),
('address line 41', 'address line 42', 1),
('address line 51', 'address line 52', 3),
('address line 61', 'address line 62', 4),
('address line 71', 'address line 72', 5),
('address line 81', 'address line 82',6)

select * from [address]


--adding a new column to existing user table
ALTER TABLE [user]
ADD manager_id INT NULL

--inserting users

INSERT INTO [user]
VALUES ('Kiran', 'Sarode', 1, 'kiran.sarode@xyz.com', '8087381830', 1, null),
('Pradnya', 'Sarode', 1, 'p.sarode@xyz.com', '9087381830', 1, null)

INSERT INTO [user]
VALUES ('Suresh', 'Sarode', 1, 's.sarode@xyz.com', '7087381830', 1, 1),
('Manda', 'Sarode', 1, 'm.sarode@xyz.com', '6087381830', 1, 2)

INSERT INTO [user]
VALUES 
('Prakash', 'Patil', 1, 'p.patil@xyz.com', '5087381830', 1, 3),
('Tapasya', 'Patil', 1, 'tp@xyz.com', '4087381830', 1, 1),
('Darshan', 'Mali', 1, 'dm@xyz.com', '3087381830', 1, 2)


select * from [user]

--self join to check employee and their managers
SELECT emp.id, emp.fname + ' ' + emp.lname as employee, mgr.id, mgr.fname + ' ' + mgr.lname as manager 
FROM [user] emp
    LEFT JOIN [user] mgr ON emp.manager_id = mgr.id






