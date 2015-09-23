Prerequisites:
* Fully funtional LSF installation
  * Path to C include: $LSF_BINDIR/../../include
  * Path to LSF Libs: $LSF_LIBDIR
  * LSF should be setup to roll the lsb.acct files (optional but highly suggested)
    * In lsb.parms to roll once a day, set the following:
```
ACCT_ARCHIVE_AGE = 1
ACCT_ARCHIVE_TIME = 00:01
```
* Execution node must be licensed to run LSF commands (otherwise LSF's API calls will fail)
* C++ compiler (tested on XL and GCC)

Suggested:
* SQL Server (tested with MySQL)
  * Server must be able to import CSV files. 
  * Example SQL schema provided. All fieldnames are based directly on LSF's API reference

Example compile on AIX:
```
export OBJECT_MODE=64
xlC128 -I$LSF_BINDIR/../../include -L$LSF_LIBDIR -llsf -lbat -o lsf_dump lsb_acct_dump.cc ofst.cc alist.cc jlist.cc lsf.cc lsf_dump.cc fdump.cc
```

Example compile on Linux:
```
g++ -I$LSF_BINDIR/../../include -L$LSF_LIBDIR  -lnsl -llsf -lbat -o lsf_dump lsb_acct_dump.cc ofst.cc alist.cc jlist.cc lsf.cc lsf_dump.cc fdump.cc
```

Example usage:
```
bash scripts/mysql_import.sh "example" "$LSF_ENVDIR/../work/$cluster/logdir/lsb.acct.1" /usr/local/bin/lsf_dump
```
