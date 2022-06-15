#create temporary table from challenge1
CREATE TEMPORARY TABLE challenge_1
SELECT 
        s.title_id as TITLE_ID,
        a.au_id as AUTHOR_ID,
        ta.royaltyper as ROYALTYPER,
        qty as QUANTITY,
        t.price as PRICE,
        t.royalty as ROYALTY,
        t.advance as ADVANCED
        (t.price * qty * t.royalty/100 * ta.royaltyper/100) as sales_royalty
FROM sales as s
INNER JOIN 
	titleauthor as ta
	on ta.title_id = s.title_id
INNER JOIN 
	titles as t
    on 
    s.title_id = t.title_id
INNER JOIN
    authors a 
ON 
	ta.au_id = a.au_id
order by sales_royalty;



#create temporary table 2
CREATE TEMPORARY TABLE challenge_2
SELECT  TITLE_ID,
        sales_royalty,
		AUTHOR_ID,
        sum(sales_royalty) as total_royalties
FROM challenge_1
GROUP BY TITLE_ID, sales_royalty, AUTHOR_ID;



#create temporary table 3
CREATE TABLE most_profiting_authors_2 
	SELECT  AUTHOR_ID,
        round(sum((sales_royalty) + (advanced*(royaltyper_/100))),2) PROFIT
from challenge_2
	GROUP BY AUTHOR_ID
	order by PROFIT DESC
	LIMIT 3;