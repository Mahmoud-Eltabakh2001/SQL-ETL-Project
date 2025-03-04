----------------Create DB
CREATE DATABASE [Nashville Housing DB];

USE [Nashville Housing DB];
GO

-----Load data from CSV file into DB 
--Create Table 

CREATE TABLE [dbo].[Nashville Housing Data](
	[UniqueID] VARCHAR(10) NOT NULL,
	[ParcelID] VARCHAR(50) NOT NULL,
	[LandUse] VARCHAR(50) NOT NULL,
	[PropertyAddress] VARCHAR(50) NULL,
	[SaleDate] DATE NULL,
	[SalePrice] INT NULL,
	[LegalReference] VARCHAR(50) NULL,
	[SoldAsVacant] VARCHAR(50) NULL,
	[OwnerName] VARCHAR(80) NULL,
	[OwnerAddress] VARCHAR(50) NULL,
	[Acreage] FLOAT NULL,
	[TaxDistrict] VARCHAR(50) NULL,
	[LandValue] INT NULL,
	[BuildingValue] INT NULL,
	[TotalValue] INT NULL,
	[YearBuilt] INT NULL,
	[Bedrooms] INT NULL,
	[FullBath] INT NULL,
	[HalfBath] INT NULL
) ON [PRIMARY]
GO
-----Use Bulk Insert to load CSV File into DB

BULK INSERT [dbo].[Nashville Housing Data]
FROM 'E:\SQL Project\Nashville Housing Data.csv'
WITH(
   FIELDTERMINATOR=',',
   FORMAT='csv',
   ROWTERMINATOR='\n',
   FIRSTROW=2
   );

SELECT * FROM [dbo].[Nashville Housing Data] order by [UniqueID]

Delete From [dbo].[Nashville Housing Data]
where [UniqueID] ='';

select count(*)
from [dbo].[Nashville Housing Data] 

select distinct [UniqueID]
from [Nashville Housing Data]

--Check Duplicates
select count(*) as Count
from [dbo].[Nashville Housing Data]
group by [LandUse],[PropertyAddress],[SaleDate],[SalePrice],[LegalReference],[SoldAsVacant],[OwnerName],[OwnerAddress],
[Acreage],[TaxDistrict],[LandValue],[BuildingValue],[TotalValue],[YearBuilt],[Bedrooms],[FullBath],[HalfBath]
having count(*) >1

--Remove Duplicates

WITH Duplicates_CTE  AS(
    Select *,ROW_NUMBER() OVER(
                              Partition By [LandUse],[PropertyAddress],[SaleDate],[SalePrice],[LegalReference],[SoldAsVacant],
							               [OwnerName],[OwnerAddress],[Acreage],[TaxDistrict],[LandValue],[BuildingValue],
										   [TotalValue],[YearBuilt],[Bedrooms],[FullBath],[HalfBath]
                              Order By [UniqueID] ) AS RowNum
	From [Nashville Housing Data]
)
--Select * From Duplicates_CTE Where RowNum >1;
delete from Duplicates_CTE
where RowNum >1;

select count(*)
from [dbo].[Nashville Housing Data]

--Populate PropertyAddress

select *
from [dbo].[Nashville Housing Data]
order by [ParcelID]

select a.[ParcelID],a.[PropertyAddress],b.[ParcelID],b.[PropertyAddress]
from [dbo].[Nashville Housing Data] a join [dbo].[Nashville Housing Data] b 
on a.[ParcelID]= b.[ParcelID] and a.[UniqueID ] <> b.[UniqueID ]
where a.[PropertyAddress] is null

update a
set [PropertyAddress]=coalesce(a.[PropertyAddress],b.[PropertyAddress])
from [dbo].[Nashville Housing Data] a join [dbo].[Nashville Housing Data] b 
on a.[ParcelID]= b.[ParcelID] and a.[UniqueID ] <> b.[UniqueID ]
where a.[PropertyAddress] is null

--Split PropertyAddress into address and city

select [PropertyAddress] 
from [dbo].[Nashville Housing Data]

select [PropertyAddress],replace(substring([PropertyAddress],1, charindex(',',[PropertyAddress])) ,',','') as Address ,
       substring( [PropertyAddress],charindex(',',[PropertyAddress]) +1,len( [PropertyAddress]) )as City 
from [dbo].[Nashville Housing Data]

alter table [dbo].[Nashville Housing Data]
add PropertySplitAddress varchar(50) 
go
update [dbo].[Nashville Housing Data]
set PropertySplitAddress =replace(substring([PropertyAddress],1, charindex(',',[PropertyAddress])) ,',','')

alter table [dbo].[Nashville Housing Data]
add PropertySplitCity varchar(50) 
go
update [dbo].[Nashville Housing Data]
set PropertySplitCity =substring( [PropertyAddress],charindex(',',[PropertyAddress]) +1,len( [PropertyAddress]) )

select * 
from [dbo].[Nashville Housing Data]

--SoldAsVacant

select distinct [SoldAsVacant]
from [dbo].[Nashville Housing Data]

update [dbo].[Nashville Housing Data]
set [SoldAsVacant] = case when [SoldAsVacant]='N' then 'No'
                          when [SoldAsVacant]='Y' then 'Yes' Else [SoldAsVacant] end

--Split OwnerAddress into Address , City , State

select parsename( replace([OwnerAddress],',','.') , 1 ) as State,
       parsename( replace([OwnerAddress],',','.') , 2 ) as City,
       parsename( replace([OwnerAddress],',','.') , 3 ) as Address
from [dbo].[Nashville Housing Data]

alter table [dbo].[Nashville Housing Data]
add OwnerSplitAddress varchar(50) 
go
update [dbo].[Nashville Housing Data]
set OwnerSplitAddress =parsename( replace([OwnerAddress],',','.') , 3 )

alter table [dbo].[Nashville Housing Data]
add OwnerSplitCity varchar(50) 
go
update [dbo].[Nashville Housing Data]
set OwnerSplitCity =parsename( replace([OwnerAddress],',','.') , 2 ) 

alter table [dbo].[Nashville Housing Data]
add OwnerSplitState varchar(50) 
go
update [dbo].[Nashville Housing Data]
set OwnerSplitState =parsename( replace([OwnerAddress],',','.') , 1 )

select * from [Nashville Housing Data]

--Remove Unused Columns

Select * From [Nashville Housing Data]
--[PropertyAddress] , [OwnerAddress]  

Alter Table [Nashville Housing Data]
Drop Column [PropertyAddress] , [OwnerAddress]


