drop database if exists MYBD_practice;
create database MYBD_practice;
use MYBD_practice;

create table  Building(
ID_Building INT PRIMARY KEY AUTO_INCREMENT,
Address varchar(100) NOT NULL,
District varchar(100) NOT NULL,
Material varchar(100) NOT NULL,
Floor varchar(100) NOT NULL,
Picture Blob NOT NULL,
Owner varchar(100) NOT NULL,
Doorway INT NOT NULL,
Flats INT NOT NULL
);
CREATE TABLE Apartament (
ID_Apartament INT PRIMARY KEY AUTO_INCREMENT,
Flat INT NOT NULL,
Floor INT NOT NULL,
Flattype varchar(100) NOT NULL,
People INT NOT NULL,
Doorway INT NOT NULL,
Square INT NOT NULL
);
CREATE TABLE Client (
ID_Client INT PRIMARY KEY AUTO_INCREMENT,
Lastname varchar(100) NOT NULL,
Firstname varchar(100) NOT NULL,
Patronymic varchar(100) NOT NULL,
Passport INT NOT NULL
);
CREATE TABLE Profile (
ID_Profile INT PRIMARY KEY AUTO_INCREMENT,
Password varchar(100) NOT NULL,
Email varchar(100) NOT NULL,
ID_Client INT NOT NULL,
foreign key (ID_Client) references Client (ID_Client)
);
CREATE TABLE Counter (
ID_Counter INT PRIMARY KEY AUTO_INCREMENT,
WhenMade DATETIME NOT NULL,
MadeIn varchar(100) NOT NULL,
ID_Apartament INT NOT NULL,
Result INT NOT NULL 
);

CREATE TABLE Responsible (
ID_Responsible INT PRIMARY KEY AUTO_INCREMENT,
Lastname varchar(100) NOT NULL,
Firstname varchar(100) NOT NULL,
Patronymic varchar(100) NOT NULL
);

CREATE TABLE Checking (
ID_Checking INT PRIMARY KEY AUTO_INCREMENT,
DateView DATETIME NOT NULL,
Result Boolean NOT NULL,
ID_Responsible INT NOT NULL,
foreign key (ID_Responsible) references Responsible (ID_Responsible),
ID_Counter INT NOT NULL,
foreign key (ID_Counter) references Counter (ID_Counter)
);

CREATE TABLE Tafiff_sheet (
ID_Tafiff_sheet INT PRIMARY KEY AUTO_INCREMENT,
Price DECIMAL NOT NULL,
Tafiff_start_date Date
);

CREATE TABLE Pay (
ID_Pay INT PRIMARY KEY AUTO_INCREMENT,
date_pay DATE,
PayMonth DECIMAL NOT NULL,
Month INT,
Result_Counter INT,
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
INSERT INTO Building (ID_Building,address, district, Material, Floor, Picture, Owner, Doorway, Flats) VALUES
(1,'12 Main St', 'Downtown', 'Brick', '5', NULL, 'John Doe', 5, 125),
(2,'16 Park Average', 'Uptown', 'Concrete', '10', NULL, 'Jane Smith', 10, 500),
(3,'7 Elmost St', 'Midtown', 'Wood', '4', NULL, 'Bob Johnson', 4, 64);

INSERT INTO Apartament (ID_Apartament,Flat, Floor, Flattype, People,Doorway,Square) VALUES
(1, 17, 4, 'Penthouse', 10, 3, 50),
(2, 305, 9, 'Loft', 7, 5, 45),
(3, 26, 8, 'Studio', 4, 2, 30);

INSERT INTO Client (ID_Client, Lastname, Firstname, Patronymic, Passport) VALUES
(1,'Smith', 'John', 'James', 123456789),
(2,'Johnson', 'Alice', 'Marie', 987654321),
(3,'Doe', 'Bob', 'Robert', 456789123);

INSERT INTO Profile (ID_Profile,Password,Email,ID_Client) VALUES
(1, 11111,'Smith_John_James@mail.ru',1),
(2, 22222, 'Johnson_Alice_Marie@mail.ru',2),
(3, 33333,'Doe_Bob_Robert@mail.ru',3);

INSERT INTO Counter (ID_Counter,WhenMade, MadeIn, ID_Apartament, Result) VALUES
(1,'2022-04-29 12:00:00', 'China', 1, 450),
(2,'2022-05-01 15:30:00', 'USA', 2, 350),
(3,'2022-05-02 11:45:00', 'Germany', 3, 380);

INSERT INTO Responsible (ID_Responsible,Lastname, Firstname, Patronymic) VALUES
(1, 'Smith', 'John', 'James'),
(2, 'Johnson', 'Alice', 'Marie'),
(3, 'Brown', 'Mike', 'Thomas');

INSERT INTO Checking (ID_Checking, DateView, Result, ID_Responsible, ID_Counter) VALUES
(1,'2022-05-02 14:00:00', TRUE, 1, 1),
(2,'2022-05-03 16:30:00', TRUE, 2, 2),
(3,'2022-05-04 13:45:00', TRUE, 3, 3);

INSERT INTO Tafiff_sheet (ID_Tafiff_sheet, Price, Tafiff_start_date) VALUES
(1, 8, '2023-04-14'),
(2, 9, '2023-03-24'),
(3, 10, '2023-01-01');

INSERT INTO Pay (ID_Pay, date_pay, PayMonth, Month, Result_Counter, ID_Client, ID_Apartament, ID_Building, ID_Counter, ID_Tafiff_sheet) VALUES
(1,'2023-04-15', 3600, 4, 450, 1, 1, 1, 1, 1),
(2,'2023-03-28', 3150, 3, 350, 2, 2, 2, 2, 2),
(3,'2023-01-09', 3800, 1, 380, 3, 3, 3, 3, 3);

CREATE OR REPLACE VIEW Practice AS 
select Building.Address AS Address, Apartament.Flat AS Flat, Apartament.Floor AS Floor, Apartament.Doorway AS Doorway, Client.Passport AS Passport, Client.ID_Client AS ID_Client,  CONCAT(SUBSTRING(Client.Firstname,1,1),'. ',SUBSTRING(Client.Patronymic,1,1),'. ',Client.Lastname) AS Initial, Pay.PayMonth AS PayMonth
From Client Inner join Profile ON Client.ID_Client = Profile.ID_Client
Inner join Pay on Client.ID_Client = Pay.ID_Client
Inner join Apartament on Apartament.ID_Apartament = Pay.ID_Apartament
Inner join Building on Building.ID_Building = Pay.ID_Building
Where Client.ID_Client;
Select * from Practice;
drop VIEW Practice;