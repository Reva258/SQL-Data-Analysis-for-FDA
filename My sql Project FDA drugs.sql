-- SQL Data Analysis for FDA 

-- Task I: Identifying Approval Trends

-- 1. Determine the number of drugs approved each year and provide insights into the yearly trends.
SELECT YEAR(ActionDate) AS ApprovalYear, COUNT(DISTINCT ApplNo) AS ApprovedDrugs
FROM regactiondate
WHERE ActionDate IS NOT NULL
GROUP BY ApprovalYear
ORDER BY ApprovalYear;
-- Analysis : The year on drugs approved each year has been increasing order.
 
-- 2. Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.
SELECT YEAR(ActionDate) AS ApprovalYear, COUNT(DISTINCT ApplNo) AS ApprovedDrugs
FROM regactiondate
WHERE ActionDate IS NOT NULL
GROUP BY ApprovalYear
ORDER BY ApprovedDrugs desc
Limit 3;
-- Year 2000, 1998, and 2001 got highest approvals.

SELECT YEAR(ActionDate) AS ApprovalYear, COUNT(DISTINCT ApplNo) AS ApprovedDrugs
FROM regactiondate
WHERE ActionDate IS NOT NULL
GROUP BY ApprovalYear
ORDER BY ApprovedDrugs asc
Limit 3;
-- Year 1945, 1943, and 1943 got lowest approvals.

-- 3. Explore approval trends over the years based on sponsors.
select YEAR(regactiondate.ActionDate) AS ApprovalYear, application.SponsorApplicant, COUNT(DISTINCT regactiondate.ApplNo) AS ApprovedDrugs
from regactiondate 
join application 
on regactiondate.ApplNo = application.ApplNo
WHERE ActionDate IS NOT NULL
group by application.SponsorApplicant, ApprovalYear
Order by ApprovalYear; 

-- 4. Rank sponsors based on the total number of approvals they received each year between 1939 and 1960
SELECT 
    YEAR(regactiondate.ActionDate) AS ApprovalYear,
    application.SponsorApplicant,
    COUNT(DISTINCT regactiondate.ApplNo) AS ApprovedDrugs,
    RANK() OVER (PARTITION BY YEAR(regactiondate.ActionDate) ORDER BY COUNT(DISTINCT regactiondate.ApplNo) DESC) AS SponsorRank
FROM 
    regactiondate
JOIN 
    application ON regactiondate.ApplNo = application.ApplNo
WHERE 
    YEAR(regactiondate.ActionDate) BETWEEN 1939 AND 1960
    AND regactiondate.ActionDate IS NOT NULL
GROUP BY 
    ApprovalYear, application.SponsorApplicant;

-- Task II: Segmentation Analysis Based on Drug Marketing Status
-- 1. Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.
SELECT ProductMktStatus, count(distinct ProductNo) as ProductCount
From product
group by ProductMktStatus;
 -- Analysis : Based on the ProductMktStatus, 53 products have status "1" and only 8 product have marketing status "4".

-- 2. Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.
SELECT YEAR(regactiondate.ActionDate) AS ApprovalYear, ProductMktStatus, count(distinct Product.ApplNo) as ApplicationCount
From regactiondate
Join Product on regactiondate.ApplNo = Product.ApplNo
Where YEAR(regactiondate.ActionDate) > 2010
Group by ApprovalYear, Product.ProductMktStatus
order by ApprovalYear, ApplicationCount DESC;

-- 3. Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time
SELECT YEAR(regactiondate.ActionDate) AS ApprovalYear, ProductMktStatus, count(distinct Product.ApplNo) as ApplicationCount
From regactiondate
Join Product on regactiondate.ApplNo = Product.ApplNo
Group by ApprovalYear, Product.ProductMktStatus
order by ApplicationCount DESC;

-- Task III: Analyzing Products
-- 1. Categorize Products by dosage form and analyze their distribution
select Form, count(distinct ProductNo) as TotalProducts
from product
group by Form
order by TotalProducts;

-- 2. Calculate the total number of approvals for each dosage form and identify the most successful forms
select product.Form, count(distinct product.ProductNo) as TotalProducts
from regactiondate
Join product 
on regactiondate.ApplNo = product.ApplNo
Where regactiondate.ActionType="AP"
group by product.Form
order by TotalProducts Desc
Limit 5;
-- Analysis : The 'INJECTABLE;INJECTION' form has highest approved products i.e '53'. 

-- Task IV: Exploring Therapeutic Classes and Approval Trends
-- 1. Analyze drug approvals based on therapeutic evaluation code (TE_Code)
select product.TECode, count(distinct product.ProductNo) as TotalProducts
from regactiondate
Join product 
on regactiondate.ApplNo = product.ApplNo
Where product.TECode IS NOT NULL
AND regactiondate.ActionType="AP"
group by product.TECode
order by TotalProducts Desc;

-- 2. Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.
select YEAR(regactiondate.ActionDate) AS ApprovalYear, product.TECode, count(distinct product.ProductNo) as TotalProducts
from regactiondate
Join product 
on regactiondate.ApplNo = product.ApplNo
Where product.TECode IS NOT NULL
AND regactiondate.ActionType="AP"
group by product.TECode, regactiondate.ActionDate
order by TotalProducts Desc;