#!/usr/bin/env bash
export ORACLE_SID=TSTTOOLS.test.ie
export ORACLE_HOME=/opt/oracle/product/121020_cl_64/cl
export PATH=$PATH:/var/SP/vfinas/tooladm/PIL/properties:/var/SP/vfinas/tooladm/PIL/generic:/var/SP/vfinas/tooladm/PIL/scripts:/var/SP/vfinas/tooladm/PIL/temp
:/var/SP/vfinas/tooladm/PIL/scout/validationScripts:/var/SP/vfinas/tooladm/PIL/scout/fixScripts:/usr/local/bin:/opt/oracle/product/121020_cl_64/cl/bin:/usr/j
ava/jdk1.8.0_65/bin:/var/SP/vfinas/tooladm:/usr/bin:/usr/local/bin:/opt/oracle/product/121020_cl_64/cl:/opt/oracle/product/121020_cl_64/cl/lib:/opt/oracle/pr
oduct/121020_cl_64/cl/bin:/usr/java/jdk1.8.0_65:/usr/java/jdk1.8.0_65/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/puppetlabs/bin:/usr/sbin:/us
r/local/bin:/bin:/var/SP/vfinas/tooladm/SoftwareChecker/SoftwareChecker8.8/etc:/var/SP/vfinas/tooladm/Scripts:/usr/bin/python:.:/var/SP/vfinas/tooladm/Script
:/var/SP/vfinas/tooladm/GENESIS/ant1.9.4/bin:/var/SP/vfinas/tooladm/genesis_launcher:/var/SP/vfinas/tooladm/genesis_launcher/SQL:/var/SP/vfinas/tooladm/hotfi
x:/var/SP/vfinas/tooladm/ensight:/var/SP/vfinas/tooladm/ensight/SQL:/usr/java/jdk1.8.0_65/bin:/opt/oracle/product/121020_cl_64/cl/bin:/var/SP/vfinas/tooladm/
BOOTMANAGER/scripts:/var/SP/vfinas/tooladm/GENESIS/ant1.9.4/bin:/usr/java/jdk1.8.0_65/bin:/var/SP/vfinas/tooladm/Amc-iebssavr/bin:/var/SP/vfinas/tooladm/Amc-
iebssavr/tomcat/bin:/usr/bin/openssl:/usr/bin/openssl:/usr/local/bin:/usr/bin:/etc:/var/SP/vfinas/tooladm/PIL/scripts

export TNS_ADMIN=/var/SP/vfinas/tooladm/TNS_ADMIN

for i in `cat /var/SP/vfinas/tooladm/ADBA_SCRIPTS/table_space/DB_LIST.txt`
do
echo $i
     sqlplus -silent AIM_DBA/AIM_DBA_E4UINOX@$i <<EOF
prompt db connected

! echo 'Database Name is ' $i
set serveroutput on size 1000000
set termout off
set lines 1000
SET VERIFY OFF
set pages 0
set head off
set feedback off
break on grantee
col filename new_value fname
col spoolfile new_value spf
col object_name for a30
col owner for a30
col object_type for a20
col status for a10
col last_ddl_time for a20
col index_name for a30
col table_name for a30
col TABLE_OWNER for a30
col INDEX_TYPE for a10
col tablespace_name for a30
col partition_name for a30
col INDEX_OWNER for a30
col SUBPARTITION_NAME for a30
set serveroutput on
set lines 300 pages 1500
spool on
spool /var/SP/vfinas/tooladm/ADBA_SCRIPTS/table_space/Tablespace_`echo $i`_Report.html
@/var/SP/vfinas/tooladm/ADBA_SCRIPTS/table_space/tblspc_html.sql 

exit
EOF
done


#####SEND MAIL Table Format
cd /var/SP/vfinas/tooladm/ADBA_SCRIPTS/table_space
(echo "From: Table_Space@vodafone.com "
  echo "To:sulochana.vemula@vodafone.com"
#  echo "To:sulochana.vemula@vodafone.com"
  echo "Subject: DB-Tablespace-Utilization-Report"
  echo "Content-Type: text/html; charset=\"us-ascii\""
cat DE_common_header.html
cat tablespace.html
cat static_List.html
cat Tablespace_TSTABP1_Report.html
cat Tablespace_TSTOMS1_Report.html
echo "Many Regards"
) | /usr/sbin/sendmail -t

