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
#include <engine/logging.h>
#include <stdarg.h>

#include "engine.h"

void
_log_output(const char *msg, ...)
{
	va_list arg_ptr;
	va_start(arg_ptr, msg);
	engine.vlog_output(msg, arg_ptr);
	va_end(arg_ptr);
}
