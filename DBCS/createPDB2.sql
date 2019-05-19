create pluggable database PDB2 ADMIN USER pdb_adm  identified by "ZZ0r_cle#1";
alter pluggable database PDB2 open;
alter session set container=PDB2;
create tablespace TBS2 datafile size 1G;
select name from dba_services;
