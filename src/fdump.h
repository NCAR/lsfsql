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

#include "ofst.h"

#ifndef FDUMP_H
#define FDUMP_H

/**
 * @brief formatted dumper
 * dumps the data into a csv file
 */
class fdump_t : public ofst_t
{
public:
    /**
     * @brief ctor
     * @param filename file name to write to
     */
    fdump_t(const char * filename);
    
    fdump_t& operator << (const size_t &other);
    fdump_t& operator << (const int &other);
    fdump_t& operator << (const float &other);
    fdump_t& operator << (const double &other);
    fdump_t& operator << (const time_t &other);
    fdump_t& operator << (const char* other);
    fdump_t& operator << (const bool &other);
    /**
     * @brief row break
     */
    fdump_t& rbreak();
private:
    size_t fields; ///number of fields written on current row

    /** @short field break
     * writes field break if there have already been fields written
     */
    void fb();

    /** @short Field Start 
     * print the " character
     * and calls fb()
     */
    void fs(const bool quotes);
 
    /** @short Field End 
     * print the " character
     */
    void fe(const bool quotes); 

    /**
     * @brief print escaped character
     */
    void escape(char c); 
};

#endif                   
