import psycopg2


def menu():
    while True:
        print("\n> Menu:")
        print("\t1. Find the coach of a team in a specific match.")
        print("\t2. View the goals and penalties of a match.")
        print("\t3. Footballer statistic for current season.")
        print("\t4. Team statistic for current season.")
        print("\t?. Exit")

        choice = input("\n> Type a number (1-4) for executing query, or anything else for exiting: ")

        if choice == '1':
            match_id = input("Match id: ")
            team_id = input("Team id: ")
            query = "select t3.coach_id, t4.footballer_name, t4.footballer_surname " \
                    "from " \
                    "(select home_team_id as home, away_team_id as away " \
                    "from match where match_id=%s and (home_team_id=%s or away_team_id=%s)) as t1 " \
                    "inner join coach_registration_date_in_team as t2 " \
                    "on t2.team_id=%s and (t2.team_id=t1.home or t2.team_id=t1.away) " \
                    "inner join coach as t3 " \
                    "on t3.coach_id=t2.coach_id " \
                    "inner join footballer as t4 " \
                    "on t4.footballer_id=t3.footballer_id;"
            cursor.execute(query, (match_id, team_id, team_id, team_id))
            print(cursor.fetchone())
        elif choice == '2':
            match_id = input("Match id: ")
            goal_query = "select t1.goal_time, t1.is_valid, t2.footballer_id, " \
                         "t2.footballer_name, t2.footballer_surname " \
                         "from goal as t1 natural join footballer as t2 " \
                         "where t1.match_id=%s;"
            cursor.execute(goal_query, match_id)
            print("Goals:")
            for row in cursor.fetchall():
                print(row)

            penalty_query = "select t1.penalty_time, t2.footballer_id, t2.footballer_name, t2.footballer_surname " \
                            "from penalty as t1 natural join footballer as t2 " \
                            "where t1.match_id=%s;"
            cursor.execute(penalty_query, match_id)
            print("\nPenalties:")
            for row in cursor.fetchall():
                print(row)
        elif choice == '3':
            footballer_id = input("Footballer id: ")
            query = "select * " \
                    "from footballer_statistic_in_match as t1 natural join footballer_position_in_team as t2 " \
                    "where footballer_id=%s;"
            cursor.execute(query, footballer_id)
            print("Footballer statistic:")
            for row in cursor.fetchall():
                print(row)
        elif choice == '4':
            team_id = input("Team id: ")
            query = "select sum(t1.home_wins + t1.away_wins + " \
                    "t2.home_defeats + t2.away_defeats + " \
                    "t3.home_draws + t3.away_draws), sum(t1.home_wins + t2.home_defeats + t3.home_draws), " \
                    "sum(t1.away_wins + t2.away_defeats + t3.away_draws) " \
                    "from team_wins as t1 natural join team_defeats as t2 natural join team_draws as t3 " \
                    "where team_id=%s;"
            cursor.execute(query, team_id)
            print("Team statistic:")
            for row in cursor.fetchall():
                print(row)
        else:
            print("Exiting...")
            return


if __name__ == '__main__':
    conn = psycopg2.connect(host="localhost", database="footballclub_db", user="postgres", password="1234")
    cursor = conn.cursor()
    menu()
    conn.close()
