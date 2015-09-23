# lsfsql
Export job accounting data from IBM Platform LSF to CSV files for SQL import. 
This allows the job information to be processed and analysed by other
(unrelated) tools. An example SQL database schema is provided for reference.

This tool uses the IBM Platform LSF 8 (or later) C API. You will need to
have LSF installed and operational in order to use the LSF API.

Expected usage pattern:
1. Wait until LSF rolls lsb.acct file (optional)
2. Run lsfsql to dump LSF accounting data into CSV
3. Import CSV into SQL database
4. Analysis in SQL database of data


