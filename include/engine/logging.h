/*
 * Copyright (C) 2024 Emmy Emmycelium
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#ifndef LOG_H
#define LOG_H

#include <stdint.h>
#include <stdlib.h>

#define LOG_ERROR 0
#define LOG_WARN  1
#define LOG_INFO  2
#define LOG_DEBUG 3
#define LOG_TRACE 4

#define LOG_STRING(s) "\033[90m[" s "\033[90m]\033[0m " __FILE__ ":%s\t"

#ifndef LOG_LEVEL
#ifdef DEBUG_FLAG
#define LOG_LEVEL LOG_DEBUG
#else
#define LOG_LEVEL LOG_WARN
#endif
#endif

#define FATAL(message, ...)                                             \
	_log_output(LOG_STRING("\033[31mFATAL") message "\n", __func__, \
	    ##__VA_ARGS__)

#define ERROR(message, ...)                                             \
	_log_output(LOG_STRING("\033[31mERROR") message "\n", __func__, \
	    ##__VA_ARGS__)

#if LOG_LEVEL >= LOG_WARN
#define WARN(message, ...)                                              \
	_log_output(LOG_STRING("\033[33mWARN ") message "\n", __func__, \
	    ##__VA_ARGS__)
#else
#define WARN(message, ...)
#endif

#if LOG_LEVEL >= LOG_INFO
#define INFO(message, ...)                                              \
	_log_output(LOG_STRING("\033[32mINFO ") message "\n", __func__, \
	    ##__VA_ARGS__)
#else
#define INFO(message, ...)
#endif

#if LOG_LEVEL >= LOG_DEBUG
#define DEBUG(message, ...)                                             \
	_log_output(LOG_STRING("\033[36mDEBUG") message "\n", __func__, \
	    ##__VA_ARGS__)
#else
#define DEBUG(message, ...)
#endif

#if LOG_LEVEL >= LOG_TRACE
#define TRACE(message, ...)                                            \
	_log_output(LOG_STRING("\033[0mTRACE") message "\n", __func__, \
	    ##__VA_ARGS__)
#else
#define TRACE(message, ...)
#endif

void _log_output(const char *message, ...)
    __attribute__((format(printf, 1, 2)));

#endif // LOG_H
