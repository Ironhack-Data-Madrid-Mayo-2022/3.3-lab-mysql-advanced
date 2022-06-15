-- Challenge 1 - Most Profiting Authors

-- Step 1: Calculate the royalties of each sales for each author

select tas.title_id, au_id, royaltyper, qty, royalty, price, (qty*price*royalty/100)*royaltyper/100 as royalties_sales_au
from (select ta.title_id, au_id, royaltyper, qty
		from titleauthor as ta
		left join sales as s
		on ta.title_id=s.title_id) as tas
left join titles as t
on tas.title_id=t.title_id 
order by royalties_sales_au desc;



-- Step 2: Aggregate the total royalties for each title for each author

select tast.title_id, au_id, royaltyper, qty, royalty, price, sum(royalties_sales_au) as sum_royalties_sales_au
from (select tas.title_id, au_id, royaltyper, qty, royalty, price, (qty*price*royalty/100)*royaltyper/100 as royalties_sales_au
from (select ta.title_id, au_id, royaltyper, qty
		from titleauthor as ta
		left join sales as s
		on ta.title_id=s.title_id) as tas
left join titles as t
on tas.title_id=t.title_id 
order by royalties_sales_au desc) as tast
group by tast.title_id, au_id
order by sum_royalties_sales_au desc;   



-- Step 3: Calculate the total profits of each author  

select au_id, (advance_au + sum_royalties_sales_au) as Total
from (select tast.title_id, au_id, royaltyper, qty, royalty, price, advance, sum(royalties_sales_au) as sum_royalties_sales_au, (advance*royaltyper)/100 as advance_au
		from (select tas.title_id, au_id, royaltyper, qty, royalty, price, advance, (qty*price*royalty/100)*royaltyper/100 as royalties_sales_au
			  from (select ta.title_id, au_id, royaltyper, qty
						from titleauthor as ta
						left join sales as s
						on ta.title_id=s.title_id) as tas
			  left join titles as t
			  on tas.title_id=t.title_id 
			  order by royalties_sales_au desc) as tast
		group by tast.title_id, au_id
		order by sum_royalties_sales_au desc) tastr
group by au_id
order by Total desc
limit 3;



-- Challenge 2 - Alternative Solution

-- Step 1: Calculate the royalties of each sales for each author

create temporary table titleauthor_sales
select ta.title_id, au_id, royaltyper, qty
		from titleauthor as ta
		left join sales as s
		on ta.title_id=s.title_id;

select tas.title_id, au_id, royaltyper, qty, royalty, price, (qty*price*royalty/100)*royaltyper/100 as royalties_sales_au
from titleauthor_sales as tas
left join titles as t
on tas.title_id=t.title_id 
order by royalties_sales_au desc;



-- Step 2: Aggregate the total royalties for each title for each author

create temporary table titleauthor_sales_titles
select tas.title_id, au_id, royaltyper, qty, royalty, price, (qty*price*royalty/100)*royaltyper/100 as royalties_sales_au
from titleauthor_sales as tas
left join titles as t
on tas.title_id=t.title_id 
order by royalties_sales_au desc;


select tast.title_id, au_id, royaltyper, qty, royalty, price, sum(royalties_sales_au) as sum_royalties_sales_au
from titleauthor_sales_titles as tast
group by tast.title_id, au_id
order by sum_royalties_sales_au desc;


-- Step 3: Calculate the total profits of each author

create temporary table titleauthor_sales_titles2
select tast.title_id, au_id, royaltyper, qty, royalty, price, advance, sum(royalties_sales_au) as sum_royalties_sales_au, (advance*royaltyper)/100 as advance_au
		from (select tas.title_id, au_id, royaltyper, qty, royalty, price, advance, (qty*price*royalty/100)*royaltyper/100 as royalties_sales_au
			  from (select ta.title_id, au_id, royaltyper, qty
						from titleauthor as ta
						left join sales as s
						on ta.title_id=s.title_id) as tas
			  left join titles as t
			  on tas.title_id=t.title_id 
			  order by royalties_sales_au desc) as tast
		group by tast.title_id, au_id
		order by sum_royalties_sales_au desc;

select au_id, (advance_au + sum_royalties_sales_au) as Total
from titleauthor_sales_titles2 as tastr
group by au_id
order by Total desc
limit 3;


-- Challenge 3

create table most_profitable_authors as 
select au_id, (advance_au + sum_royalties_sales_au) as Total
from (select tast.title_id, au_id, royaltyper, qty, royalty, price, advance, sum(royalties_sales_au) as sum_royalties_sales_au, (advance*royaltyper)/100 as advance_au
		from (select tas.title_id, au_id, royaltyper, qty, royalty, price, advance, (qty*price*royalty/100)*royaltyper/100 as royalties_sales_au
			  from (select ta.title_id, au_id, royaltyper, qty
						from titleauthor as ta
						left join sales as s
						on ta.title_id=s.title_id) as tas
			  left join titles as t
			  on tas.title_id=t.title_id 
			  order by royalties_sales_au desc) as tast
		group by tast.title_id, au_id
		order by sum_royalties_sales_au desc) tastr
group by au_id
order by Total desc
limit 3;