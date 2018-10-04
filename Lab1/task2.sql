
\echo *** Task 2.1 *** 

CREATE VIEW isbn_and_title AS
  SELECT isbn, title
  FROM editions, books
  WHERE editions.book_id = books.book_id;
DROP VIEW isbn_and_title;

\echo *** Task 2.2 *** \echo

INSERT INTO editions(isbn, book_id, edition, publisher_id, publication_date)
VALUES ('5555', 12345, 1, 59, '2012-12-02');

/*ERROR: insert or update on table "editions" violates foreign key constraint "editions_book_id_fkey"
  DETAIL: Key (book_id)=(12345) is not present in table "books".
  COMMENT: book_id must exist in books, before an editions of this book can be inserted*/

\echo *** Task 2.3 *** 

INSERT INTO editions(isbn)
VALUES ('5555');

/*ERROR: new row for relation "editions" violates check constraint "integrity"
  DETAIL: Failing row contains (5555, null, null, null, null).
  COMMENT: from create.sql it is stated that book_id and edition cannot be NULL*/

\echo *** Task 2.4 *** 

INSERT INTO books(book_id,title)
VALUES (12345, 'How I Insert');
INSERT INTO editions(isbn, book_id, edition, publisher_id, publication_date)
VALUES ('5555', 12345, 1, 59, '2012-12-02');
SELECT *
FROM books;

/*Author and subject can be NULL*/

\echo *** Task 2.5 *** 
/*SELECT *
FROM subjects;*/

UPDATE books
SET subject_id = 10 -- subject_id = 10 refers to mystery subject 
WHERE book_id = 12345;

/*SELECT *
FROM subjects;*/

\echo *** Task 2.6 *** 

DELETE FROM books
WHERE book_id = 12345;

/*ERROR: update or delete on table "books" violates foreign key constraint "editions_book_id_fkey" on table "editions"
  DETAIL: Key (book_id)=(12345) is still referenced from table "editions".
  COMMENT: book_id still exists in "editions" table, it has to be deleted in the right order from both tables*/

\echo *** Task 2.7 *** 

DELETE FROM editions
WHERE book_id = 12345;
DELETE FROM books
WHERE book_id = 12345;
SELECT *
FROM books;

\echo *** Task 2.8 *** 

INSERT INTO books(book_id,title,subject_id) 
VALUES(12345,'How I Insert',3443);
/* ERROR: insert or update on table "books" violates foreign key constraint "books_subject_id_fkey"
   DETAIL: Key (subject_id)=(3443) is not present in table "subjects".
   COMMENT: subject_id must be first updated in the table "subjects" (if it doesnt exist already) and then in the "books" table*/

\echo *** Task 2.9 *** 

ALTER TABLE books ADD CONSTRAINT hasSubject
	CHECK (subject_id IS NOT NULL);

\echo A book can be inserted with NULL author_id and NOT NULL subject_id \echo

INSERT INTO subjects(subject_id)
VALUES(99);
INSERT INTO books(book_id, title,subject_id)
VALUES (12321,'test',99);
SELECT *
/*FROM subjects;
SELECT *
FROM books;*/

DELETE FROM books
WHERE subject_id = 99;
DELETE FROM subjects
WHERE subject_id = 99;

/*SELECT *
FROM subjects;
SELECT *
FROM books;*/


\echo A book cannot be inserted with NULL subject_id \echo

INSERT INTO books(book_id, title)
VALUES (12321,'test');

ALTER TABLE books DROP CONSTRAINT hasSubject;
