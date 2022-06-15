#CHALLENGE1
#Step 1: Calculate the royalties of each sales for each author
SELECT 
        s.title_id as TITLE_ID,
        a.au_id as AUTHOR_ID,
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



#Step 2: Aggregate the total royalties for each title for each author
SELECT  TITLE_ID,
		AUTHOR_ID,
        sum(sales_royalty) as total_royalties
FROM(
SELECT 
        s.title_id as TITLE_ID,
        a.au_id as AUTHOR_ID,
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
order by sales_royalty DESC) AS output1
GROUP BY TITLE_ID, AUTHOR_ID;


#STEP3
SELECT  AUTHOR_ID,
		last_name,
        first_name,
        round(sum((sales_royalty) + (advanced*(royaltyper_/100))),2) PROFIT
FROM(
SELECT 
        t.advance as advanced,
        a.au_lname as first_name,
        a.au_fname as last_name,
        ta.royaltyper as royaltyper_,
        s.title_id as TITLE_ID,
        a.au_id as AUTHOR_ID,
        round((t.price * qty * t.royalty/100 * ta.royaltyper/100),2) as sales_royalty
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
order by sales_royalty DESC) as output1
GROUP BY AUTHOR_ID
order by PROFIT DESC
LIMIT 3;

-------------------------
#CHALLENGE2 





----------------------
#CHALLENGE3. CREATE TABLE
CREATE TABLE most_profiting_authors AS
	SELECT  AUTHOR_ID,
        round(sum((sales_royalty) + (advanced*(royaltyper_/100))),2) PROFIT
	FROM(
	SELECT 
			t.advance as advanced,
			a.au_lname as first_name,
			a.au_fname as last_name,
			ta.royaltyper as royaltyper_,
			s.title_id as TITLE_ID,
			a.au_id as AUTHOR_ID,
			round((t.price * qty * t.royalty/100 * ta.royaltyper/100),2) as sales_royalty
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
	order by sales_royalty DESC) as output1
	GROUP BY AUTHOR_ID
	order by PROFIT DESC
	LIMIT 3;