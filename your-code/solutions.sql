-- Challenge 1
-- Step 1

SELECT 
    titleauthor.title_id AS Title_ID,
    authors.au_id AS Author_ID,
    ROUND(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalties
FROM
    titleauthor
        INNER JOIN
    authors ON authors.au_id = titleauthor.au_id
        INNER JOIN
    sales ON sales.title_id = titleauthor.title_id
        INNER JOIN
    titles ON titles.title_id = sales.title_id
ORDER BY Royalties DESC;

-- Step 2
SELECT 
    Title_ID, Author_Id, SUM(Royalties) AS Sum_Aggregated
FROM
    (SELECT 
        titleauthor.title_id AS Title_ID,
            authors.au_id AS Author_ID,
            ROUND(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalties
    FROM
        titleauthor
    INNER JOIN authors ON authors.au_id = titleauthor.au_id
    INNER JOIN sales ON sales.title_id = titleauthor.title_id
    INNER JOIN titles ON titles.title_id = sales.title_id) AS Tabla
GROUP BY Title_ID , Author_ID
ORDER BY Sum_Aggregated DESC;

-- Step 3
SELECT 
    Title_ID, Author_Id, SUM(Royalties) AS Sum_Aggregated
FROM
    (SELECT 
        titleauthor.title_id AS Title_ID,
            authors.au_id AS Author_ID,
            ROUND(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalties
    FROM
        titleauthor
    INNER JOIN authors ON authors.au_id = titleauthor.au_id
    INNER JOIN sales ON sales.title_id = titleauthor.title_id
    INNER JOIN titles ON titles.title_id = sales.title_id) AS Tabla
GROUP BY Title_ID , Author_ID
ORDER BY Sum_Aggregated DESC;
