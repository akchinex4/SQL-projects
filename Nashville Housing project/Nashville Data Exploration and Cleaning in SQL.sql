SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio_Project].[dbo].[NashvilleHousing]

  -- Cleaning Data in SQL Queries
  select * 
  from  Portfolio_Project.dbo.NashvilleHousing

  -- Standardizing the date format
  select SaleDate 
from Portfolio_Project.dbo.NashvilleHousing 

select SaleDate, Convert(Date,SaleDate)
from Portfolio_Project.dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = Convert(Date,SaleDate) 

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

select SaleDateConverted, Convert(Date,SaleDate)
from Portfolio_Project.dbo.NashvilleHousing

--Populate Property Address Data
select *
from Portfolio_Project.dbo.NashvilleHousing
--where PropertyAddress is null 
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_Project.dbo.NashvilleHousing a
Join Portfolio_Project.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_Project.dbo.NashvilleHousing a
Join Portfolio_Project.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State) 
select PropertyAddress
from Portfolio_Project.dbo.NashvilleHousing
--where PropertyAddress is null 
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address 

from Portfolio_Project.dbo.NashvilleHousing 


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) 

select *
from Portfolio_Project.dbo.NashvilleHousing 

select OwnerAddress
from Portfolio_Project.dbo.NashvilleHousing 

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from Portfolio_Project.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OnwerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OnwerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitcity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from Portfolio_Project.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" Field.

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio_Project.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   End
from Portfolio_Project.dbo.NashvilleHousing 

Update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   End

--Remove Duplicates

with RowNumCTE as(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num

From Portfolio_Project.dbo.NashvilleHousing
--order by ParcelID
)
Delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress

--Checking duplicate
with RowNumCTE as(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num

From Portfolio_Project.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

select *
from Portfolio_Project.dbo.NashvilleHousing 


--Delete Unused Columns

select *
from Portfolio_Project.dbo.NashvilleHousing 

Alter table Portfolio_Project.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table Portfolio_Project.dbo.NashvilleHousing
Drop column SaleDate



