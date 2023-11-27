# Downloaded the data: We import the data from 311_services_data for New York City. This dataset shows the data of noise pollution complains registered.alter

# Now I have imported the dataset into MySQL workbench and ready to clean the data.alter

# First of  all lets check the data 



SELECT *
FROM noise;

# Add a new column with name date_time and fill it with datetime formate for the  combine_datetime column

ALTER TABLE noise
ADD COLUMN mix_date DATETIME;


#now fill this mix_date column with the datetime formate of string combine_datetime


UPDATE noise
SET mix_date = STR_TO_DATE(combine_datetime, '%Y-%m-%d %H:%i:%s');


# lets just check for the data if if worked properly

SELECT mix_date,
       reported_date,
       reported_day,
       reported_month
       reported_time
FROM noise;

# now fill the reported_date and time separately into separate column as we have already included two columns so first delete them and add new

ALTER TABLE noise
DROP COLUMN reported_date;

ALTER TABLE noise
DROP COLUMN reported_time;

# so now just create new columnns name same as reported_date and reported_time

ALTER TABLE noise
ADD COLUMN reported_date DATE;

ALTER TABLE noise
ADD COLUMN reported_year INT;

ALTER TABLE noise
ADD COLUMN reported_day VARCHAR(50);

ALTER TABLE noise
ADD COLUMN reported_month VARCHAR(50);

ALTER TABLE noise
ADD COLUMN reported_time TIME;

# now lets fill the values into these
# fill the reported_date

UPDATE noise
SET reported_date = DATE(mix_date);

# fill the reported_time

UPDATE noise
SET reported_time = TIME(mix_date);


# fill the reporte_day

UPDATE noise
SET reported_day = dayofweek(mix_date);

# THis day is in form of numbers like 1 for sunday 2 for monday as sql consider day of the week

UPDATE noise
SET reported_day =
    CASE 
        WHEN reported_day = 1 THEN 'Sunday'
        WHEN reported_day = 2 THEN 'Monday'
        WHEN reported_day = 3 THEN 'Tuesday'
        WHEN reported_day = 4 THEN 'Wednesday'
        WHEN reported_day = 5 THEN 'Thursday'
        WHEN reported_day = 6 THEN 'Friday'
        WHEN reported_day = 7 THEN 'Saturday'
        ELSE 'Invalid Day'
    END;

# now will fill the month details in the reported_month column

UPDATE noise
SET reported_month = MONTHNAME(mix_date);

# At last the year column

UPDATE noise
SET reported_year = YEAR(mix_date);


# lets fill the null values in city column 

# first change the blank values into null
UPDATE noise
SET City = CASE WHEN City = '' THEN NULL ELSE City END;

#now lets just get rid of these nullvalues

UPDATE noise AS a
JOIN noise AS b
ON a.`Incident Zip` = b.`Incident Zip` AND a.`Unique Key` <> b.`Unique Key`
SET a.City = COALESCE(a.City, b.City)
WHERE a.City IS NULL AND b.City IS NOT NULL;

# now lets just analyze the data a little bit and check for TOP 5 city with most complains

SELECT City, COUNT(City)
FROM noise
GROUP BY City
ORDER BY COUNT(City) DESC
LIMIT 5;


#  which noise is disturbing the people more

SELECT Descriptor, COUNT(Descriptor)
FROM noise
GROUP BY Descriptor
ORDER BY COUNT(Descriptor) DESC
LIMIT 5;


# At what time the most of complain has been recorded

SELECT reported_time, COUNT(reported_time)
FROM noise
GROUP BY reported_time
ORDER BY COUNT(reported_time) DESC
LIMIT 5;

# Here we can see that most of the complains are repoted at night time

# On which day the residents complain more

SELECT reported_day, COUNT(reported_day)
FROM noise
GROUP BY reported_day
ORDER BY COUNT(reported_day) DESC
LIMIT 5;

# it is clearly observed that most of the complains re reported on sunday 

# now we will visualize the data using tableau