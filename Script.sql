/* Lets look at the data as a whole*/
SELECT *
FROM medical_charges mc 


/* Do smokers pay more in medical charges on average?*/

WITH avg_charges_by_smoker AS (
    SELECT
        smoker,
        ROUND(AVG(charges), 2) AS avg_charges
    FROM medical_charges
    WHERE charges IS NOT NULL
    GROUP BY smoker
)
SELECT
    smoker,
    avg_charges
FROM avg_charges_by_smoker;


/*Does age affect the amount paid on average?*/
SELECT 	
 	CASE 
 		WHEN age BETWEEN 10 AND 20 THEN '10-20'
 		WHEN age BETWEEN 21 AND 30 THEN '21-30'
 		WHEN age BETWEEN 31 AND 40 THEN '31-40'
 		WHEN age BETWEEN 41 AND 50 THEN '41-50'
 		ELSE '51+'
 	END AS age_group,
 	AVG(charges) as avg_charges
 FROM medical_charges mc 
 GROUP BY age_group 
 ORDER BY age_group ASC;

/*What region has the highest average charger per age group?*/
WITH AgeGrouped AS (
  SELECT
    *,
    CASE 
      WHEN age BETWEEN 10 AND 20 THEN '10-20'
      WHEN age BETWEEN 21 AND 30 THEN '21-30'
      WHEN age BETWEEN 31 AND 40 THEN '31-40'
      WHEN age BETWEEN 41 AND 50 THEN '41-50'
      ELSE '51+'
    END AS age_group
  FROM medical_charges
)
SELECT
  age_group,
  region,
  ROUND(AVG(charges), 2) AS avg_charge
FROM AgeGrouped
GROUP BY region, age_group
ORDER BY age_group;

/*Compare charges of people of similar age and sex who do and do not smoke. */
WITH AgeGrouped AS (
  SELECT
    *,
    CASE 
      WHEN age BETWEEN 10 AND 20 THEN '10-20'
      WHEN age BETWEEN 21 AND 30 THEN '21-30'
      WHEN age BETWEEN 31 AND 40 THEN '31-40'
      WHEN age BETWEEN 41 AND 50 THEN '41-50'
      ELSE '51+'
    END AS age_group
  FROM medical_charges
)
SELECT
  a.age_group AS age_group_a,
  a.sex AS sex_a,
  a.smoker AS smoker_a,
  a.region AS region,
  ROUND(a.charges,2) AS charges_a,
  b.age_group AS age_group_b,
  b.sex AS sex_b,
  b.smoker AS smoker_b,
  ROUND(b.charges,0) AS charges_b
FROM AgeGrouped a
JOIN AgeGrouped b
  ON a.region = b.region
  AND a.smoker != b.smoker
WHERE a.smoker = 'yes'
GROUP BY a.age_group, b.age_group;

/* A BMI over 24.9 is considered overweight for the average American. Does being over this limit affect your medical charges?*/
WITH BMIClass AS ( 	
	SELECT 
		*,
		CASE 
		  WHEN bmi <= 24.9 THEN 'bmi_not_overweight'
		  Else 'bmi_overweight'
		END AS bmi_class
	FROM medical_charges mc
)
SELECT
	bmi_class,	
	ROUND(AVG(charges),0) AS avg_charges 
FROM BMIClass 
GROUP BY bmi_class;
