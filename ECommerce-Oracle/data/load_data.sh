sqlplus -s system/oracle << EOF
whenever sqlerror exit sql.sqlcode;
set echo off
set heading off

@createuser.sql
@city.sql
@country.sql
@countrylanguage.sql
@customers.sql
@orderdetails.sql
@orders.sql
@zips.sql

exit;
EOF
