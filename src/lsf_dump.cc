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

#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <fstream>
#include "lsf.h"

int main(int argc, char **argv)
{
    if(argc != 10)
    {
	fprintf(stderr, 
	    "%s "
	    "{lsb.acct input file} "
	    "{jobid file} "
	    "{jobFinishLog csv file} "
	    "{jobFinishLog_execHosts csv file} "
	    "{jobFinishLog_askedHosts csv file} "
	    "{jobFinishLog_hRusages csv file} "
	    "{advresid file} "
	    "{rsvFinishLog csv file} "
	    "{rsvFinishLog_alloc csv file} "
	    "\n", argv[0]);
	return EXIT_FAILURE;
    }

    FILE *file_lsb_event = NULL;
    if(argv[1][0] == '-')
    {
	file_lsb_event = stdin;
    }
    else  //actual file
    {
	file_lsb_event = fopen(argv[1], "r");
	if(file_lsb_event == NULL) {
	    perror(argv[1]);
	    return EXIT_FAILURE;
	}    
    }

    lsb_acct_dump_t dump(argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8], argv[9]);

    if(!dump)
    {
	fprintf(stderr, "Error opening output files.\n");
	return EXIT_FAILURE;
    }

    if(init_lsf(argv[0]))
	return EXIT_FAILURE;

    if(dump_lsf_acct(file_lsb_event, dump))
    {
	fprintf(stderr, "Parse Failure.\n");
	return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
