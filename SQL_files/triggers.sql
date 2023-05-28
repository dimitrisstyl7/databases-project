create or replace function check_team_space() returns trigger as
$$
declare
    current_count int;
begin
    select count(*)
    into current_count
    from footballclub_db.public.footballer_registration_date_in_team
    where team_id = new.team_id
      and date_part('year', registration_date) = date_part('year', new.registration_date);

    if current_count >= 11 then
        raise exception 'Team has reached the maximum number of players.';
    end if;

    return new;
end ;
$$ language plpgsql;

create or replace function check_coach_eligibility_criteria() returns trigger as
$$
declare
    flag boolean := false;
begin
    select exists(select 1
                  from footballclub_db.public.footballer_registration_date_in_team
                  where footballer_id = new.footballer_id
                    and date_part('year', registration_date) < date_part('year', current_date))
    into flag;

    if not flag then
        raise exception 'The coach must have been a footballer first in a team, at least one year before becoming a coach.';
    end if;
    return new;
end;
$$ language plpgsql;

create or replace function check_footballer_registration_criteria() returns trigger as
$$
declare
    flag boolean := false;
begin
    select exists(select 1
                  from footballclub_db.public.footballer_registration_date_in_team
                  where footballer_id = new.footballer_id
                    and date_part('year', registration_date) = date_part('year', new.registration_date))
    into flag;

    if flag then
        raise exception 'The footballer is already registered in a team for the current year.';
    end if;
    return new;
end;
$$ language plpgsql;

create or replace function check_coach_registration_criteria() returns trigger as
$$
declare
    flag boolean := false;
begin
    select exists(select 1
                  from footballclub_db.public.coach_registration_date_in_team
                  where coach_id = new.coach_id
                    and date_part('year', registration_date) = date_part('year', new.registration_date))
    into flag;

    if flag then
        raise exception 'The coach is already registered in a team for the current year.';
    end if;
    return new;
end;
$$ language plpgsql;

create or replace function check_match_criteria() returns trigger as
$$
declare
    flag boolean := false;
begin
    select exists(select 1
                  from footballclub_db.public.match
                  where (home_team_id = new.home_team_id
                      or away_team_id = new.away_team_id
                      or home_team_id = new.away_team_id
                      or away_team_id = new.home_team_id)
                    and match_date = new.match_date)
    into flag;

    if flag then
        raise exception 'One or both of the teams are already playing a match on the same day.';
    end if;

    select exists(select 1
                  from footballclub_db.public.match
                  where (home_team_id = new.home_team_id
                      or away_team_id = new.away_team_id
                      or home_team_id = new.away_team_id
                      or away_team_id = new.home_team_id)
                    and (date(match_date) = date(new.match_date - interval '10 day')
                      or date(match_date) = date(new.match_date + interval '10 day')))
    into flag;

    if flag then
        raise exception 'One or both of the teams are already playing a match 10 days before or after the current match.';
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function initialize_team_statistic() returns trigger as
$$
begin
    insert into footballclub_db.public.team_wins values (new.team_id, 0, 0);
    insert into footballclub_db.public.team_draws values (new.team_id, 0, 0);
    insert into footballclub_db.public.team_defeats values (new.team_id, 0, 0);
    insert into footballclub_db.public.team_statistic values (new.team_id, 0, 0, 0);
    return new;
end;
$$ language plpgsql;

-- create or replace function update_team_statistic() returns trigger as
-- $$
-- begin
--     update footballclub_db.public.team_statistic
--     set sum_of_wins    = sum_of_wins + tg_argv[0]::integer,
--         sum_of_draws   = sum_of_draws + tg_argv[1]::integer,
--         sum_of_defeats = sum_of_defeats + tg_argv[2]::integer
--     where team_id = new.team_id;
--     return new;
-- end;
-- $$ language plpgsql;

-- create or replace function initialize_footballer_statistic_in_match() returns trigger as
-- $$
-- declare
--     cur refcursor;
--     rec record;
-- begin
--     open cur for select footballer_id
--                  from footballclub_db.public.footballer_registration_date_in_team
--                  where team_id = new.home_team_id
--                    and date_part('year', registration_date) = date_part('year', new.match_date);
--
--     loop
--         fetch cur into rec;
--         exit when not found;
--         insert into footballclub_db.public.footballer_statistic_in_match
--         values (rec.footballer_id, new.match_id, 0, 0, 0, 0, 0, '00:00:00');
--     end loop;
--     close cur;
--
--     return new;
-- end;
-- $$ language plpgsql;


create or replace trigger check_team_space
    before insert
    on footballclub_db.public.footballer_registration_date_in_team
    for each row
execute function check_team_space();

create or replace trigger check_coach_eligibility_criteria
    before insert
    on footballclub_db.public.coach
    for each row
execute function check_coach_eligibility_criteria();

create or replace trigger check_footballer_registration_criteria
    before insert
    on footballclub_db.public.footballer_registration_date_in_team
    for each row
execute function check_footballer_registration_criteria();

create or replace trigger check_coach_registration_criteria
    before insert
    on footballclub_db.public.coach_registration_date_in_team
    for each row
execute function check_coach_registration_criteria();

create or replace trigger check_match_criteria
    before insert
    on footballclub_db.public.match
    for each row
execute function check_match_criteria();

create or replace trigger initialize_team_statistic
    after insert
    on footballclub_db.public.team
    for each row
execute function initialize_team_statistic();

-- create or replace trigger update_team_win_statistic
--     after update
--     on footballclub_db.public.team_wins
--     for each row
-- execute function update_team_statistic(1, 0, 0);
--
-- create or replace trigger update_team_draw_statistic
--     after update
--     on footballclub_db.public.team_draws
--     for each row
-- execute function update_team_statistic(0, 1, 0);
--
-- create or replace trigger update_team_defeat_statistic
--     after update
--     on footballclub_db.public.team_defeats
--     for each row
-- execute function update_team_statistic(0, 0, 1);

-- create or replace trigger initialize_footballer_statistic_in_match
--     after insert
--     on footballclub_db.public.match
--     for each row
-- execute function initialize_footballer_statistic_in_match();