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

#include "fdump.h"
#include "jlist.h"
#include "alist.h"

#ifndef LSB_ACCT_DUMP_H
#define LSB_ACCT_DUMP_H

/**
 * @brief lsb.acct dump file structure
 * manages all the dump file objects
 */
class lsb_acct_dump_t
{
public:
    ///Job List
    jlist_t jlist; 
    fdump_t jobFinishLog; 
    fdump_t jobFinishLog_execHosts; 
    fdump_t jobFinishLog_askedHosts;
    fdump_t jobFinishLog_hRusages; 
    ///Adv Reservation List
    alist_t alist; 
    fdump_t rsvFinishLog; 
    fdump_t rsvFinishLog_alloc; 

    /**
     * @brief ctor
     * construct with the following dump files
     */
    lsb_acct_dump_t(
	const char * jlist_filename,
	const char * jobFinishLog_filename,
	const char * jobFinishLog_execHosts_filename,
	const char * jobFinishLog_askedHosts_filename,
	const char * jobFinishLog_hRusages_filename,
	const char * alist_filename,
	const char * rsvFinishLog_filename,
	const char * rsvFinishLog_alloc_filename
    ) :	
	jlist(jlist_filename), 
	jobFinishLog(jobFinishLog_filename), 
	jobFinishLog_execHosts(jobFinishLog_execHosts_filename), 
	jobFinishLog_askedHosts(jobFinishLog_askedHosts_filename), 
	jobFinishLog_hRusages(jobFinishLog_hRusages_filename),
	alist(alist_filename),
	rsvFinishLog(rsvFinishLog_filename),
	rsvFinishLog_alloc(rsvFinishLog_alloc_filename)
    {};

    /**
     * @brief are all stream healthy?
     */
    operator bool()
    {
	return 
	    jlist && 
	    jobFinishLog && 
	    jobFinishLog_execHosts && 
	    jobFinishLog_askedHosts && 
	    jobFinishLog_hRusages &&
	    alist &&
	    rsvFinishLog &&
	    rsvFinishLog_alloc
	;
    }
};

#endif                   
