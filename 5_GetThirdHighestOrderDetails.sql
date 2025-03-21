
CREATE OR REPLACE PROCEDURE GetThirdHighestOrderDetails(p_result OUT SYS_REFCURSOR)
IS
BEGIN
   OPEN p_result FOR
   SELECT
      TO_NUMBER(REGEXP_REPLACE(Order_Ref, '[^0-9]', '')) AS Order_Reference,
      TO_CHAR(Order_Date, 'FMMonth DD, YYYY') AS Order_Date,
      UPPER(Supplier_Name) AS Supplier_Name,
      TO_CHAR(Order_Total_Amount, 'FM99,999,990.00') AS Order_Total_Amount,
      Order_Status,
      LISTAGG(Invoice_Reference, ', ') WITHIN GROUP (ORDER BY Invoice_Reference) AS Invoice_References
   FROM (
      SELECT
         o.Order_Ref,
         o.Order_Date,
         s.Supplier_Name,
         o.Order_Total_Amount,
         o.Order_Status,
         i.Invoice_Reference,
         DENSE_RANK() OVER (ORDER BY o.Order_Total_Amount DESC) AS rnk
      FROM Orders o
      JOIN Suppliers s ON o.Supplier_ID = s.Supplier_ID
      LEFT JOIN Invoices i ON o.Order_ID = i.Order_ID
   ) subquery
   WHERE rnk = 3
   GROUP BY
      Order_Ref, Order_Date, Supplier_Name, Order_Total_Amount, Order_Status;

END;
/



DECLARE
   v_result SYS_REFCURSOR;
   v_Order_Reference NUMBER;
   v_Order_Date VARCHAR2(20);
   v_Supplier_Name VARCHAR2(2000);
   v_Order_Total_Amount VARCHAR2(20);
   v_Order_Status VARCHAR2(2000);
   v_Invoice_References VARCHAR2(4000);
BEGIN
   GetThirdHighestOrderDetails(v_result);

   FETCH v_result INTO
      v_Order_Reference,
      v_Order_Date,
      v_Supplier_Name,
      v_Order_Total_Amount,
      v_Order_Status,
      v_Invoice_References;

   IF v_result%FOUND THEN
      -- Display the retrieved values
      DBMS_OUTPUT.PUT_LINE('Order Reference: ' || v_Order_Reference);
      DBMS_OUTPUT.PUT_LINE('Order Date: ' || v_Order_Date);
      DBMS_OUTPUT.PUT_LINE('Supplier Name: ' || v_Supplier_Name);
      DBMS_OUTPUT.PUT_LINE('Order Total Amount: ' || v_Order_Total_Amount);
      DBMS_OUTPUT.PUT_LINE('Order Status: ' || v_Order_Status);
      DBMS_OUTPUT.PUT_LINE('Invoice References: ' || v_Invoice_References);
   ELSE
      DBMS_OUTPUT.PUT_LINE('No record found for the third-highest Order Total Amount.');
   END IF;

   CLOSE v_result;
END;
/

