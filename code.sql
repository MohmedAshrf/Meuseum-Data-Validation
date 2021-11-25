%%sql
postgresql:///roman
    
-- Execute your SQL commands here
select upper(name) as name, lower(full_name) as full_name ,
CASE
    WHEN birth_city is null  and birth_province is null  THEN 'Unknown'
    WHEN birth_city is null  THEN CONCAT('Unknown, ', birth_province)
    WHEN birth_province is null THEN CONCAT(birth_city, ', Unknown')
    ELSE CONCAT(birth_city, ', ',birth_province)
END as birhtplace,
CASE
    WHEN (birth is null or death is null) THEN 'Unknown'
    ELSE  date_part('year',age(to_timestamp(death, 'yy-mm-dd HH24:MI:SS.MS'),to_timestamp(birth, 'yy-mm-dd HH24:MI:SS.MS')))::name
END as age,
CASE
    WHEN (reign_start is null or reign_end is null) THEN 'Unknown'
    ELSE  date_part('year',age(to_timestamp(reign_end, 'yy-mm-dd HH24:MI:SS.MS'),to_timestamp(reign_start, 'yy-mm-dd HH24:MI:SS.MS')))::name
END as regin,
CASE
    WHEN cause in ('Assassination', 'Natural Causes', 'Execution', 'Died in Battle', 'Suicide') THEN cause
    ELSE 'Other'
END as cause,
CASE
    WHEN date_part('year',to_timestamp(reign_start, 'yy-mm-dd HH24:MI:SS.MS'))::int < 284  THEN 'Principate'
    ELSE 'Dominate'
END as era
from emperors
