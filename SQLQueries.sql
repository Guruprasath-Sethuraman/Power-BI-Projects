/*1 Perform a Spend Analysis in USD and Create Reports to Analyse Spend:
a) By Region, b) By Category, c) By Pipeline Category, d) By Financial Year, e) By FY Qtrs
f) By Weekday*/

--1a) By Region
	select
		R.[Region Category], 
		round(sum(p.Spend_Global_Currency * E.[Exchange Rate - USD]),0) as Sales_in_USD
	from PurchaseTable p
	left join RegionMappingTable R
	on R.Region = p.Region
	left join ExchangeRateTable E
	on E.[Global Currency] = p.Currency
	group by R.[Region Category];
 

--1b) By Category
	select
		C.Category, 
		round(sum(p.Spend_Global_Currency * E.[Exchange Rate - USD]),0) as Sales_in_USD
	from PurchaseTable p
	left join CategoriesTable C
	on C.Material_Group = p.Material_Group
	left join ExchangeRateTable E
	on E.[Global Currency] = p.Currency
	group by C.Category;

--1c) By Pipline Category
	select
		C.Pipeline_Category, 
		round(sum(p.Spend_Global_Currency * E.[Exchange Rate - USD]),0) as Sales_in_USD
	from PurchaseTable p
	left join CategoriesTable C
	on C.Material_Group = p.Material_Group
	left join ExchangeRateTable E
	on E.[Global Currency] = p.Currency
	group by C.Pipeline_Category;


--1d,e) By Financial Year & FY Qtrs

			select 
				C.[FY Name],
				C.[Qtr Name],
				round(sum(p.Spend_Global_Currency * E.[Exchange Rate - USD]),0) as Sales_in_USD
			from PurchaseTable p
			left join ExchangeRateTable E
			on p.Currency = E.[Global Currency]
			left join CalendarTable C
			on C.Date = p.PO_Date
			group by C.[FY Name], C.[Qtr Name]


--1e) By Weekday
			select 
				C.[Weekday Name],
				round(sum(p.Spend_Global_Currency * E.[Exchange Rate - USD]),0) as Sales_in_USD
			from PurchaseTable p
			left join ExchangeRateTable E
			on p.Currency = E.[Global Currency]
			left join CalendarTable C
			on C.Date = p.PO_Date
			group by C.[Weekday Name];
			
	
/*2. Analyse the % of US Spend to Total Spend 
(in USD - Refer table in Question 1) By Category*/

--step-1: Create total spend across All Region
with tbl1 as (select
		C.Category, 
		round(sum(p.Spend_Global_Currency * E.[Exchange Rate - USD]),0) as Total_Sales
	from PurchaseTable p
	left join CategoriesTable C
	on C.Material_Group = p.Material_Group
	left join ExchangeRateTable E
	on E.[Global Currency] = p.Currency
	left join RegionMappingTable R
	on R.Region = p.Region
	group by C.Category),

--step-2: Create total spend on USA Region
tbl2 as (select
		C.Category, 
		round(sum(p.Spend_Global_Currency * E.[Exchange Rate - USD]),0) as USA_Sales
	from PurchaseTable p
	left join CategoriesTable C
	on C.Material_Group = p.Material_Group
	left join ExchangeRateTable E
	on E.[Global Currency] = p.Currency
	left join RegionMappingTable R
	on R.Region = p.Region
	where R.[Region Category] ='USA Region'
	group by C.Category)
select 
	tbl1.category, tbl2.USA_Sales,tbl1.Total_Sales,concat(round(tbl2.USA_Sales*100/tbl1.Total_Sales,2),'%') as [% of US Spend]
from tbl2
join tbl1 on tbl1.category=tbl2.category


/*3. Report the Maximum and Minimum Order Values (Spend): by Category*/

with MnM as (select
				C.Category,
				round(p.Spend_Global_Currency * E.[Exchange Rate - USD],0) as Total_USD
			from PurchaseTable p
			left join ExchangeRateTable E
			on E.[Global Currency] = p.Currency
			left join CategoriesTable C
			on c.Material_Group = p.Material_Group
			)
select 
	MnM.Category, MAX(MnM.Total_USD) as [Max order values], MIN(MnM.Total_USD) [Min order values]
from MnM
group by MnM.Category

/*4 Report Processing Charges by Region. 
Processing Charges for Purchases are as follows

USD Value From	USD Value To	Processing Charges
 USD - 			 USD 1,000 		2%
 USD 1,000 		 USD 2,500 		3%
 USD 2,500 		 USD 5,000 		4%
 USD 5,000		 USD 10,000 	5%
 USD 10,000 	 USD 9,999,999 	6%
*/
--FIRST CREATE A FUNCTION FOR PRCESSING CHARGES
create function Processing_Charges(@Total_USD as float) returns float
as
begin
		declare @output as float;
		set @output = (case  when @Total_USD<1000 then @Total_USD *0.02
							when @Total_USD<2500 then @Total_USD *0.03
							when @Total_USD<5000 then @Total_USD *0.04
							when @Total_USD<10000 then @Total_USD *0.05
							else @Total_USD *0.06
							end)
		return @output;
end;

--Run function first; then Run below the query as follows:
			select
				R.[Region Category],
				round(sum(dbo.Processing_Charges(p.Spend_Global_Currency * E.[Exchange Rate - USD])),2) as Proessing_Charages
			from PurchaseTable p
			left join ExchangeRateTable E
			on E.[Global Currency] = p.Currency
			left join RegionMappingTable R
			on R.Region =p.Region
			group by R.[Region Category]

/*5. Purchases over USD 5,000 in Asia Region for category 
CAPITAL EQUIP & SERVICES or FINISHED PRODUCTS needs special approval.
Create a Special Approval Report showing number of special approval cases: By Category */

With SpecialApproval as (select 
			R.[Region Category],
			C.Category,
			round(p.Spend_Global_Currency * E.[Exchange Rate - USD],0) as Total_USD
		from PurchaseTable P
		left join ExchangeRateTable E
		on E.[Global Currency] = P.Currency
		left join CategoriesTable C
		on C.Material_Group = P.Material_Group
		left join RegionMappingTable R
		on R.Region =P.Region
		Where R.[Region Category] ='Asia Region' 
		and C.Category in ('CAPITAL EQUIP & SERVICES', 'FINISHED PRODUCTS')
		and round(p.Spend_Global_Currency * E.[Exchange Rate - USD],0)>=5000		
		)

select
	s.[Region Category], s.category, count(s.Total_USD) as Special_Approval_Cases
from SpecialApproval S
group by s.[Region Category], s.category;