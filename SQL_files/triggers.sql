CREATE OR REPLACE FUNCTION check_team_space() RETURNS TRIGGER AS
$$
DECLARE
    current_count INT;
BEGIN
    SELECT COUNT(*)
    INTO current_count
    FROM footballclub_db.public.football_team_member
    WHERE team_id = NEW.team_id
      AND DATE_PART('YEAR', registered_date) = DATE_PART('YEAR', NEW.registered_date);

    IF current_count >= 11 THEN
        RAISE EXCEPTION 'Team has reached the maximum number of players.';
    END IF;

    RETURN NEW;
END ;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_team_space
    BEFORE INSERT
    ON footballclub_db.public.football_team_member
    FOR EACH ROW
EXECUTE FUNCTION check_team_space();

CREATE OR REPLACE FUNCTION check_coach_criteria() RETURNS TRIGGER AS
$$
DECLARE
    flag BOOLEAN := FALSE;
BEGIN
    IF NEW.role = 'coach' THEN
        SELECT EXISTS(SELECT 1
                      FROM footballclub_db.public.football_team_member
                      WHERE team_id = NEW.team_id
                        AND member_id = NEW.member_id
                        AND role = 'footballer')
        INTO flag;

        IF NOT flag THEN
            RAISE EXCEPTION 'The coach must have been a footballer first in the team.';
        END IF;
    end if;

    RETURN NEW;
END ;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_coach_criteria
    BEFORE INSERT
    ON footballclub_db.public.football_team_member
    FOR EACH ROW
EXECUTE FUNCTION check_coach_criteria();

select current_date;
SELECT now()::timestamp(0);