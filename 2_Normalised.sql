
-- Create Suppliers Table
CREATE TABLE Suppliers (
    Supplier_ID NUMBER PRIMARY KEY,
    Supplier_Name VARCHAR2(2000),
    Supplier_Contact_Name VARCHAR2(2000),
    Supplier_Address VARCHAR2(2000),
    Supplier_Contact_Number1 VARCHAR2(2000),
    Supplier_Contact_Number2 VARCHAR2(2000),
    Supplier_Email VARCHAR2(2000)
);

-- Create Orders Table
CREATE TABLE Orders (
    Order_ID NUMBER PRIMARY KEY,
    Order_Ref VARCHAR2(2000),
    Order_Date DATE,
    Supplier_ID NUMBER,
    Order_Total_Amount NUMBER,
    Order_Description VARCHAR2(2000),
    Order_Status VARCHAR2(2000),
    FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(Supplier_ID)
);

-- Create OrderLines Table
CREATE TABLE OrderLines (
    OrderLine_ID NUMBER PRIMARY KEY,
    Order_ID NUMBER,
    Order_Line_Amount NUMBER,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

-- Create Invoices Table
CREATE TABLE Invoices (
    Invoice_ID NUMBER PRIMARY KEY,
    Order_ID NUMBER,
    Invoice_Reference VARCHAR2(2000),
    Invoice_Date DATE,
    Invoice_Status VARCHAR2(2000),
    Invoice_Hold_Reason VARCHAR2(2000),
    Invoice_Amount NUMBER,
    Invoice_Description VARCHAR2(2000),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

-- Create Payments Table
CREATE TABLE Payments (
    Payment_ID NUMBER PRIMARY KEY,
    Invoice_ID NUMBER,
    Payment_Amount NUMBER,
    Payment_Date DATE,
    FOREIGN KEY (Invoice_ID) REFERENCES Invoices(Invoice_ID)
);