#!/usr/bin/python

# When you import the pgdb  module, all the
# classes and functions in that module become available for you to
# use.  For example you can now use the pgdb.connect() function to
# establish a connection to your copy of the database. 

import pgdb
from sys import argv

class DBContext:

    def __init__(self): 
        print("AUTHORS NOTE: If you submit faulty information here, I am not responsible for the consequences.")

        params = {'host':'nestor2.csc.kth.se', 'user':raw_input("Username: "), 'database':raw_input("Database: "), 'password':raw_input("Password: ")}
        self.conn = pgdb.connect(**params)
        self.menu = ["Select.", "Insert.", "Remove.", "Exit"]
        self.cur = self.conn.cursor()

    def print_menu(self):
        """Prints a menu of all functions this program offers.  Returns the numerical correspondant of the choice made."""
        for i,x in enumerate(self.menu):
            print("%i. %s"%(i+1,x))
        return self.get_int()

    def get_int(self):
        """Retrieves an integer from the user.
        If the user fails to submit an integer, it will reprompt until an integer is submitted."""
        while True:
          #  The try statement works as follows.  First, the try
          #  clause (the statement(s) between the try and except
          #  keywords) is executed. If no exception occurs, the except
          #  clause is skipped and execution of the try statement is
          #  finished. If an exception occurs during execution of the
          #  try clause, the rest of the clause is skipped. Then if
          #  its type matches the exception named after the except
          #  keyword, the except clause is executed, and then
          #  execution continues after the try statement.  If an
          #  exception occurs which does not match the exception named
          #  in the except clause, it is passed on to outer try
          #  statements; if no handler is found, it is an unhandled
          #  exception and execution stops with a message as shown
          #  above.
            try:
                choice = int(input("Choose: "))
                if 1 <= choice <= len(self.menu):
                    return choice
                # here we had a number but it was out of range
                print("Invalid choice.")
            except (NameError,ValueError, TypeError, SyntaxError):
                print("That was not a number, genious.... :(")

                # This function will be called if the user choses select.
    def select(self):
        """Finds and prints tuples.
        Will query the user for the information required to identify a tuple.
        If the filter field is left blank, no filter will be used."""
        # raw_input returns the entire line entered at the promt. The
        # split(",") method then creates a list of the relations
        # (tables) that you have separated by commas.  The strip
        # method just remove the white space.  So this line is read
        # from right to left, that is first the user input is parsed
        # into a list of names, then the x is set to the list contents
        # incremented thru the list then the current x is striped and
        # the words " natural join " are added to the long string
        # being defined and stored in the variable tables.

        tables = [x.strip() + " natural join " for x in raw_input("Choose table(s): ").split(",")]
        tables[len(tables)-1] = tables[len(tables)-1][0:len(tables[len(tables)-1])-14]
        print tables
        columns = raw_input("Choose column(s): ")
        print columns
        filters = raw_input("Apply filters: ")
        # This will set query to the long string "SELECT columns FROM
        # tables WHERE filters;" The %s indicate that a string from a
        # variable will be inserted here, Those string variables
        # (actually expressions here) are then listed at the end
        # separated by commas.

        # lambda is a python keyword for defining a function (here with a+b)
        # reduce is a python built in way to call a function on a list 
        #   (iterable) (here each element of columns is taken as b in turn 
        # join is the python way to concatenate a list of strings
        try:
            query = """SELECT %s FROM %s%s;"""%(reduce(lambda a,b:a+b,columns), "".join(tables), "" if filters == "" else " WHERE %s"%filters)
        except (NameError,ValueError, TypeError,SyntaxError):
            print "  Bad input."
            return
        print(query)
        self.cur.execute(query)       
        self.print_answer()

    def remove(self):
        table = raw_input("\nTable to delete: ")
        column = raw_input("Column to delete: ")
        value = raw_input("Value of column to delete: ")
        try:
            query = "DELETE FROM %s WHERE %s = %s;"% (table, column, value)
        except (NameError, ValueError, TypeError, SyntaxError):
            print "  Bad input."
            return
        print(query)
        self.cur.execute(query)
        #Commit to confirm any changes
        self.conn.commit()

        #Print table to confirm the update
        query = "SELECT * FROM %s;"% (table)
        self.cur.execute(query)
        print("\n--------------------------------------")        
        self.print_answer_new()
        print("----------------------------------------")  

    def insert(self):
        table = raw_input("\nEnter table you wish to insert into: ")
        columns = raw_input("Enter the columns that you wish to add to separated by commas: ")
        values = raw_input("Enter the values you wish to enter separated by commas: ")

        try:
            query = "INSERT INTO %s (%s) VALUES (%s);" % (table, columns, values)
        except (NameError, ValueError, TypeError, SyntaxError):
            print "  Bad input."
            return
            
        print(query)
        self.cur.execute(query)
        self.conn.commit() 

        #Confirm the update in the table
        query = "SELECT * FROM %s;"% (table)
        self.cur.execute(query)
        print("\n--------------------------------------")        
        self.print_answer_new()
        print("----------------------------------------")  
        
    def exit(self):    
        self.cur.close()
        self.conn.close()
        exit()
    
    def print_answer(self):
    # We print all the stuff that was just fetched.
            print("\n".join([", ".join([str(a) for a in x]) for x in self.cur.fetchall()]))

    def print_answer_new(self):
            print("\n".join([" | ".join([str(a) for a in x]) for x in self.cur.fetchall()]))

    # we call this below in the main function.
    def run(self):
        """Main loop.
        Will divert control through the DBContext as dictated by the user."""
        actions = [self.select, self.insert, self.remove, self.exit]
        while True:
            try:
                # So this is executed right to left, The print_menu
                # function is run first (defined above), then the
                # return value is used as an index into the list
                # actions defined above, then that action is called.
                actions[self.print_menu()-1]()
                print
            except IndexError:
# if somehow the index into actions is wrong we just loop back
                print("Bad choice")

#Python reads until it sees this then starts executing what comes after
if __name__ == "__main__":
    db = DBContext()
    db.run()
