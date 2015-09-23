#!/bin/bash
#
# Simple example script to dump lsf accounting and then import into SQL
#
[ -z "$1" -o -z "$2" -z "$3" ] && echo "$0 {lsf cluster name} {path to lsb.acct} {path to lsf_dump}"
[ -f /etc/nolocal ] && echo "nolocal set. bailing!" && exit 1
umask 0027

#Default configuration for this script
#may not work for your setup without tweaking
cluster="$1"
fname="$2"
lsfdump="$3"
dst=/tmp/
#It is expected that mysql user will have passwordless access to the database
mysql_user=lsf

#default files created by LSF dump
joblist=$dst/joblist
jobFinishLog=$dst/jobFinishLog
jobFinishLog_exec=$dst/jobFinishLog_execHosts
jobFinishLog_asked=$dst/jobFinishLog_askedHosts
jobFinishLog_usage=$dst/jobFinishLog_hRusages
alist=$dst/alist
rsvFinishLog=$dst/rsvFinishLog
rsvFinishLog_alloc=$dst/rsvFinishLog_alloc

echo "LSF dump: $fname lines: $(wc -l < $fname)"
$lsf_dump $fname \
    $joblist $jobFinishLog $jobFinishLog_execHosts \
    $jobFinishLog_askedHosts $jobFinishLog_hRusages \
    $alist $rsvFinishLog $rsvFinishLog_alloc
ret=$?
curjobs=$(wc -l < $jobFinishLog)
echo "LSF dump: $(basename $fname) return: $? jobs: $curjobs" 
[ $ret -ne 0 ] && echo -e "Error parsing $fname.\nReturn = $ret\nOutput:\n$out" && exit 1

SQLquery=$(echo "
use LSF;
LOAD DATA INFILE '$jobFinishLog' REPLACE 
    INTO TABLE ${cluster}_jobFinishLog 
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '\"'
    ESCAPED BY '\\\\'
    LINES TERMINATED BY '\\n'
    (jobId,userId,userName,numProcessors,jStatus,submitTime,beginTime,termTime,startTime,endTime,queue,resReq,fromHost,numAskedHosts,hostFactor,numExHosts,numExPhysicalHosts,cpuTime,jobName,command,ru_utime,ru_stime,ru_maxrss,ru_ixrss,ru_ismrss,ru_idrss,ru_isrss,ru_minflt,ru_majflt,ru_nswap,ru_inblock,ru_oublock,ru_msgsnd,ru_msgrcv,ru_nsignals,ru_nvcsw,ru_nivcsw,ru_exutime,dependCond,timeEvent,preExecCmd,mailUser,projectName,exitStatus,maxNumProcessors,loginShell,idx,maxRMem,maxRSwap,rsvId,sla,additionalInfo,exitInfo,warningTimePeriod,warningAction,chargedSAAP,licenseProject,app,postExecCmd,runtimeEstimation,jgroup,requeueEValues,notifyCmd,lastResizeTime,jobDescription,SUB_JOB_NAME,SUB_QUEUE,SUB_HOST,SUB_IN_FILE,SUB_OUT_FILE,SUB_ERR_FILE,SUB_EXCLUSIVE,SUB_NOTIFY_END,SUB_NOTIFY_BEGIN,SUB_USER_GROUP,SUB_CHKPNT_PERIOD,SUB_CHKPNT_DIR,SUB_CHKPNTABLE,SUB_RESTART_FORCE,SUB_RESTART,SUB_RERUNNABLE,SUB_WINDOW_SIG,SUB_HOST_SPEC,SUB_DEPEND_COND,SUB_RES_REQ,SUB_OTHER_FILES,SUB_PRE_EXEC,SUB_LOGIN_SHELL,SUB_MAIL_USER,SUB_MODIFY,SUB_MODIFY_ONCE,SUB_PROJECT_NAME,SUB_INTERACTIVE,SUB_PTY,SUB_PTY_SHELL,SUB_EXCEPT,SUB_TIME_EVENT,SUB2_HOLD,SUB2_MODIFY_CMD,SUB2_BSUB_BLOCK,SUB2_HOST_NT,SUB2_HOST_UX,SUB2_QUEUE_CHKPNT,SUB2_QUEUE_RERUNNABLE,SUB2_IN_FILE_SPOOL,SUB2_JOB_CMD_SPOOL,SUB2_JOB_PRIORITY,SUB2_USE_DEF_PROCLIMIT,SUB2_MODIFY_RUN_JOB,SUB2_MODIFY_PEND_JOB,SUB2_WARNING_TIME_PERIOD,SUB2_WARNING_ACTION,SUB2_USE_RSV,SUB2_TSJOB,SUB2_LSF2TP,SUB2_JOB_GROUP,SUB2_SLA,SUB2_EXTSCHED,SUB2_LICENSE_PROJECT,SUB2_OVERWRITE_OUT_FILE,SUB2_OVERWRITE_ERR_FILE,SUB2_SSM_JOB,SUB2_SYM_JOB,SUB2_SRV_JOB,SUB2_SYM_GRP,SUB2_SYM_JOB_PARENT,SUB2_SYM_JOB_REALTIME,SUB2_SYM_JOB_PERSIST_SRV,SUB2_SSM_JOB_PERSIST,J_EXCEPT_OVERRUN,J_EXCEPT_UNDERUN,J_EXCEPT_IDLE)
    SET sql_last_update = CURRENT_TIMESTAMP();
SHOW WARNINGS;
LOAD DATA INFILE '$jobFinishLog_exec' REPLACE 
    INTO TABLE ${cluster}_jobFinishLog_execHosts
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '\"'
    ESCAPED BY '\\\\'
    LINES TERMINATED BY '\\n';
SHOW WARNINGS;
LOAD DATA INFILE '$jobFinishLog_asked' REPLACE 
    INTO TABLE ${cluster}_jobFinishLog_askedHosts
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '\"'
    ESCAPED BY '\\\\'
    LINES TERMINATED BY '\\n';
SHOW WARNINGS;
LOAD DATA INFILE '$jobFinishLog_usage' REPLACE 
    INTO TABLE ${cluster}_jobFinishLog_hRusages
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '\"'
    ESCAPED BY '\\\\'
    LINES TERMINATED BY '\\n';
SHOW WARNINGS; 
LOAD DATA INFILE '$rsvFinishLog' REPLACE 
    INTO TABLE ${cluster}_rsvFinishLog
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '\"'
    ESCAPED BY '\\\\'
    LINES TERMINATED BY '\\n';
SHOW WARNINGS;  
LOAD DATA INFILE '${rsvFinishLog_alloc}' REPLACE 
    INTO TABLE ${cluster}_rsvFinishLog_alloc
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '\"'
    ESCAPED BY '\\\\'
    LINES TERMINATED BY '\\n';
SHOW WARNINGS;   
")  

echo "$SQLquery" | mysql -u $mysql_user -vv
ret=$?
echo "MySQL Import Return: $ret"

#cleanup output if everything worked
[ $ret -eq 0 ] && rm $d/joblist $d/jobFinishLog $d/jobFinishLog_execHosts $d/jobFinishLog_askedHosts $d/jobFinishLog_hRusages $d/alist $d/rsvFinishLog $d/rsvFinishLog_alloc

exit $ret

