USE publications;
SELECT 
    authors.au_id AS Author_ID,
    titles.title_id AS Title_ID,
    (titles.price * sales.qty * (titles.royalty / 100) *( titleauthor.royaltyper / 100)) AS sales_royalty
FROM
    sales
        INNER JOIN
    titleauthor ON titleauthor.title_id = sales.title_id
        INNER JOIN
    titles ON titles.title_id = sales.title_id
        INNER JOIN
    authors ON titleauthor.au_id = authors.au_id
ORDER BY sales_royalty DESC
