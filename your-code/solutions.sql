/* Challenge 1 */

/* Step 1 */

SELECT 
    t.title_id,
    a.au_id,
    t.advance,
    (t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS royalties
FROM
    sales s
        INNER JOIN
    titles t ON s.title_id = t.title_id
        INNER JOIN
    titleauthor ta ON ta.title_id = t.title_id
        INNER JOIN
    authors a ON ta.au_id = a.au_id;
    e_id INNER JOIN
    authors a ON ta.au_id = a.au_id;

/* Step 2 */

SELECT 
	t1.title_id, 
	t1.au_id,
    t1.advance,
    sum(t1.royalties) as royalties 
FROM (
	SELECT 
		t.title_id,
		a.au_id,
        t.advance,
		(t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS royalties
	FROM
		sales s
			INNER JOIN
		titles t ON s.title_id = t.title_id
			INNER JOIN
		titleauthor ta ON ta.title_id = t.title_id
			INNER JOIN
		authors a ON ta.au_id = a.au_id
	) AS t1
GROUP BY 
    t1.au_id, t1.title_id;

/* Step 3 */

SELECT 
	t2.au_id, 
    sum(t2.advance + t2.royalties) AS profits 
FROM (
	SELECT 
		t1.title_id, 
		t1.au_id, 
        t1.advance,
		sum(t1.royalties) as royalties 
	FROM (
		SELECT 
			t.title_id,
			a.au_id,
            t.advance,
			(t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS royalties
		FROM
			sales s
				INNER JOIN
			titles t ON s.title_id = t.title_id
				INNER JOIN
			titleauthor ta ON ta.title_id = t.title_id
				INNER JOIN
			authors a ON ta.au_id = a.au_id
		) AS t1
	GROUP BY 
        t1.au_id, t1.title_id
    ) AS t2
GROUP BY 
    t2.au_id
ORDER BY 
    profits DESC
LIMIT 3;



/* Challenge 2 */


CREATE TEMPORARY TABLE temp1    
	SELECT 
		t.title_id,
		a.au_id,
        t.advance,
		(t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS royalties
	FROM
		sales s
			INNER JOIN
		titles t ON s.title_id = t.title_id
			INNER JOIN
		titleauthor ta ON ta.title_id = t.title_id
			INNER JOIN
		authors a ON ta.au_id = a.au_id;


CREATE TEMPORARY TABLE temp2            
	SELECT 
		temp1.title_id, 
        temp1.au_id,
        SUM(temp1.royalties) AS sumRoyalties
	FROM
		temp1
	GROUP BY 
        temp1.au_id , temp1.title_id;
    

SELECT 
	temp2.au_id, 
    sum(t.advance + sumRoyalties) AS profits 
FROM
	temp2
		INNER JOIN 
	titles t on t.title_id = temp2.title_id
		INNER JOIN 
	authors a on a.au_id = temp2.au_id
GROUP BY 
    temp2.au_id
ORDER BY 
    profits DESC
LIMIT 3;



/* Challenge 3 */


CREATE TABLE most_profiting_authors (
	au_id VARCHAR(11) NOT NULL PRIMARY KEY,
	profits DECIMAL(10,2) NOT NULL
);

ALTER TABLE most_profiting_authors ADD FOREIGN KEY (au_id) REFERENCES authors(au_id) ON DELETE RESTRICT;



SET foreign_key_checks = 0;

INSERT INTO most_profiting_authors (au_id, profits)
SELECT 
        t2.au_id, 
        sum(t2.advance + t2.royalties) AS profits 
    FROM (
        SELECT 
            t1.title_id, 
            t1.au_id, 
            t1.advance,
            sum(t1.royalties) as royalties 
        FROM (
            SELECT 
                t.title_id,
                a.au_id,
                t.advance,
                (t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS royalties
            FROM
                sales s
                    INNER JOIN
                titles t ON s.title_id = t.title_id
                    INNER JOIN
                titleauthor ta ON ta.title_id = t.title_id
                    INNER JOIN
                authors a ON ta.au_id = a.au_id
            ) AS t1
        GROUP BY t1.au_id, t1.title_id
        ) AS t2
    GROUP BY t2.au_id
    ORDER BY profits DESC
    LIMIT 3	;

SET foreign_key_checks = 1;

SELECT 
	* 
FROM 
	most_profiting_authors;