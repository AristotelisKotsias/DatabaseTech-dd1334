DROP FUNCTION decstock() CASCADE;

CREATE FUNCTION decstock() RETURNS trigger AS $pname$
	BEGIN
		IF (SELECT stock
		    FROM stock
		    WHERE stock.isbn = NEW.isbn) = 0
		THEN
			RAISE EXCEPTION 'There is no stock to ship'
		ELSE
			UPDATE stock
			SET stock = stock - 1
			WHERE stock.isbn = new.isbn
		END IF;
		RETURN NEW;
	END;

$pname$ LANGUAGE plpgsql;

CREATE TRIGGER stockTrigger
AFTER INSERT ON shipments
FOR EACH ROW 
EXECUTE PROCEDURE decstock();

