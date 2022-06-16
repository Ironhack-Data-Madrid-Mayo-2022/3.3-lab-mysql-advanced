#Step 1: Calculate the royalties of each sales for each author
select t.title_id, au_id, round((t.price * s.qty * t.royalty/100 * ta.royaltyper/100)) as sales_royalty from titles as t
inner join titleauthor as ta
on ta.title_id = t.title_id
inner join sales as s
on s.title_id = ta.title_id

