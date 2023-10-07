# Data-Cleaning-Project-using-SQL

## Cleaning Data in SQL Queries

## Objective
The purpose of this SQL script is to clean and standardize the data within the `PortfolioProject.dbo.NashvilleHousing` table. The cleaning process involves various tasks, including standardizing date formats, populating missing property addresses, breaking down addresses into individual columns, transforming "Y" and "N" values to "Yes" and "No," removing duplicates, and finally, deleting unused columns. This ensures the dataset's consistency and enhances its usability for analysis and reporting.

## Steps to Clean the Data

### 1. **Standardize Date Format**
   The script begins by standardizing the date format in the `SaleDate` column, ensuring uniformity for date-related analysis.

### 2. **Populate Property Address Data**
   - Null property addresses are populated by matching records based on `ParcelID` and updating missing values from corresponding non-null records.
   
### 3. **Break Down Address Columns**
   - The `PropertyAddress` column is divided into individual columns (`Address`, `City`, `State`) for improved granularity and ease of analysis.

### 4. **Transform "Y" and "N" Values**
   - The `SoldAsVacant` column values ("Y" and "N") are transformed to "Yes" and "No," respectively, for clarity and consistency.

### 5. **Remove Duplicates**
   - Duplicates are identified based on specific columns (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`) and removed, ensuring a unique dataset.

### 6. **Delete Unused Columns**
   - Unused columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`) are removed from the table, streamlining the dataset for efficient storage and analysis.

## Instructions for Use
1. **Database Connection:**
   - Ensure you have appropriate database access and connection permissions.
   - Execute the SQL script in a database management tool connected to the target database.

2. **Review and Modify:**
   - Review the script to ensure compatibility with your database schema.
   - Modify table and column names if necessary to match your database structure.

3. **Run the Script:**
   - Execute the script in the database management tool to clean and standardize the data in the `PortfolioProject.dbo.NashvilleHousing` table.

## Conclusion
This comprehensive cleaning process enhances the dataset's quality, making it reliable for subsequent analysis and reporting. The standardized format, populated missing values, transformed values, absence of duplicates, and removal of unnecessary columns contribute to a clean and organized dataset, facilitating meaningful insights and decision-making processes.

---

*Disclaimer: The provided SQL script assumes a specific database schema. Please adjust column names, table names, and query logic as per your database structure and requirements.*
