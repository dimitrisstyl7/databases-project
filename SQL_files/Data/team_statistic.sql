update footballclub_db.public.team_statistic
set sum_of_wins    = 1,
    sum_of_draws   = 0,
    sum_of_defeats = 1
where team_id = 1;
update footballclub_db.public.team_statistic
set sum_of_wins    = 0,
    sum_of_draws   = 1,
    sum_of_defeats = 1
where team_id = 2;
update footballclub_db.public.team_statistic
set sum_of_wins    = 1,
    sum_of_draws   = 1,
    sum_of_defeats = 0
where team_id = 3;
update footballclub_db.public.team_statistic
set sum_of_wins    = 0,
    sum_of_draws   = 0,
    sum_of_defeats = 1
where team_id = 4;
update footballclub_db.public.team_statistic
set sum_of_wins    = 1,
    sum_of_draws   = 0,
    sum_of_defeats = 0
where team_id = 5;
