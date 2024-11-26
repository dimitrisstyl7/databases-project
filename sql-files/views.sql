create or replace view match_statistic_for_a_specific_date as
with current_match as (select match_id,
                              home_team_id,
                              away_team_id,
                              match_date,
                              match_time
                       from footballclub_db.public.match
                       where match_date = '2023-05-05'),

     home_team as (select cm.match_id, t.team_name as home_team_name
                   from footballclub_db.public.team as t
                            inner join current_match as cm
                                       on t.team_id = cm.home_team_id),

     away_team as (select cm.match_id, t.team_name as away_team_name
                   from footballclub_db.public.team as t
                            inner join current_match as cm
                                       on t.team_id = cm.away_team_id),

     match_stadium as (select cm.match_id, t.stadium
                       from footballclub_db.public.team as t
                                inner join current_match as cm
                                           on t.team_id = cm.home_team_id),

     match_score as (select cm.match_id, ms.home_team_score, ms.away_team_score
                     from footballclub_db.public.match_score as ms
                              inner join current_match as cm
                                         on ms.match_id = cm.match_id),

     footballer_stat as (select fsm.match_id,
                                fsm.footballer_id,
                                f.footballer_name,
                                f.footballer_surname,
                                f.position,
                                fsm.time_played,
                                fsm.yellow_cards,
                                fsm.red_cards
                         from (footballclub_db.public.footballer natural join footballclub_db.public.footballer_position_in_team) as f
                                  inner join (footballclub_db.public.footballer_statistic_in_match natural join current_match) as fsm
                                             on f.footballer_id = fsm.footballer_id),

     goal as (select g.match_id,
                     g.footballer_id,
                     g.goal_time
              from footballclub_db.public.goal as g
                       natural join footballer_stat as fs
              where g.is_valid = true)

select cm.match_id,
       ht.home_team_name,
       at.away_team_name,
       ms.stadium,
       cm.match_date,
       cm.match_time,
       msc.home_team_score,
       msc.away_team_score,
       fs.footballer_id,
       fs.footballer_name,
       fs.footballer_surname,
       fs.position,
       fs.time_played,
       fs.yellow_cards,
       fs.red_cards,
       g.goal_time
from current_match as cm
         inner join home_team as ht
                    on cm.match_id = ht.match_id
         inner join away_team as at
                    on cm.match_id = at.match_id
         inner join match_stadium as ms
                    on cm.match_id = ms.match_id
         inner join match_score as msc
                    on cm.match_id = msc.match_id
         inner join footballer_stat as fs
                    on cm.match_id = fs.match_id
         full outer join goal as g
                         on cm.match_id = g.match_id and fs.footballer_id = g.footballer_id;


create or replace view league_statistic_for_a_specific_season as
with current_match as (select match_id,
                              home_team_id,
                              away_team_id,
                              match_date,
                              match_time
                       from footballclub_db.public.match
                       where match_date >= '2023-01-01'
                         and match_date <= '2023-12-31'),

     home_team as (select cm.match_id, t.team_name as home_team_name
                   from footballclub_db.public.team as t
                            inner join current_match as cm
                                       on t.team_id = cm.home_team_id),

     away_team as (select cm.match_id, t.team_name as away_team_name
                   from footballclub_db.public.team as t
                            inner join current_match as cm
                                       on t.team_id = cm.away_team_id),

     match_stadium as (select cm.match_id, t.stadium
                       from footballclub_db.public.team as t
                                inner join current_match as cm
                                           on t.team_id = cm.home_team_id),

     match_score as (select cm.match_id, ms.home_team_score, ms.away_team_score
                     from footballclub_db.public.match_score as ms
                              inner join current_match as cm
                                         on ms.match_id = cm.match_id)

select cm.match_id,
       ht.home_team_name,
       at.away_team_name,
       ms.stadium,
       cm.match_date,
       cm.match_time,
       msc.home_team_score,
       msc.away_team_score
from current_match as cm
         inner join home_team as ht
                    on cm.match_id = ht.match_id
         inner join away_team as at
                    on cm.match_id = at.match_id
         inner join match_stadium as ms
                    on cm.match_id = ms.match_id
         inner join match_score as msc
                    on cm.match_id = msc.match_id;
