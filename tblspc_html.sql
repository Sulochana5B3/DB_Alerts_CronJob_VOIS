select '<BR><FONT FACE="VERDANA" SIZE=3 COLOR="#000000"> &1 Database:' || UPPER(b.instance_name) || '(Host:' || upper(b.host_name) || ', Startup
Time:'||TO_CHAR(STARTUP_TIME, 'DD-MON-YY HH24:MI') ||')<BR><BR>' from v$database a,v$instance b,dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FGFFFF">TABLESPACE_NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MB_Used
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MB_Free
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">Percent_Used ' from dual;

select case  when percent_used < 90 then '<tr bgcolor="#FFFF00">'
else '<tr bgcolor="#FF0000">' end ||
'<td><FONT FACE="VERDANA" SIZE=2>' || TABLESPACE_NAME ||
'<td><FONT FACE="VERDANA" SIZE=2>' || MB_Used ||
'<td><FONT FACE="VERDANA" SIZE=2>' || MB_Free ||
'<td><FONT FACE="VERDANA" SIZE=2>' || Percent_Used
from
( select  a.TABLESPACE_NAME,
        round(a.BYTES/1024/1024,2) MB_used,
        round(b.BYTES/1024/1024,2) MB_free,
        round(((a.BYTES-b.BYTES)/a.BYTES)*100,2) percent_used
 from
        (
                select  TABLESPACE_NAME,
                        sum(BYTES) BYTES
                from    dba_data_files
                group   by TABLESPACE_NAME
        )
        a,
        (
                select  TABLESPACE_NAME,
                        sum(BYTES) BYTES ,
                        max(BYTES) largest
                from    dba_free_space
                group   by TABLESPACE_NAME
        )
        b
 where   a.TABLESPACE_NAME=b.TABLESPACE_NAME
 and round(((a.BYTES-b.BYTES)/a.BYTES)*100) > 75
 order   by ((a.BYTES-b.BYTES)/a.BYTES) desc);
select '</table>' from dual;


