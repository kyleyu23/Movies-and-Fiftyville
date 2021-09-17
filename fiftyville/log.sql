-- Keep a log of any SQL queries you execute as you solve the mystery.

select description from crime_scene_reports where year = 2020 and month = 7 and day = 28 and street = "Chamberlin Street";
--Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse. Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.

.schema interviews
select name, transcript from interviews where year = 2020 and month = 7 and day = 28 and transcript like "%courthouse%";
--Ruth | Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away. If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time frame.
    -- check cars left the parking lot
--Eugene | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at the courthouse, I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.
    -- check people who withdrew money from ATM
--Raymond | As the thief was leaving the courthouse, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.
    --check phone_calls about flights

-- check cars left the parking lot
    .schema courthouse_security_logs
    select minute, activity, license_plate from courthouse_security_logs where year = 2020 and month = 7 and day = 28 and hour = 10 and minute between 15 and 20;
    --16 | exit | 5P2BI95
    --18 | exit | 94KL13X
    --18 | exit | 6P58WS2
    --19 | exit | 4328GD8
    --20 | exit | G412CB7

        --get name by license_plate
    select name from people where license_plate in
        (select license_plate from courthouse_security_logs where year = 2020 and month = 7 and day = 28 and hour = 10 and minute between 15 and 20)
        order by name asc;
    Amber
    Danielle
    Ernest X
    Patrick
    Roger

-- check people who withdrew money from ATM
    --get bank account number from atm_transactions
    --get person_id by bank account number
    --get name by person_id
    select name from people where id in (
        select person_id from bank_accounts where account_number in (
            select account_number from atm_transactions where year = 2020 and month = 7 and day = 28 and atm_location = "Fifer Street" and transaction_type = "withdraw"
            )
        )
    Bobby
    Danielle
    Elizabeth
    Ernest X
    Madison
    Roy
    Russell
    Victoria

-- check phone_calls about flights
    select caller from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60;
    -- get name by phone_number
    select name from people where phone_number in
    (select caller from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60)
    order by name asc;
    Bobby
    Ernest X
    Evelyn
    Kathryn
    Kimberly
    Madison
    Roger
    Russell
    Victoria

-- check who Ernest called to order tickets
    --get Ernest's phone number
    select phone_number from people where name = "Ernest"

    --get receivers from Ernest's call
    select receiver from phone_calls where caller =
        (select phone_number from people where name = "Ernest") and
        year = 2020 and month = 7 and day = 28
        --from these people, get the people who called the airport
        select caller from phone_calls where caller in
        (
           select receiver from phone_calls where caller =
            (select phone_number from people where name = "Ernest") and
            year = 2020 and month = 7 and day = 28
        )


--get eariliest flight destination
select * from flights where origin_airport_id =
(select id from airports where city = "Fiftyville")
order by month, day, hour, minute asc
-- the first one after day 28 is the earilist flight
4 is the destination_id
36 is the flight_id


select * from airports where id = 4



--find accomplice

    --get receivers from Ernest's call
        select name from people where phone_number =
        (select receiver from phone_calls where caller =
            (select phone_number from people where name = "Ernest") and
            year = 2020 and month = 7 and day = 28 and duration <= 60
        )

