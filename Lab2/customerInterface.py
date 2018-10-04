#!/usr/bin/python

import pgdb
from sys import argv
#  The code should not allow the customer to find out other customers or other booktown data.
#  Security is taken as the customer knows his own customer_id, first and last names.  
#  So not really so great but it illustrates how one would check a password if there were the addition of encription.

#  Most of the code is here except those little pieces needed to avoid injection attacks.  
#  You might want to read up on pgdb, postgresql, and this useful function: pgdb.escape_string(some text)

#  You should also add exception handling.  Search WWW for 'python try' or 'exception' for things like:
#         try: 
#             ...
#         except (errorcode1, errorcode2,...):
#             ....
# A good tip is the error message you get when exceptions are not caught such as:
#  Traceback (most recent call last):
#  File "./customerInterface.py", line 105, in <module>
#    db.run()
#  File "./customerInterface.py", line 98, in run
#    actions[self.print_menu()-1]()
#  File "./customerInterface.py", line 68, in shipments
#    self.cur.execute(query)
#  File "/usr/lib/python2.6/dist-packages/pgdb.py", line 259, in execute
#    self.executemany(operation, (params,))
#  File "/usr/lib/python2.6/dist-packages/pgdb.py", line 289, in executemany
#    raise DatabaseError("error '%s' in '%s'" % (msg, sql))
# pg.DatabaseError: error 'ERROR:  syntax error at or near "*"
# LINE 1: SELECT * FROM * WHERE *
#
#  You should think "Hey this pg.DatabaseError (an error code) mentioned above could be caught at 
#  File "./customerInterface.py", line 68, in shipments  self.cur.execute(query) also mentioned above."
#  The only problem is the codes need to be pgdb. instead of the pg. shown in my output 
#  (I am not sure why they are different) so the code to catch is pgdb.DatabaseError.

class DBContext:

    def __init__(self): #PG-connection setup
        print("AUTHORS NOTE: If you submit faulty information here, I am not responsible for the consequences.")

        print "The idea is that you, the authorized database user, log in."
        print "Then the interface is available to customers whos should only be able to see their own shipments."
        params = {'host':'nestor2.csc.kth.se', 'user':raw_input("Username: "), 'database':'', 'password':raw_input("Password: ")}
        self.conn = pgdb.connect(**params)
        self.menu = ["Shipments Status", "Exit"]
        self.cur = self.conn.cursor()

    def print_menu(self):
        """Prints a menu of all functions this program offers.  Returns the numerical correspondant of the choice made."""
        for i,x in enumerate(self.menu):
            print("%i. %s"%(i+1,x))
        return self.get_int()

    def get_int(self):
        while True:
            try:
                choice = int(input("Choose: "))
                if 1 <= choice <= len(self.menu):
                    return choice
                print("Invalid choice.")
            except (NameError,ValueError, TypeError,SyntaxError):
                print("That was not a number, genious.... :(")
 
    def shipments(self):
        #Test input is ID=671, fname='Chuck', lname='Brown'
        try: 
            #Check that input is integer
            ID = int(raw_input("customerID: ")) 
        except (NameError, ValueError, TypeError, SyntaxError):
            print("Non numerical ID. Try again...")
            return;
        
        #Good against SQL injections attacks because escape characters are removed 
        fname = pgdb.escape_string(raw_input("First Name: ").strip())  
        lname = pgdb.escape_string(raw_input("Last Name: ").strip())    

        query = "SELECT first_name, last_name FROM customers WHERE customer_id = %s;" % ID
        print(query)
        print("------------------------------------------------------------")
        
        try:
            self.cur.execute(query)
        except (NameError,ValueError,TypeError,SyntaxError):
            print("Query execution failed.")
            return

        #fetchone() retrieves one result row for the query that was executed.
        #empty list (none) -> nothing was retrieved from the DB
        customer_list = self.cur.fetchone() 
        if customer_list is None:           
            print("Customer does not exist in DB")
            return
        else:
            if customer_list[0].lower() == fname.lower() and customer_list[1].lower() == lname.lower():
                print("Welcome %s %s" % (fname,lname))
            else:
                print("Name %s %s does not match %s" % (fname,lname,ID)) #ID exists but first name or/and last name are incorrect
                return

        #isbn alone is ambigous because it's a key to 2 tables (stock,shipments)
        #and for that reason it must be specified on which table the SQL should check
        query = """SELECT shipment_id,ship_date,shipments.isbn,title          
                   FROM Shipments                                   
                        JOIN editions ON shipments.isbn = editions.isbn
                        JOIN books ON editions.book_id = books.book_id
                    WHERE customer_id = %s; """ % ID   

        print("------------------------------------------------------------")
        try:
            self.cur.execute(query)
            print("Customer: %d | %s | %s" % (ID,fname,lname))
            print("shipment_id, ship_date, isbn, title")
            self.print_answer()
        except (NameError,ValueError,TypeError,SyntaxError):
            print("Query execution failed.")
            return
        print("------------------------------------------------------------\n")

    def exit(self):    
        self.cur.close()
        self.conn.close()
        exit()

    def print_answer(self):
            print("\n".join([", ".join([str(a) for a in x]) for x in self.cur.fetchall()]))

    def run(self):
        """Main loop.
        Will divert control through the DBContext as dictated by the user."""
        actions = [self.shipments, self.exit]
        while True:
            try:
                actions[self.print_menu()-1]()
            except IndexError:
                print("Bad choice")
                continue

if __name__ == "__main__":
    db = DBContext()
    db.run()
