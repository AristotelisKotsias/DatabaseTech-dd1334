SELECT
  last_name,
  first_name
FROM authors
WHERE author_id = (
  SELECT author_id
  FROM books
  WHERE title = 'The Shining'
);

SELECT title
FROM books
WHERE author_id = (
  SELECT author_id
  FROM authors
  WHERE first_name = 'Paulette' AND last_name = 'Bourgeois'
);

SELECT 
	last_name,
	first_name
FROM books
WHERE subject_id = 'Horror';