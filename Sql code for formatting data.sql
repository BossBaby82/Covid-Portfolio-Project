-- sql practise for data cleaning--


select * from nashvillehousingdata;

-- count rows to find out total data is imported n the database--

select count(UniqueID) from nashvillehousingdata;

-- Change saledate column data type-

alter table nashvillehousingdata add column SaleDate1 date;# [parsingtext="%Y-%m-%d %H:%M:%S"];
update nashvillehousingdata set SaleDate1 = STR_TO_DATE(SaleDate,'%d-%M-%Y') where UniqueID>1; 

alter table nashvillehousingdata
Drop column SaleDate1;

-- populate address data--(Using Join on the single table)


select PropertyAddress, ParcelID from nashvillehousingdata
order by ParcelID;

select PropertyAddress from nashvillehousingdata
where PropertyAddress is null;

------UPDATE nashvillehousingdata 
--set  PropertyAddress = (SELECT b.PropertyAddress
        FROM  nashvillehousingdata a
		JOIN nashvillehousingdata b 
        ON a.ParcelID = b.ParcelID
        WHERE a.UniqueID <> b.UniqueID 
        AND a.PropertyAddress IS NULL) ---
WHERE UniqueID IN (SELECT  a.UniqueID
        FROM nashvillehousingdata a
		JOIN nashvillehousingdata b ON a.ParcelID = b.ParcelID
        WHERE a.UniqueID <> b.UniqueID AND a.PropertyAddress IS NULL)---------
                
                
                
SELECT b.PropertyAddress,a.UniqueID
FROM nashvillehousingdata a
JOIN nashvillehousingdata b ON a.ParcelID = b.ParcelID
WHERE a.UniqueID <> b.UniqueID AND a.PropertyAddress IS NULL;


UPDATE nashvillehousingdata a
INNER JOIN nashvillehousingdata b 
ON (a.UniqueID != b.UniqueId
AND a.ParcelID = b.ParcelID
AND b.PropertyAddress IS NOT NULL
AND a.PropertyAddress IS NULL) 
SET 
a.PropertyAddress = b.PropertyAddress;

select * from nashvillehousingdata
where PropertyAddress is null;

-- Breaking Address column into different columns--

select PropertyAddress, OwnerAddress
from nashvillehousingdata;

--- select position('str' in 'akashstrpurvi')---

Alter table nashvillehousingdata
add column Country text;

update  nashvillehousingdata a
set Country = substring_index(OwnerAddress,',',-1)
where OwnerAddress is not null;

SELECT Country from nashvillehousingdata;

Alter table nashvillehousingdata
add column state text;

update  nashvillehousingdata a
set state = substring_index(OwnerAddress,',',-2)
where OwnerAddress is not null;

SELECT state from nashvillehousingdata;



update  nashvillehousingdata a
set state = substring_index(state,',',1)
where state is not null;

select country,OwnerAddress, state from nashvillehousingdata;



-- Change Y and N to Yes and No in "Sold as Vacant" field---

select SoldAsVacant from nashvillehousingdata;

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashvillehousingdata
group by SoldAsVacant
order by 2;

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
     end
from nashvillehousingdata;

update nashvillehousingdata
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
     end;
     
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashvillehousingdata
group by SoldAsVacant
order by 2;


-- Delete Unused Columns--

Select *
From nashvillehousingdata;

Alter table nashvillehousingdata
drop column PropertyAddress,
drop column state1,
drop column TaxDistrict;

show columns from nashvillehousingdata;

describe nashvillehousingdata;

--- Show Duplicates ----

SELECT UniqueID, COUNT(UniqueID) AS DuplicateRanks
FROM nashvillehousingdata
GROUP BY UniqueID
HAVING COUNT(UniqueID)>1;




