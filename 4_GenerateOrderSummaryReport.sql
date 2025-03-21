
CREATE OR REPLACE PROCEDURE GetOrderSummaryReport(p_result OUT SYS_REFCURSOR)
IS
   v_action VARCHAR2(50);
BEGIN
   OPEN p_result FOR
   SELECT
      TO_NUMBER(REGEXP_REPLACE(o.Order_Ref, '[^0-9]', '')) AS Order_Reference,
      TO_CHAR(o.Order_Date, 'MON-YY') AS Order_Period,
      INITCAP(s.Supplier_Name) AS Supplier_Name,
      TO_CHAR(o.Order_Total_Amount, 'FM99,999,990.00') AS Order_Total_Amount,
      o.Order_Status,
      i.Invoice_Reference,
      TO_CHAR(i.Invoice_Amount, 'FM99,999,990.00') AS Invoice_Total_Amount,
      CASE
         WHEN COUNT(i.Invoice_ID) = 0 THEN 'To verify'
         WHEN COUNT(i.Invoice_ID) = COUNT(CASE WHEN i.Invoice_Status = 'Paid' THEN 1 END) THEN 'OK'
         WHEN COUNT(i.Invoice_ID) > COUNT(CASE WHEN i.Invoice_Status = 'Pending' THEN 1 END) THEN 'To follow up'
         ELSE 'To verify'
      END AS Action
   FROM
      Orders o
      LEFT JOIN Suppliers s ON o.Supplier_ID = s.Supplier_ID
      LEFT JOIN Invoices i ON o.Order_ID = i.Order_ID
   GROUP BY
      o.Order_ID, o.Order_Ref, o.Order_Date, s.Supplier_Name, o.Order_Total_Amount, o.Order_Status,
      i.Invoice_Reference, i.Invoice_Amount
   ORDER BY
      o.Order_Date DESC, i.Invoice_Reference;

END;
/



-- Fetching of results
DECLARE
   v_result SYS_REFCURSOR;
   v_Order_Reference NUMBER;
   v_Order_Period VARCHAR2(7);
   v_Supplier_Name VARCHAR2(2000);
   v_Order_Total_Amount VARCHAR2(20);
   v_Order_Status VARCHAR2(2000);
   v_Invoice_Reference VARCHAR2(2000);
   v_Invoice_Total_Amount VARCHAR2(20);
   v_Action VARCHAR2(50);
BEGIN
   GetOrderSummaryReport(v_result);

   -- Fetch and display the results
   LOOP
      FETCH v_result INTO
         v_Order_Reference,
         v_Order_Period,
         v_Supplier_Name,
         v_Order_Total_Amount,
         v_Order_Status,
         v_Invoice_Reference,
         v_Invoice_Total_Amount,
         v_Action;

      EXIT WHEN v_result%NOTFOUND;

      -- Display the retrieved values
      DBMS_OUTPUT.PUT_LINE('Order Reference: ' || v_Order_Reference);
      DBMS_OUTPUT.PUT_LINE('Order Period: ' || v_Order_Period);
      DBMS_OUTPUT.PUT_LINE('Supplier Name: ' || v_Supplier_Name);
      DBMS_OUTPUT.PUT_LINE('Order Total Amount: ' || v_Order_Total_Amount);
      DBMS_OUTPUT.PUT_LINE('Order Status: ' || v_Order_Status);
      DBMS_OUTPUT.PUT_LINE('Invoice Reference: ' || v_Invoice_Reference);
      DBMS_OUTPUT.PUT_LINE('Invoice Total Amount: ' || v_Invoice_Total_Amount);
      DBMS_OUTPUT.PUT_LINE('Action: ' || v_Action);
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
   END LOOP;

   CLOSE v_result;
END;
/
