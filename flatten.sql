/****** Script for SelectTopNRows command from SSMS  ******/

SELECT
	  JSON_VALUE([SRC], '$.api_properties') AS api_properties
	  ,JSON_VALUE([SRC], '$.carrier') AS carrier
	  ,JSON_VALUE([SRC], '$.device_id') AS device_id
	  ,JSON_VALUE([SRC], '$.device_manufacturer') AS device_manufacturer
	  ,JSON_VALUE([SRC], '$.device_model') AS device_model
	  ,JSON_VALUE([SRC], '$.enriched') AS enriched
	  ,JSON_VALUE([SRC], '$.event_id') AS event_id
	  ,JSON_VALUE([SRC], '$.event_properties.action') AS action
	  ,JSON_VALUE([SRC], '$.event_properties.auth') AS auth
	  ,JSON_VALUE([SRC], '$.event_properties.component_type') AS component_type
	  ,JSON_VALUE([SRC], '$.event_properties.has_double_fired') AS has_double_fired
	  ,JSON_VALUE([SRC], '$.event_properties.locale') AS locale
	  ,JSON_VALUE([SRC], '$.event_properties.logging_id') AS logging_id
	  ,JSON_VALUE([SRC], '$.event_properties.page_key') AS page_key
	  ,JSON_VALUE([SRC], '$.event_properties.page_path') AS page_path
	  ,JSON_VALUE([SRC], '$.event_properties.platform') AS event_platform
	  ,JSON_VALUE([SRC], '$.event_properties.prev_page_key') AS prev_page_key
	  ,JSON_VALUE([SRC], '$.event_properties.prev_page_path') AS prev_page_path
	  ,JSON_VALUE([SRC], '$.event_properties.project_name') AS project_name
	  ,JSON_VALUE([SRC], '$.event_properties.session_uuid') AS session_uuid
	  ,JSON_VALUE([SRC], '$.event_properties.source') AS sources
	  ,JSON_VALUE([SRC], '$.event_properties.state') AS states
	  ,JSON_VALUE([SRC], '$.event_properties.time_start') AS time_start
	  ,JSON_VALUE([SRC], '$.event_type') AS event_type
	  ,JSON_VALUE([SRC], '$.group_properties') AS group_properties
	  ,JSON_VALUE([SRC], '$.groups') AS groups
	  ,JSON_VALUE([SRC], '$.jwt_authed') AS jwt_authed
	  ,JSON_VALUE([SRC], '$.language') AS languages
	  ,JSON_VALUE([SRC], '$.library.name') AS library_name
	  ,JSON_VALUE([SRC], '$.library.version') AS library_version
	  ,JSON_VALUE([SRC], '$.os_name') AS os_name
	  ,JSON_VALUE([SRC], '$.os_version') AS os_version
	  ,JSON_VALUE([SRC], '$.platform') AS platforms
	  ,JSON_VALUE([SRC], '$.sequence_number') AS sequence_number
	  ,JSON_VALUE([SRC], '$.session_id') AS session_id
	  ,JSON_VALUE([SRC], '$.timestamp') AS time_stamp
	  ,JSON_VALUE([SRC], '$.user_agent') AS user_agent
	  ,JSON_VALUE([SRC], '$.user_id') AS userid
	  ,JSON_VALUE([SRC], '$.validated') AS validated
	  ,JSON_VALUE([SRC], '$.validation_version') AS validation_version
	  ,JSON_VALUE([SRC], '$.version_name') AS version_name
      
  INTO dbo.flattened_json_table
  FROM [manoj].[dbo].[Flatten_json];


GO


/****** Script for SelectTopNRows command from SSMS  ******/

SELECT * FROM dbo.flattened_json_table;


/****** DELETE null rows from the table  ******/
DELETE FROM dbo.flattened_json_table WHERE time_stamp IS NULL;


/****** Contains UNIQUE rows  ******/
with ROWCTE(user_session) as  
(
select CONCAT(userid, '_', time_stamp) AS user_timestamp
from dbo.flattened_json_table)

SELECT count(distinct user_timestamp), count(user_timestamp) FROM ROWCTE;





/****** PK - (userid, time_stamp) ******/
ALTER TABLE dbo.flattened_json_table ALTER COLUMN userid nvarchar(40) NOT NULL;
ALTER TABLE dbo.flattened_json_table ALTER COLUMN time_stamp nvarchar(40) NOT NULL;

ALTER TABLE dbo.flattened_json_table
ADD PRIMARY KEY (userid, time_stamp);


/****** Setting proper Datatype ******/
ALTER TABLE dbo.flattened_json_table ALTER COLUMN device_id INT;
ALTER TABLE dbo.flattened_json_table ALTER COLUMN event_id INT;
ALTER TABLE dbo.flattened_json_table ALTER COLUMN auth TINYINT;
ALTER TABLE dbo.flattened_json_table ALTER COLUMN sequence_number INT;
ALTER TABLE dbo.flattened_json_table ALTER COLUMN session_id BIGINT;


/****** TABLE SCHEMA ******/
EXEC sp_help 'dbo.flattened_json_table';


SELECT * FROM dbo.flattened_json_table;