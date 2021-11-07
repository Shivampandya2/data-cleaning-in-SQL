Select * 
From portfolio_project_1..Neshville
-----------------------------------------------------------------
--Formating Sale date

Select SaleDateConverted, CONVERT(date,SaleDate) as SaleDateConverted
From portfolio_project_1..Neshville

Update Neshville
Set SaleDate = Convert (Date, SaleDate)

ALTER TABLE Neshville
Add SaleDateConverted Date

Update Neshville
SET SaleDateConverted = CONVERT(Date,SaleDate)

-----------------------------------------------------------------------
--Populate Property address 
Select *
From portfolio_project_1..Neshville
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From portfolio_project_1..Neshville a
	Join portfolio_project_1..Neshville b
On a.ParcelID = b.parcelID 
And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null 

Update a
Set PropertyAddress  = ISNULL (a.PropertyAddress, b.PropertyAddress)
From portfolio_project_1..Neshville a
	Join portfolio_project_1..Neshville b
On a.ParcelID = b.parcelID 
And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null 
	

--------------------------------------------------------
--Breaking out Address into Individual Columns Like Address, City, State 
Select PropertyAddress
From portfolio_project_1..Neshville

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From portfolio_project_1..Neshville

ALTER TABLE Neshville
Add PropertySplitAddress Nvarchar(255);

Update Neshville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Neshville
Add PropertySplitCity Nvarchar (50)

Update Neshville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select * 
From portfolio_project_1..Neshville


-------------------------------------------------------------
--For proerty owner address 
Select OwnerAddress
From portfolio_project_1..Neshville

Select 
Parsename (Replace(OwnerAddress, ',', '.'), 3),
Parsename (Replace(OwnerAddress, ',', '.'),2),
Parsename (Replace(OwnerAddress, ',', '.'),1)
From portfolio_project_1..Neshville


ALTER TABLE Neshville
Add OwnerSplitAddress Nvarchar(255);

Update Neshville
SET OwnerSplitAddress = Parsename (Replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE Neshville
Add OwnerSplitCity1  Nvarchar (255);

Update Neshville
SET OwnerSplitCity1 = Parsename (Replace(OwnerAddress, ',', '.'),2)

ALTER TABLE Neshville
Add PropertySplitState Nvarchar(55);

Update Neshville
SET PropertySplitState = Parsename (Replace(OwnerAddress, ',', '.'),1)


-------------------------------------------------------------------
--Change y/nto Yes and No In "Sold as Vacant" Field 

Select Distinct (SoldAsVacant), Count (SoldAsVacant)
From portfolio_project_1..Neshville
Group by SoldAsVacant
Order By 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
From portfolio_project_1..Neshville

Update Neshville
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End


---------------------------------------------------------------
--Remove Duplicates 

With RowNumCTE As (
Select * , 
	Row_Number() Over (
	Partition By ParcelID, 
				PropertyAddress,
				SalePrice, 
				SaleDate,
				LegalReference
				Order By UniqueID) row_num

From portfolio_project_1..Neshville
)
Delete 
From RowNumCTE
Where row_num > 1 


---------------------------------------------------
--DeleteUnused Cols 

Select *
From portfolio_project_1..Neshville

Alter Table portfolio_project_1..Neshville
Drop Column  OwnerAddress, OwnerSplitCity, TaxDistrict, PropertyAddress, SaleDate

--DONE DATA CLEANING 
------------------------------------------------------------

--NUMBER OF PROPERTY SOLD BY CITY 
Select PropertySplitCity,  Count(PropertySplitCity) as NumberOfProperties
From portfolio_project_1..Neshville
Group by PropertySplitCity

-----------------------------------------------------
--Number of Property Sold by year

Select Year(SaleDateConverted), Count (*) as PropertySold
From portfolio_project_1..Neshville
Where Year(SaleDateConverted) = 2013
Or Year(SaleDateConverted) = 2014
Or Year(SaleDateConverted) = 2015
Or Year(SaleDateConverted) = 2016
Group by Year(SaleDateConverted)

-----------------------------------------------------

-- Number of Property Sold by month
Select Year(SaleDateConverted), Count (*) as Propertysold
From portfolio_project_1..Neshville
Where Year(SaleDateConverted) = 2013
AND(Month (SaleDateConverted) = 01
OR Month (SaleDateConverted) = 02
OR Month (SaleDateConverted) = 03
OR Month (SaleDateConverted) = 04
OR Month (SaleDateConverted) = 05
OR Month (SaleDateConverted) = 06
OR Month (SaleDateConverted) = 07
OR Month (SaleDateConverted) = 08
OR Month (SaleDateConverted) = 09
OR Month (SaleDateConverted) = 10
OR Month (SaleDateConverted) = 11
OR Month (SaleDateConverted) = 12 )
Group by Year(SaleDateConverted),Month (SaleDateConverted)

 























