

-- Cleaning data in SQL Series

Select *
From PortfolioProject..NashvilleHousing


-- Standardize Sale Date

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Adress Data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueId] <> b.[UniqueID]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueId] <> b.[UniqueID]


-- Breaking out Address into Individual Columns


Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing


Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From PortfolioProject..NashvilleHousing



--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE 
	When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	End
	From PortfolioProject..NashvilleHousing

	Update PortfolioProject..NashvilleHousing
	SET SoldAsVacant =
 CASE 
	When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	End
	From PortfolioProject..NashvilleHousing
	

	-- Remove Duplicates

	WITH RowNumCTE as(
	Select *,
	ROW_NUMBER()OVER (
	PARTITION BY	ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num
				

	From PortfolioProject..NashvilleHousing
	--Order by ParcelID
	)
	Select *
	From RowNumCTE
	Where row_num > 1

	

	Select *
	From PortfolioProject..NashvilleHousing


	--Delete Unused Columns

	Select *
	From PortfolioProject..NashvilleHousing

	ALTER TABLE PortfolioProject..NashvilleHousing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

	ALTER TABLE PortfolioProject..NashvilleHousing
	DROP COLUMN SaleDate