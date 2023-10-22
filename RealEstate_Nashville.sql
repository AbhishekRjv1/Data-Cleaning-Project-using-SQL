/*
									REAL ESTATE HOUSING DATA CLEANING (MYSQL)

SQL skills used: date formatting with STR_TO_DATE, data population through UPDATE with JOIN and IFNULL, address component breakdown using SUBSTRING_INDEX, 
    transformation with CASE statements, duplicate identification with ROW_NUMBER(), and column removal using DROP COLUMN.


*/

-- Standardize Date Format - changing datetime to date format

SELECT STR_TO_DATE(SaleDate, '%Y-%m-%d') as saleDateConverted
FROM PortfolioProject.NashvilleHousing;

UPDATE PortfolioProject.NashvilleHousing
SET SaleDate = STR_TO_DATE(SaleDate, '%Y-%m-%d');



-- If it doesn't Update properly, use ALTER TABLE

ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN SaleDateConverted DATE;

UPDATE PortfolioProject.NashvilleHousing
SET SaleDateConverted = STR_TO_DATE(SaleDate, '%Y-%m-%d');  -- later SaleDate column can be dropped



-- Populate Property Address data from another column where ParcelID is same  

UPDATE PortfolioProject.NashvilleHousing a
JOIN PortfolioProject.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;



-- Breaking out Address into Individual Columns (Address, City, State)

ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN PropertySplitAddress VARCHAR(255),
ADD COLUMN PropertySplitCity VARCHAR(255);

UPDATE PortfolioProject.NashvilleHousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);



-- Spliting Owner Address

ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN OwnerSplitAddress VARCHAR(255),
ADD COLUMN OwnerSplitCity VARCHAR(255),
ADD COLUMN OwnerSplitState VARCHAR(255);

UPDATE PortfolioProject.NashvilleHousing
SET OwnerSplitAddress = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -3), ',', 1),
    OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1),
    OwnerSplitState = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -1), ',', 1);



-- Change Y and N to Yes and No in "Sold as Vacant" field

UPDATE PortfolioProject.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
                        ELSE SoldAsVacant 
                        END;



-- Show the counts of all Duplicates

WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) as row_num
    FROM PortfolioProject.NashvilleHousing
)
select count(*) from PortfolioProject.NashvilleHousing
where UniqueID in (select UniqueID FROM RowNumCTE WHERE row_num > 1)
order by UniqueID;



-- Delete Unused Columns 

ALTER TABLE PortfolioProject.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
 