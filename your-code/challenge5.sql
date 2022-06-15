create table most_profiting_authors as SELECT 
    Author_ID, Title_ID, sum((sales_royalty)+(Advance*(ROYALTYPER/100))) PROFIT
FROM
    (SELECT 
		titleauthor.title_id AS Title_ID,
            authors.au_id AS Author_ID,
            titles.advance AS Advance,
            titleauthor.royaltyper as ROYALTYPER,
            round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
    FROM
        titleauthor
    INNER JOIN authors ON authors.au_id = titleauthor.au_id
    INNER JOIN sales ON sales.title_id = titleauthor.title_id
    INNER JOIN titles ON titles.title_id = titleauthor.title_id
    ) AS AntiguaTabla
group by Author_ID
order by PROFIT desc
Limit 3;
