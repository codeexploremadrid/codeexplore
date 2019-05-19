create pluggable database PDB2 ADMIN USER pdb_adm identified by "ZZ0r_cle#1";
alter pluggable database PDB2 open;
ADMINISTER KEY MANAGEMENT SET KEYSTORE close;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY "ZZ0r_cle#1" CONTAINER=all;
ALTER SESSION SET CONTAINER = pdb2;
ADMINISTER KEY MANAGEMENT SET KEY USING TAG 'tag' IDENTIFIED BY "ZZ0r_cle#1" WITH BACKUP USING 'backup_identifier';
create tablespace TBS2 datafile size 1G;
select name from dba_services;
ALTER SESSION SET CONTAINER = CDB$root;
