USE publications;
SELECT 
    Author_ID, Title_ID, sum(sales_royalty) AS Royaltys
FROM
    (SELECT 
		titleauthor.title_id AS Title_ID,
            authors.au_id AS Author_ID,
            titles.advance AS Advance,
            round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS 'sales_royalty'
    FROM
        titleauthor
    INNER JOIN authors ON authors.au_id = titleauthor.au_id
    INNER JOIN sales ON sales.title_id = titleauthor.title_id
    INNER JOIN titles ON titles.title_id = titleauthor.title_id) AS AntiguaTabla
group by Title_ID, Author_ID
order by Royaltys

	


