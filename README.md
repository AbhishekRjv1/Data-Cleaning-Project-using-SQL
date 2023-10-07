# Data Cleaning and Standardization

## Overview
This set of SQL queries aims to clean and standardize the data within the `PortfolioProject.NashvilleHousing` table. The cleaning process includes standardizing date formats, handling missing and inconsistent property addresses, breaking down address fields into individual components, transforming categorical values, removing duplicates, and finally, deleting unnecessary columns. These steps ensure the dataset's consistency and prepare it for meaningful analysis and reporting.

## Standardize Date Format
The `SaleDate` column is converted to the correct date format (`'%Y-%m-%d'`). This standardizes the date representation for uniformity and consistency in data analysis.

```sql
SELECT STR_TO_DATE(SaleDate, '%Y-%m-%d') as saleDateConverted
FROM PortfolioProject.NashvilleHousing;

UPDATE PortfolioProject.NashvilleHousing
SET SaleDate = STR_TO_DATE(SaleDate, '%Y-%m-%d');
```

## Populate and Standardize Address Data
### Populate Missing Property Addresses
Missing `PropertyAddress` values are populated by matching records based on `ParcelID`.

```sql
UPDATE PortfolioProject.NashvilleHousing a
JOIN PortfolioProject.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress);
```

### Break Down Address Components
`PropertyAddress` values are split into `PropertySplitAddress` and `PropertySplitCity` columns, providing individual components for analysis.

```sql
ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN PropertySplitAddress VARCHAR(255),
ADD COLUMN PropertySplitCity VARCHAR(255);

UPDATE PortfolioProject.NashvilleHousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertySplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', -2), ',', 1);
```

## Standardize Owner Address Components
`OwnerAddress` values are parsed and split into `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState` columns, ensuring consistent formatting and separation of address elements.

```sql
ALTER TABLE PortfolioProject.NashvilleHousing
ADD COLUMN OwnerSplitAddress VARCHAR(255),
ADD COLUMN OwnerSplitCity VARCHAR(255),
ADD COLUMN OwnerSplitState VARCHAR(255);

UPDATE PortfolioProject.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);
```

## Transform Categorical Values
The `SoldAsVacant` column values ('Y' and 'N') are transformed to 'Yes' and 'No', respectively, for clarity and consistency.

```sql
UPDATE PortfolioProject.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
                        ELSE SoldAsVacant END;
```

## Remove Duplicates
Duplicates based on specific columns (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`) are identified and removed, ensuring a unique dataset.

```sql
WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) as row_num
    FROM PortfolioProject.NashvilleHousing
)
DELETE FROM RowNumCTE
WHERE row_num > 1;
```

## Delete Unused Columns
Unused columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`) are removed, streamlining the dataset for efficient storage and analysis.

```sql
ALTER TABLE PortfolioProject.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
```

## Instructions for Use
1. **Database Connection:**
   - Ensure you have appropriate database access and connection permissions.
   - Execute the SQL script in a database management tool connected to the target MySQL database.

2. **Review and Modify:**
   - Review the script to ensure compatibility with your MySQL database schema.
   - Modify table and column names if necessary to match your database structure.

3. **Run the Script:**
   - Execute the script in the database management tool to clean and standardize the data in the `PortfolioProject.NashvilleHousing` table.

## Conclusion
This comprehensive data cleaning process enhances the dataset's quality, making it reliable for subsequent analysis and reporting. The standardized date formats, populated and consistent addresses, transformed categorical values, absence of duplicates, and removal of unnecessary columns contribute to a clean and organized dataset, facilitating meaningful insights and decision-making processes.

---

