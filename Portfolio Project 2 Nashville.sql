--Cleaning Data in SQL Quaries

SELECT *
FROM [Portfolio Project].[dbo].[Nashville]

--Standardize Date Format

ALTER TABLE [Portfolio Project].[dbo].[Nashville]
ADD SaleDateConverted Date

UPDATE [Portfolio Project].[dbo].[Nashville]
SET SaleDateConverted = CONVERT(Date,Saledate)

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM [Portfolio Project].[dbo].[Nashville]


--Populate Property Adress data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].[dbo].[Nashville] AS a
	JOIN  [Portfolio Project].[dbo].[Nashville] AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].[dbo].[Nashville] AS a
	JOIN  [Portfolio Project].[dbo].[Nashville] AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Populate out Address into Individual Columns (Address,City,State)

ALTER TABLE [Portfolio Project].[dbo].[Nashville]
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Portfolio Project].[dbo].[Nashville]
SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Portfolio Project].[dbo].[Nashville]
ADD PropertySplitCity Nvarchar(255);


UPDATE [Portfolio Project].[dbo].[Nashville]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))



SELECT *
FROM  [Portfolio Project].[dbo].[Nashville]

---ALTERNATE TO SUBSTRING


ALTER TABLE [Portfolio Project].[dbo].[Nashville]
ADD OwnerSplitAddress Nvarchar(255);

UPDATE [Portfolio Project].[dbo].[Nashville]
SET  OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE  [Portfolio Project].[dbo].[Nashville]
ADD OwnerSplitCity nvarchar(255);

UPDATE [Portfolio Project].[dbo].[Nashville]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE  [Portfolio Project].[dbo].[Nashville]
ADD OwnerSplitState Nvarchar(255);

UPDATE [Portfolio Project].[dbo].[Nashville]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM  [Portfolio Project].[dbo].[Nashville]





--- Change Y & N to Yes & No

UPDATE [Portfolio Project].[dbo].[Nashville]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
SELECT *
FROM  [Portfolio Project].[dbo].[Nashville]


--Remove Duplicates


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM [Portfolio Project].[dbo].[Nashville]
)

SELECT *
FROM RowNumCTE 
Where row_num > 1
ORDER BY PropertyAddress


--Delete Unused Columns

ALTER TABLE [Portfolio Project].[dbo].[Nashville]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE  [Portfolio Project].[dbo].[Nashville]
DROP COLUMN SaleDate

SELECT *
FROM  [Portfolio Project].[dbo].[Nashville]
