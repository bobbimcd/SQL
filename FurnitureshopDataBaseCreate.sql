

CREATE DATABASE FURNSHOP;

---------------------------------------------------------
-- Part 2 Turn FURNSHOP Database ON

USE FURNSHOP;


CREATE TABLE Customer
	(CustomerID         INT          NOT NULL,
	 CustomerName       VARCHAR(25)    ,
	 CustomerAddress    VARCHAR(30)    ,
         CustomerCity       VARCHAR(20)    ,              
         CustomerState      CHAR(2)        ,
         CustomerPostalCode VARCHAR(10)    ,
CONSTRAINT Customer_PK PRIMARY KEY (CustomerID));



CREATE TABLE Territory
	(TerritoryID        INT    NOT NULL,
         TerritoryName      VARCHAR(50)    ,
CONSTRAINT Territory_PK PRIMARY KEY (TerritoryID));



CREATE TABLE DoesBusinessIn
	(CustomerID         INT           NOT NULL,
         TerritoryID       INT           NOT NULL,
CONSTRAINT DoesBusinessIn_PK PRIMARY KEY (CustomerID, TerritoryID),
CONSTRAINT DoesBusinessIn_FK1 FOREIGN KEY (CustomerID) 
	REFERENCES Customer(CustomerID),
CONSTRAINT DoesBusinessIn_FK2 FOREIGN KEY (TerritoryID) 
	REFERENCES Territory(TerritoryID));


CREATE TABLE Salesperson
	(SalespersonID        INT          NOT NULL,              
   SalespersonName       VARCHAR(25)    , /* Fixed */
   SalespersonTelephone VARCHAR(50)    ,
   SalespersonFax       VARCHAR(50)    ,
	 SalespersonAddress   VARCHAR(30)    ,
	 SalespersonCity      VARCHAR(20)    ,
	 SalespersonState     CHAR(2)        ,
	 SalespersonZip       VARCHAR(20)    ,
         SalesTerritoryID     INT      ,
CONSTRAINT Salesperson_PK PRIMARY KEY (SalespersonID),
CONSTRAINT Salesperson_FK1 FOREIGN KEY (SalesTerritoryID) /*Fixed*/
	REFERENCES Territory(TerritoryID));


CREATE TABLE Skill
	(SkillID            VARCHAR(12)    NOT NULL,
	 SkillDescription   VARCHAR(30)    ,              
CONSTRAINT Skill_PK PRIMARY KEY (SkillID));



CREATE TABLE Employee
	(EmployeeID         VARCHAR(10)    NOT NULL,
         EmployeeName       VARCHAR(25)    ,
         EmployeeAddress    VARCHAR(30)    ,
         EmployeeCity       VARCHAR(20)    ,
	 EmployeeState      CHAR(2)        ,
         EmployeeZip        VARCHAR(10)    ,
	 EmployeeBirthDate  DATE           ,
         EmployeeDateHired  DATE           ,
	 EmployeeSupervisor VARCHAR(10)    ,
CONSTRAINT Employee_PK PRIMARY KEY (EmployeeID));



CREATE TABLE EmployeeSkills
	(EmployeeID         VARCHAR(10)    NOT NULL,
         SkillID            VARCHAR(12)    NOT NULL,
	 QualifyDate 	    DATE	           ,
CONSTRAINT EmployeeSkills_PK PRIMARY KEY (EmployeeID, SkillID),
CONSTRAINT EmployeeSkills_FK1 FOREIGN KEY (EmployeeID) 
	REFERENCES Employee(EmployeeID),
CONSTRAINT EmployeeSkills_FK2 FOREIGN KEY (SkillID) 
	REFERENCES Skill(SkillID));


CREATE TABLE WorkCenter
	(WorkCenterID       VARCHAR(12)    NOT NULL,
	 WorkCenterLocation  VARCHAR(30)           ,
CONSTRAINT WorkCenter_PK PRIMARY KEY (WorkCenterID));


CREATE TABLE WorksIn
	(EmployeeID          VARCHAR(10)    NOT NULL,
         WorkCenterID        VARCHAR(12)    NOT NULL,
CONSTRAINT WorksIn_PK PRIMARY KEY (EmployeeID, WorkCenterID),
CONSTRAINT WorksIn_FK1 FOREIGN KEY (EmployeeID) 
	REFERENCES Employee(EmployeeID),
CONSTRAINT WorksIn_FK2 FOREIGN KEY (WorkCenterID) 
	REFERENCES WorkCenter(WorkCenterID));


CREATE TABLE ProductLine
	(ProductLineID     INT         NOT NULL,
	ProductLineName    VARCHAR(50)               ,
CONSTRAINT ProductLine_PK PRIMARY KEY (ProductLineID));


CREATE TABLE Product
	(ProductID            INT  NOT NULL,
         ProductLineID       INT ,
         ProductDescription   VARCHAR(50)    ,
         ProductFinish        VARCHAR(20)    ,
         ProductStandardPrice DECIMAL(6,2)    ,
	 ProductOnHand	      INT      ,
CONSTRAINT Product_PK PRIMARY KEY (ProductID),
CONSTRAINT Product_FK1 FOREIGN KEY (ProductLineID) 
	REFERENCES ProductLine(ProductLineID));


CREATE TABLE ProducedIn
	(ProductID	  INT	 NOT NULL,
         WorkCenterID     VARCHAR(12)    NOT NULL,
CONSTRAINT ProducedInPK PRIMARY KEY (ProductID, WorkCenterID),
CONSTRAINT ProducedInFK1 FOREIGN KEY (ProductID) 
	REFERENCES Product(ProductID),
CONSTRAINT ProducedInFK2 FOREIGN KEY (WorkCenterID) 
	REFERENCES WorkCenter(WorkCenterID));

CREATE TABLE CustomerShipAddress
	(ShipAddressID	INT	NOT NULL,
	 CustomerID	INT	NOT NULL,
	 TerritoryID	INT	NOT NULL,
	 ShipAddress	VARCHAR(30)	,
	 ShipCity	VARCHAR(20)	,
	 ShipState	CHAR(2)     	,
	 ShipZip	VARCHAR(10)	,
	 ShipDirections	VARCHAR(100)	,
CONSTRAINT CSA_PK PRIMARY KEY (ShipAddressID),
CONSTRAINT CSA_FK1 FOREIGN KEY (CustomerID)
	REFERENCES Customer(CustomerID),
CONSTRAINT CSA_FK2 FOREIGN KEY (TerritoryID)
	REFERENCES Territory(TerritoryID));


CREATE TABLE Orders
	(OrderID            INT        NOT NULL,
	 CustomerID         INT   ,
   OrderDate          DATE        ,
	 FulfillmentDate    DATE	,
	 SalespersonID	    INT	,
	 ShipAdrsID	    INT	,
CONSTRAINT Order_PK PRIMARY KEY (OrderID),
CONSTRAINT Order_FK1 FOREIGN KEY (CustomerID) 
	REFERENCES Customer(CustomerID),
CONSTRAINT Order_FK2 FOREIGN KEY (SalespersonID)
	REFERENCES Salesperson(SalespersonID),
CONSTRAINT Order_FK3 FOREIGN KEY (ShipAdrsID)
	REFERENCES CustomerShipAddress(ShipAddressID));


CREATE TABLE OrderLine
	(OrderLineID	    INT	     NOT NULL,
	 OrderID            INT        NOT NULL,
         ProductID         INT        NOT NULL,
         OrderedQuantity    INT         ,
CONSTRAINT OrderLine_PK PRIMARY KEY (OrderLineID),
CONSTRAINT OrderLine_FK1 FOREIGN KEY (OrderID) 
	REFERENCES Orders(OrderID),
CONSTRAINT OrderLine_FK2 FOREIGN KEY (ProductID) 
	REFERENCES Product(ProductID));

CREATE TABLE PaymentType
  (PaymentTypeID  VARCHAR(50)    NOT NULL,
  TypeDescription VARCHAR(50)   NOT NULL,
  CONSTRAINT PaymentType_PK  PRIMARY KEY (PaymentTypeID));
  
CREATE TABLE Payment
  (PaymentID      INT    NOT NULL,
   OrderID        INT    NOT NULL,
   PaymentTypeID  VARCHAR(50)  NOT NULL,
   PaymentDate    DATE                 ,
   PaymentAmount  DECIMAL(6,2)          ,
   PaymentComment VARCHAR(255)         , 
  CONSTRAINT  Payment_PK  PRIMARY KEY (PaymentID),
  CONSTRAINT  Payment_FK1 FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID),
  CONSTRAINT  Payment_FK2 FOREIGN KEY (PaymentTypeID)
    REFERENCES PaymentType(PaymentTypeID));
    
CREATE TABLE Shipped
  (OrderLineId  INT NOT NULL,
   ShippedQuantity     INT NOT NULL,
   ShippedDate         DATE,
  CONSTRAINT Shipped_PK PRIMARY KEY (OrderLineId),
  CONSTRAINT Shipped_FK1  FOREIGN KEY (OrderLineId)
    REFERENCES OrderLine(OrderLineID));


CREATE TABLE Vendor
	(VendorID           INT         NOT NULL,
         VendorName         VARCHAR(25)    ,
         VendorAddress      VARCHAR(30)    ,
         VendorCity         VARCHAR(20)    ,
         VendorState        CHAR(2)        ,
	 VendorZipcode      VARCHAR(50)    ,
	 VendorPhone        VARCHAR(12)    ,
	 VendorFax          VARCHAR(12)    ,              
	 VendorContact      VARCHAR(50)    ,
         VendorTaxIdNumber  VARCHAR(50)    ,
CONSTRAINT Vendor_PK PRIMARY KEY (VendorID));




CREATE TABLE RawMaterial
	(MaterialID             VARCHAR(12)    NOT NULL,
         MaterialName           VARCHAR(30) ,
	 Thickness		VARCHAR(50) ,
	 Width			VARCHAR(50) ,
	 MatSize			VARCHAR(50) ,  /*Fixed*/
	 Material		VARCHAR(15) ,
         MaterialStandardPrice  DECIMAL(6,2) ,
         UnitOfMeasure          VARCHAR(15) ,
	 MaterialType		VARCHAR(50),
CONSTRAINT RawMaterial_PK PRIMARY KEY (MaterialID)); /*Fixed*/


CREATE TABLE Uses
        (MaterialID         VARCHAR(12)    NOT NULL,
         ProductID          INT      NOT NULL,
         QuantityRequired   INT              ,
CONSTRAINT Uses_PK PRIMARY KEY (ProductID, MaterialID),  /*Fixed*/
CONSTRAINT Uses_FK1 FOREIGN KEY (ProductID) 
	REFERENCES Product(ProductID),
CONSTRAINT Uses_FK2 FOREIGN KEY (MaterialID) 
	REFERENCES RawMaterial(MaterialID));


CREATE TABLE Supplies
	(VendorID           INT         NOT NULL,
         MaterialID     VARCHAR(12)       NOT NULL,
         SupplyUnitPrice    DECIMAL(6,2)   ,              
CONSTRAINT Supplies_PK PRIMARY KEY (VendorID, MaterialID),
CONSTRAINT Supplies_FK1 FOREIGN KEY (MaterialID) 
	REFERENCES RawMaterial(MaterialID),
CONSTRAINT Supplies_FK2 FOREIGN KEY (VendorID) 
	REFERENCES Vendor(VendorID));

