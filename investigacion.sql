-- REPORTE DE CRIMENES
SELECT
    description
FROM
    crime_scene_report
WHERE
    type = "murder"
    AND date = 20180115
    AND city = "SQL City";

-- Resultado
-- 2 witnesses.
-- The first witness lives at the last house on "Northwestern Dr".
-- The second witness, named Annabel, lives somewhere on "Franklin Ave"

-----

-- TESTIGOS + ENTREVISTAS
-- T1 - id.14887
-- T2 - id.16371
SELECT
    p.id,
    i.transcript
FROM
    person AS p
    LEFT JOIN (
        SELECT
            *
        FROM
            interview
    ) AS i ON p.id = i.person_id
WHERE
    (
        address_street_name = "Northwestern Dr"
        AND address_number = (
            SELECT
                MAX(address_number)
            FROM
                person
        )
    )
    OR (
        address_street_name = "Franklin Ave"
        AND name LIKE "%Annabel%"
    )
    -- Resultado
    -- bolsa Get Fit Now Gym, code gym empieza 48Z, 
    -- gold miembro, placa H42W
    -- 20180109 en el gym 
    -- Horas en el gym del sospechoso
--------------------
SELECT
    membership_id,
    person_id,
    name,
    check_in_date,
    check_in_time,
    check_out_time
FROM
    get_fit_now_member AS gym_m
    LEFT JOIN (
        SELECT
            membership_id,
            check_in_date,
            check_in_time,
            check_out_time
        FROM
            get_fit_now_check_in
        WHERE
            check_in_date = 20180109
    ) AS gym_c ON gym_m.id = gym_c.membership_id
WHERE
    gym_m.membership_status = "gold"
    AND gym_m.id LIKE "48Z%"

-- Horas Gym del testigo 16-17
SELECT
    person_id,
    name,
    check_in_time,
    check_out_time
FROM
    get_fit_now_member AS gym_m
    LEFT JOIN (
        SELECT
            membership_id,
            check_in_date,
            check_in_time,
            check_out_time
        FROM
            get_fit_now_check_in
        WHERE
            check_in_date = 20180109
    ) gym_c ON gym_m.id = gym_c.membership_id
WHERE
    gym_m.person_id = 16371

-- PLACAS DE CARRO SOSPECHOSO
-- PERSONAS ID: 28819 Y 67318
SELECT
    p.license_id,
    p.name,
    p.id
FROM
    drivers_license AS drive
    LEFT JOIN (
        SELECT
            id,
            license_id,
            name
        FROM
            person
    ) As p ON drive.id = p.license_id
WHERE
    drive.plate_number LIKE "%H42W%"

-- SOSPECHOSO 67318
INSERT INTO
    solution
VALUES
    (1, 'Jeremy Bowers');

SELECT
    value
FROM
    solution;

--------------------------------
-- PARTE II
--------------------------------
SELECT
    *
FROM
    interview
WHERE
    person_id = 67318
--  Tesla Model S.
-- by a woman with a lot of money
-- red hair
-- 5'5" (65") or 5'7" (67")
--  SQL Symphony Concert 3 times in December 2017
SELECT
    name,
    person_id,
    freq
FROM
    drivers_license AS drive
    LEFT JOIN (
        SELECT
            id,
            license_id,
            name
        FROM
            person
    ) AS p ON drive.id = p.license_id
    LEFT JOIN (
        SELECT
            person_id,
            COUNT(*) AS freq
        FROM
            facebook_event_checkin
        WHERE
            event_name = "SQL Symphony Concert"
            AND date BETWEEN 20171201 AND 20171231
        GROUP BY
            person_id
        ORDER BY
            freq DESC
    ) AS fb ON p.id = fb.person_id
WHERE
    drive.gender = "female"
    AND drive.car_make = "Tesla"
    AND drive.car_model = "Model S"
    AND drive.hair_color = 'red'
    AND drive.height BETWEEN 65 AND 67

-- Ingresos de sospechoso
SELECT
    id,
    name,
    annual_income
FROM
    person
    INNER JOIN (
        SELECT
            *
        FROM
            income
    ) USING (ssn)
WHERE
    person.id IN (99716, 90700, 78881)

--- LUGAR DEL CRIMEN
SELECT
    event_name,
    name
FROM
    facebook_event_checkin AS f
    LEFT JOIN (
        SELECT
            id,
            name
        FROM
            person
    ) AS p ON f.person_id = p.id
WHERE
    f.event_name = "The Funky Grooves Tour"

--- DONDE CONTACTO A JEREMY
SELECT
    *
FROM
    facebook_event_checkin AS f
    LEFT JOIN (
        SELECT
            id,
            name
        FROM
            person
    ) AS p ON f.person_id = p.id
WHERE
    f.event_name = "SQL Symphony Concert"
    AND f.date = 20171206 --v 69325 99716
-------------------------
--  id SOSPECHOSO 78881
INSERT INTO
    solution
VALUES
    (1, 'Miranda Priestly');

SELECT
    value
FROM
    solution;

-----------------------