create TYPE TRIP_PARTICIPANT_OBJ AS OBJECT (
    FIRSTNAME           VARCHAR(50),
    LASTNAME            VARCHAR(50),
    TRIP_NAME           VARCHAR(100),
    TRIP_DATE           DATE,
    COUNTRY_NAME        VARCHAR(64),
    RESERVATION_ID      INT,
    RESERVATION_STATUS  VARCHAR(1)
)
/

create TYPE TRIP_OBJ AS OBJECT (
    TRIP_NAME VARCHAR(100),
    TRIP_DATE DATE,
    COUNTRY_NAME VARCHAR(128),
    MAX_NO_PLACES INT,
    AVAILABLE_NO_PLACES INT
)
/

create type TRIP_TABLE as table of TRIP_OBJ
/

create type TRIP_PARTICIPANTS_TABLE as table of TRIP_PARTICIPANT_OBJ
/

create table LOG
(
    LOG_ID         NUMBER generated as identity
        constraint LOG_PK
            primary key,
    RESERVATION_ID NUMBER not null,
    LOG_DATE       DATE   not null,
    STATUS         CHAR
        constraint LOG_CHK1
            check (status in ('N', 'P', 'C'))
)
/

create table COUNTRIES
(
    COUNTRY_ID    NUMBER generated as identity
        constraint COUNTRIES_PK
            primary key,
    NAME          VARCHAR2(64) not null,
    OFFICIAL_NAME VARCHAR2(128)
)
/

create table PERSON
(
    PERSON_ID NUMBER generated as identity
        constraint PERSON_PK
            primary key,
    FIRSTNAME VARCHAR2(50),
    LASTNAME  VARCHAR2(50)
)
/

create table TRIP
(
    TRIP_ID             NUMBER generated as identity
        constraint TRIP_PK
            primary key,
    TRIP_NAME           VARCHAR2(100),
    COUNTRY_ID          NUMBER
        constraint TRIP_FK1
            references COUNTRIES,
    TRIP_DATE           DATE,
    MAX_NO_PLACES       NUMBER,
    NO_AVAILABLE_PLACES NUMBER
)
/

create trigger TR_ON_TRIP_UPDATE
    before update
    on TRIP
    for each row
DECLARE
    l_trip_count INT;
    l_trip_available_no_places INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_count
    FROM VIEW_AVAILABLE_TRIPS_ T
    WHERE T.TRIP_ID = :NEW.TRIP_ID;
    IF l_trip_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || :NEW.TRIP_ID || ' does not exist or is not available');
    END IF;

    SELECT NO_AVAILABLE_PLACES INTO l_trip_available_no_places
    FROM VIEW_AVAILABLE_TRIPS_ T
    WHERE T.TRIP_ID = :NEW.TRIP_ID;
    IF l_trip_available_no_places - :NEW.NO_AVAILABLE_PLACES < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'There are not free slots enough');
    END IF;
END;
/

create table RESERVATION
(
    RESERVATION_ID NUMBER generated as identity
        constraint RESERVATION_PK
            primary key,
    TRIP_ID        NUMBER
        constraint RESERVATION_FK2
            references TRIP,
    PERSON_ID      NUMBER
        constraint RESERVATION_FK1
            references PERSON,
    STATUS         CHAR
        constraint RESERVATION_CHK1
            check (status in ('N', 'P', 'C'))
)
/

create trigger TR_ON_ADD_RESERVATION
    after insert
    on RESERVATION
    for each row
DECLARE
    l_available_no_places INT;
BEGIN
    SELECT NO_AVAILABLE_PLACES INTO l_available_no_places FROM AVAILABLETRIPS;
    IF l_available_no_places <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Trip ' || :new.TRIP_ID || ' does not have any free spots');
    END IF;

    INSERT INTO LOG (RESERVATION_ID, LOG_DATE, STATUS)
    VALUES (RESERVATION_ID, CURRENT_DATE, :new.STATUS);
END;
/

create trigger TR_ON_MODIFY_RESERVATION_STATUS
    after update
    on RESERVATION
    for each row
DECLARE
    l_available_no_places INT;
BEGIN
    IF :NEW.STATUS = 'N' OR :NEW.STATUS = 'P' THEN
        SELECT NO_AVAILABLE_PLACES INTO l_available_no_places
        FROM VIEW_AVAILABLE_TRIPS_ T
        WHERE T.TRIP_ID = :NEW.TRIP_ID;

        IF l_available_no_places = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Trip ' || :NEW.TRIP_ID || ' does not have any more free spots');
        END IF;
        
        UPDATE TRIP
        SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
        WHERE TRIP_ID = :NEW.TRIP_ID;
    END IF;

    INSERT INTO LOG (RESERVATION_ID, LOG_DATE, STATUS)
    VALUES (RESERVATION_ID, CURRENT_DATE, :OLD.STATUS);
END;
/

create trigger TR_ON_DELETE_RESERVATION
    before delete
    on RESERVATION
    for each row
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot delete reservation records');
END;
/

create view RESERVATIONS_ as
SELECT
    C.name,
    C.COUNTRY_ID,
    T.TRIP_ID,
    T.TRIP_DATE,
    T.TRIP_NAME,
    P.PERSON_ID,
    P.FIRSTNAME,
    P.LASTNAME,
    R.RESERVATION_ID,
    R.STATUS
FROM RESERVATION R
        INNER JOIN TRIP T ON R.TRIP_ID = T.TRIP_ID
        INNER JOIN COUNTRIES C ON T.COUNTRY_ID = C.COUNTRY_ID
        INNER JOIN PERSON P on R.PERSON_ID = P.PERSON_ID
WITH READ ONLY
/

create view RESERVATIONS as
SELECT
    COUNTRY_NAME,
    TRIP_DATE,
    TRIP_NAME,
    FIRSTNAME,
    LASTNAME,
    RESERVATION_ID,
    STATUS
FROM RESERVATIONS_
/

create view TRIPS_ (TRIP_ID, COUNTRY_NAME, COUNTRY_ID, TRIP_DATE, TRIP_NAME, NO_PLACES, NO_AVAILABLE_PLACES) as
SELECT DISTINCT
    T.TRIP_ID,
    R.COUNTRY_NAME,
    R.COUNTRY_ID,
    T.TRIP_DATE,
    T.TRIP_NAME,
    T.MAX_NO_PLACES,
    T.MAX_NO_PLACES - TS.TRIPS_COUNT
FROM TRIP T
    INNER JOIN RESERVATIONS_ R ON T.TRIP_ID = R.TRIP_ID
    INNER JOIN (
        SELECT TRIP_ID, COUNT(*) TRIPS_COUNT
        FROM RESERVATIONS_ R
        WHERE R.STATUS = 'N' OR R.STATUS = 'P'
        GROUP BY R.TRIP_ID
    ) TS ON T.TRIP_ID = TS.TRIP_ID
WITH READ ONLY
/

create view TRIPS as
SELECT COUNTRY_NAME, TRIP_DATE, TRIP_NAME, NO_PLACES, NO_AVAILABLE_PLACES FROM TRIPS_
/

create view VIEW_AVAILABLE_TRIPS_ as
SELECT T.COUNTRY_NAME, T.TRIP_ID, T.TRIP_DATE, T.TRIP_NAME, T.NO_PLACES, T.NO_AVAILABLE_PLACES FROM TRIPS_ T
INNER JOIN RESERVATIONS_ R on T.TRIP_ID= R.TRIP_ID
WHERE T.NO_AVAILABLE_PLACES > 0 AND CURRENT_DATE <= R.TRIP_DATE AND (R.STATUS = 'N' OR R.STATUS = 'P')
/

create view AVAILABLETRIPS as
SELECT COUNTRY_NAME, TRIP_DATE, TRIP_NAME, NO_PLACES, NO_AVAILABLE_PLACES FROM VIEW_AVAILABLE_TRIPS_
/

create view VIEW_AVAILABLE_TRIPS4_ as
SELECT C.NAME, T.TRIP_ID, T.TRIP_DATE, T.TRIP_NAME, T.MAX_NO_PLACES, T.NO_AVAILABLE_PLACES FROM TRIP T
    INNER JOIN COUNTRIES C on T.COUNTRY_ID = C.COUNTRY_ID
    WHERE CURRENT_DATE <= T.TRIP_DATE AND T.NO_AVAILABLE_PLACES > 0
/

create view TRIPS4_ as
SELECT DISTINCT
    T.TRIP_ID,
    R.COUNTRY_NAME,
    R.COUNTRY_ID,
    T.TRIP_DATE,
    T.TRIP_NAME,
    T.MAX_NO_PLACES,
    T.NO_AVAILABLE_PLACES
FROM TRIP T
    INNER JOIN RESERVATIONS_ R ON T.TRIP_ID = R.TRIP_ID
WITH READ ONLY
/

create FUNCTION TripParticipants(trip_id INT)
RETURN TRIP_PARTICIPANTS_TABLE
AS
    l_result TRIP_PARTICIPANTS_TABLE;
    
    l_trip_number INT;
    l_trip_id TRIP.TRIP_ID%TYPE := trip_id;
BEGIN
    SELECT COUNT(*) INTO l_trip_number FROM TRIP WHERE TRIP.TRIP_ID = l_trip_id;

    IF l_trip_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || trip_id || ' does not exist');
    END IF;

    SELECT TRIP_PARTICIPANT_OBJ(
        P.FIRSTNAME,
        P.LASTNAME,
        T.TRIP_NAME,
        T.TRIP_DATE,
        C.name,
        R.RESERVATION_ID,
        R.STATUS
    ) BULK COLLECT INTO l_result
    FROM RESERVATION R
    INNER JOIN TRIP T ON R.TRIP_ID = T.TRIP_ID
    INNER JOIN COUNTRIES C ON T.COUNTRY_ID = C.COUNTRY_ID
    INNER JOIN PERSON P on R.PERSON_ID = P.PERSON_ID
        WHERE T.TRIP_ID = l_trip_id;

    RETURN l_result;
END;
/

create FUNCTION PersonReservations(person_id INT)
RETURN TRIP_PARTICIPANTS_TABLE
AS
    l_result TRIP_PARTICIPANTS_TABLE;
    
    l_person_number INT;
    l_person_id TRIP.TRIP_ID%TYPE := person_id;
BEGIN
    SELECT COUNT(*) INTO l_person_number FROM TRIP;

    IF l_person_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Person ' || person_id || ' does not exist');
    END IF;

    SELECT TRIP_PARTICIPANT_OBJ(
        P.FIRSTNAME,
        P.LASTNAME,
        T.TRIP_NAME,
        T.TRIP_DATE,
        C.name,
        R.RESERVATION_ID,
        R.STATUS
    ) BULK COLLECT INTO l_result
    FROM RESERVATION R
    INNER JOIN TRIP T ON R.TRIP_ID = T.TRIP_ID
    INNER JOIN COUNTRIES C ON T.COUNTRY_ID = C.COUNTRY_ID
    INNER JOIN PERSON P on R.PERSON_ID = P.PERSON_ID
        WHERE P.PERSON_ID = l_person_id;

    RETURN l_result;
END;
/

create FUNCTION Fn_AvailableTrips(country_name VARCHAR, date_from DATE, date_to DATE)
RETURN TRIP_TABLE
AS
    l_result TRIP_TABLE;

    l_country_count INT;
    l_date_diff INT := date_to - date_from;
BEGIN
    SELECT COUNT(*) INTO l_country_count FROM COUNTRIES WHERE NAME = country_name;

    IF l_country_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Country ' || country_name || ' does not exist');
    END IF;
    IF l_date_diff < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Wrong dates');
    END IF;


    SELECT TRIP_OBJ(
        T.TRIP_NAME,
        T.TRIP_DATE,
        T.COUNTRY_NAME,
        T.NO_PLACES,
        T.NO_AVAILABLE_PLACES
    ) BULK COLLECT INTO l_result
    FROM AVAILABLETRIPS T
    WHERE
        T.COUNTRY_NAME = Fn_AvailableTrips.country_name
        AND T.TRIP_DATE BETWEEN date_from AND date_to;

    RETURN l_result;
END;
/

create PROCEDURE AddReservation(trip_id INT, person_id INT)
AS
    l_trip_id INT := trip_id;
    l_person_id INT := person_id;
    l_available_no_places INT;
    l_trip_number INT;
    l_person_number INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_number FROM TRIP WHERE TRIP_ID = l_trip_id;
    IF l_trip_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || trip_id || ' does not exist');
    END IF;

    SELECT COUNT(*) INTO l_person_number FROM PERSON WHERE PERSON_ID = l_person_id;
    IF l_person_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Person ' || person_id || ' does not exist');
    END IF;

    SELECT NO_AVAILABLE_PLACES INTO l_available_no_places FROM AVAILABLETRIPS;
    IF l_available_no_places <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Trip ' || trip_id || ' does not have any free spots');
    END IF;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (l_trip_id, l_person_id, 'N');
END;
/

create PROCEDURE ModifyReservationStatus(reservation_id INT, status VARCHAR)
AS
    l_reservation_id INT := reservation_id;
    l_status VARCHAR(1) := status;
    l_trip_id TRIP.TRIP_ID%TYPE;
    l_reservation_count INT;
    l_current_status VARCHAR(1);
    l_available_no_places INT;

BEGIN
    SELECT COUNT(*) INTO l_reservation_count FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_reservation_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Reservation ' || reservation_id || ' does not exist');
    END IF;

    SELECT R.STATUS INTO l_current_status FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_status = l_current_status THEN
        RAISE_APPLICATION_ERROR(-20002, 'Current reservation ' || reservation_id || ' status is equal to passed argument');
    END IF;

    SELECT TRIP_ID INTO l_trip_id
    FROM RESERVATION R
    WHERE R.RESERVATION_ID = l_reservation_id;

    IF status = 'N' OR status = 'P' THEN
        SELECT NO_AVAILABLE_PLACES INTO l_available_no_places
        FROM VIEW_AVAILABLE_TRIPS_
        WHERE TRIP_ID = l_trip_id;

        IF l_available_no_places = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Trip ' || l_trip_id || ' does not have any more free spots');
        END IF;
    END IF;

    INSERT INTO LOG (RESERVATION_ID, LOG_DATE, STATUS)
    VALUES (RESERVATION_ID, CURRENT_DATE, l_current_status);

    UPDATE RESERVATION
    SET STATUS = l_status
    WHERE RESERVATION_ID = l_reservation_id;
END;
/

create PROCEDURE ModifyNoPlaces(trip_id INT, no_places INT) AS
    l_trip_id INT := trip_id;
    l_trip_count INT;
    l_trip_available_no_places INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_count
    FROM VIEW_AVAILABLE_TRIPS_ T
    WHERE T.TRIP_ID = l_trip_id;
    IF l_trip_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || trip_id || ' does not exist or is not available');
    END IF;

    SELECT NO_AVAILABLE_PLACES INTO l_trip_available_no_places
    FROM VIEW_AVAILABLE_TRIPS_ T
    WHERE T.TRIP_ID = l_trip_id;
    IF l_trip_available_no_places - no_places < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'There are not free slots enough');
    END IF;

    UPDATE TRIP
    SET MAX_NO_PLACES = no_places
    WHERE TRIP_ID = l_trip_id;
END;
/

create PROCEDURE ADDRESERVATION2(trip_id INT, person_id INT)
AS
    l_trip_id INT := trip_id;
    l_person_id INT := person_id;
    l_available_no_places INT;
    l_trip_number INT;
    l_person_number INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_number FROM TRIP T WHERE T.TRIP_ID = l_trip_id;
    IF l_trip_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || trip_id || ' does not exist');
    END IF;

    SELECT COUNT(*) INTO l_person_number FROM PERSON P WHERE P.PERSON_ID = l_person_id;
    IF l_person_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Person ' || person_id || ' does not exist');
    END IF;

    SELECT NO_AVAILABLE_PLACES INTO l_available_no_places FROM AVAILABLETRIPS;
    IF l_available_no_places <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Trip ' || trip_id || ' does not have any free spots');
    END IF;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (l_trip_id, l_person_id, 'N');
END;
/

create PROCEDURE ModifyReservationStatus2(reservation_id INT, status VARCHAR)
AS
    l_reservation_id INT := reservation_id;
    l_status VARCHAR(1) := status;
    l_trip_id TRIP.TRIP_ID%TYPE;
    l_reservation_count INT;
    l_current_status VARCHAR(1);
    l_available_no_places INT;
BEGIN
    SELECT COUNT(*) INTO l_reservation_count FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_reservation_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Reservation ' || reservation_id || ' does not exist');
    END IF;

    SELECT R.STATUS INTO l_current_status FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_status = l_current_status THEN
        RAISE_APPLICATION_ERROR(-20002, 'Current reservation ' || reservation_id || ' status is equal to passed argument');
    END IF;

    SELECT TRIP_ID INTO l_trip_id
    FROM RESERVATION R
    WHERE R.RESERVATION_ID = l_reservation_id;

    IF status = 'N' OR status = 'P' THEN
        SELECT NO_AVAILABLE_PLACES INTO l_available_no_places
        FROM VIEW_AVAILABLE_TRIPS_
        WHERE TRIP_ID = l_trip_id;

        IF l_available_no_places = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Trip ' || l_trip_id || ' does not have any more free spots');
        END IF;
    END IF;

    UPDATE RESERVATION
    SET STATUS = l_status
    WHERE RESERVATION_ID = l_reservation_id;
END;
/

create PROCEDURE ADDRESERVATION3(trip_id INT, person_id INT)
AS
    l_trip_id INT := trip_id;
    l_person_id INT := person_id;
    l_trip_number INT;
    l_person_number INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_number FROM TRIP T WHERE T.TRIP_ID = l_trip_id;
    IF l_trip_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || trip_id || ' does not exist');
    END IF;

    SELECT COUNT(*) INTO l_person_number FROM PERSON P WHERE P.PERSON_ID = l_person_id;
    IF l_person_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Person ' || person_id || ' does not exist');
    END IF;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (l_trip_id, l_person_id, 'N');
END;
/

create PROCEDURE ModifyReservationStatus3(reservation_id INT, status VARCHAR)
AS
    l_reservation_id INT := reservation_id;
    l_status VARCHAR(1) := status;
    l_reservation_count INT;
    l_current_status VARCHAR(1);
BEGIN
    SELECT COUNT(*) INTO l_reservation_count FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_reservation_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Reservation ' || reservation_id || ' does not exist');
    END IF;

    SELECT R.STATUS INTO l_current_status FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_status = l_current_status THEN
        RAISE_APPLICATION_ERROR(-20002, 'Current reservation ' || reservation_id || ' status is equal to passed argument');
    END IF;

    UPDATE RESERVATION
    SET STATUS = l_status
    WHERE RESERVATION_ID = l_reservation_id;
END;
/

create PROCEDURE ADDRESERVATION4(trip_id INT, person_id INT)
AS
    l_trip_id INT := trip_id;
    l_person_id INT := person_id;
    l_trip_number INT;
    l_person_number INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_number FROM TRIP T WHERE T.TRIP_ID = l_trip_id;
    IF l_trip_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || trip_id || ' does not exist');
    END IF;

    SELECT COUNT(*) INTO l_person_number FROM PERSON P WHERE P.PERSON_ID = l_person_id;
    IF l_person_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Person ' || person_id || ' does not exist');
    END IF;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (l_trip_id, l_person_id, 'N');

    UPDATE TRIP
    SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
    WHERE TRIP_ID = l_trip_id;
END;
/

create PROCEDURE ModifyReservationStatus4(reservation_id INT, status VARCHAR)
AS
    l_reservation_id INT := reservation_id;
    l_status VARCHAR(1) := status;
    l_reservation_count INT;
    l_current_status VARCHAR(1);
    l_trip_id INT;
BEGIN
    SELECT COUNT(*) INTO l_reservation_count FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_reservation_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Reservation ' || reservation_id || ' does not exist');
    END IF;

    SELECT R.STATUS INTO l_current_status FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_status = l_current_status THEN
        RAISE_APPLICATION_ERROR(-20002, 'Current reservation ' || reservation_id || ' status is equal to passed argument');
    END IF;

    IF status IN ('N', 'P') THEN
        SELECT TRIP_ID INTO l_trip_id
        FROM RESERVATION R
        WHERE R.RESERVATION_ID = l_reservation_id;

        UPDATE TRIP
        SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
        WHERE TRIP_ID = l_trip_id;
    END IF;

    UPDATE RESERVATION
    SET STATUS = l_status
    WHERE RESERVATION_ID = l_reservation_id;
END;
/

create PROCEDURE PR_UPDATE_AVAILABLE_NO_PLACES AS
    l_trip_count INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_count FROM TRIP T;

    FOR row IN (SELECT * FROM TRIP T) LOOP
        UPDATE TRIP T
        SET T.NO_AVAILABLE_PLACES = (SELECT MAX_NO_PLACES FROM TRIP) - (
            SELECT COUNT(*)
            FROM RESERVATIONS_ R
            WHERE R.STATUS IN ('N', 'P') AND R.TRIP_ID = row.TRIP_ID
        )
        WHERE T.TRIP_ID = row.TRIP_ID;
    END LOOP;
END;
/

create PROCEDURE ADDRESERVATION5(trip_id INT, person_id INT)
AS
    l_trip_id INT := trip_id;
    l_person_id INT := person_id;
    l_trip_number INT;
    l_person_number INT;
BEGIN
    SELECT COUNT(*) INTO l_trip_number FROM TRIP T WHERE T.TRIP_ID = l_trip_id;
    IF l_trip_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Trip ' || trip_id || ' does not exist');
    END IF;

    SELECT COUNT(*) INTO l_person_number FROM PERSON P WHERE P.PERSON_ID = l_person_id;
    IF l_person_number = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Person ' || person_id || ' does not exist');
    END IF;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (l_trip_id, l_person_id, 'N');
END;
/

create PROCEDURE ModifyReservationStatus5(reservation_id INT, status VARCHAR)
AS
    l_reservation_id INT := reservation_id;
    l_status VARCHAR(1) := status;
    l_reservation_count INT;
    l_current_status VARCHAR(1);
    l_trip_id INT;
BEGIN
    SELECT COUNT(*) INTO l_reservation_count FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_reservation_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Reservation ' || reservation_id || ' does not exist');
    END IF;

    SELECT R.STATUS INTO l_current_status FROM RESERVATION R WHERE R.RESERVATION_ID = l_reservation_id;
    IF l_status = l_current_status THEN
        RAISE_APPLICATION_ERROR(-20002, 'Current reservation ' || reservation_id || ' status is equal to passed argument');
    END IF;

    IF status IN ('N', 'P') THEN

    END IF;

    UPDATE RESERVATION
    SET STATUS = l_status
    WHERE RESERVATION_ID = l_reservation_id;
END;
/

create PROCEDURE ModifyNoPlaces5(trip_id INT, no_places INT) AS
    l_trip_id INT := trip_id;
BEGIN
    UPDATE TRIP
    SET MAX_NO_PLACES = no_places
    WHERE TRIP_ID = l_trip_id;
END;
/

