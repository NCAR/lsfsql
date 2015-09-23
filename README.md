# lsfsql
Export job accounting data from IBM Platform LSF to CSV files for SQL import. 
This allows the job information to be processed and analysed by other
(unrelated) tools. An example SQL database schema is provided for reference.

This tool uses the IBM Platform LSF 8 (or later) C API. You will need to
have LSF installed and operational in order to use the LSF API.

Expected usage pattern:
* Wait until LSF rolls lsb.acct file (optional)
* Run lsfsql to dump LSF accounting data into CSV
* Import CSV into SQL database
* Analysis in SQL database of data


