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
#ifndef API_H
#define API_H

#include <stdarg.h>

typedef struct {
	const char *app_name;
	int width, height;
} app_info;

typedef void(game_update_f)(long);
typedef app_info(get_app_info_f)(void);

typedef struct {
	game_update_f *update;
	get_app_info_f *get_app_info;
} game_api;

typedef struct {
	void (*vlog_output)(const char *, va_list);
} engine_api;

typedef engine_api *(get_game_api)(game_api *);

#endif
