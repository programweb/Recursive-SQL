# Recursive-SQL

mysql_mariadb-path-to-parent.sql
&nbsp;

SQL code I developed for a scientist/researcher at the University of Washington to get all the ancestors (geographic location hierarchy for human disease data) 


Here is recursive sample **SQL for PostgreSQL** that I made on a job in 2015:

```sql
with recursive loopedInserts as (
    INSERT INTO "configuration"(parameter, value)
    VALUES
    	('xml_archive_dir_base', '/srv/dc/mirth/live/adt/archive'),
	    ('xml_error_dir_base', '/srv/dc/mirth/live/adt/error'),
	    ('xml_output_location', '/srv/dc/mirth/live/adt/out')
    RETURNING id, value
)
INSERT INTO facilities_configuration(facilities_id, configuration_id, value)
    SELECT f.id, c.id, v.value 
    FROM facilities f 
    CROSS JOIN (SELECT id FROM loopedInserts) c
    LEFT JOIN loopedInserts v ON c.id = v.id
```
