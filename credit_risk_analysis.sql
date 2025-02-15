-- Deducing the loan duration
SELECT 
    SK_ID_CURR,
    AMT_CREDIT,
    AMT_ANNUITY,
    ROUND(AMT_CREDIT / AMT_ANNUITY) AS LOAN_DURATION_MONTHS
FROM application;

-- Relationship between Gender and Credit Score
SELECT 
    CASE 
        WHEN CODE_GENDER = 'M' THEN 'Male'
        WHEN CODE_GENDER = 'F' THEN 'Female'
        ELSE 'Unknown'  
    END AS Gender,
    AVG(EXT_SOURCE_1) AS AVG_EXT_SOURCE_1,
    AVG(EXT_SOURCE_2) AS AVG_EXT_SOURCE_2,
    AVG(EXT_SOURCE_3) AS AVG_EXT_SOURCE_3
FROM application
WHERE EXT_SOURCE_1 IS NOT NULL AND EXT_SOURCE_2 IS NOT NULL AND EXT_SOURCE_3 IS NOT NULL
GROUP BY Gender;

-- Relationship between Income and Credit Score
SELECT 
    CASE 
        WHEN AMT_INCOME_TOTAL < 200000 THEN 'Low Income'
        WHEN AMT_INCOME_TOTAL BETWEEN 200000 AND 500000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS Income_Bracket,
    AVG(IFNULL(EXT_SOURCE_1, 0)) AS AVG_EXT_SOURCE_1,
    AVG(IFNULL(EXT_SOURCE_2, 0)) AS AVG_EXT_SOURCE_2,
    AVG(IFNULL(EXT_SOURCE_3, 0)) AS AVG_EXT_SOURCE_3
FROM application
WHERE EXT_SOURCE_1 IS NOT NULL AND EXT_SOURCE_2 IS NOT NULL AND EXT_SOURCE_3 IS NOT NULL
GROUP BY Income_Bracket
ORDER BY
    CASE 
        WHEN Income_Bracket = 'Low Income' THEN 1
        WHEN Income_Bracket = 'Medium Income' THEN 2
        WHEN Income_Bracket = 'High Income' THEN 3
    END;

-- Relationship between Education Levels and Credit Score
SELECT 
    NAME_EDUCATION_TYPE,
    AVG(IFNULL(EXT_SOURCE_1, 0)) AS AVG_EXT_SOURCE_1,
    AVG(IFNULL(EXT_SOURCE_2, 0)) AS AVG_EXT_SOURCE_2,
    AVG(IFNULL(EXT_SOURCE_3, 0)) AS AVG_EXT_SOURCE_3
FROM application
WHERE EXT_SOURCE_1 IS NOT NULL AND EXT_SOURCE_2 IS NOT NULL AND EXT_SOURCE_3 IS NOT NULL
GROUP BY NAME_EDUCATION_TYPE
ORDER BY 
	CASE 
		WHEN NAME_EDUCATION_TYPE = 'Lower secondary' THEN 1
		WHEN NAME_EDUCATION_TYPE = 'Secondary / secondary special' THEN 2
		WHEN NAME_EDUCATION_TYPE = 'Incomplete higher' THEN 3
		WHEN NAME_EDUCATION_TYPE = 'Higher education' THEN 4
		WHEN NAME_EDUCATION_TYPE = 'Academic degree' THEN 5
	END;

-- Relationship between Income Group and Credit Amount
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

-- Relationship between Family Status and Credit Amount
SELECT 
    NAME_FAMILY_STATUS AS Family_Status,
    ROUND(AVG(AMT_CREDIT),2) AS AVG_Credit_Amount
FROM application
WHERE AMT_CREDIT IS NOT NULL 
    AND NAME_FAMILY_STATUS IS NOT NULL
GROUP BY Family_Status
ORDER BY AVG_Credit_Amount ASC;

-- Relationship between Education Level and Credit Amount
SELECT 
    NAME_EDUCATION_TYPE AS Education_Level,
    ROUND(AVG(AMT_CREDIT),2) AS AVG_Credit_Amount
FROM application
WHERE AMT_CREDIT IS NOT NULL 
    AND NAME_EDUCATION_TYPE IS NOT NULL
GROUP BY Education_Level
ORDER BY 
    CASE
        WHEN Education_Level = 'Lower secondary' THEN 1
        WHEN Education_Level = 'Secondary / secondary special' THEN 2
        WHEN Education_Level = 'Incomplete higher' THEN 3
        WHEN Education_Level = 'Higher education' THEN 4
        WHEN Education_Level = 'Academic degree' THEN 5
    END;

-- Relationship between Income and Payment Difficulties
SELECT 
    CASE
        WHEN AMT_INCOME_TOTAL <= 200000 THEN 'Low Income'
        WHEN AMT_INCOME_TOTAL > 200000 AND AMT_INCOME_TOTAL <= 500000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS Income_Group,
    AVG(TARGET) AS Percentage_Payment_Difficulties
FROM application
WHERE AMT_INCOME_TOTAL IS NOT NULL
GROUP BY Income_Group
ORDER BY 
    CASE
        WHEN Income_Group = 'Low Income' THEN 1
        WHEN Income_Group = 'Medium Income' THEN 2
        WHEN Income_Group = 'High Income' THEN 3
    END;

-- Relationship between Family Status and Payment Difficulties
SELECT 
    NAME_FAMILY_STATUS AS Family_Status,
    AVG(TARGET) AS Percentage_Payment_Difficulties
FROM application
WHERE NAME_FAMILY_STATUS IS NOT NULL AND NAME_FAMILY_STATUS != 'Unknown'
GROUP BY Family_Status
ORDER BY Percentage_Payment_Difficulties DESC;

-- Relationship between Credit Amount and Payment Difficulties
SELECT 
    CASE
        WHEN AMT_CREDIT <= 500000 THEN 'Low Credit Amount'
        WHEN AMT_CREDIT > 500000 AND AMT_CREDIT <= 1500000 THEN 'Medium Credit Amount'
        ELSE 'High Credit Amount'
    END AS Credit_Amount_Group,
    AVG(TARGET) AS Percentage_Payment_Difficulties
FROM application
WHERE AMT_CREDIT IS NOT NULL
GROUP BY Credit_Amount_Group
ORDER BY 
    CASE
        WHEN Credit_Amount_Group = 'Low Credit Amount' THEN 1
        WHEN Credit_Amount_Group = 'Medium Credit Amount' THEN 2
        WHEN Credit_Amount_Group = 'High Credit Amount' THEN 3
    END;

-- Relationship between Number of Other Loans and Payment Difficulties
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

-- Relationship between Age and Credit Scores
SELECT 
    CASE 
        WHEN ABS(DAYS_BIRTH) <= 35 * 365 THEN 'Young'
        WHEN ABS(DAYS_BIRTH) > 35 * 365 AND ABS(DAYS_BIRTH) <= 50 * 365 THEN 'Middle-Aged'
        ELSE 'Old'
    END AS Age_Group,
    AVG(EXT_SOURCE_1) AS Avg_Ext_Source_1,
    AVG(EXT_SOURCE_2) AS Avg_Ext_Source_2,
    AVG(EXT_SOURCE_3) AS Avg_Ext_Source_3
FROM application
WHERE EXT_SOURCE_1 IS NOT NULL 
  AND EXT_SOURCE_2 IS NOT NULL 
  AND EXT_SOURCE_3 IS NOT NULL
GROUP BY Age_Group
ORDER BY 
    CASE 
        WHEN Age_Group = 'Young' THEN 1
        WHEN Age_Group = 'Middle-Aged' THEN 2
        ELSE 3
    END;

-- Relationship between Max Overdue Amount and Payment Difficulties
SELECT 
    CASE 
	    WHEN AMT_CREDIT_MAX_OVERDUE = 0 THEN 'No Overdue'
	    WHEN AMT_CREDIT_MAX_OVERDUE > 0 and AMT_CREDIT_MAX_OVERDUE <= 50000 THEN 'Low Overdue'
        WHEN AMT_CREDIT_MAX_OVERDUE > 50000 AND AMT_CREDIT_MAX_OVERDUE <= 200000 THEN 'Medium Overdue'
        ELSE 'High Overdue'
    END AS Overdue_Category,
    AVG(a.TARGET) AS Avg_Payment_Difficulties
FROM bureau b
JOIN application a ON b.SK_ID_CURR = a.SK_ID_CURR
WHERE b.AMT_CREDIT_MAX_OVERDUE IS NOT NULL
GROUP BY Overdue_Category
ORDER BY 
    CASE 
        WHEN Overdue_Category = 'No Overdue' THEN 1
        WHEN Overdue_Category = 'Low Overdue' THEN 2
        WHEN Overdue_Category = 'Medium Overdue' THEN 3
        ELSE 4
    END;
