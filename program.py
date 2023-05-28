def menu():
    while True:
        print("\n> Menu:")
        print("\t1. Find the coach of a team in a specific match.")
        print("\t2. View the goals and penalties of a match.")
        print("\t3. Footballer statistic for a specific season.")
        print("\t4. Team statistic for a specific season.")
        print("\t?. Exit")
        
        choice = input("\n> Type a number (1-4) for executing query, or anything else for exiting: ")
        
        print()
        if choice == '1':
            print("Executing query 1\n")
        elif choice == '2':
            print("Executing query 2\n")
        elif choice == '3':
            print("Executing query 3\n")
        elif choice == '4':
            print("Executing query 4\n")
        else:
            print("Exiting...")
            return


if __name__ == '__main__':
    menu()
