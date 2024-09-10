drop database if exists MY_BD_Practice;
create database MY_BD_Practice;
use MY_BD_Practice;

create table  Building(
ID_Building INT PRIMARY KEY auto_increment,
Address varchar(100) NOT NULL,
District varchar(100) NOT NULL,
Material varchar(100) NOT NULL,
Floors int NOT NULL,
Picture Blob,
Owner varchar(100) NOT NULL,
Doorway INT NOT NULL,
Flats INT NOT NULL
);
CREATE TABLE Apartament (
ID_Apartament INT PRIMARY KEY auto_increment,
Flat INT NOT NULL,
Floor INT NOT NULL,
Flattype varchar(100) NOT NULL,
People INT NOT NULL,
Doorway INT NOT NULL,
Square INT NOT NULL
);
CREATE TABLE Client (
ID_Client INT PRIMARY KEY auto_increment,
FIO varchar(100) NOT NULL,
Passport INT NOT NULL,
-- Лицевой счет
Personal_account INT NOT NULL
);
-- CREATE TABLE Map (
-- ID_Map INT PRIMARY KEY auto_increment,
-- cardNumber INT NOT NULL,
-- cardName varchar(50) NOT NULL,
-- Month int NOT NULL,
-- Year int NOT NULL,
-- CVV int,
-- ID_Client INT NOT NULL,
-- foreign key (ID_Client) references Client (ID_Client)
-- );
CREATE TABLE Profile (
ID_Profile INT PRIMARY KEY auto_increment,
Email varchar(100) NOT NULL unique,
Password varchar(100) NOT NULL,
ID_Client INT NOT NULL,
foreign key (ID_Client) references Client (ID_Client) ON DELETE CASCADE
);
CREATE TABLE Counter (
ID_Counter INT PRIMARY KEY auto_increment,
WhenMade DATE NOT NULL,
MadeIn varchar(100) NOT NULL,
Result_Counter INT NOT NULL 
);

CREATE TABLE Responsible (
ID_Responsible INT PRIMARY KEY auto_increment,
FIO varchar(100) NOT NULL
);

CREATE TABLE Checking (
ID_Checking INT PRIMARY KEY auto_increment,
DateView DATE NOT NULL,
Result Boolean NOT NULL,
ID_Responsible INT NOT NULL,
foreign key (ID_Responsible) references Responsible (ID_Responsible),
ID_Counter INT NOT NULL,
foreign key (ID_Counter) references Counter (ID_Counter)
);

CREATE TABLE Tafiff_sheet (
ID_Tafiff_sheet INT PRIMARY KEY auto_increment,
Price DECIMAL NOT NULL,
Tafiff_start_date Date
);

CREATE TABLE Pay (
ID_Pay INT PRIMARY KEY auto_increment,
date_pay DATE,
PayMonth INT NOT NULL,
Month INT,
Payment varchar(11),
ID_Client INT NOT NULL,
foreign key (ID_Client) references Client (ID_Client),
ID_Apartament INT NOT NULL, 
foreign key (ID_Apartament) references Apartament (ID_Apartament),
ID_Building INT NOT NULL,
foreign key (ID_Building) references Building (ID_Building),
ID_Counter INT NOT NULL,
foreign key (ID_Counter) references Counter (ID_Counter),
ID_Tafiff_sheet INT NOT NULL,
foreign key (ID_Tafiff_sheet) references Tafiff_sheet (ID_Tafiff_sheet)
);
INSERT INTO Building (ID_Building,address, district, Material, Floors, Picture, Owner, Doorway, Flats) VALUES
(1,'12 Main St', 'Downtown', 'Brick', 5, NULL, 'John Doe', 5, 125),
(2,'16 Park Average', 'Uptown', 'Concrete', 10, NULL, 'Jane Smith', 10, 500),
(3,'7 Elmost St', 'Midtown', 'Wood', 4, NULL, 'Bob Johnson', 4, 64);

INSERT INTO Apartament (ID_Apartament,Flat, Floor, Flattype, People,Doorway,Square) VALUES
(1, 17, 4, 'Penthouse', 10, 3, 50),
(2, 305, 9, 'Loft', 7, 5, 45),
(3, 26, 8, 'Studio', 4, 2, 30);

INSERT INTO Client (ID_Client, FIO, Passport,Personal_account) VALUES
(1,'Smith John James', 123456789, 1111111),
(2,'Johnson Alice Marie', 987654321,2222222),
(3,'Doe Bob Robert', 456789123,3333333);

-- INSERT INTO Map( ID_Map, cardNumber, cardName, Month, Year, CVV, ID_Client) VALUES
-- (1,'Smith John James', 123456789, 1111111),
-- (2,'Johnson Alice Marie', 987654321,2222222),
-- (3,'Doe Bob Robert', 456789123,3333333);

INSERT INTO Profile (ID_Profile,Email,Password,ID_Client) VALUES
(1, 'Smith_John_James@mail.ru', 11111, 1),
(2, 'Johnson_Alice_Marie@mail.ru', 22222, 2),
(3, 'Doe_Bob_Robert@mail.ru', 33333, 3);

INSERT INTO Counter (ID_Counter,WhenMade, MadeIn, Result_Counter) VALUES
(1,'2022-04-29', 'China', 450),
(2,'2022-05-01', 'USA', 350),
(3,'2022-05-02', 'Germany', 380);

INSERT INTO Responsible (ID_Responsible,FIO) VALUES
(1, 'Smith John James'),
(2, 'Johnson Alice Marie'),
(3, 'Brown Mike Thomas');

INSERT INTO Checking (ID_Checking, DateView, Result, ID_Responsible, ID_Counter) VALUES
(1,'2022-05-02', TRUE, 1, 1),
(2,'2022-05-03', TRUE, 2, 2),
(3,'2022-05-04', TRUE, 3, 3);

INSERT INTO Tafiff_sheet (ID_Tafiff_sheet, Price, Tafiff_start_date) VALUES
(1, 8, '2023-04-14'),
(2, 9, '2023-03-24'),
(3, 10, '2023-01-01');

INSERT INTO Pay (ID_Pay, date_pay, PayMonth, Month, Payment, ID_Client, ID_Apartament, ID_Building, ID_Counter, ID_Tafiff_sheet) VALUES
(1,'2023-04-15', 0, 1,'Оплачено', 1, 1, 1, 1, 1),
(2,'2023-03-28', 0, 1, 'Оплачено', 2, 2, 2, 2, 2),
(3,'2023-01-09', 0,  1, 'Оплачено', 3, 3, 3, 3, 3);
DELIMITER $$
CREATE TRIGGER Trigger1
BEFORE INSERT ON Profile
FOR EACH ROW 
BEGIN 
    IF (Profile.Email = new.Email) AND 
    (SELECT COUNT(*) FROM Profile WHERE Profile.Email = new.Email) >= 2 THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Такой Email уже зарегистрирован!';
    END IF; 
END $$
DELIMITER ;
INSERT INTO Profile (ID_Profile,Email,Password,ID_Client) VALUES
(5, 'Smith_John_James@mail.ru', 12432431, 5);
Drop trigger Trigger1;










delimiter $$
CREATE PROCEDURE InsertProfileWithEmailCheck
(
    IN email_param VARCHAR(100),
    IN password_param VARCHAR(100),
    IN id_client_param INT
)
BEGIN
    DECLARE email_count INT;
    SET email_count = (SELECT COUNT(*) FROM Profile WHERE Email = email_param);
    IF email_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    ELSE
        INSERT INTO Profile (Email, Password, ID_Client) VALUES (email_param, password_param, id_client_param);
    END IF;
END$
delimiter ;











CREATE OR REPLACE VIEW Practice AS 
select Building.Address AS Address, Client.FIO AS FIO, Apartament.Floor AS Floor, Apartament.Flat AS Flat,  Apartament.Doorway AS Doorway, Client.Personal_account AS Personal_account, Client.Passport AS Passport, Pay.Month AS Month, Pay.PayMonth AS PayMonth
From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client
Inner join Pay on Client.ID_Client = Pay.ID_Client
Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament
Inner join Building on Building.ID_Building = Pay.ID_Building
Where Client.ID_Client;
Select * from Practice;
drop VIEW Practice;

Select Profile.Email, Profile.Password, Client.FIO,Client.Passport, Building.Address, Apartament.Doorway,  Apartament.Floor, Apartament.Flat
From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client
Inner join Pay on Client.ID_Client = Pay.ID_Client
Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament
Inner join Building on Building.ID_Building = Pay.ID_Building
Where Client.ID_Client;


SELECT Building.Address AS Address, Client.FIO AS FIO, Apartament.Floor AS Floor, Apartament.Flat AS Flat,  Apartament.Doorway AS Doorway, Client.Personal_account AS Personal_account, Client.Passport AS Passport, Pay.Month AS Month, Pay.PayMonth AS PayMonth, Tafiff_sheet.Price AS Price
From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client Inner join Pay on Client.ID_Client = Pay.ID_Client Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament Inner join Building on Building.ID_Building = Pay.ID_Building Inner join Tafiff_sheet on Tafiff_sheet.ID_Tafiff_sheet = Pay.ID_Tafiff_sheet;


Select max(ID_Profile)+1 as ID_Profile from Profile;
Select ID_Profile as ID_Profile from Profile;
SELECT max(ID_Client)+1 as ID_Client from Client;
SELECT FIO FROM Client Where ID_Client = MAX(ID_Client) LIMIT 1;
SELECT FIO FROM Client WHERE ID_Client = (SELECT MAX(ID_Client) FROM Client);

UPDATE Client 
SET Personal_account = null 
Set Passport = null 
WHERE ID_Client = (SELECT MAX(ID_Client) FROM Client)
LIMIT 1; 
Select * from Client;

SELECT Price from Tafiff_sheet where Tafiff_start_date = (SELECT MAX(Tafiff_start_date) FROM Tafiff_sheet);
Select * from Client;
SELECT ID_Client FROM Client where ID_Client = (SELECT MAX(ID_Client) FROM Client);

SELECT Building.Address AS Address, Client.FIO AS FIO, Apartament.Floor AS Floor, Apartament.Flat AS Flat,  Apartament.Doorway AS Doorway, Client.Personal_account AS Personal_account, Client.Passport AS Passport, Pay.Month AS Month, Counter.Result_Counter As Result_Counter, Pay.PayMonth AS PayMonth, Tafiff_sheet.Price AS Price 
From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client 
Inner join Pay on Client.ID_Client = Pay.ID_Client 
Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament 
Inner join Building on Building.ID_Building = Pay.ID_Building 
Inner join Tafiff_sheet on Tafiff_sheet.ID_Tafiff_sheet = Pay.ID_Tafiff_sheet
Inner Join Counter on Counter.ID_Counter = Pay.ID_Counter;

SELECT Building.Address AS Address, Client.FIO AS FIO, Apartament.Floor AS Floor, Apartament.Flat AS Flat,  Apartament.Doorway AS Doorway, Client.Personal_account AS Personal_account, Client.Passport AS Passport, Pay.Month AS Month, Counter.Result_Counter As Result_Counter, Pay.PayMonth AS PayMonth, Tafiff_sheet.Price AS Price 
From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client 
Inner join Pay on Client.ID_Client = Pay.ID_Client 
Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament 
Inner join Building on Building.ID_Building = Pay.ID_Building  
Inner join Tafiff_sheet on Tafiff_sheet.ID_Tafiff_sheet = Pay.ID_Tafiff_sheet 
Inner Join Counter on Counter.ID_Counter = Pay.ID_Counter 
Where Client.ID_Client = (SELECT ID_Client FROM Client where ID_Client = (SELECT MAX(ID_Client) FROM Client));

SELECT Building.Address AS Address, Client.FIO AS FIO_C, Apartament.Floor AS Floor, Apartament.Flat AS Flat,  Apartament.Doorway AS Doorway, Client.Personal_account AS Personal_account, Client.Passport AS Passport, Counter.WhenMade AS WhenMade, Responsible.FIO AS FIO_R, Checking.DateView AS DateView
      From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client 
      Inner join Pay on Client.ID_Client = Pay.ID_Client 
      Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament 
      Inner join Building on Building.ID_Building = Pay.ID_Building  
      Inner join Tafiff_sheet on Tafiff_sheet.ID_Tafiff_sheet = Pay.ID_Tafiff_sheet 
      Inner join Counter on Counter.ID_Counter = Pay.ID_Counter 
      Inner join Checking on Checking.ID_Counter = Counter.ID_Counter
      Inner join Responsible on Checking.ID_Responsible = Responsible.ID_Responsible;
      
      
SELECT Apartament.Square AS Square, Building.Address AS Address, Client.FIO AS FIO_C, Apartament.Floor AS Floor, Apartament.Flat AS Flat,  Apartament.Doorway AS Doorway, Client.Personal_account AS Personal_account, Client.Passport AS Passport, Counter.WhenMade AS WhenMade, Responsible.FIO AS FIO_R, Checking.DateView AS DateView
      From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client 
      Inner join Pay on Client.ID_Client = Pay.ID_Client 
      Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament 
      Inner join Building on Building.ID_Building = Pay.ID_Building  
      Inner join Tafiff_sheet on Tafiff_sheet.ID_Tafiff_sheet = Pay.ID_Tafiff_sheet 
      Inner join Counter on Counter.ID_Counter = Pay.ID_Counter 
      Inner join Checking on Checking.ID_Counter = Counter.ID_Counter
      Inner join Responsible on Checking.ID_Responsible = Responsible.ID_Responsible
      Where Email = '';
      
      
      SELECT Counter.ID_Counter As ID_Counter
From Counter Inner join Pay on Counter.ID_Counter = Pay.ID_Counter
Inner Join Client on  Client.ID_Client = Pay.ID_Client  
Where Client.ID_Client = 1 ;

SELECT Pay.ID_Pay AS ID_Pay
From Pay Inner join Client on Pay.ID_Client  = Client.ID_Client 
Where Client.ID_Client = 1;