--Task 1
Select ProductName from DimProduct;
Select ProductName from DimProduct where ProductType = 'Bread';
Select * from DimPromotion where PromotionPercentage > 0.10 order by PromotionType;
Select * from DimDateTime where FullDateTime = '2019-01-21 09:00:00.000' ;

select * from DimEmployee where EmployeeActive = 'Yes';
select * from DimEmployee where EmployeeType = 'Production' and EmployeeActive = 'Yes'; 


--Task 2
Select * from DimProduct where ProductType Like 'B%';
Select * from DimProduct where ProductType Like 'B%d';
Select SalesAmount, ProductType FROM FactSales, DimProduct WHERE FactSales.ProductCode = DimProduct.ProductCode and PromotionID IS NULL;
Select SalesAmount, ProductType FROM FactSales, DimProduct WHERE FactSales.ProductCode = DimProduct.ProductCode 
and ProductName like '%bread%' Order by ProductType;

--Select * from DimEmployee where ProductType Like 'B%';

--Task 3
SELECT GETDATE()
Select Year(EmployeeDOB) from DimEmployee;
Select Month(EmployeeDOB) from DimEmployee;
Select Day(EmployeeDOB) from DimEmployee;
Select DATEADD(YEAR,1, FullDateTime) from FactSales where PromotionID IS NOT NULL;
Select Datediff(Year, EmployeeDOB, GETDATE()) from DimEmployee;
Select * from DimEmployee Where (DATEDIFF(DAY, EmployeeDOB, GETDATE()) / 365.25) > 25;
Select * from DimEmployee

SELECT count(*) FROM FactSales inner join DimProduct on FactSales.ProductCode = DimProduct.ProductCode
 inner join DimCategory on DimCategory.CategoryID = DimProduct.CategoryID where PromotionID IS NULL; --join of more than 1 tables


 SELECT 
    FORMAT(dt.FullDateTime, 'dd-MM-yyyy') AS SalesDate_DMY,
    dt.DTMonth AS SalesMonth,
    dt.DTYear AS SalesYear,
    fs.SalesAmount,
    fs.CostAmount,
    (fs.SalesAmount - fs.CostAmount) AS Profit,
    ROW_NUMBER() OVER (
        PARTITION BY dt.DTMonth
        ORDER BY fs.FullDateTime
    ) AS RowNumberPerMonth
FROM 
    FactSales fs
JOIN 
    DimDateTime dt ON fs.FullDateTime = dt.FullDateTime
WHERE 
    dt.DTYear = 2020
ORDER BY 
    dt.DTMonth, fs.FullDateTime;


--------------------TASK 15 PIVOT------------------------------------------
SELECT ProductName, Pancake, Loaf, Bread, Dansih, Tart, [Sweet Bagel], [Savoury Bagel]
FROM (
SELECT ProductType, ProductName, CategoryID
FROM DimProduct) up
PIVOT (Count(CategoryID) FOR ProductType IN (Pancake, Loaf, Bread, Dansih, Tart, [Sweet Bagel], [Savoury Bagel])) AS pvt
ORDER BY ProductName


--------------------TASK 16 RANK------------------------------------------
SELECT EmployeeFirstName, EmployeeLastName  
    ,ROW_NUMBER() OVER (ORDER BY quantity) AS "Row Number"  
    ,RANK() OVER (ORDER BY quantity) AS Rank  
    ,DENSE_RANK() OVER (ORDER BY quantity) AS "Dense Rank"  
    ,PromotionType
    ,PromotionPercentage 
FROM DimEmployee inner join FactSales on DimEmployee.EmployeeID = FactSales.EmployeeID inner join DimPromotion on FactSales.PromotionID = DimPromotion.PromotionID
where FactSales.PromotionID IS NOT NULL;

SELECT EmployeeFirstName, EmployeeLastName 
    ,ROW_NUMBER() OVER (ORDER BY PromotionPercentage) AS "Row Number"  
    ,RANK() OVER (ORDER BY PromotionPercentage) AS Rank  
    ,DENSE_RANK() OVER (ORDER BY PromotionPercentage) AS "Dense Rank"  
    ,PromotionType
    ,PromotionPercentage 
FROM DimEmployee inner join FactSales on DimEmployee.EmployeeID = FactSales.EmployeeID inner join DimPromotion on FactSales.PromotionID = DimPromotion.PromotionID
where FactSales.PromotionID IS NOT NULL;


--------------------TASK 17 LAG LEAD------------------------------------------


select EmployeeID, FullDateTime, ProductCode, SalesAmount,
    LAG(SalesAmount) Over (PARTITION by EmployeeID order by FullDateTime, ProductCode) as preSalesAmount, 
    Lead(SalesAmount) Over (PARTITION by EmployeeID order by FullDateTime, ProductCode) as postSalesAmount 
 from FactSales


Select ProductType, YEAR(FullDateTime) AS [Year], Quantity,

FIRST_VALUE(ProductType) OVER (
    PARTITION BY YEAR(FullDateTime) ORDER BY Quantity
) As LowestSalesVolume
From DimProduct INNER JOIN FactSales on DimProduct.ProductCode = FactSales.ProductCode
Where YEAR(FullDateTime) BETWEEN 2019 and 2020;

select EmployeeID, FullDateTime, ProductCode, SalesAmount,
    FIRST_VALUE(SalesAmount) Over (PARTITION by EmployeeID order by FullDateTime, ProductCode ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as FIRSTSale,
    LAST_VALUE(SalesAmount) Over (PARTITION by EmployeeID order by FullDateTime, ProductCode ) as LastSale
 from FactSales

 select * from FactSales where EmployeeID=1 order by FullDateTime, ProductCode ;--284.48,306.81

 ---TASK 18 ---
 SELECT EmployeeFirstName, EmployeeLastName, YEAR(FactSales.FullDateTime) AS [YEAR], 
       Round(CUME_DIST () OVER (PARTITION BY YEAR(FactSales.FullDateTime) ORDER BY SalesAmount),3) AS CumeDist  
FROM DimEmployee inner join FactSales on DimEmployee.EmployeeID = FactSales.EmployeeID 
Where YEAR(FactSales.FullDateTime) IN (2021, 2020)
ORDER BY YEAR(FactSales.FullDateTime) DESC;  


SELECT EmployeeFirstName, EmployeeLastName, YEAR(FactSales.FullDateTime) AS [YEAR], 
       Round(PERCENT_RANK () OVER (PARTITION BY YEAR(FactSales.FullDateTime) ORDER BY SalesAmount),3) AS PercRank  
FROM DimEmployee inner join FactSales on DimEmployee.EmployeeID = FactSales.EmployeeID 
Where YEAR(FactSales.FullDateTime) IN (2021, 2020)
ORDER BY YEAR(FactSales.FullDateTime) DESC;  


---TASK 19 Logical Functions---

DECLARE @a INT = 45, @b INT = 40;
SELECT [Result] = IIF( @a > @b, 'TRUE', 'FALSE' );

DECLARE @P INT = NULL, @S INT = NULL;  
SELECT [Result] = IIF( 45 > 30, @P, @S );

SELECT IIF (40 > (Select Top (1) Quantity from FactWaste Order By Quantity asc), 'High', 'Low' )


SELECT CHOOSE ( 3, 'Food', 'Sleep', 'Shopping', 'Gym' ) AS Result;

SELECT EmployeeType, EmployeeStartDate, CHOOSE(MONTH(EmployeeStartDate),'Winter','Winter', 'Spring','Spring','Spring','Summer','Summer',   
                                                  'Summer','Autumn','Autumn','Autumn','Winter') AS Quarter_Hired  
FROM DimEmployee
WHERE  YEAR(EmployeeStartDate) > 2015  
ORDER BY YEAR(EmployeeStartDate);  







