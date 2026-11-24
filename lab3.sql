-- Create the Lab 3 schema.
CREATE DATABASE IF NOT EXISTS lab3;
USE lab3;

-- Create the client table.
CREATE TABLE CLIENT (
    clientID INT NOT NULL AUTO_INCREMENT,
    client_name VARCHAR(55) NOT NULL,
    client_address VARCHAR(55) NOT NULL,
    client_age INT NOT NULL,
    PRIMARY KEY (clientID)
) ENGINE = InnoDB;

-- Create the policy catalog.
CREATE TABLE POLICY (
    policyID INT NOT NULL AUTO_INCREMENT,
    policyType VARCHAR(55) NOT NULL,
    policyTerm VARCHAR(45) NOT NULL,
    policyLimits VARCHAR(100) NOT NULL,
    PRIMARY KEY (policyID)
) ENGINE = InnoDB;

-- Link clients to policies. Deleting either parent removes its assignments.
CREATE TABLE POLICY_LIST (
    CLIENT_clientID INT NOT NULL,
    POLICY_policyID INT NOT NULL,
    PRIMARY KEY (CLIENT_clientID, POLICY_policyID),
    CONSTRAINT fk_policy_list_client FOREIGN KEY (CLIENT_clientID)
        REFERENCES CLIENT (clientID) ON DELETE CASCADE,
    CONSTRAINT fk_policy_list_policy FOREIGN KEY (POLICY_policyID)
        REFERENCES POLICY (policyID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Insert the assigned clients.
INSERT INTO CLIENT (clientID, client_name, client_address, client_age) VALUES
    (1, 'James Clark', '1001 Plymouth Ave', 38),
    (2, 'Leah Nicole', '2401 Chicago Ave. #212', 36),
    (3, 'Silas Alexander', '5012 Humboldt Lane', 22),
    (4, 'Noah Charles', '501 College Ave.', 25),
    (5, 'Chris Isaac', '228 e, 149th st.', 37),
    (6, 'Noah Charles', '501 College Ave.', 25),
    (7, 'Brittney Owens', '321 Thursday Ave.', 42),
    (8, 'Kurt Douglas', '123 Mt. Glenwood', 58),
    (9, 'Areta Farries', '789 Touy Ave.', 62),
    (10, 'Jessica Daniel', '698 Featherstone', 47),
    (11, 'Gary Moore', '698 Featherstone', 48),
    (12, 'Elnora Daniel', '698 Featherstone', 61),
    (13, 'Daniel Moore', '698 Featherstone', 22),
    (14, 'Cheryl Pearson', '228 e, 149th st.', 67);

-- Insert the offered policies using unformatted dollar amounts.
INSERT INTO POLICY (policyID, policyType, policyTerm, policyLimits) VALUES
    (1, 'Home', 'yearly', '100000'),
    (2, 'Home', 'yearly', '250000'),
    (3, 'Home', 'yearly', '500000'),
    (4, 'Home', 'yearly', '1000000'),
    (5, 'Home', '6-month', '100000'),
    (6, 'Home', '6-month', '250000'),
    (7, 'Home', '6-month', '500000'),
    (8, 'Home', '6-month', '1000000'),
    (9, 'Car', 'yearly', '60000'),
    (10, 'Car', 'yearly', '120000'),
    (11, 'Car', '6-month', '60000'),
    (12, 'Car', '6-month', '120000');

-- Insert the client-policy assignments.
INSERT INTO POLICY_LIST (CLIENT_clientID, POLICY_policyID) VALUES
    (2, 1),
    (9, 1),
    (13, 1),
    (2, 4),
    (5, 4),
    (8, 5),
    (14, 6),
    (11, 7),
    (1, 8),
    (3, 8),
    (7, 9),
    (1, 10),
    (3, 10),
    (7, 10),
    (10, 10),
    (6, 11),
    (4, 12);

-- 1. List all clients.
SELECT * FROM CLIENT ORDER BY clientID;

-- 2. Rename Chris Isaac to Chris Pearson.
UPDATE CLIENT SET client_name = 'Chris Pearson'
WHERE clientID = 5 AND client_name = 'Chris Isaac';

-- 3. List Home policies.
SELECT * FROM POLICY WHERE policyType = 'Home' ORDER BY policyID;

-- 4. List yearly policies.
SELECT * FROM POLICY WHERE policyTerm = 'yearly' ORDER BY policyID;

-- 5. List client names, addresses, and ages, oldest first.
SELECT client_name, client_address, client_age
FROM CLIENT ORDER BY client_age DESC, clientID;

-- 6. Calculate the average client age.
SELECT AVG(client_age) AS `Average Age` FROM CLIENT;

-- 7. List clients aged 22 through 40.
SELECT client_name, client_age FROM CLIENT
WHERE client_age BETWEEN 22 AND 40 ORDER BY clientID;

-- 8. List Home policies with a limit of $250,000 or less.
SELECT * FROM POLICY
WHERE policyType = 'Home' AND CAST(policyLimits AS UNSIGNED) <= 250000
ORDER BY policyID;

-- 9. List clients on Featherstone, youngest first.
SELECT client_name, client_address FROM CLIENT
WHERE client_address LIKE '%Featherstone%' ORDER BY client_age, clientID;

-- 10. List clients aged 35 or older whose address contains the digit 8.
SELECT client_name, client_address, client_age FROM CLIENT
WHERE client_age >= 35 AND client_address LIKE '%8%' ORDER BY clientID;

-- 11. Count the policies offered in the catalog.
SELECT COUNT(*) AS `Total Policies` FROM POLICY;

-- 12. Count the policies offered by type.
SELECT policyType, COUNT(*) AS `Total Policies` FROM POLICY
GROUP BY policyType ORDER BY policyType;

-- 13. Return the youngest and oldest client ages.
SELECT MIN(client_age) AS `Youngest Client`, MAX(client_age) AS `Oldest Client`
FROM CLIENT;

-- 14. List clients and their Home policy assignments.
SELECT c.*, pl.CLIENT_clientID, pl.POLICY_policyID
FROM CLIENT AS c
JOIN POLICY_LIST AS pl ON pl.CLIENT_clientID = c.clientID
JOIN POLICY AS p ON p.policyID = pl.POLICY_policyID
WHERE p.policyType = 'Home'
ORDER BY c.clientID, pl.POLICY_policyID;

-- 15. List policy assignments for client 2.
SELECT c.*, pl.CLIENT_clientID, pl.POLICY_policyID
FROM CLIENT AS c
JOIN POLICY_LIST AS pl ON pl.CLIENT_clientID = c.clientID
WHERE c.clientID = 2 ORDER BY pl.POLICY_policyID;

-- Extra credit. List clients with their assigned policies.
SELECT c.*, pl.CLIENT_clientID, pl.POLICY_policyID, p.*
FROM CLIENT AS c
JOIN POLICY_LIST AS pl ON pl.CLIENT_clientID = c.clientID
JOIN POLICY AS p ON p.policyID = pl.POLICY_policyID
ORDER BY c.clientID, p.policyID;