/*
Data Cleaning for Nashville Housing Data Part - 1
*/

SELECT * FROM Portfolio_Project.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------
-- (1) Standardize Date Format:
SELECT SaleDate, CONVERT(date, SaleDate) AS SaleDate_Only 
FROM Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD SaleDate_Only DATE;

GO
UPDATE Portfolio_Project.dbo.NashvilleHousing
SET SaleDate_Only = CAST(SaleDate as Date)

SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing;

-----------------------------------------------------------------------------------------------------------
-- (2) Populate Property Address:

/*
Here we have used Self Join.

Sometimes PropertyAddress is NULL for some rows but available for the same ParcelID.
i.e. There are same Parcel IDs which has same address.

What ISNULL does? 
If a.PropertyAddress is null it replace it with b.PropertyAddress.

*/

SELECT a.PropertyAddress,b.ParcelID ,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing a
JOIN
Portfolio_Project.dbo.NashvilleHousing b
ON
a.ParcelID = b.ParcelID
AND
a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing a
JOIN
Portfolio_Project.dbo.NashvilleHousing b
ON
a.ParcelID = b.ParcelID
AND
a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------
-- (3) Splitting Address into Individual Columns:
-- CHARINDEX returns the position (index) of a character inside a string

-- i) Property Address:

SELECT PropertyAddress FROM Portfolio_Project.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD PropertyAddress_Street NCHAR(225);

GO
UPDATE Portfolio_Project.dbo.NashvilleHousing
SET PropertyAddress_Street = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD PropertyCity NCHAR(225);

GO
UPDATE Portfolio_Project.dbo.NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- ii) Owner's Address
/*

PARSENAME() is used to split object names in SQL Server.
PARSENAME('string', part_number)
PARSENAME() = Split string from RIGHT side using dot (.)

---------------------------------
| part_number | What it returns |
| ----------- | --------------- |
| 1           | Last part       |
| 2           | Second last     |
| 3           | Third last      |
| 4           | Fourth last     |

PARSENAME() only understands dots (.), not commas (,)

*/
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),   -- First part i.e. Address
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),   -- Middel part i.e. City
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)    -- Last part i.e. State
FROM Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD OwnerStreet_Address NCHAR(225);

GO
UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerStreet_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD OwnerCity_Address NCHAR(225);

GO
UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerCity_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD OwnerState NCHAR(225);

GO
UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--------------------------------------------------------------------------------------------------------------
-- (4) Change Y and N to Yes and No in "Sold as Vacant" field:
SELECT DISTINCT(SoldAsVacant) FROM Portfolio_Project.dbo.NashvilleHousing

SELECT DISTINCT(SoldAsVacant), count(SoldAsVacant)
FROM Portfolio_Project.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     WHEN SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
     END

FROM Portfolio_Project.dbo.NashvilleHousing

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     WHEN SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
     END

-- To check if it is updated run the DISTINCT line query.


-------------------------------------------------------------------------------------------------------------
-- (5) Removing Duplicates:

SELECT *, ROW_NUMBER() OVER(
          PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
          ORDER BY UniqueID)
          row_num
FROM Portfolio_Project.dbo.NashvilleHousing
ORDER BY ParcelID

/*
This query tells us the actual duplicated row by providing row numbers.
If the row_num > 1 for some entry then that entry is repeated and only the 1st time entry will be retained.
Eg.Check for entry in 50468 row.
*/

-- We will create a CTE to check for duplicates:
WITH RowNum_CTE as (
SELECT *, ROW_NUMBER() OVER(
          PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
          ORDER BY UniqueID)
          row_num
FROM Portfolio_Project.dbo.NashvilleHousing)
-- ORDER BY ParcelID 

SELECT * FROM RowNum_CTE
WHERE row_num > 1
ORDER BY PropertyAddress


-- Now we will delete the duplicate rows
WITH RowNum_CTE as (
SELECT *, ROW_NUMBER() OVER(
          PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
          ORDER BY UniqueID)
          row_num
FROM Portfolio_Project.dbo.NashvilleHousing
-- ORDER BY ParcelID
)

DELETE FROM RowNum_CTE
WHERE row_num > 1

-- To check re-run the query to check duplicates.


--------------------------------------------------------------------------------------------------------------
-- (6) Drop Unused Columns:
Select *
From Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN SaleDate

