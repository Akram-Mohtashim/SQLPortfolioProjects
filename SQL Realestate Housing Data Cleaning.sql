*/

Cleaning Data in SQL Queries
*/

Select *
From PortfolioProject..NashvilleHousing


---Standardize Date Format 

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)


---Populate Property Address date

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NUll



Update a
SET PropertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NUll



---Breaking Out Address Into Individual Columns(Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--where Propertyaddress is null
--Order By ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) As Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))  As Address

From PortfolioProject..NashvilleHousing



Alter Table NashvilleHousing
Add PropertySPlitAddress Nvarchar(255);


Update NashvilleHousing
Set PropertySPlitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousing



Select OwnerAddress
From PortfolioProject..NashvilleHousing


Select
PARSENAME(Replace(OwnerAddress,',','.') ,3),
PARSENAME(Replace(OwnerAddress,',','.') ,2),
PARSENAME(Replace(OwnerAddress,',','.') ,1)
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.') ,3)



Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.') ,2)



Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);


Update NashvilleHousing
Set OwnerSplitState =PARSENAME(Replace(OwnerAddress,',','.') ,1)


Select *
From PortfolioProject..NashvilleHousing


---Changes Y and N to Yes and No in "Sold as vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group By SoldAsVacant
Order By 2



Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THen 'No'
		Else SoldAsVacant
		End
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THen 'No'
		Else SoldAsVacant
		End



---Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(Partition BY ParcelID,
								Propertyaddress,
									SalePrice,
									SaleDate,
									LegalReference
									ORDER BY 
										UniqueID
										) row_num
From PortfolioProject..NashvilleHousing
--Order BY ParcelID
--Where row_num > 1
)
Select *
From RowNumCTE
Where Row_num > 1
Order By PropertyAddress




---Delete Unsed Columns


Select *
From PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
Drop Column SaleDate