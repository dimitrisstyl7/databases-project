create table team
(
    team_id     integer     not null unique,
    team_name   varchar(30) not null,
    stadium     varchar(30) not null,
    description text        not null,
    primary key (team_id)
);

create table footballer
(
    footballer_id      integer     not null unique,
    footballer_name    varchar(10) not null check (footballer_name ~ '^[Α-Ωα-ωΆ-Ώά-ώΫϋΰΪϊΐ]+$'),
    footballer_surname varchar(10) not null check (footballer_surname ~ '^[Α-Ωα-ωΆ-Ώά-ώΫϋΰΪϊΐ]+$'),
    primary key (footballer_id)
);

create table footballer_registration_date_in_team
(
    footballer_id     integer not null,
    team_id           integer not null,
    registration_date date    not null,
    primary key (footballer_id, team_id, registration_date),
    foreign key (footballer_id) references footballer (footballer_id),
    foreign key (team_id) references team (team_id)
);

create table footballer_position_in_team
(
    footballer_id integer     not null,
    team_id       integer     not null,
    position      varchar(15) not null check (position in ('goalkeeper', 'defender', 'midfielder', 'forward')),
    primary key (footballer_id, team_id),
    foreign key (footballer_id) references footballer (footballer_id),
    foreign key (team_id) references team (team_id)
);

create table coach
(
    coach_id      integer not null unique,
    footballer_id integer not null,
    primary key (coach_id),
    foreign key (footballer_id) references footballer (footballer_id)
);

create table coach_registration_date_in_team
(
    coach_id          integer not null,
    team_id           integer not null,
    registration_date date    not null,
    primary key (coach_id, team_id, registration_date),
    foreign key (coach_id) references coach (coach_id),
    foreign key (team_id) references team (team_id)

);

create table coach_position_in_team
(
    coach_id integer     not null,
    team_id  integer     not null,
    position varchar(15) not null check (position in
                                         ('head', 'assistant', 'goalkeeping', 'fitness', 'technical', 'scout',
                                          'youth')),
    primary key (coach_id, team_id),
    foreign key (coach_id) references coach (coach_id),
    foreign key (team_id) references team (team_id)
);

create table match
(
    match_id     integer not null unique,
    home_team_id integer not null,
    away_team_id integer not null,
    match_date   date    not null,
    match_time   time    not null,
    primary key (match_id),
    foreign key (home_team_id) references team (team_id),
    foreign key (away_team_id) references team (team_id)
);

create table match_score
(
    match_id        integer not null unique,
    home_team_score integer not null,
    away_team_score integer not null,
    primary key (match_id),
    foreign key (match_id) references match (match_id)
);

create table team_wins
(
    team_id   integer not null unique,
    home_wins integer not null,
    away_wins integer not null,
    primary key (team_id),
    foreign key (team_id) references team (team_id)
);

create table team_draws
(
    team_id    integer not null unique,
    home_draws integer not null,
    away_draws integer not null,
    primary key (team_id),
    foreign key (team_id) references team (team_id)
);

create table team_defeats
(
    team_id      integer not null unique,
    home_defeats integer not null,
    away_defeats integer not null,
    primary key (team_id),
    foreign key (team_id) references team (team_id)
);

create table team_statistic
(
    team_id        integer not null unique,
    sum_of_wins    integer not null,
    sum_of_draws   integer not null,
    sum_of_defeats integer not null,
    primary key (team_id),
    foreign key (team_id) references team (team_id)
);

create table goal
(
    match_id      integer not null,
    footballer_id integer not null,
    goal_time     time    not null,
    is_valid      boolean not null,
    is_penalty    boolean not null,
    primary key (match_id, footballer_id, goal_time),
    foreign key (match_id) references match (match_id),
    foreign key (footballer_id) references footballer (footballer_id)
);

create table corner
(
    match_id      integer not null,
    footballer_id integer not null,
    corner_time   time    not null,
    primary key (match_id, corner_time),
    foreign key (match_id) references match (match_id),
    foreign key (footballer_id) references footballer (footballer_id)
);

create table penalty
(
    match_id      integer not null,
    footballer_id integer not null,
    penalty_time  time    not null,
    primary key (match_id, penalty_time),
    foreign key (match_id) references match (match_id),
    foreign key (footballer_id) references footballer (footballer_id)
);

create table card
(
    match_id      integer not null,
    footballer_id integer not null,
    card_time     time    not null,
    is_yellow     boolean not null,
    primary key (match_id, footballer_id, card_time),
    foreign key (match_id) references match (match_id),
    foreign key (footballer_id) references footballer (footballer_id)
);

create table footballer_statistic_in_match
(
    footballer_id integer not null,
    match_id      integer not null,
    goals         integer not null,
    corners       integer not null,
    penalties     integer not null,
    yellow_cards  integer not null,
    red_cards     integer not null,
    time_played   time    not null,
    primary key (match_id, footballer_id),
    foreign key (match_id) references match (match_id),
    foreign key (footballer_id) references footballer (footballer_id)
);