-- If not already done execute the following permission grant on DBMS_LOCK
-- It is used in the function below to sleep for a while
GRANT execute ON DBMS_LOCK TO World;

-- Create a type used in the next function
create or replace type world.number_type as table of number;
/

-- Function to be used within a SELECT statement
-- Parameter 1: <numberToReturn>
-- Parameter 2: <sleepTimeInSeconds>
create or replace function world.get_num_t(nbr in number, s_time in number)
return number_type
pipelined
is
begin
	dbms_lock.sleep(s_time);
	pipe row(nbr);
	return;
end;
/
