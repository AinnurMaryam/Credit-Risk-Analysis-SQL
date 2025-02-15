# Credit Risk Data Analysis (MySQL on AWS) 🏦  

This project explores credit risk factors using SQL queries in MySQL, analyzing historical loan data to assess borrower behavior and loan performance.  

## 📌 Features  
✔️ SQL-based data analysis  
✔️ Queries for loan performance, borrower risk assessment, and default probability  
✔️ MySQL database hosted on AWS (provided as part of a training program)  

## 🛠️ Technologies Used  
- MySQL  
- DBeaver  
- AWS RDS  

## 📊 Key Analysis & Queries  
Here are some key queries from the project:  

1. **Loan Duration Estimation**  
   ```sql
   SELECT 
       SK_ID_CURR,
       AMT_CREDIT,
       AMT_ANNUITY,
       ROUND(AMT_CREDIT / AMT_ANNUITY) AS LOAN_DURATION_MONTHS
   FROM application;

2. **Income Group and Credit Amount Relationship**
   ```sql
   SELECT
     CASE
       WHEN AMT_INCOME_TOTAL <= 200000 THEN 'Low Income'
       WHEN AMT_INCOME_TOTAL > 200000 AND AMT_INCOME_TOTAL <= 500000 THEN 'Medium Income'
       ELSE 'High Income'
     END AS Income_Group,
     ROUND(AVG(AMT_CREDIT),2) AS AVG_Credit_Amount
   FROM application
   WHERE AMT_CREDIT IS NOT NULL
     AND AMT_INCOME_TOTAL IS NOT NULL
   GROUP BY Income_Group
   ORDER BY
     CASE
        WHEN Income_Group = 'Low Income' THEN 1
        WHEN Income_Group = 'Medium Income' THEN 2
        WHEN Income_Group = 'High Income' THEN 3
     END;

3. **Payment Difficulties and Loan Count**
   ```sql
   SELECT 
    CASE 
        WHEN Loan_Count = 0 THEN 'No Loans'            
        WHEN Loan_Count BETWEEN 1 AND 2 THEN '1-2 Loans' 
        WHEN Loan_Count BETWEEN 3 AND 5 THEN '3-5 Loans' 
        ELSE 'More than 5 Loans'                          
    END AS Loan_Count_Category,
    AVG(a.TARGET) AS Average_Payment_Difficulties
   FROM (
    SELECT 
        b.SK_ID_CURR, 
        COUNT(b.SK_ID_BUREAU) AS Loan_Count  
    FROM bureau b  
    GROUP BY b.SK_ID_CURR
   ) AS Loan_Counts
   JOIN application a ON Loan_Counts.SK_ID_CURR = a.SK_ID_CURR
   GROUP BY Loan_Count_Category
   ORDER BY 
    CASE
        WHEN Loan_Count_Category = 'No Loans' THEN 1
        WHEN Loan_Count_Category = '1-2 Loans' THEN 2
        WHEN Loan_Count_Category = '3-5 Loans' THEN 3
        ELSE 4
    END;

For full analysis and results, see Credit_Risk_Analysis_Report.pdf

## 🚀 How to Run
If you want to run the queries in your own environment:
1. Set up MySQL on your local machine
2. Import any available credit risk dataset into your database
3. Run the queries from credit_risk_analysis.sql using DBeaver or MySQL Workbench

## 📂 Files Included
- credit_risk_analysis.sql → SQL queries for analysis
- Credit_Risk_Analysis_Report.pdf → Report with findings and insights

## 📢 About This Project
This project was part of a training program focused on SQL-based credit risk analysis. The database was provided by the training organization, and access may be restricted.
