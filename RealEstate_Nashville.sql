-- Standardize Date Format

SELECT STR_TO_DATE(SaleDate, '%Y-%m-%d') as saleDateConverted
FROM PortfolioProject.NashvilleHousing;

UPDATE PortfolioProject.NashvilleHousing
SET SaleDate = STR_TO_DATE(SaleDate, '%Y-%m-%d');



-- If it doesn't Update properly

ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN SaleDateConverted DATE;

UPDATE PortfolioProject.NashvilleHousing
SET SaleDateConverted = STR_TO_DATE(SaleDate, '%Y-%m-%d');



-- Populate Property Address data

UPDATE PortfolioProject.NashvilleHousing a
JOIN PortfolioProject.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress);



-- Breaking out Address into Individual Columns (Address, City, State)

ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN PropertySplitAddress VARCHAR(255),
ADD COLUMN PropertySplitCity VARCHAR(255);

UPDATE PortfolioProject.NashvilleHousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertySplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', -2), ',', 1);



-- Split Owner Address

ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN OwnerSplitAddress VARCHAR(255),
ADD COLUMN OwnerSplitCity VARCHAR(255),
ADD COLUMN OwnerSplitState VARCHAR(255);

UPDATE PortfolioProject.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);



-- Change Y and N to Yes and No in "Sold as Vacant" field

UPDATE PortfolioProject.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
                        ELSE SoldAsVacant END;



-- Remove Duplicates

WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) as row_num
    FROM PortfolioProject.NashvilleHousing
)
DELETE FROM RowNumCTE
WHERE row_num > 1;



-- Delete Unused Columns

ALTER TABLE PortfolioProject.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
