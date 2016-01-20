export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
/u01/app/oracle/product/11.2.0/xe/bin/sqlplus -s sys/oracle as sysdba << EOF
whenever sqlerror exit sql.sqlcode;
set echo off
set heading off

@/root/createuser.sql
@/root/city.sql
@/root/country.sql
@/root/countrylanguage.sql
@/root/customers.sql
@/root/orderdetails.sql
@/root/orders.sql
@/root/zips.sql
@/root/sproc.sql

exit;
EOF
