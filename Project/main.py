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

        if choice == "1":
            match_id = input("\t> Match id: ")
            team_id = input("\t> Team id: ")
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
            result = cursor.fetchone()
            if result is None:
                print("\n\t\tNo coach found.")
            else:
                print("\n\tResult:")
                print(f"\t\t<> Coach id: {result[0]}  |  Coach name: {result[1]} {result[2]}")

        elif choice == "2":
            match_id = input("\t> Match id: ")
            goal_query = "select t1.goal_time, t1.is_valid, t2.footballer_id, " \
                         "t2.footballer_name, t2.footballer_surname " \
                         "from goal as t1 natural join footballer as t2 " \
                         "where t1.match_id=%s;"
            cursor.execute(goal_query, match_id)
            print("\n\tResult:")
            print("\t\tGoals:")
            result = cursor.fetchall()
            if len(result) == 0:
                print("\t\t\tNo goals found.")
            else:
                for row in result:
                    print(f"\t\t\t<> Goal time: {row[0]}  |  Is valid: {row[1]}  |  Footballer id: {row[2]}")

            penalty_query = "select t1.penalty_time, t2.footballer_id, t2.footballer_name, t2.footballer_surname " \
                            "from penalty as t1 natural join footballer as t2 " \
                            "where t1.match_id=%s;"
            cursor.execute(penalty_query, match_id)
            print("\n\t\tPenalties:")
            result = cursor.fetchall()
            if len(result) == 0:
                print("\t\t\tNo penalties found.")
            else:
                for row in result:
                    print(
                        f"\t\t\t<> Penalty time: {row[0]}  |  Footballer id: {row[1]}  |  "
                        f"Footballer name: {row[2]} {row[3]}")

        elif choice == "3":
            footballer_id = input("\t> Footballer id: ")
            query = "select t1.goals, t1.penalties, t1.yellow_cards, t1.red_cards, t1.time_played, t2.position " \
                    "from footballer_statistic_in_match as t1 natural join footballer_position_in_team as t2 " \
                    "where t1.footballer_id=%s;"
            cursor.execute(query, footballer_id)
            print("\n\tResult:")
            result = cursor.fetchall()
            if len(result) == 0:
                print("\t\tNo statistic found.")
            for row in result:
                print(f"\t\t<> Goals: {row[0]}  |  Penalties: {row[1]}  |  Yellow cards: {row[2]}  |  "
                      f"Red cards: {row[3]}  |  Time played: {row[4]}  |  Position: {row[5]}")

        elif choice == "4":
            team_id = input("\t> Team id: ")
            query = "select sum(t1.home_wins + t1.away_wins + " \
                    "t2.home_defeats + t2.away_defeats + " \
                    "t3.home_draws + t3.away_draws), sum(t1.home_wins + t2.home_defeats + t3.home_draws), " \
                    "sum(t1.away_wins + t2.away_defeats + t3.away_draws) " \
                    "from team_wins as t1 natural join team_defeats as t2 natural join team_draws as t3 " \
                    "where team_id=%s;"
            cursor.execute(query, team_id)
            print("\n\tResult:")
            result = cursor.fetchall()
            if len(result) == 0:
                print("\t\tNo statistic found.")
            for row in result:
                print(f"\t\t<> Total matches: {row[0]}  |  Home matches: {row[1]}  |  Away matches: {row[2]}")
        else:
            print("\nExiting...")
            return


if __name__ == "__main__":
    conn = psycopg2.connect(host="localhost", database="footballclub_db", user="postgres", password="1234")
    cursor = conn.cursor()
    menu()
    conn.close()
