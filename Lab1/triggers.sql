--DROP FUNCTION decstock() CASCADE;

--Creating the trigger function
CREATE FUNCTION decstock() RETURNS trigger AS $pname$
	BEGIN
		IF (SELECT stock
		    FROM stock
		    WHERE stock.isbn = NEW.isbn) = 0
			THEN RAISE EXCEPTION 'There is no stock to ship';
		ELSE
			UPDATE stock
			SET stock = stock - 1
			WHERE stock.isbn = new.isbn;
		END IF;
		RETURN NEW;
	END;

$pname$ LANGUAGE plpgsql;

--Creating the trigger
CREATE TRIGGER stockTrigger --Create trigger
	BEFORE INSERT ON shipments --Clause to indicate that the trigger uses DB state BEFORE the trig. event
	FOR EACH ROW --Trigger executes for every row
	EXECUTE PROCEDURE decstock(); --Action 

\echo *** Display stock table before making shipments *** 

SELECT *
FROM stock;

\echo *** Ship a book that is not in stock *** 

INSERT INTO shipments
VALUES (2000, 860, '0394900014', '2012-12-07');

\echo *** Ship a book that is in stock *** 

INSERT INTO shipments
VALUES (2001, 860, '044100590X', '2012-12-07'); 

SELECT *
FROM shipments
WHERE shipment_id > 1999;

\echo *** Display stock table ***

SELECT *
FROM stock;

\echo *** Restore database to its original state ***

DELETE FROM shipments
WHERE shipment_id > 1999;
UPDATE stock
SET stock = 89
WHERE isbn = '044100590X';

DROP FUNCTION decstock() CASCADE;