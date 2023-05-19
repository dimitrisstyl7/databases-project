DROP TABLE IF EXISTS CARD;
DROP TABLE IF EXISTS FOOTBALLER_STATISTIC;
DROP TABLE IF EXISTS CORNER;
DROP TABLE IF EXISTS PENALTY;
DROP TABLE IF EXISTS GOAL;
DROP TABLE IF EXISTS MATCH_STATISTIC;
DROP TABLE IF EXISTS MATCH;
DROP TABLE IF EXISTS DEFEATS;
DROP TABLE IF EXISTS DRAWS;
DROP TABLE IF EXISTS WINS;
DROP TABLE IF EXISTS TEAM_STATISTIC;
DROP TABLE IF EXISTS COACH;
DROP TABLE IF EXISTS FOOTBALLER;
DROP TABLE IF EXISTS FOOTBALL_TEAM_MEMBER;
DROP TABLE IF EXISTS TEAM;

CREATE TABLE TEAM
(
    team_id     INT  NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    stadium     TEXT NOT NULL,
    description TEXT NOT NULL,
    PRIMARY KEY (team_id)
);

CREATE TABLE FOOTBALL_TEAM_MEMBER
(
    team_id         INT         NOT NULL,
    member_id       INT         NOT NULL UNIQUE,
    name            VARCHAR(10) NOT NULL CHECK (name ~ '^[Α-Ωα-ωΆ-Ώά-ώΫϋΰΪϊΐ]+$'),
    surname         VARCHAR(10) NOT NULL CHECK (name ~ '^[Α-Ωα-ωΆ-Ώά-ώΫϋΰΪϊΐ]+$'),
    role            TEXT        NOT NULL, -- footballer or coach
    registered_date DATE        NOT NULL,
    PRIMARY KEY (team_id, member_id, role),
    FOREIGN KEY (team_id) REFERENCES TEAM (team_id)
);

CREATE TABLE FOOTBALLER
(
    footballer_id INT  NOT NULL UNIQUE,
    position      TEXT NOT NULL,
    PRIMARY KEY (footballer_id),
    FOREIGN KEY (footballer_id) REFERENCES FOOTBALL_TEAM_MEMBER (member_id)
);

CREATE TABLE COACH
(
    coach_id   INT  NOT NULL UNIQUE,
    role TEXT NOT NULL, -- main or assistant
    PRIMARY KEY (coach_id),
    FOREIGN KEY (coach_id) REFERENCES FOOTBALL_TEAM_MEMBER (member_id)
);

CREATE TABLE TEAM_STATISTIC
(
    team_id        INT NOT NULL UNIQUE,
    sum_of_wins    INT NOT NULL,
    sum_of_draws   INT NOT NULL,
    sum_of_defeats INT NOT NULL,
    PRIMARY KEY (team_id),
    FOREIGN KEY (team_id) REFERENCES TEAM (team_id)
);

CREATE TABLE WINS
(
    team_id INT NOT NULL UNIQUE,
    home    INT NOT NULL,
    away    INT NOT NULL,
    PRIMARY KEY (team_id),
    FOREIGN KEY (team_id) REFERENCES TEAM_STATISTIC (team_id)
);

CREATE TABLE DRAWS
(
    team_id INT NOT NULL UNIQUE,
    home    INT NOT NULL,
    away    INT NOT NULL,
    PRIMARY KEY (team_id),
    FOREIGN KEY (team_id) REFERENCES TEAM_STATISTIC (team_id)
);

CREATE TABLE DEFEATS
(
    team_id INT NOT NULL UNIQUE,
    home    INT NOT NULL,
    away    INT NOT NULL,
    PRIMARY KEY (team_id),
    FOREIGN KEY (team_id) REFERENCES TEAM_STATISTIC (team_id)
);

CREATE TABLE MATCH
(
    match_id     INT  NOT NULL UNIQUE,
    home_team_id INT  NOT NULL,
    away_team_id INT  NOT NULL,
    date         DATE NOT NULL,
    PRIMARY KEY (match_id),
    FOREIGN KEY (home_team_id) REFERENCES TEAM (team_id),
    FOREIGN KEY (away_team_id) REFERENCES TEAM (team_id)
);

CREATE TABLE MATCH_STATISTIC
(
    match_id        INT NOT NULL UNIQUE,
    home_team_goals INT NOT NULL,
    away_team_goals INT NOT NULL,
    PRIMARY KEY (match_id),
    FOREIGN KEY (match_id) REFERENCES MATCH (match_id)
);

CREATE TABLE GOAL
(
    match_id INT     NOT NULL,
    valid    BOOLEAN NOT NULL,
    time     TIME    NOT NULL,
    PRIMARY KEY (match_id, time),
    FOREIGN KEY (match_id) REFERENCES MATCH (match_id)
);

CREATE TABLE PENALTY
(
    match_id INT  NOT NULL,
    time     TIME NOT NULL,
    PRIMARY KEY (match_id, time),
    FOREIGN KEY (match_id) REFERENCES MATCH (match_id)
);

CREATE TABLE CORNER
(
    match_id INT  NOT NULL,
    time     TIME NOT NULL,
    PRIMARY KEY (match_id, time),
    FOREIGN KEY (match_id) REFERENCES MATCH (match_id)
);

CREATE TABLE FOOTBALLER_STATISTIC
(
    footballer_id INT  NOT NULL,
    match_id      INT  NOT NULL,
    goals         INT  NOT NULL,
    yellow_cards  INT  NOT NULL,
    red_cards     INT  NOT NULL,
    duration      TIME NOT NULL,
    PRIMARY KEY (footballer_id, match_id),
    FOREIGN KEY (footballer_id) REFERENCES FOOTBALLER (footballer_id),
    FOREIGN KEY (match_id) REFERENCES MATCH (match_id)
);

CREATE TABLE CARD
(
    footballer_id INT  NOT NULL,
    match_id      INT  NOT NULL,
    color         CHAR NOT NULL,
    time          TIME NOT NULL,
    PRIMARY KEY (footballer_id, match_id, time),
    FOREIGN KEY (footballer_id) REFERENCES FOOTBALLER (footballer_id),
    FOREIGN KEY (match_id) REFERENCES MATCH (match_id)
);