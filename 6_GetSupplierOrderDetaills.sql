CREATE OR REPLACE FUNCTION GetSupplierOrderDetails
RETURN SYS_REFCURSOR
IS
    result_cursor SYS_REFCURSOR;
BEGIN
    OPEN result_cursor FOR
    SELECT
        Supplier_Name,
        Supplier_Contact_Name,
        Supplier_Contact_Number1 AS Supplier_Contact_No_1,
        Supplier_Contact_Number2 AS Supplier_Contact_No_2,
        COUNT(DISTINCT Orders.Order_ID) AS Total_Orders,
        TO_CHAR(SUM(Order_Total_Amount), '999,999,990.00') AS Order_Total_Amount
    FROM Suppliers
    JOIN Orders ON Suppliers.Supplier_ID = Orders.Supplier_ID
    WHERE Orders.Order_Date BETWEEN TO_DATE('2017-01-01', 'YYYY-MM-DD') AND TO_DATE('2017-08-31', 'YYYY-MM-DD')
    GROUP BY
        Supplier_Name,
        Supplier_Contact_Name,
        Supplier_Contact_Number1,
        Supplier_Contact_Number2
    ORDER BY Supplier_Name;

    RETURN result_cursor;

END GetSupplierOrderDetails;
/