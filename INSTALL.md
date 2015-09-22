Example compile on AIX:

```
export OBJECT_MODE=64
CFLAGS="-I/usr/local/lsf/8.0/include/ -L/usr/local/lsf/8.0/aix5-64/lib/ "
xlC128 $CFLAGS -llsf -lbat -o lsf_dump lsb_acct_dump.cc ofst.cc alist.cc jlist.cc lsf.cc lsf_dump.cc fdump.cc
```

Example compile on Linux:

```
CFLAGS="-I/ncar/opt/lsf/8.3/include/ -L/ncar/opt/lsf/8.3/linux2.6-glibc2.3-x86_64/lib/ "
g++ $CFLAGS -lnsl -llsf -lbat -o lsf_dump lsb_acct_dump.cc ofst.cc alist.cc jlist.cc lsf.cc lsf_dump.cc fdump.cc
```

