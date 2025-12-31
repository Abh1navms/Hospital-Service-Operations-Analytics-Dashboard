create database Hospital;
use Hospital;


# CHECK TOTAL ROWS
SELECT COUNT(*) AS total_patients FROM patients;

SELECT COUNT(*) AS total_service_records FROM services_weekly;

SELECT COUNT(*) AS total_staff FROM staff;

SELECT COUNT(*) AS total_schedule_rows FROM staff_schedule;



# Weekly Demand vs Capacity
SELECT
    week,
    service,
    available_beds,
    patients_request,
    (patients_request - available_beds) AS capacity_gap
FROM services_weekly
ORDER BY week;



# Admission vs Refusal Rate

SELECT
    week,
    service,
    patients_admitted,
    patients_refused,
    ROUND((patients_admitted / patients_request) * 100, 2) AS admission_rate,
    ROUND((patients_refused / patients_request) * 100, 2) AS refusal_rate
FROM services_weekly;


# Average Patient Satisfaction by Service

SELECT
    service,
    ROUND(AVG(satisfaction), 2) AS avg_satisfaction
FROM patients
GROUP BY service
ORDER BY avg_satisfaction DESC;




SET SQL_SAFE_UPDATES = 0;
UPDATE patients
SET arrival_date = STR_TO_DATE(arrival_date, '%d-%m-%Y'),
    departure_date = STR_TO_DATE(departure_date, '%d-%m-%Y');

# (LOS) - Length of Stay
SELECT
    patient_id,
    name,
    service,
    DATEDIFF(departure_date, arrival_date) AS length_of_stay
FROM patients
ORDER BY length_of_stay DESC;

# Service Efficiency Ranking

SELECT
    sw.service,
    ROUND(AVG(sw.patients_admitted / sw.patients_request) * 100, 2) AS avg_admission_rate,
    ROUND(AVG(sw.patient_satisfaction), 2) AS avg_service_satisfaction,
    ROUND(AVG(ss.present) * 100, 2) AS staff_punctuality
FROM services_weekly sw
LEFT JOIN staff_schedule ss ON sw.service = ss.service
GROUP BY sw.service
ORDER BY avg_admission_rate DESC;
