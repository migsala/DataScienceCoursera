
--*****************************************************************************************---
--------------------------------------- REGISTRANTS 2014---------------------------------------------
--*****************************************************************************************---


--Registrations----


SELECT 

c.[Customer RBA Number],
c.[Registrant Full Name],
c.[Registrant Country Name],
c.[Registrant Prov State Name],
c.[Registrant Prov State],
c.[Registrant Postal Code],
c.[Registrant City],
c.[Registrant Address Line 1],
c.[Registrant Company Name],
c.[Registrant Bus Tel Country Code],
c.[Registrant Bus Tel Area Code],
c.[Registrant Bus Tel Number],
c.[Registrant Bus Tel Number Ext],
c.[Registrant Email],
c.[Registrant Method],
c.[Customer Prev Registered Date],
c.[Customer Prev Purchased Date],
c.[Customer Prev Auctions As Registrant],
c.[Customer Prev Auctions As Buyer],
c.[Customer Prev Auctions As Seller],
e.[Customer Industry Category],
b.[Auction Year],
b.[Auction Country],
b.[Auction Event Name],
b.[Auction Number],
b.[Auction Date]

--into #temp1

FROM

[Fact].[Auction_Registration] a
LEFT JOIN edw.[Dim].[Auction] b                          ON a.[Auction Key] = b.[Auction Key]
LEFT JOIN [Dim].[Registrant] c							 ON a.[Registrant Key] = c.[Registrant Key]
--LEFT JOIN edw.[Dim].[Customer_Auction] d                 ON a.[Customer Auction Key] = d.[Customer Auction Key]
LEFT JOIN edw.[Dim].[Customer] e                         ON c.[Customer RBA Number] = e.[Customer RBA Number] 


WHERE

b.[Auction Category] = 'Include'
AND b.[Auction Year] = '2013' 
AND [Registrant Country] in ('USA','CAN')
AND [Customer Prev Auctions As Buyer] = 0
AND c.[Customer RBA Number] <> 0
AND e.[Customer Industry Category] <> 'Transportation'


GROUP BY

c.[Customer RBA Number],
c.[Registrant Full Name],
c.[Registrant Country Name],
c.[Registrant Prov State Name],
c.[Registrant Prov State],
c.[Registrant Postal Code],
c.[Registrant City],
c.[Registrant Address Line 1],
c.[Registrant Company Name],
c.[Registrant Bus Tel Country Code],
c.[Registrant Bus Tel Area Code],
c.[Registrant Bus Tel Number],
c.[Registrant Bus Tel Number Ext],
c.[Registrant Email],
c.[Registrant Method],
c.[Customer Prev Registered Date],
c.[Customer Prev Purchased Date],
c.[Customer Prev Auctions As Registrant],
c.[Customer Prev Auctions As Buyer],
c.[Customer Prev Auctions As Seller],
e.[Customer Industry Category],
b.[Auction Year],
b.[Auction Country],
b.[Auction Event Name],
b.[Auction Number],
b.[Auction Date]

order by  c.[Customer RBA Number], e.[Customer Industry Category] desc






--Purchases---


SELECT 

a.[Customer RBA Number],
[Customer Full Name],
[Customer Country Name],
[Customer Prov State],
[Customer City],
[Customer Address1],
[Customer Postal Code],
[Customer Company Name],
[Customer Primary Tel Country Code],
[Customer Primary Tel Area Code],
[Customer Primary Tel Number],
[Customer Email Address],
[Customer Business Type],
[Customer Industry Category],
b.[Auction Year],
b.[Auction Country],
b.[Auction Event Name],
b.[Auction Number],
b.[Auction Date],
--[Customer Web Account Type],
--[Customer Web Account Effective Date],
--[Asset Group Code],
--[Asset Group Name],
--[Asset Manufacturer],
--[Asset Model],
--[Asset Year Of Manufacture],
--[Asset Serial Number],
--f.[Lot Number],
--[Asset Model Description],
--[Asset Comes With],
--[Asset Primary Industry],
--SUM(CAST([Total GAP USD_CAT] AS MONEY)) AS 'GAP' ,

SUM([Total GAP USD_CAT]) AS 'GAP' ,
SUM([# Lots Sold_CAT]) AS '# Lots'

--into #temp2

FROM


edw.[Fact].[Customer_Auction_Transaction] a
LEFT JOIN edw.[Dim].[Auction] b                          ON a.[Auction Key] = b.[Auction Key]
LEFT JOIN edw.[Dim].[Buyer_Seller] c                     ON a.[Buyer Seller Key] = c.[Buyer Seller Key]
LEFT JOIN edw.[Dim].[Customer_Auction] d                 ON a.[Customer Auction Key] = d.[Customer Auction Key]
LEFT JOIN edw.[Dim].[Customer] e                         ON d.[Customer RBA Number] = e.[Customer RBA Number]
LEFT JOIN edw.[Dim].[Lot] f                              ON a.[Lot Key] = f.[Lot Key]

WHERE

b.[Auction Category] = 'Include'
AND f.[Bidder Category] IN ('(C) >100','(B) =100')
AND [Auction Year] = '2013'
--AND b.[Auction Date] >= '2013-01-01' and b.[Auction Date] <= '2013-06-01'
AND c.[Buyer Seller Filter] = 'Buyers'
and [Auction Country] in ('USA', 'CAN')
and [Customer Industry Category] <> 'Transportation'

GROUP BY

a.[Customer RBA Number],
[Customer Full Name],
[Customer Country Name],
[Customer Prov State],
[Customer City],
[Customer Address1],
[Customer Postal Code],
[Customer Company Name],
[Customer Primary Tel Country Code],
[Customer Primary Tel Area Code],
[Customer Primary Tel Number],
[Customer Email Address],
[Customer Business Type],
[Customer Industry Category],
b.[Auction Year],
b.[Auction Country],
b.[Auction Event Name],
b.[Auction Number],
b.[Auction Date]
--[Customer Web Account Type],
--[Customer Web Account Effective Date]
--[Asset Group Code],
--[Asset Group Name],
--[Asset Manufacturer],
--[Asset Model],
--[Asset Year Of Manufacture],
--[Asset Serial Number],
--f.[Lot Number],
--[Asset Model Description],
--[Asset Comes With],
--[Asset Primary Industry]


having sum([Total GAP USD_CAT]) <= 10000

order by a.[Customer RBA Number] desc



