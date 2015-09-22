/*
 * Copyright (c) 2015, University Corporation for Atmospheric Research
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation and/or
 * other materials provided with the distribution.
 * 
 * 3. Neither the name of the copyright holder nor the names of its contributors
 * may be used to endorse or promote products derived from this software without
 * specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <set>
#include <map>
#include <string>
#include <cassert>
#include <iostream>
#include <cstdlib>

extern "C"
{
#include <strings.h>
#include <time.h>
#include <netdb.h>
#include "lsf/lsbatch.h"
#include "lsf/lsf.h"   
}

#include "fdump.h"
#include "lsf.h"
          
int init_lsf(char* program_name)
{
    /* initialize LSBLIB and get the configuration environment */
    if (lsb_init(program_name) < 0) {
        lsb_perror(const_cast<char *>("lsb_init"));
	return EXIT_FAILURE;
    } 
    return EXIT_SUCCESS;
}

int dump_rsvFinishLog(struct rsvFinishLog* res, lsb_acct_dump_t &dump)
{
    assert(res);
    assert(dump); 

    for(size_t i = 0; i < res->numReses; ++i)
    {
	const rsvRes &rr = res->alloc[i];
	dump.rsvFinishLog_alloc << res->rsvId << res->rsvReqTime << rr.resName << rr.count << rr.usedAmt;
	dump.rsvFinishLog_alloc.rbreak();
    }

    /**
     * For some reason, LSF didn't normalize the time window into two ints but
     * used string which can be three different formats. Reads every possible type
     * to find the right one since it's a suprise every time!
     *
     * LSF API Docs:
     *    Time window within which the reservation is active
     *    Two forms: time_t1-time_t2 or [day1]:hour1:0-[day2]:hour2:0. 
     */
    time_t start, end = 0;
    if(sscanf(res->timeWindow, "%ld-%ld", &start, &end) != 2)
    {	
	///convert the request time to a useable format
	tm *reqt = localtime(&res->rsvReqTime);
	assert(reqt);
	tm t1, t2;
	bcopy(reqt, &t1, sizeof(t1));
	bcopy(reqt, &t2, sizeof(t2));

	if(sscanf(res->timeWindow, "%u:%u:%u-%u:%u:%u", &t1.tm_mday, &t1.tm_hour, &t1.tm_min, &t2.tm_mday, &t2.tm_hour, &t2.tm_min) != 6);
	else if(sscanf(res->timeWindow, "%u:%u-%u:%u", &t1.tm_hour, &t1.tm_min, &t2.tm_hour, &t2.tm_min) != 4);
	else //unknown format
	{
	    return EXIT_FAILURE;
	}

	start = mktime(&t1);
	end = mktime(&t2);
    }

    dump.alist.res(res->rsvId, res->rsvReqTime);
    dump.rsvFinishLog 
	<< res->rsvId
	<< res->rsvReqTime  
	<< res->uid
	<< res->name
	<< res->numReses
	/*<< res->timeWindow*/
	<< start
	<< end
	<< res->duration
	<< res->creator
	<< bool(res->options & RSV_OPTION_USER) //User
	<< bool(res->options & RSV_OPTION_GROUP) //Group
	<< bool(res->options & RSV_OPTION_SYSTEM) //System
	<< bool(res->options & RSV_OPTION_RECUR) //Recur
	<< bool(res->options & RSV_OPTION_RESREQ) //Resource
	<< bool(res->options & RSV_OPTION_HOST) //Host
	<< bool(res->options & RSV_OPTION_OPEN) //Open
	<< bool(res->options & RSV_OPTION_DELETE) //Delete
	<< bool(res->options & RSV_OPTION_CLOSED) //Close
	<< bool(res->options & RSV_OPTION_EXEC) //Execute
	<< bool(res->options & RSV_OPTION_RMEXEC) //Remote
	<< bool(res->options & RSV_OPTION_NEXTINSTANCE) //Next
	<< bool(res->options & RSV_OPTION_DISABLE) //Disable
	<< bool(res->options & RSV_OPTION_ADDHOST) //Add
	<< bool(res->options & RSV_OPTION_RMHOST) //Remote
	<< bool(res->options & RSV_OPTION_DESCRIPTION) //Description
	<< bool(res->options & RSV_OPTION_TWMOD) //Timewindow
	<< bool(res->options & RSV_OPTION_SWITCHOPENCLOSE) //Switch
	<< bool(res->options & RSV_OPTION_USERMOD) //User
	<< bool(res->options & RSV_OPTION_RSVNAME) //Reservation
	<< bool(res->options & RSV_OPTION_EXPIRED) //Expired
	;
    dump.rsvFinishLog.rbreak();

    return EXIT_SUCCESS;
}

int dump_jobFinishLog(struct jobFinishLog* job, lsb_acct_dump_t &dump)
{
    assert(job);
    assert(dump);

    dump.jlist.job(job->jobId, job->submitTime);

    ///maintain a list of hosts used, since lsf doesnt seam to actually do this directly
    std::set<std::string> hosts;

    ///dump the individual exec & host usages
    for(size_t i = 0; i < job->numhRusages; ++i)
    {
	hRusage &host = job->hostRusage[i];
	dump.jobFinishLog_hRusages << job->jobId << job->submitTime << job->idx << host.name << host.mem << host.swap << host.utime << host.stime;
	dump.jobFinishLog_hRusages.rbreak();

	hosts.insert(host.name);
    }

    {
	typedef std::map<std::string, size_t> exHosts_t;
	exHosts_t exHosts;

	///first count the number of jobs per physical host
 	for(size_t i = 0; i < job->numExHosts; ++i)
	{ 
	    std::string host(job->execHosts[i]); 
	    if(exHosts.find(host) == exHosts.end())
		exHosts[host] = 1;
	    else
		exHosts[host] += 1;
	}

	///dump to the db the final counts
	for(exHosts_t::const_iterator itr = exHosts.begin(); itr != exHosts.end(); ++itr) 
	{
	    assert(itr->first.size()); assert(itr->second > 0);
	    dump.jobFinishLog_execHosts << job->jobId << job->submitTime << job->idx << itr->first.c_str() << itr->second;
	    dump.jobFinishLog_execHosts.rbreak();

	    hosts.insert(itr->first);
	}
    }
 
    ///dump the individual asked hosts
    for(size_t i = 0; i < job->numAskedHosts; ++i)
    {
	dump.jobFinishLog_askedHosts << job->jobId << job->submitTime << job->idx << job->askedHosts[i];
	dump.jobFinishLog_askedHosts.rbreak();
    }                                   

    const char *jStatus = NULL;
    switch(job->jStatus)
    {
	case JOB_STAT_NULL:
	    jStatus = "NULL";
	    break;
	case JOB_STAT_PEND:
	    jStatus = "PEND";
	    break; 
	case JOB_STAT_PSUSP:
	    jStatus = "PSUSP";
	    break; 
	case JOB_STAT_RUN:
	    jStatus = "RUN";
	    break; 
	case JOB_STAT_SSUSP:
	    jStatus = "SSUSP";
	    break; 
	case JOB_STAT_USUSP:
	    jStatus = "USUSP";
	    break; 
	case JOB_STAT_EXIT:
	    jStatus = "EXIT";
	    break; 
	case JOB_STAT_DONE:
	    jStatus = "DONE";
	    break; 
	case JOB_STAT_PDONE:
	    jStatus = "PDONE";
	    break;
	case JOB_STAT_PERR:
	    jStatus = "PERR";
	    break; 
	case JOB_STAT_WAIT:
	    jStatus = "WAIT";
	    break; 
	case JOB_STAT_UNKWN:
	default:
	    jStatus = "UNKWN";
	    break; 
    }
    const char *exitInfo = NULL;
    switch(job->exitInfo)
    { 
	case TERM_PREEMPT:
		exitInfo = "TERM_PREEMPT";
		break;
	case TERM_WINDOW:
		exitInfo = "TERM_WINDOW";
		break;
	case TERM_LOAD:
		exitInfo = "TERM_LOAD";
		break;
	case TERM_OTHER:
		exitInfo = "TERM_OTHER";
		break;
	case TERM_RUNLIMIT:
		exitInfo = "TERM_RUNLIMIT";
		break;
	case TERM_DEADLINE:
		exitInfo = "TERM_DEADLINE";
		break;
	case TERM_PROCESSLIMIT:
		exitInfo = "TERM_PROCESSLIMIT";
		break;
	case TERM_FORCE_OWNER:
		exitInfo = "TERM_FORCE_OWNER";
		break;
	case TERM_FORCE_ADMIN:
		exitInfo = "TERM_FORCE_ADMIN";
		break;
	case TERM_REQUEUE_OWNER:
		exitInfo = "TERM_REQUEUE_OWNER";
		break;
	case TERM_REQUEUE_ADMIN:
		exitInfo = "TERM_REQUEUE_ADMIN";
		break;
	case TERM_CPULIMIT:
		exitInfo = "TERM_CPULIMIT";
		break;
	case TERM_CHKPNT:
		exitInfo = "TERM_CHKPNT";
		break;
	case TERM_OWNER:
		exitInfo = "TERM_OWNER";
		break;
	case TERM_ADMIN:
		exitInfo = "TERM_ADMIN";
		break;
	case TERM_MEMLIMIT:
		exitInfo = "TERM_MEMLIMIT";
		break;
	case TERM_EXTERNAL_SIGNAL:
		exitInfo = "TERM_EXTERNAL_SIGNAL";
		break;
	case TERM_RMS:
		exitInfo = "TERM_RMS";
		break;
	case TERM_ZOMBIE:
		exitInfo = "TERM_ZOMBIE";
		break;
	case TERM_SWAP:
		exitInfo = "TERM_SWAP";
		break;
	case TERM_THREADLIMIT:
		exitInfo = "TERM_THREADLIMIT";
		break;
	case TERM_SLURM:
		exitInfo = "TERM_SLURM";
		break;
	case TERM_BUCKET_KILL:
		exitInfo = "TERM_BUCKET_KILL";
		break;
	case TERM_CTRL_PID:
		exitInfo = "TERM_CTRL_PID";
		break;
	case TERM_CWD_NOTEXIST:
		exitInfo = "TERM_CWD_NOTEXIST";
		break;
    	case TERM_UNKNOWN:
	default:
		exitInfo = "TERM_UNKNOWN";
		break; 
    }


    dump.jobFinishLog << job->jobId << job->userId << job->userName << job->numProcessors << jStatus 
	<< job->submitTime << job->beginTime << job->termTime << job->startTime << job->endTime
	<< job->queue << job->resReq << job->fromHost << job->numAskedHosts;
    //djobFinishLog->smash_vector(job->numAskedHosts, const_cast<const char **>(job->askedHosts));

    dump.jobFinishLog << job->hostFactor << job->numExHosts << hosts.size();
    ///exechosts is split into a new table and joined with host rusage
    //djobFinishLog->smash_vector(job->numExHosts, const_cast<const char **>(job->execHosts));

    dump.jobFinishLog << job->cpuTime << job->jobName << job->command 
	<< job->lsfRusage.ru_utime << job->lsfRusage.ru_stime  << job->lsfRusage.ru_maxrss  << job->lsfRusage.ru_ixrss  
	<< job->lsfRusage.ru_ismrss << job->lsfRusage.ru_idrss  << job->lsfRusage.ru_isrss  << job->lsfRusage.ru_minflt  
	<< job->lsfRusage.ru_majflt << job->lsfRusage.ru_nswap  << job->lsfRusage.ru_inblock  << job->lsfRusage.ru_oublock  
	<< job->lsfRusage.ru_msgsnd  << job->lsfRusage.ru_msgrcv  << job->lsfRusage.ru_nsignals  
	<< job->lsfRusage.ru_nvcsw << job->lsfRusage.ru_nivcsw  << job->lsfRusage.ru_exutime
	<< job->dependCond << job->timeEvent << job->preExecCmd << job->mailUser << job->projectName << job->exitStatus 
	<< job->maxNumProcessors << job->loginShell << job->idx << job->maxRMem << job->maxRSwap << job->rsvId
	<< job->sla /*<< job->exceptMask*/ << job->additionalInfo << exitInfo << job->warningTimePeriod 
	<< job->warningAction << job->chargedSAAP << job->licenseProject << job->app << job->postExecCmd
	<< job->runtimeEstimation << job->jgroup << job->requeueEValues << job->notifyCmd << job->lastResizeTime 
	<< job->jobDescription 
	<< bool(job->options & SUB_JOB_NAME)
	<< bool(job->options & SUB_QUEUE)
	<< bool(job->options & SUB_HOST)
	<< bool(job->options & SUB_IN_FILE)
	<< bool(job->options & SUB_OUT_FILE)
	<< bool(job->options & SUB_ERR_FILE)
	<< bool(job->options & SUB_EXCLUSIVE)
	<< bool(job->options & SUB_NOTIFY_END)
	<< bool(job->options & SUB_NOTIFY_BEGIN)
	<< bool(job->options & SUB_USER_GROUP)
	<< bool(job->options & SUB_CHKPNT_PERIOD)
	<< bool(job->options & SUB_CHKPNT_DIR)
	<< bool(job->options & SUB_CHKPNTABLE)
	<< bool(job->options & SUB_RESTART_FORCE)
	<< bool(job->options & SUB_RESTART)
	<< bool(job->options & SUB_RERUNNABLE)
	<< bool(job->options & SUB_WINDOW_SIG)
	<< bool(job->options & SUB_HOST_SPEC)
	<< bool(job->options & SUB_DEPEND_COND)
	<< bool(job->options & SUB_RES_REQ)
	<< bool(job->options & SUB_OTHER_FILES)
	<< bool(job->options & SUB_PRE_EXEC)
	<< bool(job->options & SUB_LOGIN_SHELL)
	<< bool(job->options & SUB_MAIL_USER)
	<< bool(job->options & SUB_MODIFY)
	<< bool(job->options & SUB_MODIFY_ONCE)
	<< bool(job->options & SUB_PROJECT_NAME)
	<< bool(job->options & SUB_INTERACTIVE)
	<< bool(job->options & SUB_PTY)
	<< bool(job->options & SUB_PTY_SHELL)
	<< bool(job->options & SUB_EXCEPT)
	<< bool(job->options & SUB_TIME_EVENT)
	<< bool(job->options2 & SUB2_HOLD)
	<< bool(job->options2 & SUB2_MODIFY_CMD)
	<< bool(job->options2 & SUB2_BSUB_BLOCK)
	<< bool(job->options2 & SUB2_HOST_NT)
	<< bool(job->options2 & SUB2_HOST_UX)
	<< bool(job->options2 & SUB2_QUEUE_CHKPNT)
	<< bool(job->options2 & SUB2_QUEUE_RERUNNABLE)
	<< bool(job->options2 & SUB2_IN_FILE_SPOOL)
	<< bool(job->options2 & SUB2_JOB_CMD_SPOOL)
	<< bool(job->options2 & SUB2_JOB_PRIORITY)
	<< bool(job->options2 & SUB2_USE_DEF_PROCLIMIT)
	<< bool(job->options2 & SUB2_MODIFY_RUN_JOB)
	<< bool(job->options2 & SUB2_MODIFY_PEND_JOB)
	<< bool(job->options2 & SUB2_WARNING_TIME_PERIOD)
	<< bool(job->options2 & SUB2_WARNING_ACTION)
	<< bool(job->options2 & SUB2_USE_RSV)
	<< bool(job->options2 & SUB2_TSJOB)
	<< bool(job->options2 & SUB2_LSF2TP)
	<< bool(job->options2 & SUB2_JOB_GROUP)
	<< bool(job->options2 & SUB2_SLA)
	<< bool(job->options2 & SUB2_EXTSCHED)
	<< bool(job->options2 & SUB2_LICENSE_PROJECT)
	<< bool(job->options2 & SUB2_OVERWRITE_OUT_FILE)
	<< bool(job->options2 & SUB2_OVERWRITE_ERR_FILE)
	<< bool(job->options2 & SUB2_SSM_JOB)
	<< bool(job->options2 & SUB2_SYM_JOB)
	<< bool(job->options2 & SUB2_SRV_JOB)
	<< bool(job->options2 & SUB2_SYM_GRP)
	<< bool(job->options2 & SUB2_SYM_JOB_PARENT)
	<< bool(job->options2 & SUB2_SYM_JOB_REALTIME)
	<< bool(job->options2 & SUB2_SYM_JOB_PERSIST_SRV)
	<< bool(job->options2 & SUB2_SSM_JOB_PERSIST)
	<< bool(job->exceptMask & J_EXCEPT_OVERRUN)
	<< bool(job->exceptMask & J_EXCEPT_UNDERUN)
	<< bool(job->exceptMask & J_EXCEPT_IDLE);
    dump.jobFinishLog.rbreak();
  
    return EXIT_SUCCESS;
}

int dump_lsf_acct(FILE * file_lsb_event, lsb_acct_dump_t &dump)
{
    int lineNum = 0;// line number of next event
    while(1)
    {
	if(!dump)
	    return EXIT_FAILURE;

	struct eventRec *record = lsb_geteventrec(file_lsb_event, &lineNum);
	if (record == NULL) {
	    if (lsberrno == LSBE_EOF)
		break;
	    else ///error
	    {
		fprintf(stderr, "Error reading line: %i\n", lineNum); 
		lsb_perror(const_cast<char *>("lsb_geteventrec"));
		///return EXIT_FAILURE; allow it to continue trying
	    }
	}
 
	switch(record->type)
	{
	    case EVENT_JOB_FINISH:
		if(dump_jobFinishLog(
			&(record->eventLog.jobFinishLog), 
			dump
		))
		    return EXIT_FAILURE;
		break;
	    case EVENT_ADRSV_FINISH:
		if(dump_rsvFinishLog(
			&(record->eventLog.rsvFinishLog), 
			dump
		))
		    return EXIT_FAILURE; 
		break;
	    default:
		///ignore for now
		break;
	}
    } 
    
    return EXIT_SUCCESS;
}

