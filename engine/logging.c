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
#include <engine/logging.h>
#include <stdarg.h>
#include <stdio.h>

void
_log_output(const char *message, ...)
{
	va_list arg_ptr;
	va_start(arg_ptr, message);
	vfprintf(stderr, message, arg_ptr);
	va_end(arg_ptr);
}
