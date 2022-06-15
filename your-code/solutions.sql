/*Challenge 1 - Most Profiting Authors

Step 1: Calculate the royalties of each sales for each author*/

select titleauthor.title_id as Title_ID, 
authors.au_id as Author_ID, 
(t.price * s.qty * (t.royalty / 100) * (titleauthor.royaltyper / 100)) as Royalty_Author
from publications.authors
inner join titleauthor
on authors.au_id= titleauthor.au_id
inner join titles as t
on titleauthor.title_id= t.title_id
inner join sales as s
on t.title_id = s.title_id
order by Royalty_Author desc;


/*Step 2: Aggregate the total royalties for each title for each author*/

select Author_ID, Title_ID, sum(Royalty_Author) as aggregated_royalty
from (select titleauthor.title_id as Title_ID, authors.au_id as Author_ID, 
(t.price * s.qty * (t.royalty / 100) * (titleauthor.royaltyper / 100)) as Royalty_Author
from publications.authors
inner join titleauthor
on authors.au_id= titleauthor.au_id
inner join titles as t
on titleauthor.title_id= t.title_id
inner join sales as s
on t.title_id = s.title_id
order by Royalty_Author desc) as suma
group by Title_ID, Author_ID
ORDER BY aggregated_royalty desc; 


/*Step 3: Calculate the total profits of each author*/

select Author_ID, sum(aggregated_royalty) + adv/count(Title_ID) as Profits
from (select Title_ID, Author_ID, sum(Royalty_Author) as aggregated_royalty, adv
from (select titleauthor.title_id as Title_ID, titleauthor.au_id as Author_ID,
	titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS Royalty_Author,
	titles.advance as adv
from titleauthor
inner join titles
on titleauthor.title_id = titles.title_id
inner join sales
on titleauthor.title_id = sales.title_id) suma
group by Title_ID, adv, Author_ID) tabla
group by Author_ID, Title_ID
order by aggregated_royalty desc
limit 3;