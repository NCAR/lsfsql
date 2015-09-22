-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 10, 2014 at 09:43 AM
-- Server version: 5.1.66
-- PHP Version: 5.3.3
 
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
 
--
-- Database: `LSF`
--
 
-- --------------------------------------------------------
 
--
-- Table structure for table `example_jobFinishLog`
--
 
DROP TABLE IF EXISTS `example_jobFinishLog`;
CREATE TABLE IF NOT EXISTS `example_jobFinishLog` (
  `jobId` int(32) unsigned NOT NULL COMMENT 'The unique ID for the job. ',
  `userId` int(32) unsigned NOT NULL COMMENT 'The user ID of the submitter. ',
  `userName` text NOT NULL COMMENT 'The user name of the submitter. ',
  `numProcessors` int(11) NOT NULL COMMENT 'The number of processors requested for execution. ',
  `jStatus` enum('NULL','PEND','PSUSP','RUN','SSUSP','USUSP','EXIT','DONE','PDONE','PERR','WAIT','UNKWN') NOT NULL COMMENT 'The status of the job',
  `submitTime` int(32) NOT NULL COMMENT 'Job submission time. ',
  `beginTime` int(32) NOT NULL COMMENT 'The job started at or after this time. ',
  `termTime` int(32) NOT NULL COMMENT 'If the job was not finished by this time, it was killed. ',
  `startTime` int(32) NOT NULL COMMENT 'Job dispatch time. ',
  `endTime` int(32) NOT NULL COMMENT 'The time the job finished. ',
  `queue` text NOT NULL COMMENT 'The name of the queue to which this job was submitted. ',
  `resReq` text NOT NULL COMMENT 'Resource requirements. ',
  `fromHost` text NOT NULL COMMENT 'Submission host name. ',
  `numAskedHosts` int(32) NOT NULL COMMENT 'The number of hosts considered for dispatching this job. ',
  `hostFactor` float NOT NULL COMMENT 'The CPU factor of the first execution host. ',
  `numExHosts` int(32) NOT NULL COMMENT 'The number of processors used for execution. ',
  `numExPhysicalHosts` int(16) unsigned NOT NULL COMMENT 'Number of Physical Hosts. (unique hostnames count as LSF does not track this).',
  `cpuTime` float NOT NULL COMMENT 'The total CPU time consumed by the job. ',
  `jobName` text NOT NULL COMMENT 'Job name. ',
  `command` longblob NOT NULL COMMENT 'Job command. ',
  `ru_utime` double NOT NULL COMMENT 'User time used. ',
  `ru_stime` double NOT NULL COMMENT 'System time used. ',
  `ru_maxrss` double NOT NULL COMMENT 'Max rss. ',
  `ru_ixrss` double NOT NULL COMMENT 'Integral shared text size. ',
  `ru_ismrss` double NOT NULL COMMENT 'Integral shared text size. ',
  `ru_idrss` double NOT NULL COMMENT 'Integral unshared data. ',
  `ru_isrss` double NOT NULL COMMENT 'Integral unshared stack. ',
  `ru_minflt` double NOT NULL COMMENT 'Page reclaims. ',
  `ru_majflt` double NOT NULL COMMENT 'Page faults. ',
  `ru_nswap` double NOT NULL COMMENT 'Swaps. ',
  `ru_inblock` double NOT NULL COMMENT 'Block input operations. ',
  `ru_oublock` double NOT NULL COMMENT 'Block output operations. ',
  `ru_msgsnd` double NOT NULL COMMENT 'Messages sent. ',
  `ru_msgrcv` double NOT NULL COMMENT 'Messages received. ',
  `ru_nsignals` double NOT NULL COMMENT 'Signals received. ',
  `ru_nvcsw` double NOT NULL COMMENT 'Voluntary context switches. ',
  `ru_nivcsw` double NOT NULL COMMENT 'Involuntary. ',
  `ru_exutime` double NOT NULL COMMENT 'Convex only: exact user time used. ',
  `dependCond` text NOT NULL COMMENT 'The job dependency condition. ',
  `timeEvent` text NOT NULL COMMENT 'Time event string. ',
  `preExecCmd` text NOT NULL COMMENT 'The pre-execution command. ',
  `mailUser` text NOT NULL COMMENT 'Name of the user to whom job related mail was sent. ',
  `projectName` text NOT NULL COMMENT 'The project name, used for accounting purposes. ',
  `exitStatus` int(32) NOT NULL COMMENT 'Job''s exit status. ',
  `maxNumProcessors` int(32) NOT NULL COMMENT 'Maximum number of processors specified for the job. ',
  `loginShell` text NOT NULL COMMENT 'Login shell specified by user. ',
  `idx` int(32) NOT NULL COMMENT 'Job array index. ',
  `maxRMem` int(32) NOT NULL COMMENT 'Maximum memory used by job. ',
  `maxRSwap` int(32) NOT NULL COMMENT 'Maximum swap used by job. ',
  `rsvId` text NOT NULL COMMENT 'Advanced reservation ID. ',
  `sla` text NOT NULL COMMENT 'Service class of the job. ',
  `additionalInfo` text NOT NULL COMMENT 'Placement information of LSF jobs. ',
  `exitInfo` enum('TERM_UNKNOWN','TERM_PREEMPT','TERM_WINDOW','TERM_LOAD','TERM_OTHER','TERM_RUNLIMIT','TERM_DEADLINE','TERM_PROCESSLIMIT','TERM_FORCE_OWNER','TERM_FORCE_ADMIN','TERM_REQUEUE_OWNER','TERM_REQUEUE_ADMIN','TERM_CPULIMIT','TERM_CHKPNT','TERM_OWNER','TERM_ADMIN','TERM_MEMLIMIT','TERM_EXTERNAL_SIGNAL','TERM_RMS','TERM_ZOMBIE','TERM_SWAP','TERM_THREADLIMIT','TERM_SLURM','TERM_BUCKET_KILL','TERM_CTRL_PID','TERM_CWD_NOTEXIST') NOT NULL COMMENT 'Job termination reason',
  `warningTimePeriod` int(32) NOT NULL COMMENT 'Job warning time period in seconds; -1 if unspecified. ',
  `warningAction` text NOT NULL COMMENT 'Warning action, SIGNAL | CHKPNT | command, NULL if unspecified. ',
  `chargedSAAP` text NOT NULL COMMENT 'SAAP charged for job. ',
  `licenseProject` text NOT NULL COMMENT 'LSF License Scheduler project name. ',
  `app` text NOT NULL COMMENT 'Application profile under which the job runs. ',
  `postExecCmd` text NOT NULL COMMENT 'Post-execution commands. ',
  `runtimeEstimation` int(32) NOT NULL COMMENT 'Runtime estimate specified. ',
  `jgroup` text NOT NULL COMMENT 'Job group name. ',
  `requeueEValues` text NOT NULL COMMENT 'Job requeue exit values. ',
  `notifyCmd` text NOT NULL COMMENT 'Resize notify command. ',
  `lastResizeTime` int(32) NOT NULL COMMENT 'Last resize start time. ',
  `jobDescription` text NOT NULL COMMENT 'Job description. ',
  `SUB_JOB_NAME` tinyint(1) NOT NULL COMMENT 'Flag to indicate jobName parameter has data. ',
  `SUB_QUEUE` tinyint(1) NOT NULL COMMENT 'Flag to indicate queue parameter has data. ',
  `SUB_HOST` tinyint(1) NOT NULL COMMENT 'Flat to indicate numAskedHosts parameter has data. ',
  `SUB_IN_FILE` tinyint(1) NOT NULL COMMENT 'Flag to indicate inFile parameter has data. ',
  `SUB_OUT_FILE` tinyint(1) NOT NULL COMMENT 'Flag to indicate outFile parameter has data. ',
  `SUB_ERR_FILE` tinyint(1) NOT NULL COMMENT 'Flag to indicate errFile parameter has data. ',
  `SUB_EXCLUSIVE` tinyint(1) NOT NULL COMMENT 'Flag to indicate execution of a job on a host by itself requested. ',
  `SUB_NOTIFY_END` tinyint(1) NOT NULL COMMENT 'Flag to indicate whether to send mail to the user when the job finishes.',
  `SUB_NOTIFY_BEGIN` tinyint(1) NOT NULL COMMENT 'Flag to indicate whether to send mail to the user when the job is dispatched. ',
  `SUB_USER_GROUP` tinyint(1) NOT NULL COMMENT 'Flag to indicate userGroup name parameter has data. ',
  `SUB_CHKPNT_PERIOD` tinyint(1) NOT NULL COMMENT 'Flag to indicatechkpntPeriod parameter has data . ',
  `SUB_CHKPNT_DIR` tinyint(1) NOT NULL COMMENT 'Flag to indicate chkpntDir parameter has data. ',
  `SUB_CHKPNTABLE` tinyint(1) NOT NULL COMMENT 'Indicates the job is checkpointable. ',
  `SUB_RESTART_FORCE` tinyint(1) NOT NULL COMMENT 'Flag to indicate whether to force the job to restart even if non-restartable conditions exist. ',
  `SUB_RESTART` tinyint(1) NOT NULL COMMENT 'Flag to indicate restart of a checkpointed job. ',
  `SUB_RERUNNABLE` tinyint(1) NOT NULL COMMENT 'Indicates the job is re-runnable. ',
  `SUB_WINDOW_SIG` tinyint(1) NOT NULL COMMENT 'Flag to indicate sigValue parameter has data. ',
  `SUB_HOST_SPEC` tinyint(1) NOT NULL COMMENT 'Flag to indicate hostSpec parameter has data. ',
  `SUB_DEPEND_COND` tinyint(1) NOT NULL COMMENT 'Flag to indicate dependCond parameter has data. ',
  `SUB_RES_REQ` tinyint(1) NOT NULL COMMENT 'Flag to indicate resReq parameter has data. ',
  `SUB_OTHER_FILES` tinyint(1) NOT NULL COMMENT 'Flag to indicate nxf parameter and structure xf have data. ',
  `SUB_PRE_EXEC` tinyint(1) NOT NULL COMMENT 'Flag to indicate preExecCmd parameter has data. ',
  `SUB_LOGIN_SHELL` tinyint(1) NOT NULL COMMENT 'Equivalent to bsub -L command line option existence. ',
  `SUB_MAIL_USER` tinyint(1) NOT NULL COMMENT 'Flag to indicate mailUser parameter has data. ',
  `SUB_MODIFY` tinyint(1) NOT NULL COMMENT 'Flag to indicate newCommand parameter has data. ',
  `SUB_MODIFY_ONCE` tinyint(1) NOT NULL COMMENT 'Flag to indicate modify option once. ',
  `SUB_PROJECT_NAME` tinyint(1) NOT NULL COMMENT 'Flag to indicate ProjectName parameter has data .',
  `SUB_INTERACTIVE` tinyint(1) NOT NULL COMMENT 'Indicates that the job is submitted as a batch interactive job. ',
  `SUB_PTY` tinyint(1) NOT NULL COMMENT 'Requests pseudo-terminal support for a job submitted with the SUB_INTERACTIVE flag. ',
  `SUB_PTY_SHELL` tinyint(1) NOT NULL COMMENT 'Requests pseudo-terminal shell mode support for a job submitted with the SUB_INTERACTIVE and SUB_PTY flags. ',
  `SUB_EXCEPT` tinyint(1) NOT NULL COMMENT 'Exception handler for job. ',
  `SUB_TIME_EVENT` tinyint(1) NOT NULL COMMENT 'Specifies time_event. ',
  `SUB2_HOLD` tinyint(1) NOT NULL COMMENT 'Hold the job after it is submitted. ',
  `SUB2_MODIFY_CMD` tinyint(1) NOT NULL COMMENT 'New cmd for bmod. ',
  `SUB2_BSUB_BLOCK` tinyint(1) NOT NULL COMMENT 'Submit a job in a synchronous mode so that submission does not return until the job terminates. ',
  `SUB2_HOST_NT` tinyint(1) NOT NULL COMMENT 'Submit from NT. ',
  `SUB2_HOST_UX` tinyint(1) NOT NULL COMMENT 'Submit fom UNIX. ',
  `SUB2_QUEUE_CHKPNT` tinyint(1) NOT NULL COMMENT 'Submit to a chkpntable queue. ',
  `SUB2_QUEUE_RERUNNABLE` tinyint(1) NOT NULL COMMENT 'Submit to a rerunnable queue. ',
  `SUB2_IN_FILE_SPOOL` tinyint(1) NOT NULL COMMENT 'Spool job command. ',
  `SUB2_JOB_CMD_SPOOL` tinyint(1) NOT NULL COMMENT 'Inputs the specified file with spooling. ',
  `SUB2_JOB_PRIORITY` tinyint(1) NOT NULL COMMENT 'Submits job with priority. ',
  `SUB2_USE_DEF_PROCLIMIT` tinyint(1) NOT NULL COMMENT 'Job submitted without -n, use queue''s default proclimit. ',
  `SUB2_MODIFY_RUN_JOB` tinyint(1) NOT NULL COMMENT 'bmod -c/-M/-W/-o/-e/-v ',
  `SUB2_MODIFY_PEND_JOB` tinyint(1) NOT NULL COMMENT 'bmod options only to pending jobs ',
  `SUB2_WARNING_TIME_PERIOD` tinyint(1) NOT NULL COMMENT 'Job action warning time. ',
  `SUB2_WARNING_ACTION` tinyint(1) NOT NULL COMMENT 'Job action to be taken before a job control action occurs. ',
  `SUB2_USE_RSV` tinyint(1) NOT NULL COMMENT 'Use an advance reservation created with the brsvadd command.',
  `SUB2_TSJOB` tinyint(1) NOT NULL COMMENT 'Windows Terminal Services job. ',
  `SUB2_LSF2TP` tinyint(1) NOT NULL COMMENT 'Parameter is deprecated. ',
  `SUB2_JOB_GROUP` tinyint(1) NOT NULL COMMENT 'Submit into a job group. ',
  `SUB2_SLA` tinyint(1) NOT NULL COMMENT 'Submit into a service class. ',
  `SUB2_EXTSCHED` tinyint(1) NOT NULL COMMENT 'Submit with -extsched options. ',
  `SUB2_LICENSE_PROJECT` tinyint(1) NOT NULL COMMENT 'License Scheduler project. ',
  `SUB2_OVERWRITE_OUT_FILE` tinyint(1) NOT NULL COMMENT 'Overwrite the standard output of the job. ',
  `SUB2_OVERWRITE_ERR_FILE` tinyint(1) NOT NULL COMMENT 'Overwrites the standard error output of the job. ',
  `SUB2_SSM_JOB` tinyint(1) NOT NULL COMMENT '(symphony) session job ',
  `SUB2_SYM_JOB` tinyint(1) NOT NULL COMMENT '(symphony) symphony job ',
  `SUB2_SRV_JOB` tinyint(1) NOT NULL COMMENT '(symphony) service(LSF) job ',
  `SUB2_SYM_GRP` tinyint(1) NOT NULL COMMENT '(symphony) "group" job ',
  `SUB2_SYM_JOB_PARENT` tinyint(1) NOT NULL COMMENT '(symphony) symphony job has child symphony job ',
  `SUB2_SYM_JOB_REALTIME` tinyint(1) NOT NULL COMMENT '(symphony) symphony job has real time feature ',
  `SUB2_SYM_JOB_PERSIST_SRV` tinyint(1) NOT NULL COMMENT '(symphony) symphony job has dummy feature to hold all persistent service jobs. ',
  `SUB2_SSM_JOB_PERSIST` tinyint(1) NOT NULL COMMENT 'Persistent session job. ',
  `J_EXCEPT_OVERRUN` tinyint(1) NOT NULL,
  `J_EXCEPT_UNDERUN` tinyint(1) NOT NULL,
  `J_EXCEPT_IDLE` tinyint(1) NOT NULL,
  `sql_last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`jobId`,`submitTime`,`idx`),
  KEY `endTime` (`endTime`),
  KEY `sql_last_update` (`sql_last_update`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='LSF jobFinishLog Struct';
 
-- --------------------------------------------------------
 
--
-- Table structure for table `example_jobFinishLog_askedHosts`
--
 
DROP TABLE IF EXISTS `example_jobFinishLog_askedHosts`;
CREATE TABLE IF NOT EXISTS `example_jobFinishLog_askedHosts` (
  `jobId` int(32) unsigned NOT NULL COMMENT 'The unique ID for the job. ',
  `submitTime` int(32) unsigned NOT NULL DEFAULT '0' COMMENT 'Job submission time.',
  `idx` int(32) NOT NULL COMMENT 'Job array index.',
  `name` text NOT NULL COMMENT 'The host name.',
  PRIMARY KEY (`jobId`,`submitTime`,`idx`,`name`(6)),
  KEY `jobId` (`jobId`,`submitTime`,`idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='LSF jobFinishLog->askedHosts Array';
 
-- --------------------------------------------------------
 
--
-- Table structure for table `example_jobFinishLog_execHosts`
--
 
DROP TABLE IF EXISTS `example_jobFinishLog_execHosts`;
CREATE TABLE IF NOT EXISTS `example_jobFinishLog_execHosts` (
  `jobId` int(32) unsigned NOT NULL COMMENT 'The unique ID for the job. ',
  `submitTime` int(32) unsigned NOT NULL DEFAULT '0' COMMENT 'Job submission time.',
  `idx` int(32) NOT NULL COMMENT 'Job array index.',
  `name` text NOT NULL COMMENT 'The host name.',
  `count` int(16) unsigned NOT NULL,
  PRIMARY KEY (`jobId`,`submitTime`,`idx`,`name`(6)),
  KEY `jobId` (`jobId`,`submitTime`,`idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='LSF jobFinishLog->hRusage Struct Array';
 
-- --------------------------------------------------------
 
--
-- Table structure for table `example_jobFinishLog_hRusages`
--
 
DROP TABLE IF EXISTS `example_jobFinishLog_hRusages`;
CREATE TABLE IF NOT EXISTS `example_jobFinishLog_hRusages` (
  `jobId` int(32) unsigned NOT NULL COMMENT 'The unique ID for the job. ',
  `submitTime` int(32) unsigned NOT NULL DEFAULT '0' COMMENT 'Job submission time.',
  `idx` int(32) NOT NULL COMMENT 'Job array index.',
  `name` text NOT NULL COMMENT 'The host name.',
  `mem` int(32) NOT NULL COMMENT 'Total resident memory usage in kbytes of all currently running processes in given host.',
  `swap` int(32) NOT NULL COMMENT 'Total virtual memory usage in kbytes of all currently running processes in given process groups.',
  `utime` int(32) NOT NULL COMMENT 'Cumulative total user time in seconds on given host.',
  `stime` int(32) NOT NULL COMMENT 'Cumulative total system time in seconds on given host.',
  PRIMARY KEY (`jobId`,`submitTime`,`idx`,`name`(6)),
  KEY `jobId` (`jobId`,`submitTime`,`idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='LSF jobFinishLog->hRusage Struct Array';
 
-- --------------------------------------------------------
 
--
-- Table structure for table `example_rsvFinishLog`
--
 
DROP TABLE IF EXISTS `example_rsvFinishLog`;
CREATE TABLE IF NOT EXISTS `example_rsvFinishLog` (
  `rsvId` text NOT NULL COMMENT 'Reservation ID.',
  `rsvReqTime` int(32) unsigned NOT NULL COMMENT 'Time when the reservation is required. ',
  `uid` int(32) unsigned NOT NULL COMMENT 'The user who creat the reservation.',
  `name` text NOT NULL COMMENT 'Client of the reservation.',
  `numReses` int(32) NOT NULL COMMENT 'Number of resources reserved.',
  `timeWindow_start` int(32) NOT NULL COMMENT 'Time Window Start (parsed)',
  `timeWindow_end` int(32) NOT NULL COMMENT 'Time Window End (parsed)',
  `duration` int(32) NOT NULL COMMENT 'Duration in seconds.',
  `creator` text NOT NULL COMMENT 'Creator of the reservation. ',
  `RSV_OPTION_USER` tinyint(1) NOT NULL COMMENT 'User',
  `RSV_OPTION_GROUP` tinyint(1) NOT NULL COMMENT 'Group',
  `RSV_OPTION_SYSTEM` tinyint(1) NOT NULL COMMENT 'System',
  `RSV_OPTION_RECUR` tinyint(1) NOT NULL COMMENT 'Recur',
  `RSV_OPTION_RESREQ` tinyint(1) NOT NULL COMMENT 'Resource',
  `RSV_OPTION_HOST` tinyint(1) NOT NULL COMMENT 'Host',
  `RSV_OPTION_OPEN` tinyint(1) NOT NULL COMMENT 'Open',
  `RSV_OPTION_DELETE` tinyint(1) NOT NULL COMMENT 'Delete',
  `RSV_OPTION_CLOSED` tinyint(1) NOT NULL COMMENT 'Close',
  `RSV_OPTION_EXEC` tinyint(1) NOT NULL COMMENT 'Execute',
  `RSV_OPTION_RMEXEC` tinyint(1) NOT NULL COMMENT 'Remote',
  `RSV_OPTION_NEXTINSTANCE` tinyint(1) NOT NULL COMMENT 'Next',
  `RSV_OPTION_DISABLE` tinyint(1) NOT NULL COMMENT 'Disable',
  `RSV_OPTION_ADDHOST` tinyint(1) NOT NULL COMMENT 'Add',
  `RSV_OPTION_RMHOST` tinyint(1) NOT NULL COMMENT 'Remote',
  `RSV_OPTION_DESCRIPTION` tinyint(1) NOT NULL COMMENT 'Description',
  `RSV_OPTION_TWMOD` tinyint(1) NOT NULL COMMENT 'Timewindow',
  `RSV_OPTION_SWITCHOPENCLOSE` tinyint(1) NOT NULL COMMENT 'Switch',
  `RSV_OPTION_USERMOD` tinyint(1) NOT NULL COMMENT 'User',
  `RSV_OPTION_RSVNAME` tinyint(1) NOT NULL COMMENT 'Reservation',
  `RSV_OPTION_EXPIRED` tinyint(1) NOT NULL COMMENT 'Expired',
  PRIMARY KEY (`rsvId`(8),`rsvReqTime`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='LSF rsvFinishLog Struct';
 
-- --------------------------------------------------------
 
--
-- Table structure for table `example_rsvFinishLog_alloc`
--
 
DROP TABLE IF EXISTS `example_rsvFinishLog_alloc`;
CREATE TABLE IF NOT EXISTS `example_rsvFinishLog_alloc` (
  `rsvId` text NOT NULL COMMENT 'Reservation ID.',
  `rsvReqTime` int(32) unsigned NOT NULL COMMENT 'Time when the reservation is required. ',
  `resName` text NOT NULL COMMENT 'Name of the resource (currently: host). ',
  `count` int(32) NOT NULL COMMENT 'Reserved counter (currently: cpu number). ',
  `usedAmt` int(32) NOT NULL COMMENT 'Used of the reserved counter (not used).',
  PRIMARY KEY (`rsvId`(8),`rsvReqTime`,`resName`(8)),
  KEY `rsvId` (`rsvId`(8),`rsvReqTime`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='LSF rsvFinishLog->alloc Struct';
 
