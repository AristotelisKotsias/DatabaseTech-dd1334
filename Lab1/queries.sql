
\echo *** Task 1.1 *** 

SELECT
  last_name,
  first_name
FROM authors
WHERE author_id = (
  SELECT author_id
  FROM books
  WHERE title = 'The Shining'
);

\echo *** Task 1.2 *** 

SELECT title
FROM books
WHERE author_id = (
  SELECT author_id
  FROM authors
  WHERE first_name = 'Paulette' AND last_name = 'Bourgeois'
);

\echo *** Task 1.3 *** 

SELECT last_name, first_name
FROM customers
WHERE customer_id IN (
	SELECT customer_id
	FROM shipments
	WHERE isbn IN (
		SELECT isbn
		FROM editions
		WHERE book_id IN (
			SELECT book_id
			FROM books
			WHERE subject_id IN (
				SELECT subject_id
				FROM subjects
				WHERE subject = 'Horror'
			)
		)
	)
);

\echo *** Task 1.4 *** 

SELECT title
FROM books
WHERE book_id = (
	SELECT book_id
	FROM editions
	WHERE isbn = (
		SELECT isbn
		FROM stock
		WHERE stock = (					-- WHERE stock = max(stock) is forbidden because aggregate functions are not allowed in WHERE 
			SELECT max(stock)
			FROM stock
		)												
	)	
);

\echo *** Task 1.4 (2d solution) *** 

SELECT title
FROM books
	INNER JOIN editions ON books.book_id = editions.book_id
	INNER JOIN stock ON editions.isbn = stock.isbn
WHERE stock = ( 
	SELECT max(stock)
	FROM stock
);	

\echo *** Task 1.5 *** 

SELECT SUM(retail_price)
FROM stock
	INNER JOIN editions ON stock.isbn = editions.isbn
	INNER JOIN books ON editions.book_id = books.book_id 
	INNER JOIN subjects ON books.subject_id = subjects.subject_id
WHERE subject = 'Science Fiction';

\echo *** Task 1.6 *** 

SELECT title
FROM books
	INNER JOIN editions ON books.book_id = editions.book_id
	INNER JOIN shipments ON editions.isbn = shipments.isbn
GROUP BY books.title
HAVING COUNT(customer_id) = 2;			-- The HAVING clause is used because the WHERE keyword cannot be used with aggregate functions --

\echo *** Task 1.7 *** 

--> TODO <--
/*SELECT name, MAX(cost)
FROM publishers
	INNER JOIN editions ON publishers.publisher_id = editions.publisher_id
	INNER JOIN stock ON editions.isbn = stock.isbn
GROUP BY publishers.name ORDER BY SUM(cost) DESC LIMIT 1;*/

\echo *** Task 1.8 *** 

SELECT SUM(retail_price - cost)
FROM shipments,stock
WHERE shipments.isbn = stock.isbn;

\echo *** Task 1.9 *** 

SELECT last_name, first_name
FROM customers
	INNER JOIN shipments ON customers.customer_id = shipments.customer_id
	INNER JOIN editions ON shipments.isbn = editions.isbn
	INNER JOIN books ON editions.book_id = books.book_id
	INNER JOIN subjects ON books.subject_id = subjects.subject_id
GROUP BY customers.last_name, customers.first_name
HAVING COUNT(subjects.subject_id) > 2;

\echo *** Task 1.10 *** 

SELECT subject
FROM subjects
WHERE subject NOT IN (
	SELECT DISTINCT subject
	FROM shipments, editions, books, subjects
  	WHERE (shipments.isbn = editions.isbn
        AND editions.book_id = books.book_id
        AND books.subject_id = subjects.subject_id
	)
);
