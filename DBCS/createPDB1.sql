create pluggable database PDB1 from cePDB keystore identified by "ZZ0r_cle#1";
alter pluggable database pdb1 open;
alter session set container=PDB1;
create tablespace TBS1 datafile size 1G;
select name from dba_services;
