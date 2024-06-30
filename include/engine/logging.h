/*
 * Copyright (C) 2024 emmy emmycelium
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

#define LOG_ERROR 0
#define LOG_WARN  1
#define LOG_INFO  2
#define LOG_DEBUG 3
#define LOG_TRACE 4

#define LOG_STRING(s)	  "\033[90m[" s "\033[90m]\033[0m " __FILE__ ":%s\t"
#define LOG_STRING_SRC(s) "\033[90m[" s "\033[90m]\033[0m %s\t"

#ifndef LOG_LEVEL
#ifdef DEBUG_FLAG
#define LOG_LEVEL LOG_DEBUG
#else
#define LOG_LEVEL LOG_WARN
#endif
#endif

#define FATAL(msg, ...)                                             \
	_log_output(LOG_STRING("\033[31mFATAL") msg "\n", __func__, \
	    ##__VA_ARGS__)

#define FATAL_SRC(src, msg, ...)                                   \
	_log_output(LOG_STRING_SRC("\033[31mFATAL") msg "\n", src, \
	    ##__VA_ARGS__)

#define ERROR(msg, ...)                                             \
	_log_output(LOG_STRING("\033[31mERROR") msg "\n", __func__, \
	    ##__VA_ARGS__)

#define ERROR_SRC(src, msg, ...)                                   \
	_log_output(LOG_STRING_SRC("\033[31mERROR") msg "\n", src, \
	    ##__VA_ARGS__)

#if LOG_LEVEL >= LOG_WARN
#define WARN(msg, ...)                                              \
	_log_output(LOG_STRING("\033[33mWARN ") msg "\n", __func__, \
	    ##__VA_ARGS__)

#define WARN_SRC(src, msg, ...)                                    \
	_log_output(LOG_STRING_SRC("\033[33mWARN ") msg "\n", src, \
	    ##__VA_ARGS__)
#else
#define WARN(msg, ...)
#define WARN_SRC(src, msg, ...)
#endif

#if LOG_LEVEL >= LOG_INFO
#define INFO(msg, ...)                                              \
	_log_output(LOG_STRING("\033[32mINFO ") msg "\n", __func__, \
	    ##__VA_ARGS__)

#define INFO_SRC(src, msg, ...)                                    \
	_log_output(LOG_STRING_SRC("\033[32mINFO ") msg "\n", src, \
	    ##__VA_ARGS__)
#else
#define INFO(msg, ...)
#define INFO_SRC(src, msg, ...)
#endif

#if LOG_LEVEL >= LOG_DEBUG
#define DEBUG(msg, ...)                                             \
	_log_output(LOG_STRING("\033[36mDEBUG") msg "\n", __func__, \
	    ##__VA_ARGS__)

#define DEBUG_SRC(src, msg, ...)                                   \
	_log_output(LOG_STRING_SRC("\033[36mDEBUG") msg "\n", src, \
	    ##__VA_ARGS__)
#else
#define DEBUG(msg, ...)
#define DEBUG_SRC(src, msg, ...)
#endif

#if LOG_LEVEL >= LOG_TRACE
#define TRACE(msg, ...)                                            \
	_log_output(LOG_STRING("\033[0mTRACE") msg "\n", __func__, \
	    ##__VA_ARGS__)

#define TRACE_SRC(src, msg, ...) \
	_log_output(LOG_STRING_SRC("\033[0mTRACE") msg "\n", src, ##__VA_ARGS__)
#else
#define TRACE(msg, ...)
#define TRACE_SRC(src, msg, ...)
#endif

void _log_output(const char *msg, ...) __attribute__((format(printf, 1, 2)));

#endif // LOG_H
